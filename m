Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9201D359FBB;
	Fri,  9 Jan 2026 12:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960417; cv=none; b=GK8LUGrMMCqHmsK8SDJUDj6zfJsWTTQjyeholNQF5r6K7BECmmagznfHYYvqBBJArHAW/E9rH/xRlaVXN6MyAp8fJreugWr0EDW0jYgNehbdp8eKn2gk583hnkZpheVLnw+PPOuR8pceryMsfas0PuroUPPP61iiK3/qmEmc3Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960417; c=relaxed/simple;
	bh=Og6PUvba5Hq34MaSNFHVIkcnK4ZsSFZk0VDI6J7DQrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hItQDm2ZDShrS4o4FSYyZsn2XQ/W0JqvrS+eTgRKxjszVbEsefDlQ0tMdKlsgfiquTFnFj3he2lVU8KTS4YTDpHLjNjpDStiQOjTnb/EXQo/gXAOKNnAk3EKTve71+j+qUCKIIVxHrhHBjHHGmxpCY0fzpvuuSGJR04HwLg+D9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S1w9JjW7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S1w9JjW7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160A1C4CEF1;
	Fri,  9 Jan 2026 12:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960417;
	bh=Og6PUvba5Hq34MaSNFHVIkcnK4ZsSFZk0VDI6J7DQrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S1w9JjW7I4shEcz2uOOlEJrbdjG2ckNTCmhJyA/Ei5QMY+L80pCuAjOla9avNv/Yi
	 u3RMfSabgYvRhhyh0ODpgfR4lbFDKETVRlauWqaXamx8y+8fCSFJT2noZdr5Eyc7Dl
	 xQ2mbEi71gIXrqgR41lkKyx0MyfQVH3gJ3rFhoqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 389/737] clk: mvebu: cp110 add CLK_IGNORE_UNUSED to pcie_x10, pcie_x11 & pcie_x4
Date: Fri,  9 Jan 2026 12:38:48 +0100
Message-ID: <20260109112148.633515423@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josua Mayer <josua@solid-run.com>

[ Upstream commit f0e6bc0c3ef4b4afb299bd6912586cafd5d864e9 ]

CP110 based platforms rely on the bootloader for pci port
initialization.
TF-A actively prevents non-uboot re-configuration of pci lanes, and many
boards do not have software control over the pci card reset.

If a pci port had link at boot-time and the clock is stopped at a later
point, the link fails and can not be recovered.

PCI controller driver probe - and by extension ownership of a driver for
the pci clocks - may be delayed especially on large modular kernels,
causing the clock core to start disabling unused clocks.

Add the CLK_IGNORE_UNUSED flag to the three pci port's clocks to ensure
they are not stopped before the pci controller driver has taken
ownership and tested for an existing link.

This fixes failed pci link detection when controller driver probes late,
e.g. with arm64 defconfig and CONFIG_PHY_MVEBU_CP110_COMPHY=m.

Closes: https://lore.kernel.org/r/b71596c7-461b-44b6-89ab-3cfbd492639f@solid-run.com
Signed-off-by: Josua Mayer <josua@solid-run.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mvebu/cp110-system-controller.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/clk/mvebu/cp110-system-controller.c b/drivers/clk/mvebu/cp110-system-controller.c
index 03c59bf22106..b47c86906046 100644
--- a/drivers/clk/mvebu/cp110-system-controller.c
+++ b/drivers/clk/mvebu/cp110-system-controller.c
@@ -110,6 +110,25 @@ static const char * const gate_base_names[] = {
 	[CP110_GATE_EIP197]	= "eip197"
 };
 
+static unsigned long gate_flags(const u8 bit_idx)
+{
+	switch (bit_idx) {
+	case CP110_GATE_PCIE_X1_0:
+	case CP110_GATE_PCIE_X1_1:
+	case CP110_GATE_PCIE_X4:
+		/*
+		 * If a port had an active link at boot time, stopping
+		 * the clock creates a failed state from which controller
+		 * driver can not recover.
+		 * Prevent stopping this clock till after a driver has taken
+		 * ownership.
+		 */
+		return CLK_IGNORE_UNUSED;
+	default:
+		return 0;
+	}
+};
+
 struct cp110_gate_clk {
 	struct clk_hw hw;
 	struct regmap *regmap;
@@ -171,6 +190,7 @@ static struct clk_hw *cp110_register_gate(const char *name,
 	init.ops = &cp110_gate_ops;
 	init.parent_names = &parent_name;
 	init.num_parents = 1;
+	init.flags = gate_flags(bit_idx);
 
 	gate->regmap = regmap;
 	gate->bit_idx = bit_idx;
-- 
2.51.0



