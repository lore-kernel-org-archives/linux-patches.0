Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99790DF59;
	Wed, 20 May 2026 18:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302207; cv=none; b=nXL/3pIGapZP+dm+xpEb7KeFgmurlYIECyo5lAGq709aUIPsh0SiO0YklLarc2Y3WWgUm+49lDgjyFa4xXg0RVX0cqmjJbArufIviKMUevyfiiDcbJGUlk+hWt/rjdUvmWhUz+3NkgdFl/xlLiV3ZzCkgO1fU3MlQFkuyWfxvqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302207; c=relaxed/simple;
	bh=caTF7qZuvQqomgvIXeZYGiFB0ZVny9EhBaS+nKgXi0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JUx1TX2Sv5dJBGxwadiszY5kSuI/5kZBPzvDRunjTA2x0/+AHGKs3zqkfcZyJsl3B1qYTEILhSqi/sMEBTn3AVQiw95/SiH/96IUCfFi4w3h9qQSuunoDfSjKeqSxpmD8JVpXq105mHawTe8vEVOXLsDkj6RBI1OWuH+IuANIXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rcgBNWjr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rcgBNWjr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2E01F000E9;
	Wed, 20 May 2026 18:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302206;
	bh=2b4n/VBAD7YIV94gEK+AykdYS7GD7nGmm3alUe8RdLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rcgBNWjrpgC4Usx/IiKZdOnmOsvIJgbPGzvcixaT/Tl6gn/P+m70Bl2FTI5Ax9JSs
	 EAMQcqCkJKnsXzNYXCgCvF9+nAnK/FYVljT8obZ4YV+Rb7fi2oAIY3EyDL6q79Vprj
	 C8f81ECORk9pTBSONGBRJqUdINif/w/8mSUXJVwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Klinesmith <joshuaklinesmith@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 180/508] ksmbd: fix use-after-free from async crypto on Qualcomm crypto engine
Date: Wed, 20 May 2026 18:20:03 +0200
Message-ID: <20260520162102.539340585@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 16a57425099de..d28b34e1d047a 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -1106,6 +1106,7 @@ int ksmbd_crypt_message(struct ksmbd_work *work, struct kvec *iov,
 	struct smb2_transform_hdr *tr_hdr = smb2_get_msg(iov[0].iov_base);
 	unsigned int assoc_data_len = sizeof(struct smb2_transform_hdr) - 20;
 	int rc;
+	DECLARE_CRYPTO_WAIT(wait);
 	struct scatterlist *sg;
 	u8 sign[SMB2_SIGNATURE_SIZE] = {};
 	u8 key[SMB3_ENC_DEC_KEY_SIZE];
@@ -1192,12 +1193,12 @@ int ksmbd_crypt_message(struct ksmbd_work *work, struct kvec *iov,
 
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



