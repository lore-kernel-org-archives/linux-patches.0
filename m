Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D777C423A9A;
	Tue, 31 Mar 2026 16:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975290; cv=none; b=nyx0ln31K50Dc34HO3JbQzHj+neLzMME8jHp2a7OyY91tduloQ7/Ms/bQzqVYU00CsV6RCuBzG6DMIz+FfheVeLQMNrJP/2me+oSD2jnyIFWk2tZWnCbt1UHwKMS2vKGkPKMEw7vnNIqPVqRFtacsoGIDb+UlEr+LzZUo6Jadl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975290; c=relaxed/simple;
	bh=WgS/g5+WmkmGHidODz8yWBefzJRFIq7AOEWUuXUlCCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aC56Fd70q0ghk1WdSJfxk6fbi2y7vNyWNFamVSmXUnQGjPI0gddhgwKMY5m7hq/TMrSMBW0h016iEBSettRNjqCFV9NcVEBgZJNCefEZSaFinlki7PS55do8YFFS3+A0m5/nAnm6CC1e3Bs8a0yB4jMhNwelhBz/8RzmdhFi+DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=civm4Nxh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="civm4Nxh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B10C2BCB2;
	Tue, 31 Mar 2026 16:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975290;
	bh=WgS/g5+WmkmGHidODz8yWBefzJRFIq7AOEWUuXUlCCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=civm4NxhsVDHXXkC+nrDFQ/vy9VwMjBJrDFYB61Q+N2XTk+ZreUmLMMK+N/pK5+Oc
	 IzE6hnc1ZC7aJHNy0M+gAQ5ArnvZF4gLUeOEX1CgztvPfxi17DxxOq2x9wcJHSVJP4
	 JITaSn+irXO7GD246r7FciFJfrXy7SqwPz1nJf14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.19 204/342] ksmbd: do not expire session on binding failure
Date: Tue, 31 Mar 2026 18:20:37 +0200
Message-ID: <20260331161806.492112410@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1938,8 +1938,14 @@ out_err:
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


