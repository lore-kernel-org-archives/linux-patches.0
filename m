Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564C7387590;
	Tue, 10 Mar 2026 11:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141954; cv=none; b=sATk4i7Aq5dCvc7yahnug72PHmOBEvXuPVMbpmZWQe5c/MSGZ4zhtMWkdmv5sslldu4oT6Z9IiSq7kpY9EZ06d3oFHRjGN6GK2EY8H9yAb/Y+tNFPbMDy1rLA8zejQN7e1r4JQwXNrDMNzvZ9a3uIXjFWOX1hOnMoKtjzSgvwyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141954; c=relaxed/simple;
	bh=Pq9I8JLR/LSH3J30TC7caAscvG+nis5dOoTTQro2kZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AAPiB4/wO68mN4gjk367Y3A/4FeYUtjGg8KrW58NDMwyMWP/vJUn4OxAlKYLNJ25d+cSM/qwmyM4icQSoWUiXgOiBqeR7jsnLosJNe9OXMvun0nbjwYCMmWCzmuJK7ROFVq7SYaK9bjs6m0LCqjkToe3/Tb+YOrUWzRyPsutNgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uv9p30JX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uv9p30JX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3088BC2BC86;
	Tue, 10 Mar 2026 11:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141954;
	bh=Pq9I8JLR/LSH3J30TC7caAscvG+nis5dOoTTQro2kZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uv9p30JXiYU/RST3lBbTa0CgC51I9MgevnQYSbl7yTiebGnMjvGDkNSLbKzI5A7SW
	 kmFcK/NQp3ghUM/lEDhvcEPGayyoOmT6jcjT4Xykp8/m+STFDRsAB9BIKCQjcwz+0D
	 +CDvrGvNx5bEF9PIUn4PbyOl9gRc8KQj4CHc/9phohD8h1NbwFCiB/t75gV/4g2frh
	 9udfo8P7v9QZzB5Th85VKXpNqWI0vrTuAP9zb5tT8mUWDQ86Zr0E2qkmj1sQsR1SLP
	 dZ+Tg9CFFQrfJHHdgDNvzLQ/JA7NaLR7M3iWnePS2YgGt6mI14kh3GXpOP5WKByt36
	 zNlbGbI5eBcFg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Siddharth Vadapalli <s-vadapalli@ti.com>,
	kernel test robot <lkp@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 077/314] PCI: j721e: Add config guards for Cadence Host and Endpoint library APIs
Date: Tue, 10 Mar 2026 07:15:36 -0400
Message-ID: <0b2739bf291e9c583314137bee3e53954f054dc4.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Siddharth Vadapalli <s-vadapalli@ti.com>

[ Upstream commit 4b361b1e92be255ff923453fe8db74086cc7cf66 ]

Commit under Fixes enabled loadable module support for the driver under
the assumption that it shall be the sole user of the Cadence Host and
Endpoint library APIs. This assumption guarantees that we won't end up
in a case where the driver is built-in and the library support is built
as a loadable module.

With the introduction of [1], this assumption is no longer valid. The
SG2042 driver could be built as a loadable module, implying that the
Cadence Host library is also selected as a loadable module. However, the
pci-j721e.c driver could be built-in as indicated by CONFIG_PCI_J721E=y
due to which the Cadence Endpoint library is built-in. Despite the
library drivers being built as specified by their respective consumers,
since the 'pci-j721e.c' driver has references to the Cadence Host
library APIs as well, we run into a build error as reported at [0].

Fix this by adding config guards as a temporary workaround. The proper
fix is to split the 'pci-j721e.c' driver into independent Host and
Endpoint drivers as aligned at [2].

[0]: https://lore.kernel.org/r/202511111705.MZ7ls8Hm-lkp@intel.com/
[1]: commit 1c72774df028 ("PCI: sg2042: Add Sophgo SG2042 PCIe driver")
[2]: https://lore.kernel.org/r/37f6f8ce-12b2-44ee-a94c-f21b29c98821@app.fastmail.com/

