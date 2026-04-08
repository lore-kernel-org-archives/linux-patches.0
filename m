Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89086347503;
	Wed,  8 Apr 2026 18:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671933; cv=none; b=ZIbqUleK6GJgbOgpM6oPvktogWuFGHAlLYYheG0wL+Qie4Fyxs8otet3SGXnr6p/X7/kauYcD3+RETqaeiBwVjSLzHoEM+S5PknfiAo2WzO+G9pItLTAL3/0UcJ7GHQY1YWM96BpXvaDzMKX0BqzZgYey9C6nmd5DcI2v67x/s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671933; c=relaxed/simple;
	bh=gSidCJ1TBd1w8FkGfLJlf4kJf37j0eLAilx6V/WOEb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MrGiIQzZYA1zhGRae0zjl0KG+CumO+6d+93foavT6w7YrLQbEepbNhLODMwNqWjhb1LOExHzT9/M95f1x7ySirP8IQ5+pcZuTd0UWhBMUwh5aLK2u3nYM7e6taQQUzR9z0BVm1UWIPjDiDeRjGToWL+x5KchpzVnxx43QQHO9Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kk4fOXkM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kk4fOXkM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDD1C19425;
	Wed,  8 Apr 2026 18:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671933;
	bh=gSidCJ1TBd1w8FkGfLJlf4kJf37j0eLAilx6V/WOEb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kk4fOXkMEvkiYwmor7KY2ueEeXxfrJXXCquoAHIcb9hwXpkEnbNxj30maAy9iNEL1
	 2EZezUWMvStXm622hU3EHhDCbOImcJY5oXAhVpr3meKHj7ugbo0FZqEruQpzmYmsxm
	 Pu2Epn0zGs9SSwiEWqrUF1WURvYcwUHmeiIKFyTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 092/312] ksmbd: do not expire session on binding failure
Date: Wed,  8 Apr 2026 20:00:09 +0200
Message-ID: <20260408175937.197346868@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunwoo Kim <imv4bel@gmail.com>

commit 9bbb19d21ded7d78645506f20d8c44895e3d0fb9 upstream.

When a multichannel session binding request fails (e.g. wrong password),
the error path unconditionally sets sess->state = SMB2_SESSION_EXPIRED.
However, during binding, sess points to the target session looked up via
ksmbd_session_lookup_slowpath() -- which belongs to another connection's
user. This allows a remote attacker to invalidate any active session by
simply sending a binding request with a wrong password (DoS).

Fix this by skipping session expiration when the failed request was
a binding attempt, since the session does not belong to the current
connection. The reference taken by ksmbd_session_lookup_slowpath() is
still correctly released via ksmbd_user_session_put().

Cc: stable@vger.kernel.org
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1928,8 +1928,14 @@ out_err:
 			if (sess->user && sess->user->flags & KSMBD_USER_FLAG_DELAY_SESSION)
 				try_delay = true;
 
-			sess->last_active = jiffies;
-			sess->state = SMB2_SESSION_EXPIRED;
+			/*
+			 * For binding requests, session belongs to another
+			 * connection. Do not expire it.
+			 */
+			if (!(req->Flags & SMB2_SESSION_REQ_FLAG_BINDING)) {
+				sess->last_active = jiffies;
+				sess->state = SMB2_SESSION_EXPIRED;
+			}
 			ksmbd_user_session_put(sess);
 			work->sess = NULL;
 			if (try_delay) {


