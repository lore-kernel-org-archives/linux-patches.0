Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C962116E9;
	Wed,  7 May 2025 18:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643861; cv=none; b=LsOw7slzwts2Fsbm0ta6FFcF6jIkazHleT6iDcr4jSU156xv1zQL6ONMhtmN/yPWCKJ65hJVqvWf46r1+4s0un+Dv+56e2+s2jHmwUmfKxneIHDzxoTxjOVE43J844qO5DAYAisjTJbxdxiT5NUXYNJpyAFDURCZuXmP9KtvuQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643861; c=relaxed/simple;
	bh=9Frn/JvOAC4WOqsWcwEgq0L/TXa6RUf0xM+nszC5zwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YpialHCD0pUy+J9KW68XGDNCwXfmaczUNR5Q+fa0aUEpVORBYnMcIfq4bOfmfEkktFV9rTltIn1iRIIGeczUwOtd4QxY3YGkuOTpTqhosCjEqwoHQ6dPAKPSMg3+qKnoSbSa5uXYMlHx8dSYzlFXsQTxo9VcRz4+Ng+KUA1Lfck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DvcdgYrh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DvcdgYrh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3CB2C4CEE2;
	Wed,  7 May 2025 18:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643861;
	bh=9Frn/JvOAC4WOqsWcwEgq0L/TXa6RUf0xM+nszC5zwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DvcdgYrhczQKA3c60MjWK+O7joqw+jVTs1XD/1fMicKPm2+zay1yZGWBNZPQcEAsP
	 OY9q/y+qkwnN28GaB/uL8pUo+pSMSAxVnQ/xCk4jf7hcRKCNLRQB41+b6Qrj+x9fcN
	 McwjUZbZT1eiJnt/GkzOZM3054Xhf7/V5WjTuX2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Heelan <seanheelan@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.14 041/183] ksmbd: fix use-after-free in kerberos authentication
Date: Wed,  7 May 2025 20:38:06 +0200
Message-ID: <20250507183826.358226489@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1602,11 +1602,6 @@ static int krb5_authenticate(struct ksmb
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


