Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F1A2E7BDC;
	Tue, 15 Jul 2025 13:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586793; cv=none; b=sZ3kzcHPHEXdURiGG5AKcN9CJ7bk3FXeNDiYy6ev54RPt37Uck3qiAYbCeIMZTqmln32RH1V8mXDJMbsTcEFzKML/GJ8+PEBC0GIYYV3ZCHDFoWtU8AxZuMlbI7IAb4lCzSXy5lftmMf4nGTOID0eQ5KHmk63+TQsHMCEdLEgDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586793; c=relaxed/simple;
	bh=D2biGhonGNgel4YpYAsMaywFetr0tiejDgwQmZAvJlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P9m8pl3TnkYkb+nLaygQ3epK+0SXnO1ix/mMWywRyLzAGHomendyKhzCZirkGSmelKNQBbHM+ZLdLhCWWwhFIz2wi1uU1UyQkUifb3lAWO1sLqzj1hrfzqy3+VR/vkxikqm7wT0tIxbZVB47/3AlyJ/6Ac7wef2K7XHgzvyG5WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qZy/0+BZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qZy/0+BZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05453C4CEF6;
	Tue, 15 Jul 2025 13:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586793;
	bh=D2biGhonGNgel4YpYAsMaywFetr0tiejDgwQmZAvJlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qZy/0+BZeQnfVVcdyOjGg5TwtE3dERs71Ha1UAocZCHXIk6M5tYdgtObURy0h/HNx
	 DNjgy/sUVzz8SkYGSE8jLJI59VmNHBqG8MowxyIwvMh+wwS5M7Hah/HFNAXa4AKIIC
	 Gbz0hmr8qj9BiJLTHouNUucXz6WpL53Hgp8QZce8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Jason Xing <kernelxing@tencent.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 023/192] bnxt_en: eliminate the compile warning in bnxt_request_irq due to CONFIG_RFS_ACCEL
Date: Tue, 15 Jul 2025 15:11:58 +0200
Message-ID: <20250715130815.795294667@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Xing <kernelxing@tencent.com>

[ Upstream commit b9fd9888a5654e59f6c6249337e36c53c1faa329 ]

I received a kernel-test-bot report[1] that shows the
[-Wunused-but-set-variable] warning. Since the previous commit I made, as
the 'Fixes' tag shows, gives users an option to turn on and off the
CONFIG_RFS_ACCEL, the issue then can be discovered and reproduced with
GCC specifically.

Like Simon and Jakub suggested, use fewer #ifdefs which leads to fewer
bugs.

[1]
All warnings (new ones prefixed by >>):

   drivers/net/ethernet/broadcom/bnxt/bnxt.c: In function 'bnxt_request_irq':
>> drivers/net/ethernet/broadcom/bnxt/bnxt.c:10703:9: warning: variable 'j' set but not used [-Wunused-but-set-variable]
   10703 |  int i, j, rc = 0;
         |         ^

Fixes: 9b6a30febddf ("net: allow rps/rfs related configs to be switched")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506282102.x1tXt0qz-lkp@intel.com/
Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 9de6eefad9791..d66519ce57af0 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11565,11 +11565,9 @@ static void bnxt_free_irq(struct bnxt *bp)
 
 static int bnxt_request_irq(struct bnxt *bp)
 {
+	struct cpu_rmap *rmap = NULL;
 	int i, j, rc = 0;
 	unsigned long flags = 0;
-#ifdef CONFIG_RFS_ACCEL
-	struct cpu_rmap *rmap;
-#endif
 
 	rc = bnxt_setup_int_mode(bp);
 	if (rc) {
@@ -11590,15 +11588,15 @@ static int bnxt_request_irq(struct bnxt *bp)
 		int map_idx = bnxt_cp_num_to_irq_num(bp, i);
 		struct bnxt_irq *irq = &bp->irq_tbl[map_idx];
 
-#ifdef CONFIG_RFS_ACCEL
-		if (rmap && bp->bnapi[i]->rx_ring) {
+		if (IS_ENABLED(CONFIG_RFS_ACCEL) &&
+		    rmap && bp->bnapi[i]->rx_ring) {
 			rc = irq_cpu_rmap_add(rmap, irq->vector);
 			if (rc)
 				netdev_warn(bp->dev, "failed adding irq rmap for ring %d\n",
 					    j);
 			j++;
 		}
-#endif
+
 		rc = request_irq(irq->vector, irq->handler, flags, irq->name,
 				 bp->bnapi[i]);
 		if (rc)
-- 
2.39.5



