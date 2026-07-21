Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559953A4F4B;
	Tue, 21 Jul 2026 19:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663157; cv=none; b=QCX4GKVH0MyX/ieQlcUH9uNoBgwNWplH6KZaN+KKbSgPhL+0tY24lN5O9EjzbZa1KAkwvEdhHO1MqfHHClz7s2stpR1syOhFv6AqIc8lF7RigX8UaEUHsfBfGbobv6+/ABkyAtc6XEpIa3jJ0Tcb5l+RSPuyug4eiq/8TtOS2LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663157; c=relaxed/simple;
	bh=6cEPdSu3QfJog1/iLixoSZ6Qghc6gExJWVzbhHwEj4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fw0zSX3+XDbEh9khe5bl6I1IrCsigRBvXhHYg4u0uPHGKDxJdUX7S/HoCDTtF8irYKRI2fUNkEWUFLbhcuSME5uHMOS8+1Uj+QWPdeCbFwMZCcjuYFfIrm2tiH31EevSIbBvFpHv501A6rUTrUuNR8fdzmTBoVF6oL2hC0/yTdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBh0Jk4+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBh0Jk4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825B61F000E9;
	Tue, 21 Jul 2026 19:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663155;
	bh=67NOcNX3cJZGPq76hccn8bOK7+rUai6uBBDp3SASgSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kBh0Jk4+wncqdM+gaSfBhJ0BZFWJoh9dT7oYMNNy+KEJByeDgIAi+K/spNco1SNQC
	 qNWFbR3P7vagf3LCKL9DhYGeFXzMvgrp+BQpDW/MBMhrgdBhSE6RWOtJumlK8YTqrc
	 10XuVAy1ZLtN38rpUhEimD+3bQhwnEqSC1wkbN3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0716/1276] irqchip/gic-v3-its: Fix OF node reference leak
Date: Tue, 21 Jul 2026 17:19:19 +0200
Message-ID: <20260721152502.115430962@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b0eb6646a998cf..95d337978c75f2 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3209,11 +3209,9 @@ static void its_cpu_init_collection(struct its_node *its)
 
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



