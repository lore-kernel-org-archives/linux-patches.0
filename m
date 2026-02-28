Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E440434A3AB
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302669; cv=none; b=J1RHZGweBYDFliZopNhuJKTewKYxUUFp7j/IHhcLyyHjButPcYhHdxapKmspSv8RclpszGgvTxOmSzYd5z3pbG1XAJBwaYdeVT4k3gHM3BuWLcjJakLKu5RxCeXNGLyasNu1xLIzmHRPti+2eORr45HkcKtNwEUEUMbNTW7lZUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302669; c=relaxed/simple;
	bh=ilTWDM8sYpRaPyj3U99FjkHB9tfSK9FPBoVNkPgjEgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GrF0LloLYDXShMyWwntQ+KGhA2gyo77MEYXLdwT3fD/iIClg5BFJENVLC80qAIrpCK/5MVJqsRSG9xtI6iFySu0Gp7YtrG0dHz3Lbga/xnN96cvqMpZmQbkaFeNO3lxyueG0h/fFs1+K3IIVHRWlM5Uy84cdCafBCKW4y4lmjis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SLQ/4XPt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SLQ/4XPt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A44C116D0;
	Sat, 28 Feb 2026 18:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302668;
	bh=ilTWDM8sYpRaPyj3U99FjkHB9tfSK9FPBoVNkPgjEgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SLQ/4XPtEno70mtbll8B+eLLxo9qAdlOxmJpUGE+7ncXuGphB67S/J4JjXGVq8Ou/
	 CXJw8BbNXoBBAh792holuDjM9tVXcVupNUiWuTltMiJ9+/4TaonmsKZ3PFA7rZiSuj
	 Ju0myBlQbtE6hLi1F/Ny3TQB0JjFxBtLUIz0LQClruvEFcTbBGohF+hV8c49XVZ3fF
	 pq9HJGxQCGlq00nmb7AnWjbPUjjI5S+5Cd4vuxIRITn8lrrK34AVhd7k7s0xOk8VJU
	 vtApr+qDzgWzkS1+bX3ryuorDiOpyYhuBHa2a/uQEdzNaP379uE12v3nVhHXBRo/m9
	 phowGMcyoST/Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alper Ak <alperyasinak1@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 016/147] tpm: st33zp24: Fix missing cleanup on get_burstcount() error
Date: Sat, 28 Feb 2026 13:15:24 -0500
Message-ID: <20260228181736.1605592-16-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Alper Ak <alperyasinak1@gmail.com>

[ Upstream commit 3e91b44c93ad2871f89fc2a98c5e4fe6ca5db3d9 ]

get_burstcount() can return -EBUSY on timeout. When this happens,
st33zp24_send() returns directly without releasing the locality
acquired earlier.

Use goto out_err to ensure proper cleanup when get_burstcount() fails.

Fixes: bf38b8710892 ("tpm/tpm_i2c_stm_st33: Split tpm_i2c_tpm_st33 in 2 layers (core + phy)")
Signed-off-by: Alper Ak <alperyasinak1@gmail.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/st33zp24/st33zp24.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/st33zp24/st33zp24.c b/drivers/char/tpm/st33zp24/st33zp24.c
index 4ec10ab5e5766..33ee4fe693796 100644
--- a/drivers/char/tpm/st33zp24/st33zp24.c
+++ b/drivers/char/tpm/st33zp24/st33zp24.c
@@ -381,8 +381,10 @@ static int st33zp24_send(struct tpm_chip *chip, unsigned char *buf,
 
 	for (i = 0; i < len - 1;) {
 		burstcnt = get_burstcount(chip);
-		if (burstcnt < 0)
-			return burstcnt;
+		if (burstcnt < 0) {
+			ret = burstcnt;
+			goto out_err;
+		}
 		size = min_t(int, len - i - 1, burstcnt);
 		ret = tpm_dev->ops->send(tpm_dev->phy_id, TPM_DATA_FIFO,
 					 buf + i, size);
-- 
2.51.0

