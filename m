Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C57830567C;
	Fri, 15 May 2026 16:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862072; cv=none; b=N+VeuCJNojwi4i/PA/KD49tERc7dbCsdxp+hrMdZuUWRmIic3mlIlBJVULFRfRuQMobKKJXjqbB7JWfVNBFCym1DEeRdhfBoq5+R+e9hryi7aS8kZlXfAyfjTVDTG9PmS2OGY18173+xs7ff1n5vNV4UMI1fW8O8ixm8sPQQMNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862072; c=relaxed/simple;
	bh=5zQpFug0KSfaloPiqQ0b33S4cELNaqKDllATB0pNvPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rm7N90Cehsp9PsZ8hMrAtM/7ayQuvF3FCnNcrpp8xBRRARYXh+bL58skXsfyp5lpluWsmYVApvgeY/mpNy78E83o+MelMLco8Fz+Kby5FC5ZioMnlwW2Vnc2gBvwOH03d2aGJTngQMZ5vY9b19golaXHfsW7qHXNTuEXjAqlSs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ckaabf00; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ckaabf00"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C757AC2BCB0;
	Fri, 15 May 2026 16:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862072;
	bh=5zQpFug0KSfaloPiqQ0b33S4cELNaqKDllATB0pNvPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ckaabf00/FTzXHpExvHPw+u82I5YRVu8wZ+83eif67jvQPDwjyyVuc2hldSwlId9K
	 SlIoTiRRgfW1EJ/JQryZoOO/T1eSSTEPZSXG71R7Pd6KcxIa/D6fbRWGyg+KgJglLq
	 vJpj6B8ZZRl/vSKfjSi8FqVTDrb+sDutGn8oKyKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 096/188] spi: cadence: fix clock imbalance on probe failure
Date: Fri, 15 May 2026 17:48:33 +0200
Message-ID: <20260515154659.412614171@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit ecea4f0e9db2fb6ab4a68a59c5aba0d8f59a9566 upstream.

Make sure that the controller is active before disabling clocks on probe
failure to avoid unbalanced clock disable.

Also drop the usage count before returning (so that the controller can
be suspended after a probe deferral) and restore the autosuspend
setting.

Fixes: d36ccd9f7ea4 ("spi: cadence: Runtime pm adaptation")
Cc: stable@vger.kernel.org	# 4.7
Cc: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260421123615.1533617-3-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-cadence.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-cadence.c
+++ b/drivers/spi/spi-cadence.c
@@ -662,7 +662,6 @@ static int cdns_spi_probe(struct platfor
 		/* Set to default valid value */
 		ctlr->max_speed_hz = xspi->clk_rate / 4;
 		xspi->speed_hz = ctlr->max_speed_hz;
-		pm_runtime_put_autosuspend(&pdev->dev);
 	} else {
 		ctlr->mode_bits |= SPI_NO_CS;
 		ctlr->target_abort = cdns_target_abort;
@@ -673,12 +672,17 @@ static int cdns_spi_probe(struct platfor
 		goto clk_dis_all;
 	}
 
+	if (!spi_controller_is_target(ctlr))
+		pm_runtime_put_autosuspend(&pdev->dev);
+
 	return ret;
 
 clk_dis_all:
 	if (!spi_controller_is_target(ctlr)) {
 		pm_runtime_disable(&pdev->dev);
 		pm_runtime_set_suspended(&pdev->dev);
+		pm_runtime_put_noidle(&pdev->dev);
+		pm_runtime_dont_use_autosuspend(&pdev->dev);
 	}
 remove_ctlr:
 	spi_controller_put(ctlr);