Fixes: a2790bf81f0f ("PCI: j721e: Add support to build as a loadable module")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202511111705.MZ7ls8Hm-lkp@intel.com/
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251117113246.1460644-1-s-vadapalli@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/cadence/pci-j721e.c | 41 +++++++++++++---------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/drivers/pci/controller/cadence/pci-j721e.c b/drivers/pci/controller/cadence/pci-j721e.c
index a88b2e52fd782..0413d163cfea0 100644
--- a/drivers/pci/controller/cadence/pci-j721e.c
+++ b/drivers/pci/controller/cadence/pci-j721e.c
@@ -621,9 +621,11 @@ static int j721e_pcie_probe(struct platform_device *pdev)
 			gpiod_set_value_cansleep(gpiod, 1);
 		}
 
-		ret = cdns_pcie_host_setup(rc);
-		if (ret < 0)
-			goto err_pcie_setup;
+		if (IS_ENABLED(CONFIG_PCI_J721E_HOST)) {
+			ret = cdns_pcie_host_setup(rc);
+			if (ret < 0)
+				goto err_pcie_setup;
+		}
 
 		break;
 	case PCI_MODE_EP:
@@ -633,9 +635,11 @@ static int j721e_pcie_probe(struct platform_device *pdev)
 			goto err_get_sync;
 		}
 
-		ret = cdns_pcie_ep_setup(ep);
-		if (ret < 0)
-			goto err_pcie_setup;
+		if (IS_ENABLED(CONFIG_PCI_J721E_EP)) {
+			ret = cdns_pcie_ep_setup(ep);
+			if (ret < 0)
+				goto err_pcie_setup;
+		}
 
 		break;
 	}
@@ -660,10 +664,11 @@ static void j721e_pcie_remove(struct platform_device *pdev)
 	struct cdns_pcie_ep *ep;
 	struct cdns_pcie_rc *rc;
 
-	if (pcie->mode == PCI_MODE_RC) {
+	if (IS_ENABLED(CONFIG_PCI_J721E_HOST) &&
+	    pcie->mode == PCI_MODE_RC) {
 		rc = container_of(cdns_pcie, struct cdns_pcie_rc, pcie);
 		cdns_pcie_host_disable(rc);
-	} else {
+	} else if (IS_ENABLED(CONFIG_PCI_J721E_EP)) {
 		ep = container_of(cdns_pcie, struct cdns_pcie_ep, pcie);
 		cdns_pcie_ep_disable(ep);
 	}
@@ -729,10 +734,12 @@ static int j721e_pcie_resume_noirq(struct device *dev)
 			gpiod_set_value_cansleep(pcie->reset_gpio, 1);
 		}
 
-		ret = cdns_pcie_host_link_setup(rc);
-		if (ret < 0) {
-			clk_disable_unprepare(pcie->refclk);
-			return ret;
+		if (IS_ENABLED(CONFIG_PCI_J721E_HOST)) {
+			ret = cdns_pcie_host_link_setup(rc);
+			if (ret < 0) {
+				clk_disable_unprepare(pcie->refclk);
+				return ret;
+			}
 		}
 
 		/*
@@ -742,10 +749,12 @@ static int j721e_pcie_resume_noirq(struct device *dev)
 		for (enum cdns_pcie_rp_bar bar = RP_BAR0; bar <= RP_NO_BAR; bar++)
 			rc->avail_ib_bar[bar] = true;
 
-		ret = cdns_pcie_host_init(rc);
-		if (ret) {
-			clk_disable_unprepare(pcie->refclk);
-			return ret;
+		if (IS_ENABLED(CONFIG_PCI_J721E_HOST)) {
+			ret = cdns_pcie_host_init(rc);
+			if (ret) {
+				clk_disable_unprepare(pcie->refclk);
+				return ret;
+			}
 		}
 	}
 
-- 
2.51.0

