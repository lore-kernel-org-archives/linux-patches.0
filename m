Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDAD32B11D;
	Sat, 30 May 2026 17:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160671; cv=none; b=iJQonW7XfoTKyADPd9HqLZtNQKT6HAp+3Yvk+ftNjXgM4OM+mU2BFWw16nLuyOKTj+xHfFqCB/lkJiJQwONnRytxjUhQPpXhZ9aevonSAHsSEbk2gpNIgjPBRGN4zRgXUNB8ySSkDs3S0Ow6iF1Iz3mz9gLueAf37jCDco9CGmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160671; c=relaxed/simple;
	bh=URR4ANdAC30Bz9jOICTjpuZNqnGbB7iQjMterrP/6CE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/O9xImCyKyoSvr5Hr79IVasDES0YEIfGyuCgyJVY0ifmfZZym//TH0wl5Rks7OtvtD+uuz3ZjauC0ahLNttvZuVuEacy1vDvaCZRMy0QoYLWcBkWelEH33wYWiU1rx15jH2EsiP2uCHOT5/Imr8Ep7Yh+QtzCsRzH8mjD2yO/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MfAgsY3e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MfAgsY3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E0B1F00893;
	Sat, 30 May 2026 17:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160670;
	bh=6h1+UWXhQyi212AfW/pErAdoPwfwlB9MigptbfGvrzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MfAgsY3ejXwpjIp2+ATibwrMe8KF9x99s+QR6LSRhbimVsjn5mmgSm0bwDRLZ0uqg
	 auAnAN/GlDw6BDKnGFbru4IK/0B9nPV+uVXbdlggHklll6O91c2GgkzGzt6N/lCugH
	 Qr1nixUCYL/iZa3sVx/MKWH4Ggf7A0BPQb0SZiRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 400/969] spi: imx: fix runtime pm leak on probe deferral
Date: Sat, 30 May 2026 17:58:44 +0200
Message-ID: <20260530160311.335670531@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
@@ -1867,6 +1867,7 @@ out_register_controller:
 out_runtime_pm_put:
 	pm_runtime_dont_use_autosuspend(spi_imx->dev);
 	pm_runtime_disable(spi_imx->dev);
+	pm_runtime_put_noidle(spi_imx->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 
 	clk_disable_unprepare(spi_imx->clk_ipg);


