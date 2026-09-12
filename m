Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3073B4BEE54;
	Sat, 12 Sep 2026 09:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205186; cv=none; b=So/+dHVoU7MyJCf2fp05dFAIRru0KBZb/Z7ToEP9c+aR7YELIPWjoYrCg5c1lGfMlfHBv2skX5BBtWff5cyLm7VxWJbSxdpL8TnyvdHi1y3dxBnXF/dEk4i/qVOKMtQ3bAVDGcRSu8OWEAoec5IChse9fKYhbF52t6lKUEsTQ8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205186; c=relaxed/simple;
	bh=U7FVNoO9dxbtUFsh/STvXZUWzi+7drrF4wUA7ndOUAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TocaONAnseoR0Y76Qu0xYjaJ8M51nBqr5Iw1S9kbMK1UuiK9sPG8fYegJ8HKPy+W5Yh4u86De2ij5jS5ZtQCTnAiNWhmFJJdS5rdRhO1NY3QJ7pxDflCcOcQzqsgLYRH46bG5HMf+lrulOW9ONP0JNB2cEsIUuwdYfpZKqYIWjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sAPG3e1x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sAPG3e1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1CB1F000FF;
	Sat, 12 Sep 2026 09:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205185;
	bh=zEE/SzV5VIcJaqRejVWSvDHdmK+arug8x0HMTXFGNf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sAPG3e1x/fJgxBo3wQ4/oDqB5G5Hkd3roHQUgIKMn2qVJv4fzKjt6uvQo1nOfgReO
	 bXD4SVXTODme1AxutT4i3fw5Z57bjGlLoNvdf77+2BDEbqszs/9GlIW4uwc3/qr3lF
	 mJrPXakkbrolS3CBa9GInmMEOK8eDX/6TPaGILPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1766/1815] tpm: st33zp24: Validate locality read result
Date: Sat, 12 Sep 2026 08:58:36 +0200
Message-ID: <20260912065730.460288919@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 264216889d39df509b9c8045df53529480b0b718 ]

check_locality() treats every nonzero transport return as success. SPI
errors remain negative, while the I2C path can convert a negative write
error through its byte-sized status variable. Either result is nonzero
even though the TPM_ACCESS byte can remain unwritten, so indeterminate
ACTIVE_LOCALITY and VALID bits can falsely report an active locality.

Require recv() to return exactly the requested byte before examining
TPM_ACCESS. Transport errors and short reads now report an inactive
locality, while successful reads retain the existing behavior.

This issue was found by a static analysis checker and confirmed by manual
source review.

Fixes: 251a7b08213a ("TPM: STMicroelectronics ST33 I2C KERNEL 3.x")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Link: https://lore.kernel.org/r/20260813153032.3951878-2-ruoyuw560@gmail.com
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/st33zp24/st33zp24.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/st33zp24/st33zp24.c b/drivers/char/tpm/st33zp24/st33zp24.c
index 898e8d01d2669..0e2deff94c367 100644
--- a/drivers/char/tpm/st33zp24/st33zp24.c
+++ b/drivers/char/tpm/st33zp24/st33zp24.c
@@ -106,10 +106,10 @@ static bool check_locality(struct tpm_chip *chip)
 {
 	struct st33zp24_dev *tpm_dev = dev_get_drvdata(&chip->dev);
 	u8 data;
-	u8 status;
+	int status;
 
 	status = tpm_dev->ops->recv(tpm_dev->phy_id, TPM_ACCESS, &data, 1);
-	if (status && (data &
+	if (status == 1 && (data &
 		(TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) ==
 		(TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID))
 		return true;
-- 
2.53.0



