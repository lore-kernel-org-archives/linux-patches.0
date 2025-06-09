Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A432F193062;
	Mon,  9 Jun 2025 21:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749503605; cv=none; b=TEieSYK4HoasgmW+73e6T3kbc4qtroGNCj1jSkJgmpmykHEO5F09fGx0FLgYGlIKWN1HsWdlNUPjpZE61BdqE0HIfy16kyx9HrpsQB4vsjlN+1RSGD1mbxAuNoZTlsewkXnBI+xcXN6/hTnEZtFdp2yKA+d+8c9zz0Y0vK1EK0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749503605; c=relaxed/simple;
	bh=X5QJvkv3j9iTTBXNXX/rB02EIeJPcHs224rzb2cLDzc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=I6okcErGzOsAnil2v+6Tg5wrmeBmafPp+PRlGt7PAnG0Vj8OmEQ6LLThupnSeV9IEY0tzszL0ISgl/2AHFFRO8FJNCL6YUfB3Xd03h/YvUJvliHF96quGkGT2cvCNk1luq2r4kDE5PrKzdom3BwkVP7JXEsaMW6nwc7wdFPErcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bpIwq2rU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bpIwq2rU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2985DC4CEEB;
	Mon,  9 Jun 2025 21:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749503605;
	bh=X5QJvkv3j9iTTBXNXX/rB02EIeJPcHs224rzb2cLDzc=;
	h=From:Date:Subject:To:Cc:From;
	b=bpIwq2rUwzQKl3zfzKbT9YJHN2vvEqIcRDykHF8RnSilZ11qhxmilwjHbp2RS7cBE
	 79akQ0ZevawAWTNxxlOc2okC/REnFzO4WP4ZdnbWp94jnapLHaQgDMd1oYGscZT2xT
	 xdkV75K/Vw7Cs2VUy3levdwN1r66Nys8UxlprdxeewzF96nmSdgfipdiYmuIIw3HqM
	 HriOFob2C10CCM+HpRXht9Nf2xYOXpB4UuJnYBrTAPmYpaQ9fNUrrZNOk7mckT6SQO
	 zkHC69f7CWNCoJzJsvpp/rX5hsngkj5weYe+GfHOqRU7GoZTrwUzsdZ4Gu+Fsmge9y
	 /nPx/ItoL2VsA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 09 Jun 2025 14:13:14 -0700
Subject: [PATCH] staging: rtl8723bs: Avoid memset() in aes_cipher() and
 aes_decipher()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250609-rtl8723bs-fix-clang-arm64-wflt-v1-1-e2accba43def@kernel.org>
X-B4-Tracking: v=1; b=H4sIAGlOR2gC/x2NQQqDMBAAvyJ77kIak2j6FenB2LVdSFU2UgXx7
 y49DgwzBxQSpgKP6gChHxeeJ4X7rYLh009vQn4pgzXWm2Aiyprbxtap4Mg7Dlkd7OUbHG5jXjG
 5FIO30bjkQSOLkHr/Qfc8zwvNAAubcAAAAA==
X-Change-ID: 20250609-rtl8723bs-fix-clang-arm64-wflt-b4b9652904b5
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-staging@lists.linux.dev, llvm@lists.linux.dev, 
 patches@lists.linux.dev, stable@vger.kernel.org, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=5267; i=nathan@kernel.org;
 h=from:subject:message-id; bh=X5QJvkv3j9iTTBXNXX/rB02EIeJPcHs224rzb2cLDzc=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBnufsUB1c+2OdotPmr2YYW3QCfbbd9Cu6/fJqT2CKst8
 6tc2y/ZUcrCIMbFICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTACZyYRnDL6aiVatvr2Y9lXYo
 1NbfM1nzhGf5FNEDn7KtQ7PUMywZKhkZnur6yHnuX/2cbWlqc0nPKfXcoHliRrOmLT8ot7fupdQ
 EBgA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

After commit 6f110a5e4f99 ("Disable SLUB_TINY for build testing"), which
causes CONFIG_KASAN to be enabled in allmodconfig again, arm64
allmodconfig builds with older versions of clang (15 through 17) show an
instance of -Wframe-larger-than (which breaks the build with
CONFIG_WERROR=y):

  drivers/staging/rtl8723bs/core/rtw_security.c:1287:5: error: stack frame size (2208) exceeds limit (2048) in 'rtw_aes_decrypt' [-Werror,-Wframe-larger-than]
   1287 | u32 rtw_aes_decrypt(struct adapter *padapter, u8 *precvframe)
        |     ^

