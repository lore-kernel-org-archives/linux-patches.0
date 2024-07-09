Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F5C34545;
	Tue,  9 Jul 2024 11:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524659; cv=none; b=mMmdGBXuzeHRhZ6A6slusQhmEa+eWFCVkxzuVpuIPWUtZ+xJkNBmRTf+GxonxQLPRWYQLymvMcWcOzHljkdBzdx89JxH2u3Ia34zrxDYOial8OwOS4uDZt3bhWO93xYmRKLLIsFS7fwrIO/lNuOSsxn0KLYzSZ93BWwXNosqxus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524659; c=relaxed/simple;
	bh=7hhp7zZ+VnqFNxkNDDDetMV5moRRmVy7pDbumgrKF9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C9iaqa7VYJvjqyHnMMBeURsbbM9KXJvgQwDp+2CS1kikFGc6+m24naDBjUNBbWZcz4rnbOpwVprvqnLtimLdbq1OC9Z++NIZYAPwvnrkd2FqQg1xfSbeoy5JCxOz6UbVuDJuGstLEdP2U38/6+G3Cjo2MBOxurElWhJxBMDLVXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fyda/AmK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fyda/AmK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E620DC3277B;
	Tue,  9 Jul 2024 11:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524659;
	bh=7hhp7zZ+VnqFNxkNDDDetMV5moRRmVy7pDbumgrKF9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fyda/AmKvgziIrM6JWlR9gy65sCrk+ESZcEMHYUdHW8D/KlNsRhuemYlBnJEL75Sy
	 +aluPTgEVTjhHScjeTvJD7R1Enz1/1xK1LB5UPa7xSrE0DQEmWLZFWkWQN2GYgAWxu
	 3NwmrgN7UW5r2+hD3trfSbDMrnLG7G39ibS3xbBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/102] media: dvb-frontends: tda10048: Fix integer overflow
Date: Tue,  9 Jul 2024 13:09:49 +0200
Message-ID: <20240709110652.387038523@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f6d8a64762b99..907e786c5e10b 100644
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



