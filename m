Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A90D53B;
	Tue, 16 Jul 2024 15:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144053; cv=none; b=qMNgxR3giQmyqYiUiZbYobrYk5lp2jfoQPqvnniijZRtoMmgg8xsvJtOXJxHaG9aLgXersUvY3fFKaaI1z6TrFlaHcU61UEDT4zglooLU5w0our3g928dE2UvVgsngJi+n85XnRXUIMu+iuVXmnd6zb+AFqSrSySX06oXUR9buo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144053; c=relaxed/simple;
	bh=0uADDyyYfVTkNogd5tBz+kjhyGmeHiBV6R3iksmo4y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=McDyWm+CqDX2saoWQDS4xyvZ/JSrv30fNIXqK1n1cJdT6TZvITULafUACo+4rNa8Osr01YnaLFCMMXz2NPqBp/9F6+47IaT1nJs0o1gqDDoQC8fZhbSevBGTnDmlp66aQCLkvoertqWvCkXjqETuxi/HmqPod+W6dIc4iNghxsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jxIj47T9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jxIj47T9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF372C116B1;
	Tue, 16 Jul 2024 15:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144053;
	bh=0uADDyyYfVTkNogd5tBz+kjhyGmeHiBV6R3iksmo4y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jxIj47T92aUUjdwoMYL8CiV145hFC/NOX7xYpL2oOOy4yvIJgSkI4oYe18XXGgNcj
	 Ff+duDmXFXhTk+rqHFgfFDubqj+7LCxdgTjuMpWeeozeL2BdA+yzmmg8EOtjKu23UW
	 tvGcUNUK1TS4i2ruc2H37pqKC2pKC+1p3VnqdouE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 12/66] media: dvb-frontends: tda10048: Fix integer overflow
Date: Tue, 16 Jul 2024 17:30:47 +0200
Message-ID: <20240716152738.631802633@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152738.161055634@linuxfoundation.org>
References: <20240716152738.161055634@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 6ca1b25542c5c..888ae41b76857 100644
--- a/drivers/media/dvb-frontends/tda10048.c
+++ b/drivers/media/dvb-frontends/tda10048.c
@@ -422,6 +422,7 @@ static int tda10048_set_if(struct dvb_frontend *fe, u32 bw)
 	struct tda10048_config *config = &state->config;
 	int i;
 	u32 if_freq_khz;
+	u64 sample_freq;
 
 	dprintk(1, "%s(bw = %d)\n", __func__, bw);
 
@@ -463,9 +464,11 @@ static int tda10048_set_if(struct dvb_frontend *fe, u32 bw)
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



