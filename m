Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9193E158A04;
	Tue,  9 Jul 2024 11:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524052; cv=none; b=FsLwY5VpCsp2n8AUOvZr8ixsrK4QhLTENoUr2FvoJ/BC+w3La7/dIOT5b+REli0hI05zFtunTKawSRYTl3s0ywV68sNkZ91TnjIrliAzXhhrpIg9kFVfj6xqYVgn1aKSfk3os/qVU/t2BhvFXipMm3MFwFhhh+/b3GuIEsDfg1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524052; c=relaxed/simple;
	bh=JSnWvAzRXeYhxHZa8ncFygTLQCHDo7/2+TWvKq2n1sY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OpNOKdjphZ/LDF8vqFOYWgbMh53a1VllBuE3yMDSRzKKw4PvaprgdoPGUzZHazUR7LeVQEb9XHm4jD1WcDOwdRTyB1r3r5O26vTZzOYtTC7WP0CgPTrmbCgfLeJC/PmCmFmK4UiCeOCMhVvl2z3mAxESvHUZ9OLyw2LHie6kSpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Atxyy5vI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Atxyy5vI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A9AC3277B;
	Tue,  9 Jul 2024 11:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524052;
	bh=JSnWvAzRXeYhxHZa8ncFygTLQCHDo7/2+TWvKq2n1sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Atxyy5vICFgPc2xOeefQaPlXOmVkehQsta/VqPnyliZ9lxx3fUXIUwIrdpawDKS/k
	 tLtvlA5VMSO2D2Uf46Am1MrfbMvpQ18nAEika6ghBR2y2UH4y9PwsQ7E7FGeE06X7c
	 1s0elKMh/3UF8pqlpyTUMkcYCGiRp67HgqTO2NtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 055/197] media: dvb-frontends: tda10048: Fix integer overflow
Date: Tue,  9 Jul 2024 13:08:29 +0200
Message-ID: <20240709110711.092228916@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 5d5e4e9e4422e..3e725cdcc66bd 100644
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



