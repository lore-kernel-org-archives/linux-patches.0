Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414A9311967;
	Sat, 12 Sep 2026 14:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222857; cv=none; b=C/wd5DkLGqElk+d9r5xdeSptBrM4SdiVdO6gcd58OZGvdsgphh1TsMGT3SREBrogFsGE3rCJQGjZ6mGcBbaoZGmyyCxdwC/XN66BHIiVMeUgqsgsSGh9eHgCG3TmR9agNKqCgI/Wr0Mrp4yaolKxZgc2ujaGsMvGD2OiLc3GmLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222857; c=relaxed/simple;
	bh=VNVA/6tTlbAlgOETN/SjVVvoWk6wc7pPSYD3HTH4anU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLZJehkGF6WDo5ZYIIb9ajaMvj36IPvl67w2zHvkAuys0EoMEmMSgyGyABXEOxBJ8XeWg8M8Dbj6EOn9P57Lesa/nKbWHTv/RCm3zy7CKCxsE45Z4O8p2aSNz9P2nxAA0LkXIdq2kr+ySE+ioo27Y6BCzUNkwPsR/9L4LKilWiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oYJoQcpJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oYJoQcpJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13CB11F00893;
	Sat, 12 Sep 2026 14:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222856;
	bh=sTizl8vhV2XGhzQYvyWU/Yt2Xq/2jDoH1IjqpgxMJUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oYJoQcpJZITU9WKTXKTF1eeAbJydrB6a7JGYh25JBfn2F1+8YvDRD5TvdFqnxsSN1
	 90v6BE/caa0wWl8fFW3i5cegZcHD1DkKEc0AYmzI2NM+YkH8tzvaKs2eUT0FZz+00y
	 u3IHZu4PKRQQyNhz4iirRNNvOgEEgp1Sx4tCQN+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Radu Rendec <radu@rendec.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0669/1424] irqchip/gic-v3-its: Fix memleak in its_probe_one()
Date: Sat, 12 Sep 2026 08:51:41 +0200
Message-ID: <20260912065622.278793429@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index d3ff3ab57d4db..8160557c1acd4 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -5168,7 +5168,7 @@ static int __init its_probe_one(struct its_node *its)
 
 	err = its_init_domain(its);
 	if (err)
-		goto out_free_tables;
+		goto out_free_collection;
 
 	raw_spin_lock(&its_lock);
 	list_add(&its->entry, &its_nodes);
@@ -5176,6 +5176,8 @@ static int __init its_probe_one(struct its_node *its)
 
 	return 0;
 
+out_free_collection:
+	kfree(its->collections);
 out_free_tables:
 	its_free_tables(its);
 out_free_cmd:
-- 
2.53.0



