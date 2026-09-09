Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1560F568FD7;
	Wed,  9 Sep 2026 14:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963445; cv=none; b=MSHl34jEWrAyBB4nUm+8MRtw1KWdQFWoau0BNI1wSnACQXoxufdrTuOmVie9jWMK2+/l97FZOtLJaRw88YM53ULkIzCHtPNXqzSF+UKGEV8V1dSfgv+OaadzArRmyLwmwWO+EUn8wpmODLNMNeuR7XY7qkUqzCAHKFvmDSW0vJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963445; c=relaxed/simple;
	bh=SeVBOfcEycSdt1FU230KdnX6TeF8yXFCC4OoA/zE1Io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iUvYTgDS4pS4sedsAL6WZD52OUNfSgQdvIY5oifVwleXQwKuw0f1vsl9jmzLYO/WA8EtyRWsrB6yK2Chi40vjJTAr8AOetCq2ytmZBMEGio3L2lcIF91hbWcUVPjwG/rnVPl8szmQUd15iBCzJUMBx4RiW6QPJkiaZwKCkQE42g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SKbnW/oy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SKbnW/oy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274A81F00A3A;
	Wed,  9 Sep 2026 14:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963443;
	bh=MzYhh+TNP2GyVjTc5eUuAVmVCbMnvXgBu+3/MLAGi+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SKbnW/oyo6Hqz+X4CZvc2HCtUcwcLJimbYBT+3xa98Q1gOlNuMwIBqYQ3p5a7Gcnb
	 onJKEjf0/Y34XWD74bTEqNvZo446k1XUwQgAv4//Az4lcTCEMW/BfLWRcg28CVYJ2H
	 2fAzLJd8KWsQRO7KnQrG/5ceiUSBr3+KLd5gLrFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Kursad Oney <kursad.oney@broadcom.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 042/583] spi: bcmbca-hsspi: disable clocks on resume failure
Date: Wed,  9 Sep 2026 15:35:27 +0200
Message-ID: <20260909134239.386191708@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Can Peng <pengcan@kylinos.cn>

commit d2f5a606710ad70c341dc609430a20a5645618d5 upstream.

bcmbca_hsspi_resume() enables the HSSPI clock, and optionally the PLL
clock, before restarting the SPI controller queue.

If spi_controller_resume() fails, the function currently reports success
and leaves those clocks enabled. Propagate the error and disable the
clocks before returning.

Fixes: a38a2233f23b ("spi: bcmbca-hsspi: Add driver for newer HSSPI controller")
Cc: stable@vger.kernel.org
Signed-off-by: Can Peng <pengcan@kylinos.cn>
Reviewed-by: Kursad Oney <kursad.oney@broadcom.com>
Link: https://patch.msgid.link/20260804071904.860842-1-pengcan@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-bcmbca-hsspi.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-bcmbca-hsspi.c
+++ b/drivers/spi/spi-bcmbca-hsspi.c
@@ -612,7 +612,13 @@ static int bcmbca_hsspi_resume(struct de
 		}
 	}
 
-	spi_controller_resume(host);
+	ret = spi_controller_resume(host);
+	if (ret) {
+		if (bs->pll_clk)
+			clk_disable_unprepare(bs->pll_clk);
+		clk_disable_unprepare(bs->clk);
+		return ret;
+	}
 
 	return 0;
 }