This comes from aes_decipher() being inlined in rtw_aes_decrypt().
Running the same build with CONFIG_FRAME_WARN=128 shows aes_cipher()
also uses a decent amount of stack, just under the limit of 2048:

  drivers/staging/rtl8723bs/core/rtw_security.c:864:19: warning: stack frame size (1952) exceeds limit (128) in 'aes_cipher' [-Wframe-larger-than]
    864 | static signed int aes_cipher(u8 *key, uint      hdrlen,
        |                   ^

-Rpass-analysis=stack-frame-layout only shows one large structure on the
stack, which is the ctx variable inlined from aes128k128d(). A good
number of the other variables come from the additional checks of
fortified string routines, which are present in memset(), which both
aes_cipher() and aes_decipher() use to initialize some temporary
buffers. In this case, since the size is known at compile time, these
additional checks should not result in any code generation changes but
allmodconfig has several sanitizers enabled, which may make it harder
for the compiler to eliminate the compile time checks and the variables
that come about from them.

The memset() calls are just initializing these buffers to zero, so use
'= {}' instead, which is used all over the kernel and does the exact
same thing as memset() without the fortify checks, which drops the stack
usage of these functions by a few hundred kilobytes.

  drivers/staging/rtl8723bs/core/rtw_security.c:864:19: warning: stack frame size (1584) exceeds limit (128) in 'aes_cipher' [-Wframe-larger-than]
    864 | static signed int aes_cipher(u8 *key, uint      hdrlen,
        |                   ^
  drivers/staging/rtl8723bs/core/rtw_security.c:1271:5: warning: stack frame size (1456) exceeds limit (128) in 'rtw_aes_decrypt' [-Wframe-larger-than]
   1271 | u32 rtw_aes_decrypt(struct adapter *padapter, u8 *precvframe)
        |     ^

Cc: stable@vger.kernel.org
Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/staging/rtl8723bs/core/rtw_security.c | 44 +++++++++------------------
 1 file changed, 14 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/rtl8723bs/core/rtw_security.c b/drivers/staging/rtl8723bs/core/rtw_security.c
index 1e9eff01b1aa..e9f382c280d9 100644
--- a/drivers/staging/rtl8723bs/core/rtw_security.c
+++ b/drivers/staging/rtl8723bs/core/rtw_security.c
@@ -868,29 +868,21 @@ static signed int aes_cipher(u8 *key, uint	hdrlen,
 		num_blocks, payload_index;
 
 	u8 pn_vector[6];
-	u8 mic_iv[16];
-	u8 mic_header1[16];
-	u8 mic_header2[16];
-	u8 ctr_preload[16];
+	u8 mic_iv[16] = {};
+	u8 mic_header1[16] = {};
+	u8 mic_header2[16] = {};
+	u8 ctr_preload[16] = {};
 
 	/* Intermediate Buffers */
-	u8 chain_buffer[16];
-	u8 aes_out[16];
-	u8 padded_buffer[16];
+	u8 chain_buffer[16] = {};
+	u8 aes_out[16] = {};
+	u8 padded_buffer[16] = {};
 	u8 mic[8];
 	uint	frtype  = GetFrameType(pframe);
 	uint	frsubtype  = GetFrameSubType(pframe);
 
 	frsubtype = frsubtype>>4;
 
-	memset((void *)mic_iv, 0, 16);
-	memset((void *)mic_header1, 0, 16);
-	memset((void *)mic_header2, 0, 16);
-	memset((void *)ctr_preload, 0, 16);
-	memset((void *)chain_buffer, 0, 16);
-	memset((void *)aes_out, 0, 16);
-	memset((void *)padded_buffer, 0, 16);
-
 	if ((hdrlen == WLAN_HDR_A3_LEN) || (hdrlen ==  WLAN_HDR_A3_QOS_LEN))
 		a4_exists = 0;
 	else
@@ -1080,15 +1072,15 @@ static signed int aes_decipher(u8 *key, uint	hdrlen,
 			num_blocks, payload_index;
 	signed int res = _SUCCESS;
 	u8 pn_vector[6];
-	u8 mic_iv[16];
-	u8 mic_header1[16];
-	u8 mic_header2[16];
-	u8 ctr_preload[16];
+	u8 mic_iv[16] = {};
+	u8 mic_header1[16] = {};
+	u8 mic_header2[16] = {};
+	u8 ctr_preload[16] = {};
 
 		/* Intermediate Buffers */
-	u8 chain_buffer[16];
-	u8 aes_out[16];
-	u8 padded_buffer[16];
+	u8 chain_buffer[16] = {};
+	u8 aes_out[16] = {};
+	u8 padded_buffer[16] = {};
 	u8 mic[8];
 
 	uint frtype  = GetFrameType(pframe);
@@ -1096,14 +1088,6 @@ static signed int aes_decipher(u8 *key, uint	hdrlen,
 
 	frsubtype = frsubtype>>4;
 
-	memset((void *)mic_iv, 0, 16);
-	memset((void *)mic_header1, 0, 16);
-	memset((void *)mic_header2, 0, 16);
-	memset((void *)ctr_preload, 0, 16);
-	memset((void *)chain_buffer, 0, 16);
-	memset((void *)aes_out, 0, 16);
-	memset((void *)padded_buffer, 0, 16);
-
 	/* start to decrypt the payload */
 
 	num_blocks = (plen-8) / 16; /* plen including LLC, payload_length and mic) */

---
base-commit: 19272b37aa4f83ca52bdf9c16d5d81bdd1354494
change-id: 20250609-rtl8723bs-fix-clang-arm64-wflt-b4b9652904b5

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

