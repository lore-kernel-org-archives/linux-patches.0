Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C173CFF44;
	Fri, 15 May 2026 16:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862630; cv=none; b=FljULRrmggQ6ZYmz0FUmnElPsa/cOLjcGpCPtXY4dIOJ10C5YYD2zi9YCzLGGKJZgoLWrXPOsa8D/TOEU2ZYpCmNdRcyOkj4pWB48Nu94JvYuA8KAaC7vtwbdPPngchNMi/vZYxGJMN2hldUC7mI8HSGvm50xyDIsgiCPU+KLJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862630; c=relaxed/simple;
	bh=SuApv9Lm29i7f4Hkd7YzV6levTEYxS+xyYhdtLqYMo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q9hC8jW0/qW76cIiC2PjUALGgc3ouXjmLPWeOeCLADiqc4L9n3zKuIy8O42KnlgfTKnPzEzwk+M4gf1tNLCBEG1IOXwT6W7fIjSBKeVuxKLTsHkbvlJWgWV3hxn4W3NS8OKIeqVGoIsVh5XX99yjwpXyGMuq4og+X7aI9FTc/Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jj5F2Alp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jj5F2Alp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7C2C2BCB0;
	Fri, 15 May 2026 16:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862630;
	bh=SuApv9Lm29i7f4Hkd7YzV6levTEYxS+xyYhdtLqYMo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jj5F2AlpCvlaYKiRNRKfG+TJfnhITsuVCGdbWhaOcdWc4J5ARcp+Ql6TE3Wk+nSTz
	 QFhZFJnT4AQJNOCzJe/lZNvZzN6+RrlnbbQV1kjxP3c0G7XKNkpnmzPJHv91tPl6Mm
	 7Yqhg0KsWLqWN9GRxHDy6DZogO2jpapjpdzN0ALs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anurag Dutta <a-dutta@ti.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 121/201] spi: cadence-quadspi: fix clock imbalance on probe failure
Date: Fri, 15 May 2026 17:48:59 +0200
Message-ID: <20260515154701.183207770@linuxfoundation.org>
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

commit cba53fe20c18688c17ca668ad0e4ec05e31c70d3 upstream.

Drop the bogus runtime PM get on probe failures that was never needed
and that leaks a usage count reference while preventing the clocks from
being disabled (as runtime PM has not yet been enabled).

Fixes: 1889dd208197 ("spi: cadence-quadspi: Fix clock disable on probe failure path")
Cc: stable@vger.kernel.org	# 6.19
Cc: Anurag Dutta <a-dutta@ti.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260421125354.1534871-3-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-cadence-quadspi.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -2004,8 +2004,7 @@ disable_rpm:
 		pm_runtime_disable(dev);
 	cqspi_controller_enable(cqspi, 0);
 disable_clks:
-	if (pm_runtime_get_sync(&pdev->dev) >= 0)
-		clk_bulk_disable_unprepare(CLK_QSPI_NUM, cqspi->clks);
+	clk_bulk_disable_unprepare(CLK_QSPI_NUM, cqspi->clks);
 
 	return ret;
 }


