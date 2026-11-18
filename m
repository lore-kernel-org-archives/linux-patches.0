Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049915;
	b=Kr8cagbqYUdFC3sPeLWfnqQAJljJbP4H1h9cnNDjYtjbdn4AqDsETMH0Q7McDzWXZ01F
	 Fx1cLmeRnnZcr0U0YgkniHayLJDySwgY98cFSic0alMqH6nj6VhD+rExgOO7Qg24O/cLT
	 9aTPVzYEnz2i9XkVdGh8n/fIJJaUqZnTBXqxIiN0bJtV3tBMhBUGW4iIQRZw3ymnS53Tw
	 AyzwesjgRRoI6IMeWSCBQJ5cyZ490O/QCtj+uZJDyC1HO8UcxC4+nUditR6EdyBRVWQGb
	 xbTdfGyy247H8ylXYrM2WYgDLsh+/UfClk/Z11eQ+Ay4EPzSheFJQRYsyA6fvkffwYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049915;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mFGiSWbyefXAZ5O1VflWYTNw4YXEsLkMkOTaXRKpqFY=;
	b=btCJRu2tv56Fr7NoGIOk/7VzTFzKR2MVkbYl7EMbHoZ1Ak8uirObX2WGpoqwfgvzMP3V
	 JGTLwhIV11sZLFsqCXIzcCR4q532YfFRTWkNvTOjW+dSVCziHbAE2KyqMKWkL2LtZlV04
	 SrCJ4BJaEVZoED0Z35vL72LGeaPFrzWYlmX4gpTqm5986slA1T8kFIydW2iowmqhDR2UC
	 jzsCnCNDIp3h1UlcAvls1YrfNRxyoao9GzUM+Ov9cdpwNnxZOTv2p4GF96g6xX49klgWx
	 U58ej4VncEYsHpP2AMkg1NzjdiPvlvR2ANkHA4hbssDpereI4j9zIz798fVSAXJ1wKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h3m9ZG8D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8513606A32F;
	Thu, 19 Nov 2026 00:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h3m9ZG8D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3550D1F000C4;
	Thu, 19 Nov 2026 00:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049915;
	bh=mFGiSWbyefXAZ5O1VflWYTNw4YXEsLkMkOTaXRKpqFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h3m9ZG8DR/ddP/Rzn1mHM+JxlPs/VKk7CT2k/vh31D0r+KHAJruOd99WYQ63cqAXs
	 7AyeQzXsF8/zzzOUB/ak8JsucVVgwhDKxWcuUa7DUb54aLphde0OgtmVMdBbfcPw0b
	 gdsphhKWlzbO7c4wrQUsGebtPnVw3ti9oxPcqk/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2521/2857] irqchip/gic-v3-its: Dont free a vPE table shared with another ITS
Date: Wed, 18 Nov 2026 15:59:15 +0100
Message-ID: <20261118150332.312504277@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1c2f09778bfbf..0b8ad8bb59359 100644
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
@@ -2615,7 +2617,8 @@ static void its_free_tables(struct its_node *its)
 
 	for (i = 0; i < GITS_BASER_NR_REGS; i++) {
 		if (its->tables[i].base) {
-			its_free_pages(its->tables[i].base, its->tables[i].order);
+			if (!its->tables[i].shared)
+				its_free_pages(its->tables[i].base, its->tables[i].order);
 			its->tables[i].base = NULL;
 		}
 	}
@@ -2709,6 +2712,7 @@ static int its_alloc_tables(struct its_node *its)
 				WARN_ON(i != 2);
 				if ((sibling = find_sibling_its(its))) {
 					*baser = sibling->tables[2];
+					baser->shared = true;
 					its_write_baser(its, baser, baser->val);
 					continue;
 				}
-- 
2.53.0



