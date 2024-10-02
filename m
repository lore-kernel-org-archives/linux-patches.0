Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813E76FB0;
	Wed,  2 Oct 2024 14:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880158; cv=none; b=CrzijKyEBAnZfj0Jzt5KCeYwBC3cDeFG8Iz2CUwb2f9S/sTJRy6h/0fEjZW2MnCv2mxSDcWLd5jkEYJuT9fx6F07/WR8aqmt+ATt5ePDFBE1zcO/ET28PcYXOB5M6zPhnbl35JByCzSR6VhSg9bDHfdNKggxk2Kom6eU1ftk7+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880158; c=relaxed/simple;
	bh=E17Df4wX4NOxka3vBVsF8TXXxQ1wzEuI3ivB9gIyc08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V1RIfe+n8WLm7eV3E9mKqukN7NhhNkiQMQ0b5GR/jc/oinYt73uPAtNjHuQ7duGtDagqT98SOmvs5cwX1hNS/36MEFDISVpcOjzejTzVEHZ1VntN1zA8NooS//Ypbgo89GlMClyEFxqCWogDzC+YIya89wmt7bfveP4zdRU2fCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c5yYzTz/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c5yYzTz/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09779C4CEC2;
	Wed,  2 Oct 2024 14:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880158;
	bh=E17Df4wX4NOxka3vBVsF8TXXxQ1wzEuI3ivB9gIyc08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c5yYzTz/77dAoSnJ5y998H5oclt5KVVsO9nj0Bu2I+QRTYiJI2BpGNZyKqto55aK8
	 rWsWIG86zlpLpURjMUZb9TOGOxrl1kO+8BFiCHsSZHVFOyX9VTH6Ndu3FbTn5k3x0y
	 GXLoqo1A+k8MWwp/XMpCbsU2rTJ45q4McQe8tDKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 362/538] serial: 8250: omap: Cleanup on error in request_irq
Date: Wed,  2 Oct 2024 15:00:01 +0200
Message-ID: <20241002125806.715946368@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Schneider-Pargmann <msp@baylibre.com>

[ Upstream commit 35e648a16018b747897be2ccc3ce95ff23237bb5 ]

If devm_request_irq fails, the code does not cleanup many things that
were setup before. Instead of directly returning ret we should jump to
err.

Fixes: fef4f600319e ("serial: 8250: omap: Fix life cycle issues for interrupt handlers")
Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
Reviewed-by: Kevin Hilman <khilman@baylibre.com>
Tested-by: Kevin Hilman <khilman@baylibre.com>
Link: https://lore.kernel.org/r/20240807141227.1093006-4-msp@baylibre.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_omap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 8f472a2080ffa..4caecc3525bfd 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -1567,7 +1567,7 @@ static int omap8250_probe(struct platform_device *pdev)
 	ret = devm_request_irq(&pdev->dev, irq, omap8250_irq, 0,
 			       dev_name(&pdev->dev), priv);
 	if (ret < 0)
-		return ret;
+		goto err;
 
 	priv->wakeirq = irq_of_parse_and_map(np, 1);
 
-- 
2.43.0



