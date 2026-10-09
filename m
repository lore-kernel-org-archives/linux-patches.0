Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13B83D34A2;
	Fri,  9 Oct 2026 14:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556480; cv=none; b=Py0qCfvBW08/pqmLgebPbz4qgKE7YYU4RaEogVmDuUA/wCbXflhm06z0o798kTQfjQrUyykvt0BUSQ7Ac139CxdsmryyZo1bXYH6yQ2cbDFtB71IpodfDF/8dbPxzZU/x3W3G/5y1TwoASeRibPbH35hqg2b08BgKgeaJKwa+qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556480; c=relaxed/simple;
	bh=QEo6r5axHVepRPdxs+CYcZoilUHgh/PhuzIRz9urdeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smGFkvg5zTh4B7rFYvw4eQ4AI0V2QyHlyds7Z/KCktfuvhSlnD9SkEycbpsVVHoFO3dIOkt1yASFy2DPZoRX6Dm+8lCturBEK6nP6iBtz6voYrYkq6UZdPGbXdmJ5XOiUXMR4tyL85PlOlEMfSHSdJOHXFkuo6fXHzHaa9zoZOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JMfabKO3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JMfabKO3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E44A1F000FF;
	Fri,  9 Oct 2026 14:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556479;
	bh=r6WegPd5EXBDCt/NCDbgo5/1NMh6pxygVWy8PpG7WgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JMfabKO39eMPDhd8ZWtyzjTBmikrRDo5H593bPiG+RvKeRTszfTWpxItrPBMQ7oS4
	 NI0g2fNAouPV9S28oB5jlPP9SFuprfMWeD1kEl+WgOgeleuP7HFEB+clNUEOuQ7Gl9
	 Syr+4NMSPpdxDUbkXu2w0Xhfexjvcm3q8nHgFvc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Julian Anastasov <ja@ssi.bg>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 242/403] ipvs: bound LBLCR and LBLC cache growth
Date: Fri,  9 Oct 2026 16:10:03 +0200
Message-ID: <20261009140957.827892347@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiling Zou <zhilinz@nebusec.ai>

[ Upstream commit 2a3c3de660f96865f303fd25f1285f2ffbfd521d ]

ip_vs_lblcr_new() and ip_vs_lblc_new() create cache entries for
every previously unseen destination address. The table max_size only
tells the periodic collector to reclaim entries after the cache has
already exceeded the limit. It does not reclaim entries that the
attacker continues to use.

Reject new cache entries once either table reaches max_size * 3 / 2.
The extra headroom lets the periodic collector catch up while the
existing scheduler fallback continues to use the selected destination
when cache creation fails. New traffic therefore stays serviceable
without growing the tables further.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Suggested-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[ sashal: Retained kmalloc() instead of kmalloc_obj(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_lblc.c  | 3 +++
 net/netfilter/ipvs/ip_vs_lblcr.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_lblc.c b/net/netfilter/ipvs/ip_vs_lblc.c
index 765825b51af01..832066f11e67e 100644
--- a/net/netfilter/ipvs/ip_vs_lblc.c
+++ b/net/netfilter/ipvs/ip_vs_lblc.c
@@ -206,6 +206,9 @@ ip_vs_lblc_new(struct ip_vs_lblc_table *tbl, const union nf_inet_addr *daddr,
 		ip_vs_lblc_del(en);
 		atomic_dec(&tbl->entries);
 	}
+	if (atomic_read(&tbl->entries) >= tbl->max_size * 3 / 2)
+		return NULL;
+
 	en = kmalloc(sizeof(*en), GFP_ATOMIC);
 	if (!en)
 		return NULL;
diff --git a/net/netfilter/ipvs/ip_vs_lblcr.c b/net/netfilter/ipvs/ip_vs_lblcr.c
index 1a53c1254fe57..073d3ad177040 100644
--- a/net/netfilter/ipvs/ip_vs_lblcr.c
+++ b/net/netfilter/ipvs/ip_vs_lblcr.c
@@ -364,6 +364,9 @@ ip_vs_lblcr_new(struct ip_vs_lblcr_table *tbl, const union nf_inet_addr *daddr,
 
 	en = ip_vs_lblcr_get(af, tbl, daddr);
 	if (!en) {
+		if (atomic_read(&tbl->entries) >= tbl->max_size * 3 / 2)
+			return NULL;
+
 		en = kmalloc(sizeof(*en), GFP_ATOMIC);
 		if (!en)
 			return NULL;
-- 
2.53.0



