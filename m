Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026863;
	b=3up/4h2cSubsbhr04qW4XzEJXbH0DJAaP0EruYvNNgvKx7AshvULidsbLwHyTRl3scDV
	 j5opnfz1nrhoT/WUoC1uyOal7Q5TMBICpQInpe8LSFevzbvsvDs+pa2F6jRB/XjPaWPj/
	 X3S6C11wqsL53GkUAPT4E7gElDJj6KM/J1SvIsrlhLI1IosaMygLtvr32JZ3ozteDD/kV
	 3ysyQFVkwkd7U22iAtPfo1sy2WSLrAwhvXcW7VL1f9L9HMQrqUzFtEs0qy3NcRNAG15jP
	 r8E05yWEZDAI+EQiUwmtXdgjVpvgeWVsP7NcItjBcz7l6esyiDhSwNc2UYVtEtBv2ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026863;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c0QOOz8WF9qvZ4wxeQxMWorBpsu3FmDmAB9KA/QgaMs=;
	b=wsalIHQeDH5FoJOgi5nVXXpXwiiQPxwS651ydCbCPVix64mZCiXffoIQzj530BR7GcPe
	 ycjdCKrYg+eiR+5fyt1PfUMfSZvIxActaSI0FjrZrbOH/gSJuzQGu2y+8ClfOvpA/3Ef+
	 0+S4rkXWpJPP1m8M6dF4ozXE6L2sjCLcd/4h19WvsRtxonQiDkKsNkIYFznJwZf+XElZe
	 5tkhU4P48avR7yyk1CJcYsOILylnd6mwRlmvpfTviWIpM6ciTS3iICWGKlGN9RtPvBKT8
	 /j+p5Jw6NpUhbmQsZEgBRd2BjwrVSfOhIj8f6V7a+whXRbj2BNiv4x3FzsYQoWmMaFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QAiUfWqY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7EF606A330;
	Wed, 18 Nov 2026 18:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QAiUfWqY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2201F000C5;
	Wed, 18 Nov 2026 18:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026863;
	bh=c0QOOz8WF9qvZ4wxeQxMWorBpsu3FmDmAB9KA/QgaMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QAiUfWqYx/hdv8vfPX9WAA5aJMk3BHubZ15ozoonAI0FGpO9gyBd4rYI5588g+Rj+
	 CMelDNI41C9Sr5CPlnaG1IVB1CSOgS0sAEhb14TtUEP9K46ocDiWZvVntLPrRk3whG
	 W248rMfuM6Jzi8aW2YEt7ON1V+pMLmAx/YT9TSGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1585/2151] irqchip/gic-v3-its: Dont free a vPE table shared with another ITS
Date: Wed, 18 Nov 2026 15:55:20 +0100
Message-ID: <20261118150219.622465140@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit 32e056cc1d1582951f981113ca8b98914f29c32a ]

On GICv4.1, its_alloc_tables() copies a sibling's vPE table baser
rather than allocating one, but its_free_tables() frees it like the
rest. A probe failure on the copying ITS then frees pages the enabled
sibling still points GITS_BASER2 at, and the kernel comes up running
on that sibling.

Mark a shared table so its_free_tables() skips it.

Fixes: 5e5168461c22c ("irqchip/gic-v4.1: VPE table (aka GICR_VPROPBASER) allocation")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://patch.msgid.link/20260925085000.753400-2-fuad.tabba@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 4bd1623b9c49a..b8384ceebb270 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -87,6 +87,8 @@ struct its_baser {
 	u64		val;
 	u32		order;
 	u32		psz;
+	/* Inherited from a sibling ITS, not freed here */
+	bool		shared;
 };
 
 struct its_device;
@@ -2608,7 +2610,8 @@ static void its_free_tables(struct its_node *its)
 
 	for (i = 0; i < GITS_BASER_NR_REGS; i++) {
 		if (its->tables[i].base) {
-			its_free_pages(its->tables[i].base, its->tables[i].order);
+			if (!its->tables[i].shared)
+				its_free_pages(its->tables[i].base, its->tables[i].order);
 			its->tables[i].base = NULL;
 		}
 	}
@@ -2707,6 +2710,7 @@ static int its_alloc_tables(struct its_node *its)
 				WARN_ON(i != 2);
 				if ((sibling = find_sibling_its(its))) {
 					*baser = sibling->tables[2];
+					baser->shared = true;
 					its_write_baser(its, baser, baser->val);
 					continue;
 				}
-- 
2.53.0



