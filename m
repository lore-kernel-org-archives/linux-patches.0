Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49D5221FD4;
	Sat, 12 Sep 2026 15:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226488; cv=none; b=oXB4AMqNfls+6BW1YxpMD2lPtszudgwOr09G/teeVsqMr4f6LQfst4RdT4Rg7Ubyd71rkKDQwrfShHqyXfT8FSQRa7BCJDhxpCVuxDsP24fVQrWLIR91rVCyVqbLxB0ybhnLd4eDj5XTRVIEybhB/43ypWtq2Lfb/4b0SWwnM2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226488; c=relaxed/simple;
	bh=NeuCZ9qkcHwjV/Iu6au5VrzeSrfxQMnh6i4dAEepySs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NnY1MEAW9YsFvxKb4LXUBKuynHJKHSgHL9R1zcg4TA9s/dXtNYtDTAMsKE7Sh6B+221JAXduS/HHat50xBx5whIIf3eTwE8ojRP9XSx60yaZaBunT+ifezKiv7mw+Btgt6lXaLFu7np09Id0nVaAwLx8qf11KFwVWlUs7Uucb2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rZNCLLwK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rZNCLLwK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3EF1F000FF;
	Sat, 12 Sep 2026 15:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226487;
	bh=kgwA2n663ryJVsEAV4YT1/1NpVMArkPaZ9s+p3BlYIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rZNCLLwKU/bN3Frda7TsKK1jSMMeop0zxxs6+fWWHStj4mEinUEJkCbOqMicQ5zJ4
	 /P4a11e47lrBYsqGpS3gz+6dxIMeU80VenJpePR7L1Mwwf7dz4V5NzETm7HnOSjU0O
	 aK56JgYvsuy4XKSt5abMV7EM8HduynIAa3fViZz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1369/1424] tpm: st33zp24: Validate locality read result
Date: Sat, 12 Sep 2026 09:03:21 +0200
Message-ID: <20260912065637.921460314@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index e810a7fa9db10..e3ceda5573311 100644
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



