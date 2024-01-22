Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF0850A73;
	Tue, 23 Jan 2024 00:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970063; cv=none; b=XCKDU1yEFnRKQsx70AI/qdL0VOEp/jb2ah26ilNpNWhXffLeyoAYG/w+aLKPSbArL6c2qYnINs/L7wjmWyKw17pOL7PGFtzBZ7qaDnWaTzShiDt581ZwHpXmk+RY9j/qoS+/Nq6W2k5sZiLAylrArokaXb+sfaB2cmAlZiKLoEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970063; c=relaxed/simple;
	bh=lNa+fisM40NbeLCZMdbRZED1YfnKMoEvR/onE4IVfiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oHSrc+8AOE2dfKWwXczLCSjvbxIhJTXl2wqdRJr+oF11CJYFbsXfk92GHAaGEYl6QkQKRSC7Is2AltF4BNhFhy2f1cQeGBDc7LzHJrEZckRhlLo3RQ7Z+q4OAuFtiC5A4ior98oiedc0eXpf6Opo32MU1kPXmzjJbzKdTyZrSXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O+JyY9kh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O+JyY9kh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F36C433C7;
	Tue, 23 Jan 2024 00:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970063;
	bh=lNa+fisM40NbeLCZMdbRZED1YfnKMoEvR/onE4IVfiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O+JyY9khX7eG9VzdWnWva4Yw/guO0vKOSIw2vnbRsy4FxrhcwTXm4JfzWhIuu5wVk
	 hikbZfBS3Du9/najUcPxJZCozn86VqnVaSmvyv0mYLlCuq0XSVW64r4UTvec1HHfYB
	 Z+2YVLOpLla5rIOLX08BcIvPkqUWfKo5am5xH9q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Ravi Gunasekaran <r-gunasekaran@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 576/641] PCI: keystone: Fix race condition when initializing PHYs
Date: Mon, 22 Jan 2024 15:58:00 -0800
Message-ID: <20240122235836.189371778@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Vadapalli <s-vadapalli@ti.com>

[ Upstream commit c12ca110c613a81cb0f0099019c839d078cd0f38 ]

The PCI driver invokes the PHY APIs using the ks_pcie_enable_phy()
function. The PHY in this case is the Serdes. It is possible that the
PCI instance is configured for two lane operation across two different
Serdes instances, using one lane of each Serdes.

In such a configuration, if the reference clock for one Serdes is
provided by the other Serdes, it results in a race condition. After the
Serdes providing the reference clock is initialized by the PCI driver by
invoking its PHY APIs, it is not guaranteed that this Serdes remains
powered on long enough for the PHY APIs based initialization of the
dependent Serdes. In such cases, the PLL of the dependent Serdes fails
to lock due to the absence of the reference clock from the former Serdes
which has been powered off by the PM Core.

Fix this by obtaining reference to the PHYs before invoking the PHY
initialization APIs and releasing reference after the initialization is
complete.

Link: https://lore.kernel.org/linux-pci/20230927041845.1222080-1-s-vadapalli@ti.com
Fixes: 49229238ab47 ("PCI: keystone: Cleanup PHY handling")
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Acked-by: Ravi Gunasekaran <r-gunasekaran@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-keystone.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/pci/controller/dwc/pci-keystone.c b/drivers/pci/controller/dwc/pci-keystone.c
index 0def919f89fa..cf3836561316 100644
--- a/drivers/pci/controller/dwc/pci-keystone.c
+++ b/drivers/pci/controller/dwc/pci-keystone.c
@@ -1218,7 +1218,16 @@ static int ks_pcie_probe(struct platform_device *pdev)
 		goto err_link;
 	}
 
+	/* Obtain references to the PHYs */
+	for (i = 0; i < num_lanes; i++)
+		phy_pm_runtime_get_sync(ks_pcie->phy[i]);
+
 	ret = ks_pcie_enable_phy(ks_pcie);
+
+	/* Release references to the PHYs */
+	for (i = 0; i < num_lanes; i++)
+		phy_pm_runtime_put_sync(ks_pcie->phy[i]);
+
 	if (ret) {
 		dev_err(dev, "failed to enable phy\n");
 		goto err_link;
-- 
2.43.0



