Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A66344D8C;
	Fri, 15 May 2026 16:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862625; cv=none; b=LVEqEVmTrGOpDWvtU2/0KoRXKSFBjzuuBwFl4TE+DZrwtl8hILDWZ3RpZwZxg3xci7jCKcV4lLaVsfsvIdsx3LYDCwfjdKVunx2Ak77DSqSLqffXGGtvKc3kTlA3KvAVIb4S3Es0/rtmC1F52/aWyGGNCCr6zjanYAp3PhOzljE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862625; c=relaxed/simple;
	bh=rajBEbBnqXsNbh8BJNr+becq5dNaFzWmtnsP03wEiuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pbGmVSP77cQp8wo5Us+7+hoCA6vYZdTShYRzTcEFLglImfW/95G1kXCP6xef9y8sqtDTnhnY0KHcc9g627guJm5YjCNSDLuf9mTcbvVwrT6+1CMlNJF+/CP6/8pIDZwxPjd4cte9v10CCyfB8X2Vi4h0EH/1SwHcLq3RO4EiXfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mp5NQhRp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mp5NQhRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 700B3C2BCF5;
	Fri, 15 May 2026 16:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862624;
	bh=rajBEbBnqXsNbh8BJNr+becq5dNaFzWmtnsP03wEiuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mp5NQhRpJ+WPH/mKW1V+HgO1/PkUn8emLu0yRRWIEwIGwn2fnHfRXFTwWKynyt+dM
	 s535pvFNQ048RPV2D/0LqpxgsJ/xHV/sCnkuw6Jn+rLkfI2pYcPRIJaNhouaLSrhJA
	 C+Ji6pRBuLEYa63ycKIu6Ny2jYeIeCsj0xAnKLrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 119/201] spi: cadence: fix clock imbalance on probe failure
Date: Fri, 15 May 2026 17:48:57 +0200
Message-ID: <20260515154701.135622485@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -741,7 +741,6 @@ static int cdns_spi_probe(struct platfor
 		/* Set to default valid value */
 		ctlr->max_speed_hz = xspi->clk_rate / 4;
 		xspi->speed_hz = ctlr->max_speed_hz;
-		pm_runtime_put_autosuspend(&pdev->dev);
 	} else {
 		ctlr->mode_bits |= SPI_NO_CS;
 		ctlr->target_abort = cdns_target_abort;
@@ -752,12 +751,17 @@ static int cdns_spi_probe(struct platfor
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


