Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FFD2BDC0E;
	Sat, 12 Sep 2026 07:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197770; cv=none; b=qxLmS1zV+tzgSjKGpIJB5Q3WoTSIOCc9f94+ruB8FWeDbx5Yv39CHtV/eV4goti/zkB7ZCW+tAZvnkIAUtScLePa8R7cuW8TU7rAbqlHzZ+xZ73sPB2rr8TugMx4fOwvvToAr8tBhlhGRkThnuSQwSPHJ2megdP0jGyxUmyNsqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197770; c=relaxed/simple;
	bh=CoPLZUVT4+2D+4BSwKqZEish969z2Qhi8/XcBQ9NQTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXAelLJK+EyLIwEBsQMTcH7jXNVjwVx6mz6yMIbD9E+gNsWXo++Azf6aqZjQyeUNP/Q3hHaD6PeqUw/TH9+Z+S4fryYyODWvF/2kAJcMhcOBBIEcmw611W7CF8MVvyipEQ3v48NeSJ6nX5kRSGoPi3N6Yb8DB6ascTMV2NiWLUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uf5mPXib; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uf5mPXib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A75D1F000FF;
	Sat, 12 Sep 2026 07:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197769;
	bh=gzao/MNGEO6W3rysIxzgHes8j6i8PLOhEubVne2Wo3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uf5mPXibQyfwGigem77W8P+ayY7vHDD2ba3HioTvDzyYxU24gO6WqjFnIkGm0EPub
	 TcLjTjC4QSoBqKgOUCLn6ng8hkE/NCfAjo6GWO9iKNlOOhvS2QY3phx4LU9M82GQRt
	 9mHl7vLo958eQ/Xiy4Ig6ctaI9g9tuvx2mu03C/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Radu Rendec <radu@rendec.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0244/1815] irqchip/gic-v3-its: Fix memleak in its_probe_one()
Date: Sat, 12 Sep 2026 08:33:14 +0200
Message-ID: <20260912065654.716180627@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 6f5811aae59c1..7298e8d71867f 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -5320,7 +5320,7 @@ static int __init its_probe_one(struct its_node *its)
 
 	err = its_init_domain(its);
 	if (err)
-		goto out_free_tables;
+		goto out_free_collection;
 
 	raw_spin_lock(&its_lock);
 	list_add(&its->entry, &its_nodes);
@@ -5328,6 +5328,8 @@ static int __init its_probe_one(struct its_node *its)
 
 	return 0;
 
+out_free_collection:
+	kfree(its->collections);
 out_free_tables:
 	its_free_tables(its);
 out_free_cmd:
-- 
2.53.0



