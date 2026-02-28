Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C8939B94A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302515; cv=none; b=jgvVVuXyAQt8w51eLid247WJKsYTX6Dh3CURMw7Vj1Xb0LjhGekaT5y5Ty1qBpIVv/kwcVsQFscui4bq6nV8rZI+aPqoRIrKvGUyKE97mpipo+vGGt8VRUpYeeKxFkdndz4ZlVpJuBF11JjNPgu60bT+pGK/m527zwQtxMcgKXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302515; c=relaxed/simple;
	bh=ilTWDM8sYpRaPyj3U99FjkHB9tfSK9FPBoVNkPgjEgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IfFpEPOLNdQRsbjavG9+S3h36IJunhG0NCdMhy6EL3epIotO5i0FhWsETw6z5W73hLvJfZw1mfqc5+A0yR+YmC8jWGZGIOlfLPcbZ/WKPoEQJM1arKxzE4/1Go7xejptaaDOVNuD8ptZNwuahixqAU3NveVfrzdMuNVDpHjRgjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o4t4jjS8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o4t4jjS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86CCCC116D0;
	Sat, 28 Feb 2026 18:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302515;
	bh=ilTWDM8sYpRaPyj3U99FjkHB9tfSK9FPBoVNkPgjEgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o4t4jjS8GJy+TIutCAtzKrDRnvTKpB7uvcOvIHe70VMbWtostkg/IzEXJjjHrUo36
	 4b2XN9LwommIR2cp0/aXCT8FepuxYNjX/TOdRgX5+eiuRqocV7XtlWlmwsTlY2nlYa
	 pZIdhNoxuGdP2wUw6F6fzzxW0gp89JTRSt9H79t9UW2xDtAufMMPnhyNpCyAcfjuVH
	 HJHfUNSFO9+CLvL8qpJMDMFpqphT1OAzd4odHpQFUUqtyDoiToFpJDOawD+iPjv4Me
	 qKX+FmSXYvWGrix9vFAtA5C6nq5N6Ml6ONWZ2K7hSMgTNTIBoF5n2gldd9zbkhZlan
	 h0HFvCT1wizIw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alper Ak <alperyasinak1@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 011/164] tpm: st33zp24: Fix missing cleanup on get_burstcount() error
Date: Sat, 28 Feb 2026 13:12:30 -0500
Message-ID: <20260228181505.1600663-11-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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

