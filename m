Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030813AAF46;
	Sat, 12 Sep 2026 20:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243480; cv=none; b=BsLR7S1RCw7ozX9QwUa0YGAAAsnUlGvDGPV6MEZw5i89vKjG81rE31062vLSLFll2kQPShN5GWlljvQ0qJH+Tl77+Iac9VUFiacgIK5ac/PD3xWEeup7X05tV68c8JQKJB7VIc4/nP7rppYzdDWF62FvDj5f5DVlxC5pSf4VXak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243480; c=relaxed/simple;
	bh=HpR+LA15YV1lesf9kS7IlMkO0flSaQ9qrYglNdJLPO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7S6fF7iLG43s3qA7dy7Uk3sKteSLP95jwBczG6Z2zU4+9tMYEk+DyPy7EZeoV/qVeUfgbQ9IhvUVpweKfRj7gj7Yg28BTERQDuTUSCGPF++mL5E5zrcehdOfRnIlfQvugC9yZrR4b2mLUtoVCwc9efk9n0WlmzI4F348ZFnopk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Q3xXEgJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Q3xXEgJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87DA1F000FF;
	Sat, 12 Sep 2026 20:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243476;
	bh=NzUBhxckMdxl++X0bpUpuS7l849EglkOOZRn1bk+D2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Q3xXEgJiTKEGI6iz+xc2xz57cnBemk8ZCT4FJoRaC4PjnqDsXTMKw2iyNO1jQjWC
	 55+e6O79bB7dqlE9LzTLt4tqJ/FsvxRbaoo+zyPfib6FmNpDmjua7uGqRktmKdxqUL
	 zyHXVTZch3AhfjB9vurxnxu6mfuh3wkPiPtsXDag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 768/798] tpm: st33zp24: Validate locality read result
Date: Sat, 12 Sep 2026 09:06:36 +0200
Message-ID: <20260912065534.671833956@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f4f77548a6152..016bf31114115 100644
--- a/drivers/char/tpm/st33zp24/st33zp24.c
+++ b/drivers/char/tpm/st33zp24/st33zp24.c
@@ -113,10 +113,10 @@ static bool check_locality(struct tpm_chip *chip)
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



