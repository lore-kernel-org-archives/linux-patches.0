Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F013F8E04;
	Tue, 31 Mar 2026 16:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976000; cv=none; b=dd2oXDZXR9XBw/eBMnplDJb8UTxlQbdji4KfpcIP9QD+U82uEUWOPlihHIiVFCA2axOoNdHLoQsNAwlj8rzlArLHhpcI5MkNoHC9EiKmBUPeIRkynV/C61DE4isyXjAHBfGlIJi1kEYOkogbiTeTU1JDl0oynPnv6Vr+kUpqNpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976000; c=relaxed/simple;
	bh=rnQspb9WcOul58Fe4uJ9D6FbtaYmKoBHHPRnA9DIAzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q9zJ6OI7KBxs/DDH7PP4nQlTNOSxIfHhhwZmdiikCRDzmTYHv1KLl2sj9g/yfemxyHuGE7siIB5D8RRWlKNxk7bxS+/DchReZQI0ilkY5w9hdo3kn2zCVMa1NDYqcPaRvphkG3ibuYZf3f+07lqPaaKvmOL0ZWxDvGRSSzrWn7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ePzMhYr3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ePzMhYr3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B96C19423;
	Tue, 31 Mar 2026 16:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975999;
	bh=rnQspb9WcOul58Fe4uJ9D6FbtaYmKoBHHPRnA9DIAzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ePzMhYr3NjPb2jBSTvmkE5sF8dHdf6fbB0DHYrheGZzd9aOTuVk81qHNmq3UwZX6R
	 JN6QP1mXy+phuN47eOmIBok9dbcZH9SinoRReUeoA7WCJfZQ9YlWCtUwMo140iHAK/
	 cfaw4nt/2pjPmswg6WXDCgZ1WjnaRnsz8WVys+yM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 141/244] ksmbd: do not expire session on binding failure
Date: Tue, 31 Mar 2026 18:21:31 +0200
Message-ID: <20260331161746.976665039@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1945,8 +1945,14 @@ out_err:
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


