Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC09743F4CE;
	Tue, 21 Jul 2026 22:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672111; cv=none; b=Tdmyz+oY9pnjyOLFHaTKx/SjwIGQHI5uHudwzxByRbXtynbmfFKuYp7W9fhgmJxsjTJzScXPNtnIXIDp33Ml5LigahAyedbYWQqhIVHIkZZDwUGiVIylS2UgVUXIkUaqp1PsVzUUUwncPzza7zNqWxDjkS8SnT2p8cMpLfmR6gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672111; c=relaxed/simple;
	bh=tHfTnugrk7WL/7oQM34FSKIPmvjnyio9ny4su4Rpym0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DKrMGwqbGnUd7JKy78LNui3EkkcGsd4WHRs60KAdGyj1Bu0jY+tQnGp5Of61jzp72EC/SJeR/YYwCdUUax1bikMoKaLB4MomCM3t5tXknk1DG4HxwZJ2CvSKlgauTwKtzPH3KWV9vYpW3Ozu65k2h/Pkx1qKq+/+QzPEk91WYzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YXfNODC0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YXfNODC0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA011F000E9;
	Tue, 21 Jul 2026 22:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672110;
	bh=pajl7N3b+Sz2+qIRxd6Cz3yAoZ4hSFltvMHn7KjtwII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YXfNODC0vsm/o86Nh1CsNlEsKjtcB2JNaFw4Z1dZHUj2rVgXNYqcfWVPawnhPcxzF
	 epvGKrOIAVlhDyij0OYf+irfTT7KfFs0++CKPVrKU4Y51JxsSHHb9R2QtTs7StudUm
	 TpvtBSn1uR3YCdbeahp4OSvZ52rhBUHjvPH09JUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 502/843] irqchip/gic-v3-its: Fix OF node reference leak
Date: Tue, 21 Jul 2026 17:22:17 +0200
Message-ID: <20260721152417.325102172@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0fe5ee752c90ea..db5a0eb820c39b 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3213,11 +3213,9 @@ static void its_cpu_init_collection(struct its_node *its)
 
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



