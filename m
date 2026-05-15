Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953B43FF1A0;
	Fri, 15 May 2026 15:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860356; cv=none; b=mcDszS9X8v2Py0U1c8ZSkQBMEWj79Ot/L8Gta9qnax2EqRoz92LunnV+oKYKeDw8LZlBZazLLAo1RJa251FUQrwfOAO159rEISvEBTHLgy+X0P2a3iLfQberZc962TnXvebbX2Or6rlRyhiW1QYbwjt1CvntJvylFu1x2v9kAPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860356; c=relaxed/simple;
	bh=fN8/zJG+CiZfecpkuZhaaf17JLY2zhqJmxMAZGIj4p0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WwA1SXAallTTF/uubSsLcCZV7Y9r67nFhXyW7vtpZyBBGE8bIre/fFoDbEv7QgWr+p/xC+cw6RsZgizOGxqUHgyiX0rm+hb5GBR6MJVovJWl062PlEMdkmzPrHMR3HnLwTjSbkk4Z/rqMCBeH3/f2nKCasSk+Qu9EYZps/GrPPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fGzhsFCU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fGzhsFCU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E11C7C2BCB0;
	Fri, 15 May 2026 15:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860356;
	bh=fN8/zJG+CiZfecpkuZhaaf17JLY2zhqJmxMAZGIj4p0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fGzhsFCUvuOIfHsMT2dhDduxRwYX0qpUZCo8vmqvlVnhJ/v89/0YcfRAr76LRpblN
	 bdaujMfgEIC+DKlRhGck9AnwjsFyfAsBQy2xa3arAaTi+7J1vObQ46mcdRaeEbVxje
	 zfH5K/O2GCvhE7ai4K/kFxtPwnH1v18OuCD55r5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 055/144] spi: imx: fix runtime pm leak on probe deferral
Date: Fri, 15 May 2026 17:48:01 +0200
Message-ID: <20260515154654.823924587@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit a1d50a37d3b1df84f536a982f692371039df4a48 upstream.

Make sure to balance the runtime PM usage count before returning on
probe failure (e.g. probe deferral) so that the controller can be
suspended when a driver is later bound.

Fixes: 43b6bf406cd0 ("spi: imx: fix runtime pm support for !CONFIG_PM")
Cc: stable@vger.kernel.org	# 5.10
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260421125632.1537235-1-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-imx.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1876,6 +1876,7 @@ out_register_controller:
 out_runtime_pm_put:
 	pm_runtime_dont_use_autosuspend(spi_imx->dev);
 	pm_runtime_disable(spi_imx->dev);
+	pm_runtime_put_noidle(spi_imx->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 
 	clk_disable_unprepare(spi_imx->clk_ipg);


