Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17AD42D3A69;
	Sun,  7 Jun 2026 10:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828640; cv=none; b=bdQMi7Hgho3fJX+EcfhOncv0dzkAtfEtioA2TaLkhqY0aQ/5PP75RCyIhzFjdhXjx/tFaq9ZgSqoTRbR7Ql63HvsVDgeRJEijVQGJhDWyNbZiTE1n2/UUJzQkY/GnRHzKGKCjEpceZKufIGV5UGDuRP2iA9n/uqAqAx5+gjooQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828640; c=relaxed/simple;
	bh=RYB20Cq/LeEC9KK8r2i9Qa993iZj8TzaM8/AyR2DSO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a/eDyiSsOhZ5StVkJA9VlcnCjCMosDRVTg0P+GAAJJHABLmy/dRpXLqrjUkIf6NoCgrGiomA9bp3HNsO5bvflG99TeRoX6OD3ohBmXboloaN1rCKJJIE+JSWkiHhiHDXP/2G6GawIJ+klPWKOT8P0IoD8dm/fGtZkvjZvdb9ngw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tghpHeMh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tghpHeMh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF5441F00893;
	Sun,  7 Jun 2026 10:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828638;
	bh=tNxqzq5WKPIzU0d/zk5AD9IiHqmRf6r9l700aPdHIAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tghpHeMhMoBvSXpwOOKNwcZQpgZAsdpwh6z1i4EnmATNv8sYPyBBY0KrOKRd8Wqqe
	 E8Owg5qoeQsd+y4SsxiQFA+UH6Zs4H5JRZCGqSrCcfRVYKj67U+sEnL8EeA/y3w8/U
	 crAZOShfAIM32uLsGvI+rJ7VJQ1WqkQrUNvxOSg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	David Lechner <dlechner@baylibre.com>,
	Radu Sabau <radu.sabau@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 7.0 184/332] iio: adc: ad4695: Fix call ordering in offload buffer postenable
Date: Sun,  7 Jun 2026 11:59:13 +0200
Message-ID: <20260607095734.824250746@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radu Sabau <radu.sabau@analog.com>

commit 1a772719318c11e146f6fbe621fffd230a6f456a upstream.

ad4695_enter_advanced_sequencer_mode() was called after
spi_offload_trigger_enable(). That is wrong because
ad4695_enter_advanced_sequencer_mode() issues regular SPI transfers to
put the ADC into advanced sequencer mode, and not all SPI offload capable
controllers support regular SPI transfers while offloading is enabled.

Fix this by calling ad4695_enter_advanced_sequencer_mode() before
spi_offload_trigger_enable(), so the ADC is fully configured before the
first CNV pulse can occur. This is consistent with the same constraint
that already applies to the BUSY_GP_EN write above it.

Update the error unwind labels accordingly: add err_exit_conversion_mode
so that a failure of spi_offload_trigger_enable() correctly exits
conversion mode before clearing BUSY_GP_EN.

Fixes: f09f140e3ea8 ("iio: adc: ad4695: Add support for SPI offload")
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Signed-off-by: Radu Sabau <radu.sabau@analog.com>
Cc: Stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad4695.c |   23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

--- a/drivers/iio/adc/ad4695.c
+++ b/drivers/iio/adc/ad4695.c
@@ -876,14 +876,14 @@ static int ad4695_offload_buffer_postena
 	if (ret)
 		goto err_unoptimize_message;
 
-	ret = spi_offload_trigger_enable(st->offload, st->offload_trigger,
-					 &config);
+	ret = ad4695_enter_advanced_sequencer_mode(st, num_slots);
 	if (ret)
 		goto err_disable_busy_output;
 
-	ret = ad4695_enter_advanced_sequencer_mode(st, num_slots);
+	ret = spi_offload_trigger_enable(st->offload, st->offload_trigger,
+					 &config);
 	if (ret)
-		goto err_offload_trigger_disable;
+		goto err_exit_conversion_mode;
 
 	mutex_lock(&st->cnv_pwm_lock);
 	pwm_get_state(st->cnv_pwm, &state);
@@ -895,23 +895,16 @@ static int ad4695_offload_buffer_postena
 	ret = pwm_apply_might_sleep(st->cnv_pwm, &state);
 	mutex_unlock(&st->cnv_pwm_lock);
 	if (ret)
-		goto err_offload_exit_conversion_mode;
+		goto err_offload_trigger_disable;
 
 	return 0;
 
-err_offload_exit_conversion_mode:
-	/*
-	 * We have to unwind in a different order to avoid triggering offload.
-	 * ad4695_exit_conversion_mode() triggers a conversion, so it has to be
-	 * done after spi_offload_trigger_disable().
-	 */
-	spi_offload_trigger_disable(st->offload, st->offload_trigger);
-	ad4695_exit_conversion_mode(st);
-	goto err_disable_busy_output;
-
 err_offload_trigger_disable:
 	spi_offload_trigger_disable(st->offload, st->offload_trigger);
 
+err_exit_conversion_mode:
+	ad4695_exit_conversion_mode(st);
+
 err_disable_busy_output:
 	regmap_clear_bits(st->regmap, AD4695_REG_GP_MODE,
 			  AD4695_REG_GP_MODE_BUSY_GP_EN);


