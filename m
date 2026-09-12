Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B2033E346;
	Sat, 12 Sep 2026 16:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229239; cv=none; b=BY/eZJEPmfy2Pc8xyEg/0as8L5C880fyyuvJmDkKwuT5dJ2xCVsgAr3tm/bww0ADvApko0msGFSG9IvDGHB9tuu8D3HKaLre3Kaco6FLGo6j1g7rKLKN1zDx80dZUqB0fPWz8g8lWqlw4xWrk/HPuHoUxZ/DNSyflYTOKJPKUFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229239; c=relaxed/simple;
	bh=sGFuZk80y/HDZbsU22Lg9yIFpgJ5htx6GDWlVHVNRPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbh5+T8XzpjFJveV9gjGZfOzTIw4JE92ZD2MyBHnvxppDmIx62184aTahOSjPmksDdS16JCEtmWtmMOg8S0/dBrGCOTSwkKpJs3sXNJ6aA+g2NpqBBRazO/8hjSRxR+mWRNVQyOgw6IHzTErHgGHSUej03flvVJOQDsKm1+ej3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CJHjEU7c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CJHjEU7c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 002E11F000FF;
	Sat, 12 Sep 2026 16:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229235;
	bh=QSdl2rWwOFw1rUVaF48bHAJ+Cs6AbKzFa1cvfcmNUFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CJHjEU7cx75YXK/5OD5n7Hlo2MvfMli/znFbKmhHs2pjle0hEUAoCRznCuKdeqE1e
	 PC18wVHZEf/nNOLBAZrObrZ11GfT4Y6DVmCwb9grKwrSyF8MdbkxuLRXiQ2yTxnPkr
	 H3m0YZYHqyM8s95QfsGTdPrSIO9wxTqldpZxX15k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Radu Rendec <radu@rendec.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0547/1191] irqchip/gic-v3-its: Fix memleak in its_probe_one()
Date: Sat, 12 Sep 2026 08:54:35 +0200
Message-ID: <20260912065600.530917293@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit 1efffab6fe336a5c4fd3c2886f255cd2f998e65f ]

Fix collection leak when its_init_domain() failed in its_probe_one().

Fixes: 4c21f3c26ecc2 ("irqchip: GICv3: ITS: DT probing and initialization")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Radu Rendec <radu@rendec.net>
Link: https://patch.msgid.link/20260702033050.1583-2-shikemeng@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index f031cef97f69d..f4ea52b26f9f8 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -5128,7 +5128,7 @@ static int __init its_probe_one(struct resource *res,
 
 	err = its_init_domain(handle, its);
 	if (err)
-		goto out_free_tables;
+		goto out_free_collection;
 
 	raw_spin_lock(&its_lock);
 	list_add(&its->entry, &its_nodes);
@@ -5136,6 +5136,8 @@ static int __init its_probe_one(struct resource *res,
 
 	return 0;
 
+out_free_collection:
+	kfree(its->collections);
 out_free_tables:
 	its_free_tables(its);
 out_free_cmd:
-- 
2.53.0



