Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032029;
	b=wRCnECFVtKywhw5i+6Cdd+txPulp6MrN7ZvNEE0L6xy6rElPQHCpySrq3o81T11GLDoV
	 sj7MPCz2ExVxDGufKs+T3DxmXHUIYo+bXTFjvGDsxZOdOrP64QiItdyhSybKSU4ORpWwL
	 I+Zp61GZCyCntwqx0lHDd0qL6Ptirl2c9DWDjazDDh3XU3BC1aqiDVXVyYZv/EcK49YF4
	 R+tIRfOzVPAaXNwHbajr/cUjC4yxvSY0huW/db7YH8BgqnvPmmARmXKpCYxMtlWcVmcY8
	 cnJpAPh7cXGAjkSiTbegGM0xMFGjZZBOP/rL3ctx4vv6bnKnwpW2902/vcBU1cY21lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032029;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JwUr82/L42LTwKu/NndihgOpz9ekLlZlVuOko6oORlk=;
	b=NmwwZqsBpypnXKIzkIzBxZr50vgqd03sFAlcv5a7X68zuZ7RyjuiQ2PCI4nLajZJI7EC
	 kuBCrEd/IYv0ChfczpA9qYjJTfvNlqpunsj/jPItZaoxBMZT15zLuoKJn16a69tO8Q++u
	 AxyvrKJmtL9ua6kFydLu8wQWiwCmYQz2VldTZ/KU8anW5ZgchXqA0fbWyLaoIZf67cTKW
	 ERTs2geR2AIc4BakYwtVrbBamfbja625rSOefcqk5TJ/ywq1JSZ9EmV6F18QttRh4MJfx
	 ksxy4vbb01aWb9R62l4HZ0l8KqqKpR74i1tJuVqKR8bAtggohd4BKpxTyCFydgc//wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nwonCf34;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D019960A2608;
	Wed, 18 Nov 2026 20:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nwonCf34
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FBFD1F000C5;
	Wed, 18 Nov 2026 20:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032029;
	bh=JwUr82/L42LTwKu/NndihgOpz9ekLlZlVuOko6oORlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nwonCf340lx24mM4STwArQIwQ6ZNwGWpEIqo+CTYVMC2WDrr/hnhb1Uebeg4K1um0
	 URGhDEyh6HBpWlvUgZ6qZqq9sm/TOCvi+pR1A0wvZEqbr58C7QIdSxIPU2eOBvSLIO
	 +wln72xKD6IDiLyDyF8uTP7sej5vP2hNisA3R3Z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1266/1756] irqchip/gic-v3-its: Dont free a vPE table shared with another ITS
Date: Wed, 18 Nov 2026 15:56:33 +0100
Message-ID: <20261118150100.057465437@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6e4afde808979..298555efd5657 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -86,6 +86,8 @@ struct its_baser {
 	u64		val;
 	u32		order;
 	u32		psz;
+	/* Inherited from a sibling ITS, not freed here */
+	bool		shared;
 };
 
 struct its_device;
@@ -2611,7 +2613,8 @@ static void its_free_tables(struct its_node *its)
 
 	for (i = 0; i < GITS_BASER_NR_REGS; i++) {
 		if (its->tables[i].base) {
-			its_free_pages(its->tables[i].base, its->tables[i].order);
+			if (!its->tables[i].shared)
+				its_free_pages(its->tables[i].base, its->tables[i].order);
 			its->tables[i].base = NULL;
 		}
 	}
@@ -2710,6 +2713,7 @@ static int its_alloc_tables(struct its_node *its)
 				WARN_ON(i != 2);
 				if ((sibling = find_sibling_its(its))) {
 					*baser = sibling->tables[2];
+					baser->shared = true;
 					its_write_baser(its, baser, baser->val);
 					continue;
 				}
-- 
2.53.0



