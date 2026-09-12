Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26C6331203;
	Sat, 12 Sep 2026 19:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242403; cv=none; b=S9H1udM/4+XBesa4o3JpvwJVOR0DX/ohoIxShGloc/omgVBzTeIlW4Mff3VD8AuYDtL1cGzEdqhsPAQNiDjbBy5/6T6J9ssWHodn2+cjqSuvy0M2GBPgAq9KCjoKvimfur8rIHA+C6kqPF62qpcS1KenmooMrfth1UKma0cDEWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242403; c=relaxed/simple;
	bh=LcHMCNnyDQKPj7Xs3Sg2SwfhGgHqoBU4rsl09pg+8EQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NN8Hq9BPdVRBonjcjn+OX/1KfPBlh/Kn7Nk4pu+JcWAFCz4hJbPf7KSbLgeqLx8B9fP5OCyrC4LnCnYwggLNsNFzN3LQ4YcpuiBRRa7DlratGquXnimMDLW3FIQl04jSRxbOrzbInF6fVfr51MklFTD+ayosavSyZZ+9MxEpXEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eSl686PG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eSl686PG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9691F000FF;
	Sat, 12 Sep 2026 19:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242402;
	bh=X51YpRZO4sWZs2Y2x5bGaZGkcUSqYDoTAbhihrNZtHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eSl686PGqJXZIoY5/FpixOnGWH3kMRIBTg9I5dMhOuZASdwIQcz8IONtxLcbyePBZ
	 04OruW3OhiKI68AyUWyPtZXWVTjAUWXRWuRnSiitvOGdpDXwMVMKWaW76DWo01Oe5Q
	 jEmdveTnffmEqyaFEcNodboptpceetAUsiTNrXUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Radu Rendec <radu@rendec.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 392/798] irqchip/gic-v3-its: Fix memleak in its_probe_one()
Date: Sat, 12 Sep 2026 09:00:20 +0200
Message-ID: <20260912065526.133315745@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6b86a29990e3a..04b89f345c77c 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -5099,7 +5099,7 @@ static int __init its_probe_one(struct resource *res,
 
 	err = its_init_domain(handle, its);
 	if (err)
-		goto out_free_tables;
+		goto out_free_collection;
 
 	raw_spin_lock(&its_lock);
 	list_add(&its->entry, &its_nodes);
@@ -5107,6 +5107,8 @@ static int __init its_probe_one(struct resource *res,
 
 	return 0;
 
+out_free_collection:
+	kfree(its->collections);
 out_free_tables:
 	its_free_tables(its);
 out_free_cmd:
-- 
2.53.0



