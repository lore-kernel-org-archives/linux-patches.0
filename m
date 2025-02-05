Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92831519BE;
	Wed,  5 Feb 2025 14:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765013; cv=none; b=W3+nVcmFx9bTUpDOb8xdFJ2pHJHAjhRzX1/OjJmEkAJAQke3Qx5a/qe1wZtIuSlaNya1SC3DUgo3xt8o0RPtxW06UsbXk1ItUdtVmr7JLLNSclWN5jlL54V1My1K9WEDO0TyEV4WmJ5T9NFBPU87iUaH6MtXGTl2pAKtDXhf3sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765013; c=relaxed/simple;
	bh=cqmtTFVTDuhEE6K0q+KVMLTlvWd4bZ4XL8nCItF7lVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aL1Q+UmsDa1j8ze6QhlfKLEUY3OGn7KSZYmwPzpyTK1V7N/EXoTLzdI4lK4uifu3oW+n+GQvup8piw+itqXaT8nQ5TjETqbDq4d6MyR37Q26DD3e+Y5bPpCSwl8R+WZ6IYtEfnbAk5qFtSoM3TrRxjFs4FJlPx0zi3GIEcI1ucE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RZFI4qse; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RZFI4qse"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19EC0C4CED1;
	Wed,  5 Feb 2025 14:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765013;
	bh=cqmtTFVTDuhEE6K0q+KVMLTlvWd4bZ4XL8nCItF7lVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RZFI4qsecqB9YEOee7HM1XEbDMsuZ6+p3IcSb/VscGWAezQ2HFmHalAUfxuGc6Yc/
	 C/fdqAiS/v+vzrRceTdJQqJlnpoSnfsgstYfyxMIrlOViIcJTLsnBmDNIRsR2okYpz
	 6/CpQkt3fJsMv6KfjKNu87oh+gzCll3ES+1ZNTdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 224/393] memory: tegra20-emc: fix an OF node reference bug in tegra_emc_find_node_by_ram_code()
Date: Wed,  5 Feb 2025 14:42:23 +0100
Message-ID: <20250205134428.875376777@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit b9784e5cde1f9fb83661a70e580e381ae1264d12 ]

As of_find_node_by_name() release the reference of the argument device
node, tegra_emc_find_node_by_ram_code() releases some device nodes while
still in use, resulting in possible UAFs. According to the bindings and
the in-tree DTS files, the "emc-tables" node is always device's child
node with the property "nvidia,use-ram-code", and the "lpddr2" node is a
child of the "emc-tables" node. Thus utilize the
for_each_child_of_node() macro and of_get_child_by_name() instead of
of_find_node_by_name() to simplify the code.

This bug was found by an experimental verification tool that I am
developing.

Fixes: 96e5da7c8424 ("memory: tegra: Introduce Tegra20 EMC driver")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Link: https://lore.kernel.org/r/20241217091434.1993597-1-joe@pf.is.s.u-tokyo.ac.jp
Link: https://lore.kernel.org/r/20241218024415.2494267-3-joe@pf.is.s.u-tokyo.ac.jp
[krzysztof: applied v1, adjust the commit msg to incorporate v2 parts]
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/tegra/tegra20-emc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/memory/tegra/tegra20-emc.c b/drivers/memory/tegra/tegra20-emc.c
index fd595c851a278..eb2813b51d770 100644
--- a/drivers/memory/tegra/tegra20-emc.c
+++ b/drivers/memory/tegra/tegra20-emc.c
@@ -477,14 +477,15 @@ tegra_emc_find_node_by_ram_code(struct tegra_emc *emc)
 
 	ram_code = tegra_read_ram_code();
 
-	for (np = of_find_node_by_name(dev->of_node, "emc-tables"); np;
-	     np = of_find_node_by_name(np, "emc-tables")) {
+	for_each_child_of_node(dev->of_node, np) {
+		if (!of_node_name_eq(np, "emc-tables"))
+			continue;
 		err = of_property_read_u32(np, "nvidia,ram-code", &value);
 		if (err || value != ram_code) {
 			struct device_node *lpddr2_np;
 			bool cfg_mismatches = false;
 
-			lpddr2_np = of_find_node_by_name(np, "lpddr2");
+			lpddr2_np = of_get_child_by_name(np, "lpddr2");
 			if (lpddr2_np) {
 				const struct lpddr2_info *info;
 
@@ -521,7 +522,6 @@ tegra_emc_find_node_by_ram_code(struct tegra_emc *emc)
 			}
 
 			if (cfg_mismatches) {
-				of_node_put(np);
 				continue;
 			}
 		}
-- 
2.39.5



