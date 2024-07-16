Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3139CA40;
	Tue, 16 Jul 2024 15:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144265; cv=none; b=hmoY8PyxNbbh7yiQCgoqn76BC9RDUbz5tEZ57IUvpomM4NNXcrtja20uGq40I0ppLB2xeGH7bSuCbMC+S5V3lKa1jdyzeASkUN1m0M+KVkX/Yatkk05YVfx7g88/jw0Q/cHKvHEy+SdLs5zLDgl9ABd3ZUPzRL3j3dBP13XzSOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144265; c=relaxed/simple;
	bh=mzW9VnNPi8hfVWwWylxief5gTWGYDuDD4WzgDE6loPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zn4v0zquayg69Y7j/48d6bH1QvmR3Ai2R3WKIx9Hi6pitVV1mGushNcdK29UPUOMoouxmsEmYm06A5UTJeuOJZg7VKw25KQwNIRwcBiLwuEl0CwE2X7IihX7xYSsKwZn0c4Ek4awZTB9fBqYiPDVyVw6nsMPw5P96XxtF7JgAGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jj+v9rbZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jj+v9rbZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588E1C116B1;
	Tue, 16 Jul 2024 15:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144265;
	bh=mzW9VnNPi8hfVWwWylxief5gTWGYDuDD4WzgDE6loPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jj+v9rbZqkrEJe+A6YDxnXkOO/xck7mHgsdnsaXQTZll2/zN4kv7cAOKT/ySQO7Ax
	 OmHEB+frfiL0X7f69kIoN76H2F1Sx0/AA1S8ZS9GVYKjlOCnIbEL5Pd0hZvY1Gy4TU
	 p3kxNREe51/FAcQ9pcZ5m2Z/R46DEa9D12GNDnbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 15/78] media: dvb-frontends: tda10048: Fix integer overflow
Date: Tue, 16 Jul 2024 17:30:47 +0200
Message-ID: <20240716152741.217609837@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
References: <20240716152740.626160410@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 1aa1329a67cc214c3b7bd2a14d1301a795760b07 ]

state->xtal_hz can be up to 16M, so it can overflow a 32 bit integer
when multiplied by pll_mfactor.

Create a new 64 bit variable to hold the calculations.

Link: https://lore.kernel.org/linux-media/20240429-fix-cocci-v3-25-3c4865f5a4b0@chromium.org
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/tda10048.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/tda10048.c b/drivers/media/dvb-frontends/tda10048.c
index f1d5e77d5dcce..db829754f1359 100644
--- a/drivers/media/dvb-frontends/tda10048.c
+++ b/drivers/media/dvb-frontends/tda10048.c
@@ -410,6 +410,7 @@ static int tda10048_set_if(struct dvb_frontend *fe, u32 bw)
 	struct tda10048_config *config = &state->config;
 	int i;
 	u32 if_freq_khz;
+	u64 sample_freq;
 
 	dprintk(1, "%s(bw = %d)\n", __func__, bw);
 
@@ -451,9 +452,11 @@ static int tda10048_set_if(struct dvb_frontend *fe, u32 bw)
 	dprintk(1, "- pll_pfactor = %d\n", state->pll_pfactor);
 
 	/* Calculate the sample frequency */
-	state->sample_freq = state->xtal_hz * (state->pll_mfactor + 45);
-	state->sample_freq /= (state->pll_nfactor + 1);
-	state->sample_freq /= (state->pll_pfactor + 4);
+	sample_freq = state->xtal_hz;
+	sample_freq *= state->pll_mfactor + 45;
+	do_div(sample_freq, state->pll_nfactor + 1);
+	do_div(sample_freq, state->pll_pfactor + 4);
+	state->sample_freq = sample_freq;
 	dprintk(1, "- sample_freq = %d\n", state->sample_freq);
 
 	/* Update the I/F */
-- 
2.43.0



