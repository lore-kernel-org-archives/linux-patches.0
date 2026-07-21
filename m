Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D0F44AB9E;
	Tue, 21 Jul 2026 21:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669837; cv=none; b=ZoaxYsnqLdbC54xHHPscckR/4MzCiRGLrQVbHaHDXv/e8QgAJKiYgPdOViBsRR/2Ag3NG2Vyqgh9gxPAFo/kgJWYoSewvHOP98xabK2C9Ko9vD47p3y7yyX31Hny3GupzxufdNvP/pBSLoMC3KZW+lOW8ss6/Ex3U4FwvXG4glw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669837; c=relaxed/simple;
	bh=lExaHB0M9naTKkBj7WYCcp3eZh0LbY1fwy+GTDwxh/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0jY+4/l5XgsPNkkMZan0yYylMsPvxZCsMzmKryUfMLZc5AtA7yIg/7/DTWW1Tnu495vBiMHHFEljkGOZgPQ/qp+fEMLT0n//3ED24otB+W2SrVDxWno1sQ/t1yEsQpkPSJ3R8fBzrCyEabdW7OQ6j0Ro+5bbKy+wXMgCTWJqg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Syg6XNqt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Syg6XNqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5FF1F000E9;
	Tue, 21 Jul 2026 21:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669836;
	bh=YZX863FdP2+wfLNZc6liUBSC0XMacvE6UGyBKuQv6Aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Syg6XNqtww855VgHL578DxTUcMBYHgGuHxP5GZEDxsvlbWb4QsvxsynHwTBh14NWf
	 MH7m0iZrSFJsSgLXYTryBRhEeksmHDnlEX4sqbsbZUUHkS2zQlfc9L6AyzCvlJr8AL
	 U4/M2Q6p/Ksu8WnvB03VsyG1zdP8Nn/Fep6nw+bQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0662/1067] irqchip/gic-v3-its: Fix OF node reference leak
Date: Tue, 21 Jul 2026 17:21:03 +0200
Message-ID: <20260721152439.404471542@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 2e1368a9d61bdf5502ddade004f223a5831c5b8c ]

of_get_cpu_node() returns a referenced device node. In
its_cpu_init_collection(), the Cavium 23144 workaround only uses the
node to compare the CPU NUMA node, but the reference is never dropped.

Use the device_node cleanup helper for the CPU node reference so it is
released when leaving the workaround block, including the NUMA mismatch
return path.

Fixes: fbf8f40e1658 ("irqchip/gicv3-its: numa: Enable workaround for Cavium thunderx erratum 23144")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 43209758e83284..f031cef97f69de 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3198,11 +3198,9 @@ static void its_cpu_init_collection(struct its_node *its)
 
 	/* avoid cross node collections and its mapping */
 	if (its->flags & ITS_FLAGS_WORKAROUND_CAVIUM_23144) {
-		struct device_node *cpu_node;
+		struct device_node *cpu_node __free(device_node) = of_get_cpu_node(cpu, NULL);
 
-		cpu_node = of_get_cpu_node(cpu, NULL);
-		if (its->numa_node != NUMA_NO_NODE &&
-			its->numa_node != of_node_to_nid(cpu_node))
+		if (its->numa_node != NUMA_NO_NODE && its->numa_node != of_node_to_nid(cpu_node))
 			return;
 	}
 
-- 
2.53.0



