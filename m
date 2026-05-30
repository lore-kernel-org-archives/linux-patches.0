Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC48D39A4A4;
	Sat, 30 May 2026 18:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164205; cv=none; b=tm514e0ygwp10O8J5cJjD/vw/3DSi1H3jkYIcdl23zhf8YXexw7ToJRh6wARKLIAiYLynaik8pyGl3MfeF7MU6uXQ5Cjy9ETPrhF3WarxNntTU5Dze6eeZP1lLxwrgzDIgm0+PiQ1ochrzLODZg1DfNqxDJWaAIYOrs98Xj2pwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164205; c=relaxed/simple;
	bh=E9j6N06N5SGYh3d8dmfI6msvTwe2EKIjKhgwc8MC43k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+FyHJPJEl1nDH7eB8Awy4yHlBpRl+XssleQ5eDUfyMa+aXxIUozLdLPUcTTASXUm/mJALTvvi9PzfAhfwGc+3lmN3rXR99vet1eVg/klwsfxF/74HiulVCETo3vm9ZaeKyRU+TzU+uPU9YQVAHvyg8nOZCqJsadkmuQy7OC1tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YnSZNA1a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YnSZNA1a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC871F00893;
	Sat, 30 May 2026 18:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164204;
	bh=JDYoJXONz+iS4/8wfE4Qrv+tmr+7g+IFKKEhnYy77ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YnSZNA1atsEOVLeG9Xl8uW9+WfmHin1Q7Yw7eAuYAjODdMqoUc2LemFbV8osh1Ahw
	 DOkSKvv0zCTmNvJsJoF0cnUsGuVC0UpPOrra9ky/1qBHOFnjZk0d/VhJ0XAcc1PgeL
	 vC3J7HzZC6fUUDPNxfrio3jZrYxsItlOChbpvMh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Klinesmith <joshuaklinesmith@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 485/776] ksmbd: fix use-after-free from async crypto on Qualcomm crypto engine
Date: Sat, 30 May 2026 18:03:19 +0200
Message-ID: <20260530160252.866148887@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Klinesmith <joshuaklinesmith@gmail.com>

[ Upstream commit 3e298897f41c61450c2e7a4f457e8b2485eb35b3 ]

ksmbd_crypt_message() sets a NULL completion callback on AEAD requests
and does not handle the -EINPROGRESS return code from async hardware
crypto engines like the Qualcomm Crypto Engine (QCE). When QCE returns
-EINPROGRESS, ksmbd treats it as an error and immediately frees the
request while the hardware DMA operation is still in flight. The DMA
completion callback then dereferences freed memory, causing a NULL
pointer crash:

  pc : qce_skcipher_done+0x24/0x174
  lr : vchan_complete+0x230/0x27c
  ...
  el1h_64_irq+0x68/0x6c
  ksmbd_free_work_struct+0x20/0x118 [ksmbd]
  ksmbd_exit_file_cache+0x694/0xa4c [ksmbd]

Use the standard crypto_wait_req() pattern with crypto_req_done() as
the completion callback, matching the approach used by the SMB client
in fs/smb/client/smb2ops.c. This properly handles both synchronous
engines (immediate return) and async engines (-EINPROGRESS followed
by callback notification).

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Link: https://github.com/openwrt/openwrt/issues/21822
Signed-off-by: Joshua Klinesmith <joshuaklinesmith@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/auth.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/ksmbd/auth.c b/fs/ksmbd/auth.c
index 647692ca78a28..8fc7a1fffd55a 100644
--- a/fs/ksmbd/auth.c
+++ b/fs/ksmbd/auth.c
@@ -1108,6 +1108,7 @@ int ksmbd_crypt_message(struct ksmbd_work *work, struct kvec *iov,
 	struct smb2_transform_hdr *tr_hdr = smb2_get_msg(iov[0].iov_base);
 	unsigned int assoc_data_len = sizeof(struct smb2_transform_hdr) - 20;
 	int rc;
+	DECLARE_CRYPTO_WAIT(wait);
 	struct scatterlist *sg;
 	u8 sign[SMB2_SIGNATURE_SIZE] = {};
 	u8 key[SMB3_ENC_DEC_KEY_SIZE];
@@ -1194,12 +1195,12 @@ int ksmbd_crypt_message(struct ksmbd_work *work, struct kvec *iov,
 
 	aead_request_set_crypt(req, sg, sg, crypt_len, iv);
 	aead_request_set_ad(req, assoc_data_len);
-	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP, NULL, NULL);
+	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
+				  CRYPTO_TFM_REQ_MAY_SLEEP,
+				  crypto_req_done, &wait);
 
-	if (enc)
-		rc = crypto_aead_encrypt(req);
-	else
-		rc = crypto_aead_decrypt(req);
+	rc = crypto_wait_req(enc ? crypto_aead_encrypt(req) :
+			     crypto_aead_decrypt(req), &wait);
 	if (rc)
 		goto free_iv;
 
-- 
2.53.0



