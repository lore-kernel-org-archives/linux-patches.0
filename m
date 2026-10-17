Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575522E8DEB;
	Sat, 17 Oct 2026 17:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256755; cv=none; b=ZN6O7nfK6RRwizwC3L+jWpSNcRK/8jg15Tm7qTwIRI2XCmpHN9rnfVL58IGK7NntVY8HZu2Do/wYHIY9vvY8NlO6V2fDkkmQYYY3cNkHU3njUJow4WL4CkJ1KOtFPu1XdjRolxMBzxQ/X7rDLTWylkjtavpz2trJgw4lREuEFm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256755; c=relaxed/simple;
	bh=MtQmyZKajJxquWFSldt9WeX3vGAV5+D7vs7zEQ4gj0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Av8T3EGYf4bg+X0zumBi38epC3UAb1yYAa+O48KwghESvWkZd5wr2gxwcYu6HiWD3LTyUExLz532zDHsV2+l0bwIBnK60BeNZs8wdJzv/nqQiRvz4Ay9V43HQsPvizvUVdn1a3c2c1BCSVbXtfhX2g2bZykFRgJmfRUSPCI8gJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QpOOX6xT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QpOOX6xT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32961F000C4;
	Sat, 17 Oct 2026 17:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256754;
	bh=PuCySJMBAQmE2B6vweg5iU+d2SBbudSK4WSBonAQZtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QpOOX6xTfKGvHWlfueHDB8ogOY+92QEmSQRtxEOhjmEUe4Ic8w4wnEeKKlxiBJgso
	 EI3N76hpmue5KN1HfOD6KsGAhJ1ycVWvA2qpY2EVOK2z6TTSG+8NMI2nzrvJ0yi8Tr
	 6vhutdOM1R2fsFPXvLYeIvdYkQT9V5eGlyQcJsh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.6 0339/1674] iio: adc: sun4i-gpadc-iio: drop underflowing pm_runtime_put() calls
Date: Sat, 17 Oct 2026 17:43:31 +0200
Message-ID: <20261017160439.827785930@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

commit 8b958dd214ad0c003f56549e9e039cb8067dc1a2 upstream.

Neither the error path in sun4i_gpadc_probe() nor sun4i_gpadc_remove()
ever holds a runtime PM usage count. So the pm_runtime_put() in both
places always triggers the "Runtime PM usage count underflow!" warning
on every failed probe and every unbind.

Drop both calls.

Fixes: d1caa9905538 ("iio: adc: add support for Allwinner SoCs ADC")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/sun4i-gpadc-iio.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/iio/adc/sun4i-gpadc-iio.c
+++ b/drivers/iio/adc/sun4i-gpadc-iio.c
@@ -663,7 +663,6 @@ err_map:
 	if (!info->no_irq && IS_ENABLED(CONFIG_THERMAL_OF))
 		iio_map_array_unregister(indio_dev);
 
-	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
 	return ret;
@@ -674,7 +673,6 @@ static int sun4i_gpadc_remove(struct pla
 	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
 	struct sun4i_gpadc_iio *info = iio_priv(indio_dev);
 
-	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
 	if (!IS_ENABLED(CONFIG_THERMAL_OF))


