Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7BC223DC6;
	Sat, 30 May 2026 18:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164775; cv=none; b=KD8+CaLd+b+aXtJdhqVCcoUB4Jwg9lyougqOIHA312hIP3uHwaI1wgwwkI8bcoI1FMdRWme1rvy8xMgjj9tyqkhWBt75t05ZEnfrLKEA6ViJuBpCDoXiacQEXXwu1Wdy2HyVuam0Gn5Rxa1ERzX4B77WtTUzHwJQ++WcpalA0Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164775; c=relaxed/simple;
	bh=GuLEwqgaT1pHcsG2QPpH4sVr+CbqbFg9vzWnAz2C5qA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GPZWlQ5JrntxRbB2ikCB/m2/qt+Kf48KMrf2Ho7yyhgspsgY9FkGAMWYM+z1/91IlVvrkQyOIbV7kExKYV1Bl0D3iwSY2kL36QSFSkuA8KU2/BW9b0+4a7BiNXgNiUQxDVyicZ1fBEIgObT3u5sFhxon470Vxvtpk8tPG5LOP6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GE+3BwNe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GE+3BwNe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 632411F00893;
	Sat, 30 May 2026 18:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164774;
	bh=Cgb0BdEWxzfhfg1au+Z0ymmOdTxW2Gdq8w5k+Sy7mew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GE+3BwNeQpLWpOffcdqeXNiDPSdAfRHORq+7xTlb2xqV+XAsJ189aznj6eZILm2nJ
	 lli1/KOWvzb4MtwlCVqA6mqj4mYGK8FB1mtYhWI0AM3crLicisA3wfWxaD90uQZgqv
	 oxkt46zFiWuTa1S4hqFHI26cyjxsT4gARlcSs3fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian A. Ehrhardt" <christian.ehrhardt@codasip.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20 ?= <u.kleine-koenig@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 626/776] ASoC: codecs: ab8500: Fix casting of private data
Date: Sat, 30 May 2026 18:05:40 +0200
Message-ID: <20260530160256.154971468@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian A. Ehrhardt <christian.ehrhardt@codasip.com>

[ Upstream commit a201aef1a88b675e9eb8487e27d14e2eef3cef80 ]

ab8500_filter_controls[i].private_value is initialized using

	.private_value = (unsigned long)&(struct filter_control)
		{.count = xcount, .min = xmin, .max = xmax}

thus it's a pointer to a struct filter_control casted to unsigned long.

So to get back that pointer .private_data must be cast back, not its
address.

Fixes: 679d7abdc754 ("ASoC: codecs: Add AB8500 codec-driver")
Signed-off-by: Christian A. Ehrhardt <christian.ehrhardt@codasip.com>
Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
Link: https://patch.msgid.link/20260428192255.2294705-2-u.kleine-koenig@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/ab8500-codec.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/ab8500-codec.c b/sound/soc/codecs/ab8500-codec.c
index 5525e1ccab767..eaf12c28db83b 100644
--- a/sound/soc/codecs/ab8500-codec.c
+++ b/sound/soc/codecs/ab8500-codec.c
@@ -2498,13 +2498,13 @@ static int ab8500_codec_probe(struct snd_soc_component *component)
 		return status;
 	}
 	fc = (struct filter_control *)
-		&ab8500_filter_controls[AB8500_FILTER_ANC_FIR].private_value;
+		ab8500_filter_controls[AB8500_FILTER_ANC_FIR].private_value;
 	drvdata->anc_fir_values = (long *)fc->value;
 	fc = (struct filter_control *)
-		&ab8500_filter_controls[AB8500_FILTER_ANC_IIR].private_value;
+		ab8500_filter_controls[AB8500_FILTER_ANC_IIR].private_value;
 	drvdata->anc_iir_values = (long *)fc->value;
 	fc = (struct filter_control *)
-		&ab8500_filter_controls[AB8500_FILTER_SID_FIR].private_value;
+		ab8500_filter_controls[AB8500_FILTER_SID_FIR].private_value;
 	drvdata->sid_fir_values = (long *)fc->value;
 
 	snd_soc_dapm_disable_pin(dapm, "ANC Configure Input");
-- 
2.53.0



