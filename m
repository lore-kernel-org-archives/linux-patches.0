Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36B74B13B;
	Wed, 20 Dec 2023 16:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HVs6wVsM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65ED4C433C8;
	Wed, 20 Dec 2023 16:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088787;
	bh=cvq8bGCbWlOIvgiWwhgVty5iStrQmrzmApyExvTj6Aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HVs6wVsMW/gj+J+Qds8MhpxWneJr1wl/LhZQsChLBQsSkK/jhbwvn/79eQxrkDvmA
	 kHJ6Dv8HMnk3yw4aGYOUdj2vVCoNnLIyT7jxQZCx6Xmr9VbIJJX2XK2IiRGUSo/yf3
	 O9hcRYOtZSgsoLM05/kiXV7A70U1f//+XUek1bFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 057/159] ksmbd: set NTLMSSP_NEGOTIATE_SEAL flag to challenge blob
Date: Wed, 20 Dec 2023 17:08:42 +0100
Message-ID: <20231220160933.991486905@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 5bedae90b369ca1a7660b9af39591ed19009b495 ]

If NTLMSSP_NEGOTIATE_SEAL flags is set in negotiate blob from client,
Set NTLMSSP_NEGOTIATE_SEAL flag to challenge blob.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/auth.c    |    3 +++
 fs/ksmbd/smb2pdu.c |    2 +-
 fs/ksmbd/smb2pdu.h |    1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

--- a/fs/ksmbd/auth.c
+++ b/fs/ksmbd/auth.c
@@ -428,6 +428,9 @@ ksmbd_build_ntlmssp_challenge_blob(struc
 				   NTLMSSP_NEGOTIATE_56);
 	}
 
+	if (cflags & NTLMSSP_NEGOTIATE_SEAL && smb3_encryption_negotiated(conn))
+		flags |= NTLMSSP_NEGOTIATE_SEAL;
+
 	if (cflags & NTLMSSP_NEGOTIATE_ALWAYS_SIGN)
 		flags |= NTLMSSP_NEGOTIATE_ALWAYS_SIGN;
 
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -956,7 +956,7 @@ static void decode_encrypt_ctxt(struct k
  *
  * Return:	true if connection should be encrypted, else false
  */
-static bool smb3_encryption_negotiated(struct ksmbd_conn *conn)
+bool smb3_encryption_negotiated(struct ksmbd_conn *conn)
 {
 	if (!conn->ops->generate_encryptionkey)
 		return false;
--- a/fs/ksmbd/smb2pdu.h
+++ b/fs/ksmbd/smb2pdu.h
@@ -1672,6 +1672,7 @@ int smb3_decrypt_req(struct ksmbd_work *
 int smb3_encrypt_resp(struct ksmbd_work *work);
 bool smb3_11_final_sess_setup_resp(struct ksmbd_work *work);
 int smb2_set_rsp_credits(struct ksmbd_work *work);
+bool smb3_encryption_negotiated(struct ksmbd_conn *conn);
 
 /* smb2 misc functions */
 int ksmbd_smb2_check_message(struct ksmbd_work *work);


