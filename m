Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E18785933;
	Mon,  8 Apr 2024 13:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583285; cv=none; b=UhFrN48qLfwdKDfwwCHMqOpGn1mQGGjj+7p0C0FH9TXm1X6UJuReKrbQLfiBWD6K3olZnXALWIlXAJp7OQTZWesaINj6EJFwn0TZlRM43u4zwpyE3B8E2564iczuzzYzPQUd6lp+3NlB+JOLuXMfCLCvJV1xrvs5nLSQF8/R97s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583285; c=relaxed/simple;
	bh=8utuXNG3oBQi+BxMFu6YIcDYGoTbFv8AJgfPLQA5+sE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PL9afJb0hXAHjavPQKZjMNKkzQorKtSsD47gtewVAmlCgRr8Ym00fcvSYFkeEzHVV/NerF9R2Rg0dByHMYTdr1ykHVe++s8AtP8GKZM/ApHm4MDui9xADaScNhGgGaeXa/+FO/nHftk8iUp+4NHlJ0IQHlU+idq/AOPOdKsck68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=of6I/U4V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="of6I/U4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8135C433F1;
	Mon,  8 Apr 2024 13:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583285;
	bh=8utuXNG3oBQi+BxMFu6YIcDYGoTbFv8AJgfPLQA5+sE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=of6I/U4V+rddpouyCKNOL0EO74g2iWN1ACObzwJKLQDCI91fKtAKKqybmCU2SYkGx
	 9W3dvd9xkg0+OM/xccsZjup+GR/yOTYddTOlF97jRy82Ilc53D9VCv0cacEajEPv19
	 Faq+hAJnbFSUNkDORaMcm8zTimqH23SuHh+MI0+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 145/273] ASoC: wm_adsp: Fix missing mutex_lock in wm_adsp_write_ctl()
Date: Mon,  8 Apr 2024 14:57:00 +0200
Message-ID: <20240408125313.791483644@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit f193957b0fbbba397c8bddedf158b3bf7e4850fc ]

wm_adsp_write_ctl() must hold the pwr_lock mutex when calling
cs_dsp_get_ctl().

This was previously partially fixed by commit 781118bc2fc1
("ASoC: wm_adsp: Fix missing locking in wm_adsp_[read|write]_ctl()")
but this only put locking around the call to cs_dsp_coeff_write_ctrl(),
missing the call to cs_dsp_get_ctl().

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 781118bc2fc1 ("ASoC: wm_adsp: Fix missing locking in wm_adsp_[read|write]_ctl()")
Link: https://msgid.link/r/20240307110227.41421-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm_adsp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index 36ea0dcdc7ab0..9cb9068c0462a 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -683,11 +683,12 @@ static void wm_adsp_control_remove(struct cs_dsp_coeff_ctl *cs_ctl)
 int wm_adsp_write_ctl(struct wm_adsp *dsp, const char *name, int type,
 		      unsigned int alg, void *buf, size_t len)
 {
-	struct cs_dsp_coeff_ctl *cs_ctl = cs_dsp_get_ctl(&dsp->cs_dsp, name, type, alg);
+	struct cs_dsp_coeff_ctl *cs_ctl;
 	struct wm_coeff_ctl *ctl;
 	int ret;
 
 	mutex_lock(&dsp->cs_dsp.pwr_lock);
+	cs_ctl = cs_dsp_get_ctl(&dsp->cs_dsp, name, type, alg);
 	ret = cs_dsp_coeff_write_ctrl(cs_ctl, 0, buf, len);
 	mutex_unlock(&dsp->cs_dsp.pwr_lock);
 
-- 
2.43.0



