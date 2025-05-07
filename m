Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50D228C024;
	Wed,  7 May 2025 19:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644446; cv=none; b=kmk3OPh1dU6KIJBsi3QyWu1PFJpQl923VvId369h6xz9EtfXCCRZDaU7imX35YY4flbzzaAURXTNh9BfY75qF40Hvwo9Mx5qpENhufPTYtB/08NQ/uxeqCY7bgtvS+4TsO77xCnPSbHEtk6xCiKOlbGhoXrWOs6TMvW8BSyEl8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644446; c=relaxed/simple;
	bh=/DTsuprGGI7Cloxfwb1pT1dqfMqVD1bQeG7jGoq0y4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gqDc2ztZRUas2N+MJ1Qci4dymvMCs18wnZ/tqQ9mJk3XUh0yuELH3vxVD+zsUReF5Bypoj1ExpscOI4t7Bo6K6xOFXayjRyA3XHUS4cG6JttcCT3B3A1QVVvW0wseoaY6THb1Q9G7h9D+QbjvR03zLORGDZZzU3yzyfW7iOLnyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dv/6VQpO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dv/6VQpO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107BEC4CEE2;
	Wed,  7 May 2025 19:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644445;
	bh=/DTsuprGGI7Cloxfwb1pT1dqfMqVD1bQeG7jGoq0y4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dv/6VQpOvw3C/ir8vSgQiKShsNFKcRT756EwNPjFteCJUU4/AodZ6FQEtVJVctxx9
	 Xa2cqWxGz3gc6xvI6dmzWKAiF39YX40Z8xn/aNm2tu1Vg91xp1fGyIs0owuDVYUgb0
	 Y0YdI2ZKE0vxVJXlw8Rxgkpi6GXOS8+nl4gcnP4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Heelan <seanheelan@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 045/164] ksmbd: fix use-after-free in kerberos authentication
Date: Wed,  7 May 2025 20:38:50 +0200
Message-ID: <20250507183822.708051894@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -550,7 +550,19 @@ int ksmbd_krb5_authenticate(struct ksmbd
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
@@ -1600,11 +1600,6 @@ static int krb5_authenticate(struct ksmb
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


