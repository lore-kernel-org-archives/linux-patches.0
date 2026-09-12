Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CC84BEE54;
	Sat, 12 Sep 2026 07:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198341; cv=none; b=OOWdmFdZ4d5QRqM9JxCge00EAmFUPA7uP7KZTaLIeaD96AJTYz4HrOiAwvjLeU2Z4qyA6VDg39uoiHEUZ0KmNlE8ZIHIDcpQLPx2R60R0tjIosEyjzGa8WaYUN9lom2WcboDuPbCadU2BLLpEFWvo+aGpO9nZrzCJSCvgyS/Njw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198341; c=relaxed/simple;
	bh=8FR46rfM76/eNADr/gHDvHOBd4WA2kDbGgHl7vGBvlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ndhL/c/ZtiC5f6HWlQNp9nTuKjT/EidUZf+7fpqRzx8Xmj2jppSdH9DeXr56KfWhvVzD4PWAQtJwnAhowGqeU/vq56MCnGxZLCcIeoUgeaVA0MU5neK4dq+0tZ90JZPwxPDWoRgPFVU/Mu0aUj/mgi5Nm4ifQEPlUVq9wvKH+24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c6KX4P2I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c6KX4P2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C2F1F000FF;
	Sat, 12 Sep 2026 07:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198340;
	bh=oaF2pe2nsxtMG4T746V0vxmii+6sJ3SHSPp8284/9B8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c6KX4P2I5wD8DamM96bWuqoxR4++BQM0aG9QjKRXshRsDkwqwIGHBS+A8MLEQvHAM
	 QrhXa1jqaNWNZmHoGYbvEJx8ce52jFAaV7k/XdLsCqlm03xQphoYbUNQRe1CH//zpq
	 NcqJ3iWF9bGMp7/w8LY0Cb5j1+aWwTG4shww9UUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Stefan Wahren <wahrenst@gmx.net>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0358/1815] pmdomain: bcm: bcm2835: handle genpd provider registration errors
Date: Sat, 12 Sep 2026 08:35:08 +0200
Message-ID: <20260912065657.311581833@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit a1d9d3b958d69a13783613304f524f489fecdd1f ]

bcm2835_power_probe() initializes all power domains and then registers
the onecell genpd provider, but ignores of_genpd_add_provider_onecell()
failures. Probe can therefore return success even though no provider was
published.

Check the provider registration return value and jump to the existing
cleanup path on failure.

Fixes: 670c672608a1 ("soc: bcm: bcm2835-pm: Add support for power domains under a new binding.")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Stefan Wahren <wahrenst@gmx.net>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pmdomain/bcm/bcm2835-power.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/pmdomain/bcm/bcm2835-power.c b/drivers/pmdomain/bcm/bcm2835-power.c
index b76d74e3849be..68a0a7a8cee38 100644
--- a/drivers/pmdomain/bcm/bcm2835-power.c
+++ b/drivers/pmdomain/bcm/bcm2835-power.c
@@ -677,7 +677,12 @@ static int bcm2835_power_probe(struct platform_device *pdev)
 	if (ret)
 		goto fail;
 
-	of_genpd_add_provider_onecell(dev->parent->of_node, &power->pd_xlate);
+	ret = of_genpd_add_provider_onecell(dev->parent->of_node,
+					    &power->pd_xlate);
+	if (ret) {
+		dev_err_probe(dev, ret, "failed to add genpd provider\n");
+		goto fail;
+	}
 
 	dev_info(dev, "Broadcom BCM2835 power domains driver");
 	return 0;
-- 
2.53.0



