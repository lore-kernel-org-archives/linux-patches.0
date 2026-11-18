Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056349;
	b=m8p3DKCpAqXPsnco/Zjh+dyF35y7tfs2XgUqmE2N77eROJujpcTUW2htg0qKqmL/WV7n
	 h+XKa9bRx7vmLF//aJmzbRqNyRX3Cus/3+6njyDNshtXmwQdMfk+szOFPpWp/hBWkW5/T
	 byI7II1NPyt7hZKgwmTshezchygqnTg+oA7g2N4EJds81AU5/YaCf8tTgYuiByvLQ91Ly
	 T+8sUVawpwHQoOy0s5M6E/SbRic8A93E5QEHLB1JJFx7fWQNGfNBZSHNxAmhYWKhkkXsO
	 pivzqsIqXRFQno0HOok75Z9EI2ojXyjOGPz4feVYbifum+HTIXE3zmYLixgF0hjccUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056349;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9ApMltZCM/oDAdy+DnWaiWOxieErKwwobjLzii1wvTs=;
	b=NgMBvqe9rOTVfgrUiPjFVzvqSq9yx7LnR5diI/crLhbk6LsA65apym4GkTEzSIXnPoha
	 lux2vTMxJKC7YJgTDVWi/scaogsErVl3f50c9C1yEhyLO3DW/atfQR8a3ii/i6NPc/5jS
	 HnOi1V4WGoxlF4wAV0EiBJn3sJ96OhwQMGYdOQCob2vRex0Irro76S36+bp/6vHgFu3R7
	 CYzy10HbYnZsFoECpC8HfAovG8CGIi1mtmmcb52YzdKUtmNdHs2CUH9vu6acFVUeUrfdK
	 w0jOWJLPTs06Yyc+Hs28ASod7AOZ9yuGHXcUCVpp1WPpTxTYZdhf7Q19rrf4Ul7NPxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cltjRV1O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A004606A31C;
	Thu, 19 Nov 2026 02:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cltjRV1O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92131F000C4;
	Thu, 19 Nov 2026 02:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056349;
	bh=9ApMltZCM/oDAdy+DnWaiWOxieErKwwobjLzii1wvTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cltjRV1Oypd4ixdyhgmH4aVTxrxNHrVmytSf2mnxz7ZUixDNu5sAYME5YaZYXRCze
	 HsCJeFyUO3IElCzO6zKLCRwoLDSPTZTyK3rtCwJ5WqQcp62OvazmIiKYefv6/KZsxL
	 1d8vEe2FD27ZG5A82bHoHbQ5ds05mOWtC822SyHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1957/2214] irqchip/gic-v3-its: Dont free a vPE table shared with another ITS
Date: Wed, 18 Nov 2026 16:00:33 +0100
Message-ID: <20261118150129.256862805@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 59bff1ae30327..8dbde5d4ad719 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -85,6 +85,8 @@ struct its_baser {
 	u64		val;
 	u32		order;
 	u32		psz;
+	/* Inherited from a sibling ITS, not freed here */
+	bool		shared;
 };
 
 struct its_device;
@@ -2633,7 +2635,8 @@ static void its_free_tables(struct its_node *its)
 
 	for (i = 0; i < GITS_BASER_NR_REGS; i++) {
 		if (its->tables[i].base) {
-			its_free_pages(its->tables[i].base, its->tables[i].order);
+			if (!its->tables[i].shared)
+				its_free_pages(its->tables[i].base, its->tables[i].order);
 			its->tables[i].base = NULL;
 		}
 	}
@@ -2727,6 +2730,7 @@ static int its_alloc_tables(struct its_node *its)
 				WARN_ON(i != 2);
 				if ((sibling = find_sibling_its(its))) {
 					*baser = sibling->tables[2];
+					baser->shared = true;
 					its_write_baser(its, baser, baser->val);
 					continue;
 				}
-- 
2.53.0



