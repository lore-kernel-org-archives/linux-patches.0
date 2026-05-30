Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892A22E7389;
	Sat, 30 May 2026 18:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780167159; cv=none; b=KpKPpuMmibtvaJIHsBd/6gUIpVbb+v2vfFbGj5JAsrELCJleTHsGO1NpN0SmvwKfUx5z1Hg5sfQpNPljxVpW7/6OsCXiSgiftUGWlQ+tcUgkhLWk4uf3mqtIK1UIxuP7b02IITxH4vXXI5owqLJk1zQdAys1+WpDzYc617/zkW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780167159; c=relaxed/simple;
	bh=TeY5B9V9NZ4SWoOLjiKZSHBpSI6v3uC9Kv6zqwju8dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RliN3OqAKwKwiKsra2Azlb2DxzdIW9nLNxem51LrZ2xXQ93N9Ztm0MkK6hJ2Kv+b+kSdKDD0Bq7ysLUy1xFdBkvlHqmxBrXQGUkhFvsymxwQo8QnRUBrCLpTmPdRhe4g6jGje2sYMRuPyjmKVqCfbtZhwVBVu20nKqwfz4lFI7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IWuX7Vt6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IWuX7Vt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9494D1F00893;
	Sat, 30 May 2026 18:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780167158;
	bh=hbGWKi87yTsyQi4FLQEZImvx9JBBDOo+0dsmLqIPPjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IWuX7Vt6k2uFDxRTn/wfq/Gj5IHKoV6NYkDQFeTVw6V08WsOO70nZ/REu00H99XjE
	 0bFBybpBsnQDaPJgh3czGLz0wKF7BMw3KK4+A8YKAXqd+FyFazEcC1aI4iApTmoAA5
	 hACTYyighzLjVvmWoDXIA/jAEzJmTaOGIYY3b3vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lanqing Liu <lanqing.liu@unisoc.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 545/589] spi: sprd: fix error pointer deref after DMA setup failure
Date: Sat, 30 May 2026 18:07:06 +0200
Message-ID: <20260530160239.000229907@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 3d67fffb74267772d461c02c67f1eff893ad547d upstream.

The driver falls back to PIO mode if DMA setup fails during probe.

Make sure to check the dma.enabled flag before trying to release the DMA
channels also on late probe errors to avoid dereferencing an error
pointer (or attempting to release a channel a second time).

This issue was flagged by Sashiko when reviewing a devres allocation
conversion patch.

Fixes: 386119bc7be9 ("spi: sprd: spi: sprd: Add DMA mode support")
Link: https://sashiko.dev/#/patchset/20260505072909.618363-1-johan%40kernel.org?part=10
Cc: stable@vger.kernel.org	# 5.1
Cc: Lanqing Liu <lanqing.liu@unisoc.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260512074733.915029-1-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-sprd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-sprd.c
+++ b/drivers/spi/spi-sprd.c
@@ -995,7 +995,8 @@ err_rpm_put:
 disable_clk:
 	clk_disable_unprepare(ss->clk);
 release_dma:
-	sprd_spi_dma_release(ss);
+	if (ss->dma.enable)
+		sprd_spi_dma_release(ss);
 free_controller:
 	spi_controller_put(sctlr);
 


