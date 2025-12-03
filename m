Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4DC34E761;
	Wed,  3 Dec 2025 16:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778785; cv=none; b=pEQo6r/tDk7M82vy1dJLfdeHe2uRhzflhOitkLAfoXTxhkO05Z4ZtFxR5AXn3J5eNVeX+8oRgW1i2anVNGjA460W1c2fSLRwAvNf2Qn/MZNLk28klcFvpvSc/IIGQ38tnKBHium5VClTnu6nI1UsYGaLJJy9mSwGsh8dhlFJSEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778785; c=relaxed/simple;
	bh=zi495YNey4Hgts3a4wusjkS4DW/g3OajykZzSIJmt+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5ZkacD8cgjgLHBKRdJITQ7OZjTBKUtlc1GJhroOHzEWPlaYHpoHNNPNaucGyxI+DJDjAR4QJRxh/bq2LXg4zV24fyqFTW2vuwC3NGTL2sVxGlPDanKi1UfiHcZyTmIF9G8c2DQe/TQjVxQnPg6zNvssaJMQjaK82db7HmAKcj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ldi5S0uy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ldi5S0uy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6BFC4CEF5;
	Wed,  3 Dec 2025 16:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778785;
	bh=zi495YNey4Hgts3a4wusjkS4DW/g3OajykZzSIJmt+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ldi5S0uyp8BNnxdNi7L9aYTkFQkpeM5TDi50wFXpI9Nv3cM33mioNIvXxdil5p6/c
	 x8wZyKWiq+zM+NAMGGsZb+1PFpFIiErUHYUQ4U27BifGkXOSoZstLLAU/b9mqWYGeO
	 7BGrpPKNLhwU6lvs2QlWFck4Gsea6Gr+n4c8y8uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Ma Ke <make24@iscas.ac.cn>,
	Steev Klimaszewski <steev@kali.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 058/568] regmap: slimbus: fix bus_context pointer in regmap init calls
Date: Wed,  3 Dec 2025 16:21:00 +0100
Message-ID: <20251203152442.823035799@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Klimov <alexey.klimov@linaro.org>

commit 434f7349a1f00618a620b316f091bd13a12bc8d2 upstream.

Commit 4e65bda8273c ("ASoC: wcd934x: fix error handling in
wcd934x_codec_parse_data()") revealed the problem in the slimbus regmap.
That commit breaks audio playback, for instance, on sdm845 Thundercomm
Dragonboard 845c board:

 Unable to handle kernel paging request at virtual address ffff8000847cbad4
 ...
 CPU: 5 UID: 0 PID: 776 Comm: aplay Not tainted 6.18.0-rc1-00028-g7ea30958b305 #11 PREEMPT
 Hardware name: Thundercomm Dragonboard 845c (DT)
 ...
 Call trace:
  slim_xfer_msg+0x24/0x1ac [slimbus] (P)
  slim_read+0x48/0x74 [slimbus]
  regmap_slimbus_read+0x18/0x24 [regmap_slimbus]
  _regmap_raw_read+0xe8/0x174
  _regmap_bus_read+0x44/0x80
  _regmap_read+0x60/0xd8
  _regmap_update_bits+0xf4/0x140
  _regmap_select_page+0xa8/0x124
  _regmap_raw_write_impl+0x3b8/0x65c
  _regmap_bus_raw_write+0x60/0x80
  _regmap_write+0x58/0xc0
  regmap_write+0x4c/0x80
  wcd934x_hw_params+0x494/0x8b8 [snd_soc_wcd934x]
  snd_soc_dai_hw_params+0x3c/0x7c [snd_soc_core]
  __soc_pcm_hw_params+0x22c/0x634 [snd_soc_core]
  dpcm_be_dai_hw_params+0x1d4/0x38c [snd_soc_core]
  dpcm_fe_dai_hw_params+0x9c/0x17c [snd_soc_core]
  snd_pcm_hw_params+0x124/0x464 [snd_pcm]
  snd_pcm_common_ioctl+0x110c/0x1820 [snd_pcm]
  snd_pcm_ioctl+0x34/0x4c [snd_pcm]
  __arm64_sys_ioctl+0xac/0x104
  invoke_syscall+0x48/0x104
  el0_svc_common.constprop.0+0x40/0xe0
  do_el0_svc+0x1c/0x28
  el0_svc+0x34/0xec
  el0t_64_sync_handler+0xa0/0xf0
  el0t_64_sync+0x198/0x19c

The __devm_regmap_init_slimbus() started to be used instead of
__regmap_init_slimbus() after the commit mentioned above and turns out
the incorrect bus_context pointer (3rd argument) was used in
__devm_regmap_init_slimbus(). It should be just "slimbus" (which is equal
to &slimbus->dev). Correct it. The wcd934x codec seems to be the only or
the first user of devm_regmap_init_slimbus() but we should fix it till
the point where __devm_regmap_init_slimbus() was introduced therefore
two "Fixes" tags.

While at this, also correct the same argument in __regmap_init_slimbus().

Fixes: 4e65bda8273c ("ASoC: wcd934x: fix error handling in wcd934x_codec_parse_data()")
Fixes: 7d6f7fb053ad ("regmap: add SLIMbus support")
Cc: stable@vger.kernel.org
Cc: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: Ma Ke <make24@iscas.ac.cn>
Cc: Steev Klimaszewski <steev@kali.org>
Cc: Srinivas Kandagatla <srini@kernel.org>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Alexey Klimov <alexey.klimov@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://patch.msgid.link/20251022201013.1740211-1-alexey.klimov@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/regmap/regmap-slimbus.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/base/regmap/regmap-slimbus.c
+++ b/drivers/base/regmap/regmap-slimbus.c
@@ -48,8 +48,7 @@ struct regmap *__regmap_init_slimbus(str
 	if (IS_ERR(bus))
 		return ERR_CAST(bus);
 
-	return __regmap_init(&slimbus->dev, bus, &slimbus->dev, config,
-			     lock_key, lock_name);
+	return __regmap_init(&slimbus->dev, bus, slimbus, config, lock_key, lock_name);
 }
 EXPORT_SYMBOL_GPL(__regmap_init_slimbus);
 
@@ -63,8 +62,7 @@ struct regmap *__devm_regmap_init_slimbu
 	if (IS_ERR(bus))
 		return ERR_CAST(bus);
 
-	return __devm_regmap_init(&slimbus->dev, bus, &slimbus, config,
-				  lock_key, lock_name);
+	return __devm_regmap_init(&slimbus->dev, bus, slimbus, config, lock_key, lock_name);
 }
 EXPORT_SYMBOL_GPL(__devm_regmap_init_slimbus);
 


