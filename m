Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E463446B0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302046; cv=none; b=jxwZkYF1aKch1AOVJPYj7EHYFZvLB7FeGKdHhn738NaGjgOwBHn6IEjJWkkBv2mMVg8Bgp7axkAE9W0YMeP21lb7o0NxmvxPF7dYALzwVRWDFtspyiGAptBFXdZLN5eWVQcGxESZqeSECLgeUs4ic5XptwT5qzUhC6ADNLKWSBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302046; c=relaxed/simple;
	bh=5HBKY9CJww1o8R54/ZkEGxK4Q37ugnVlFAzAEzuWM7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfJoQnRTqZFpYdz8s5VkzNk6uoEBt2oYWAoRMEnvmFFfLVOoZ3dWtPvJfW0N86wI0S8APEjGJqYOLSFZlkOuhJ+wotOCUBOakvyJW4tFkGt3F7zmpVClTxMgRrIGWuZQyoXjg4PYDRA5A09oz8zAKeIqiRJ1PzoCUKK/bSnSDeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZyE03vWt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZyE03vWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F723C116D0;
	Sat, 28 Feb 2026 18:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302046;
	bh=5HBKY9CJww1o8R54/ZkEGxK4Q37ugnVlFAzAEzuWM7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZyE03vWtmL1NX/A4WSzJxR3QY2QS+3qH1eLwx1gm0ucnIgPaiHw3yWHG0ARzG2XHm
	 kxmKxprup3EI0e3yJY5WEi8PmyEObitZXk9mq7zEiq4DFNrs3jdtc29qFLJs5cRt8a
	 EPxpjZwFAJX0w4V6POZ0/FIaWUDGrTcobVR1vbJ4xofFX01oCV7zcm846bi3hohk/l
	 baBrs+60lzFR/5qrKCFxjXbhTQStFQIBq0zmGjDVu7dCjfPvnojHQQBQDQD4zYwGUy
	 Vr6xFhqQ6csIZR54t5qMxbWdbqTyyjno40vmo0qXCwozlMtsYQBXDMgla9t9Vih9Bz
	 rRKf89cAmOthg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alper Ak <alperyasinak1@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/283] tpm: st33zp24: Fix missing cleanup on get_burstcount() error
Date: Sat, 28 Feb 2026 13:02:41 -0500
Message-ID: <20260228180709.1583486-19-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index a5b554cd47786..f78c61f4163d5 100644
--- a/drivers/char/tpm/st33zp24/st33zp24.c
+++ b/drivers/char/tpm/st33zp24/st33zp24.c
@@ -328,8 +328,10 @@ static int st33zp24_send(struct tpm_chip *chip, unsigned char *buf,
 
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

