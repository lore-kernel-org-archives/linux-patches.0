Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C127219007D;
	Wed,  7 May 2025 18:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643609; cv=none; b=MH/8gxfIc/PokFrzX7uZMts5og4D1h9r/MFzSjqcSoBscTSZgALf2jb1wsAnDbyMva7FvSFXvGxh5yhkBivDhhl117wfXNlyUuiK2wSypKSsPPecNb5bR7JgI8b0Qr0BR+wq4aAbU9DUWAKwBrmacixISBtY0cQRpS9I1Kk73Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643609; c=relaxed/simple;
	bh=AsB23T4UufhKBxKplbKOKBFNU+G7B2YagUQTBcpPEug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SlScpRQLRcdJkFrinOnFEMAiSGVyvqmVj7Tmk1HhFSPIv8ssIk/NVNxIhfLJEQspq5Y6kJ5JXp8SFIJt55CW1jOsxX+Ad/T3ihAxWDy228Nghbgkh8w/K/pYz2TqVJNmtuubrxTUc06FCp3iNNdfqCiGJpmWLMS0jSHBk6o3Cb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m91sS6Ra; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m91sS6Ra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 408E7C4CEE2;
	Wed,  7 May 2025 18:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643609;
	bh=AsB23T4UufhKBxKplbKOKBFNU+G7B2YagUQTBcpPEug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m91sS6Rao7QwRf2ILQ/87dT7gStAOiXcCXaOTQ2ZJkMoj9KIrNRFF3iZpYAFZzcZa
	 ZLouktU45NTVssa6dZCg7LXCzpUkcsy0alD95cWkwUgtWvQHQhj7rRpkkrYu9TbDBQ
	 UNGrWbc3WE/dgn/VtyMCIK/KsWFdnUWkU1luhZx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Heelan <seanheelan@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 19/97] ksmbd: fix use-after-free in kerberos authentication
Date: Wed,  7 May 2025 20:38:54 +0200
Message-ID: <20250507183807.755950373@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -544,7 +544,19 @@ int ksmbd_krb5_authenticate(struct ksmbd
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
@@ -1615,11 +1615,6 @@ static int krb5_authenticate(struct ksmb
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


