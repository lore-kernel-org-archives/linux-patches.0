Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C3F28E572;
	Wed,  7 May 2025 19:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644896; cv=none; b=WrJSCF2mbCWNjscMxvZ7g5sYHoHDmmCqkARFijzm+RgNBkOKoF5eDxdOhSy+q15CakbNyNEzR+S4zY6LCMUafYQvNDW008VXQgydl0jD0vEdPzWRU78GCpG5z7IRRGTwBZBTS5X5iqQ6Zq0IrY4yjIA4r1T7WdarR+7FVmHwzWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644896; c=relaxed/simple;
	bh=H35eDjqp6IsE12i9koZUyHExP42Guyndsz+SoA3IPrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yn8tKKewJSlE8GVcfAn2BwHSJUrjaSdIr3hdFvUEd9ak37Su7HUIyBTR2huImxeY1giDiieF4nxYlf3toYhS27h9GSC4eXzzXWGVlZ+5m2z0m3sku+C7/KzAUhk+8ZvMZ5o8sBUTobqKNO9scLgppI8vzfbz93V/gXRvyKSRzHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lXR2XPY3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lXR2XPY3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6819AC4CEE2;
	Wed,  7 May 2025 19:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644895;
	bh=H35eDjqp6IsE12i9koZUyHExP42Guyndsz+SoA3IPrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lXR2XPY37q513GLHE/4Kg71ASAYez8FAQw2WVGaPBaYYFxOvvF1ZCF5evh47mgSQW
	 uxZVc/9Dzv3b56GPFj0aZfUT6JdkKf/UULQzGuAn3tg1kF9EshqfPx31w+MrEgF8Vy
	 j8y5hVMsvoS+L+64capSN+pod0wRNCH0kWhNzpB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Heelan <seanheelan@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 028/129] ksmbd: fix use-after-free in kerberos authentication
Date: Wed,  7 May 2025 20:39:24 +0200
Message-ID: <20250507183814.668979623@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Heelan <seanheelan@gmail.com>

commit e86e9134e1d1c90a960dd57f59ce574d27b9a124 upstream.

Setting sess->user = NULL was introduced to fix the dangling pointer
created by ksmbd_free_user. However, it is possible another thread could
be operating on the session and make use of sess->user after it has been
passed to ksmbd_free_user but before sess->user is set to NULL.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Heelan <seanheelan@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/auth.c    |   14 +++++++++++++-
 fs/smb/server/smb2pdu.c |    5 -----
 2 files changed, 13 insertions(+), 6 deletions(-)

--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -546,7 +546,19 @@ int ksmbd_krb5_authenticate(struct ksmbd
 		retval = -ENOMEM;
 		goto out;
 	}
-	sess->user = user;
+
+	if (!sess->user) {
+		/* First successful authentication */
+		sess->user = user;
+	} else {
+		if (!ksmbd_compare_user(sess->user, user)) {
+			ksmbd_debug(AUTH, "different user tried to reuse session\n");
+			retval = -EPERM;
+			ksmbd_free_user(user);
+			goto out;
+		}
+		ksmbd_free_user(user);
+	}
 
 	memcpy(sess->sess_key, resp->payload, resp->session_key_len);
 	memcpy(out_blob, resp->payload + resp->session_key_len,
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1599,11 +1599,6 @@ static int krb5_authenticate(struct ksmb
 	if (prev_sess_id && prev_sess_id != sess->id)
 		destroy_previous_session(conn, sess->user, prev_sess_id);
 
-	if (sess->state == SMB2_SESSION_VALID) {
-		ksmbd_free_user(sess->user);
-		sess->user = NULL;
-	}
-
 	retval = ksmbd_krb5_authenticate(sess, in_blob, in_len,
 					 out_blob, &out_len);
 	if (retval) {


