Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F50263F44;
	Sat, 30 May 2026 17:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161361; cv=none; b=YrRTUUg05xYV5YUeCHTKtRJk2pv/IMqPrBVVldZM2YpsI5NC+hoCTnXLHZoyev80QO8EryQSE9wDr/gfSGO1NmahTFWwt2F5QNPuFufTQfSxs3PxhxA7Xqvh3t0TlUBtXpzF1CMDs0RNFLMU2yeUgMaFB2fc+fMY7gdaWowHiDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161361; c=relaxed/simple;
	bh=ISjmwppbUVo6I7REarQIZPWmuEfjnTuIUDChe3d2Olo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QsK9mv7YjWPdKkwAOT8Xq6AqJ146qWis0gHU80N7IdEKOvhKZt/L/06cQdLuPAJG2YtqF9wP6JZgQzuU+t4UyWgAoZH+J6jNFFWGyEHFAFbvtKWhHmSo1GivNsj1ttPPwKEcECgo8Q1LoDShuk3XG1+31rHCeb+kBBzF8WtOmP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IbV3ceHw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IbV3ceHw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7601F00893;
	Sat, 30 May 2026 17:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161360;
	bh=p5wpN60JR2M+NSZjfUdiRyNPfGS4nyu0SDrFe+IJFyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IbV3ceHwLnWonjgwpdM8euBA+ZGBqpJ5PGc361hixE7RWCMurni1tWooADcPPtG1X
	 hc6F2Bb3GdVq+Hq/IE6qZViA6MKDS0gImSL/DNGo6/A/gfR9YmBNfnfHGTUROFzcaG
	 7nbo0voAVQkW+2XCaL+OJ1Su6NCkDlzW4DCeDWeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Klinesmith <joshuaklinesmith@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 571/969] ksmbd: fix use-after-free from async crypto on Qualcomm crypto engine
Date: Sat, 30 May 2026 18:01:35 +0200
Message-ID: <20260530160316.168923495@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
 fs/smb/server/auth.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index a9b73ea3a7427..38e0eb27bad53 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -1104,6 +1104,7 @@ int ksmbd_crypt_message(struct ksmbd_work *work, struct kvec *iov,
 	struct smb2_transform_hdr *tr_hdr = smb2_get_msg(iov[0].iov_base);
 	unsigned int assoc_data_len = sizeof(struct smb2_transform_hdr) - 20;
 	int rc;
+	DECLARE_CRYPTO_WAIT(wait);
 	struct scatterlist *sg;
 	u8 sign[SMB2_SIGNATURE_SIZE] = {};
 	u8 key[SMB3_ENC_DEC_KEY_SIZE];
@@ -1190,12 +1191,12 @@ int ksmbd_crypt_message(struct ksmbd_work *work, struct kvec *iov,
 
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



