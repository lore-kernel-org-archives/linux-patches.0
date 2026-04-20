Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7E83385B2;
	Mon, 20 Apr 2026 15:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700157; cv=none; b=mmi2ihoFiogPnLxyPJgNaKNlu2rziR/OT0HWUu2MdovuWEJ5iL8a/Qb/Q6qfyCrAY+wVAomMYgqsdTd+iG/TyrJV/wtbtL3sqRUpzzsvg+4eiUcYdPLypEO7i9cI7AI7QPKUOTcvYkXt2XHjYqZwA18AyBuoTyoYhsVsU2ZQWog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700157; c=relaxed/simple;
	bh=YWhfHmZBeJSAVSHPLHeDtOR5ufelwEQ99arUOMy2ZLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KRfF0XepYO6BQh+l1T2uaOS/1ybx+8uVreicOdwa1Zvfpr4eLZonudaZxIagb+276l7GHieg5oizUNsCfOS6RmPPX5pJ9Vbr8C91+D33ZypK0d9A4TyJdUz6vxhfUhmaH+bGQr83EGXD9Qqo/ritC3P/6/S0k552MjkU3bRsg+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PtTzLQp0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PtTzLQp0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35433C19425;
	Mon, 20 Apr 2026 15:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700157;
	bh=YWhfHmZBeJSAVSHPLHeDtOR5ufelwEQ99arUOMy2ZLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PtTzLQp0VtfHNv+OjLm8nI3eAvfqj9Lvfh2reYQTR2k8S2Bm2w9Rx0RK1A1YBCZu5
	 cJqkV4F48IurBUFc/1+b94WBy3IVGFSvSU04XA+HaJFxkmG4M41TvtYW/4xEryDxlS
	 KRG0bdRiRAOAQe7CZv81Arp6wruRO5CZ1CXRPoxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 063/220] soc: microchip: mpfs-mss-top-sysreg: Fix resource leak on driver unbind
Date: Mon, 20 Apr 2026 17:40:04 +0200
Message-ID: <20260420153936.309995526@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 3bfc213d4675736567a4e263c51c25144d565949 ]

Use devm_mfd_add_devices() instead of mfd_add_devices() to ensure
child devices are properly removed when the driver unbinds.

Fixes: 4aac11c9a6e7 ("soc: microchip: add mfd drivers for two syscon regions on PolarFire SoC")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/microchip/mpfs-mss-top-sysreg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/microchip/mpfs-mss-top-sysreg.c b/drivers/soc/microchip/mpfs-mss-top-sysreg.c
index b2244e44ff0fa..b0f42b8dd3ed6 100644
--- a/drivers/soc/microchip/mpfs-mss-top-sysreg.c
+++ b/drivers/soc/microchip/mpfs-mss-top-sysreg.c
@@ -16,8 +16,10 @@ static int mpfs_mss_top_sysreg_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	int ret;
 
-	ret = mfd_add_devices(dev, PLATFORM_DEVID_NONE, mpfs_mss_top_sysreg_devs,
-			      ARRAY_SIZE(mpfs_mss_top_sysreg_devs) , NULL, 0, NULL);
+	ret = devm_mfd_add_devices(dev, PLATFORM_DEVID_NONE,
+				   mpfs_mss_top_sysreg_devs,
+				   ARRAY_SIZE(mpfs_mss_top_sysreg_devs), NULL,
+				   0, NULL);
 	if (ret)
 		return ret;
 
-- 
2.53.0



