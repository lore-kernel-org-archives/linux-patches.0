Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F258377ABA;
	Sat, 12 Sep 2026 18:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238454; cv=none; b=d0Mwu44RHIuvJRKB3qvqg/cBAtpJqqAgv8bFqxC5J/5RL9oWqggGJubZO0qUWmegNWv9isjpViBq/PqehSI2R7yYCQwDJvvG4Bicljv30Unm5gh4TFYhMOOrPEolxwgNZEYYg46kYloZs/rZUgo9HG1vN7ObCeWoaEgJHpokRjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238454; c=relaxed/simple;
	bh=DTVguTOdcxWhzhrbg3RTvPGP2XjeSsAnK6tn5fz5dqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZz809/2GnhvyWNky20ZlKM6E5jNArjKB0zf5q6+M9YJla2g1cnL/HVNeu3nfl4DHhbC7AMDLBo/29MoJp4q2hy7hQInDp9BisvuDQ8g0wLp4BTDsqZYWHCo5E/Uwsbbi/QKgf54ZSzI9TWcMlZtD/malg0oeadNh6ruZDW4nnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gE2e84Gn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gE2e84Gn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067A91F00898;
	Sat, 12 Sep 2026 18:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238448;
	bh=VOkLXN9ht41TqNlztu4/1nYVTIEPzHBAVEiyr2WN0Aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gE2e84GneUCEkecPF3+7cv5lk0+eNnNFr/cBklbHnBEhRNkTQ9BEw1Y9M04xIR/kB
	 Fhf51pMYN4A+qKlSv0CiGhqSrZh5+nQDJ0VL3xLj+OHeIOm3aAylhmak2QbiOHar3e
	 ALvuNhPv+OZNef9off1tSX5FlVOZxA9tCs3a6804=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Radu Rendec <radu@rendec.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 464/935] irqchip/gic-v3-its: Fix memleak in its_probe_one()
Date: Sat, 12 Sep 2026 08:58:14 +0200
Message-ID: <20260912065537.467267980@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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
index db5a0eb820c39..540ade8255420 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -5126,7 +5126,7 @@ static int __init its_probe_one(struct resource *res,
 
 	err = its_init_domain(handle, its);
 	if (err)
-		goto out_free_tables;
+		goto out_free_collection;
 
 	raw_spin_lock(&its_lock);
 	list_add(&its->entry, &its_nodes);
@@ -5134,6 +5134,8 @@ static int __init its_probe_one(struct resource *res,
 
 	return 0;
 
+out_free_collection:
+	kfree(its->collections);
 out_free_tables:
 	its_free_tables(its);
 out_free_cmd:
-- 
2.53.0



