Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DAB78F3A;
	Wed,  5 Mar 2025 18:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197642; cv=none; b=G3Ga8rc21EHVyXiiolAqjGj9Ux+GJawCvyEsSHVCHxD4tlKfDR0BQxjUM2Y6SkP8//zifJTx66QrBNQM6Souni/AUdZ4vjPsFLB5zeSQqz9D4yFXRPR2hDNOHXndxy8kBpGEUPGmROiSSpZpNKB9JLr3mJwvA8xczl8xgLdKOoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197642; c=relaxed/simple;
	bh=MwOVCrw6tY6sVC0Zu4l+McmwRJQUdZKJF6XyHy5jjVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1/t7SK04GKKlNfCAcqxfwHtoCGNm7q8zgSaeglAQC1S0QIKbZzGti27K317O27fQ22rfnC/xKwb5R6WBcjys/uYlKItA2NI8oJIcNw7o2wzMBmxTBLAs4J6Cb0JrVfS8Yfjqy3ox+0nv1BlKxFwr+fUMlfcYIL84VnCuMLA5qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tBclxPPd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tBclxPPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B99C4CED1;
	Wed,  5 Mar 2025 18:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197641;
	bh=MwOVCrw6tY6sVC0Zu4l+McmwRJQUdZKJF6XyHy5jjVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tBclxPPdnD7gNRiWb9KDvC74+QrfVGKs+LJaVdo0NqDTEKetq0s+dtjB2lUJ6ctLa
	 ccedHurj3uP7MhmvkfN1Qi3jH2LgTGOcg2FrAp2QZJcZMOWxI7hulK7oHrgS0iY6AV
	 kI3RRSgfYgEXQfawht5xGXDCZ9TP3QeKD+fhK7xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diogo Ivo <diogo.ivo@siemens.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/142] net: ti: icss-iep: Remove spinlock-based synchronization
Date: Wed,  5 Mar 2025 18:47:49 +0100
Message-ID: <20250305174502.350370771@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Diogo Ivo <diogo.ivo@siemens.com>

[ Upstream commit 5758e03cf604aa282b9afa61aec3188c4a9b3fe7 ]

As all sources of concurrency in hardware register access occur in
non-interrupt context eliminate spinlock-based synchronization and
rely on the mutex-based synchronization that is already present.

Signed-off-by: Diogo Ivo <diogo.ivo@siemens.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 54e1b4becf5e ("net: ti: icss-iep: Reject perout generation request")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icss_iep.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/net/ethernet/ti/icssg/icss_iep.c b/drivers/net/ethernet/ti/icssg/icss_iep.c
index f06cdec14ed7a..b491d89de8fb2 100644
--- a/drivers/net/ethernet/ti/icssg/icss_iep.c
+++ b/drivers/net/ethernet/ti/icssg/icss_iep.c
@@ -110,7 +110,6 @@ struct icss_iep {
 	struct ptp_clock_info ptp_info;
 	struct ptp_clock *ptp_clock;
 	struct mutex ptp_clk_mutex;	/* PHC access serializer */
-	spinlock_t irq_lock; /* CMP IRQ vs icss_iep_ptp_enable access */
 	u32 def_inc;
 	s16 slow_cmp_inc;
 	u32 slow_cmp_count;
@@ -192,14 +191,11 @@ static void icss_iep_update_to_next_boundary(struct icss_iep *iep, u64 start_ns)
  */
 static void icss_iep_settime(struct icss_iep *iep, u64 ns)
 {
-	unsigned long flags;
-
 	if (iep->ops && iep->ops->settime) {
 		iep->ops->settime(iep->clockops_data, ns);
 		return;
 	}
 
-	spin_lock_irqsave(&iep->irq_lock, flags);
 	if (iep->pps_enabled || iep->perout_enabled)
 		writel(0, iep->base + iep->plat_data->reg_offs[ICSS_IEP_SYNC_CTRL_REG]);
 
@@ -210,7 +206,6 @@ static void icss_iep_settime(struct icss_iep *iep, u64 ns)
 		writel(IEP_SYNC_CTRL_SYNC_N_EN(0) | IEP_SYNC_CTRL_SYNC_EN,
 		       iep->base + iep->plat_data->reg_offs[ICSS_IEP_SYNC_CTRL_REG]);
 	}
-	spin_unlock_irqrestore(&iep->irq_lock, flags);
 }
 
 /**
@@ -549,7 +544,6 @@ static int icss_iep_perout_enable_hw(struct icss_iep *iep,
 static int icss_iep_perout_enable(struct icss_iep *iep,
 				  struct ptp_perout_request *req, int on)
 {
-	unsigned long flags;
 	int ret = 0;
 
 	mutex_lock(&iep->ptp_clk_mutex);
@@ -562,11 +556,9 @@ static int icss_iep_perout_enable(struct icss_iep *iep,
 	if (iep->perout_enabled == !!on)
 		goto exit;
 
-	spin_lock_irqsave(&iep->irq_lock, flags);
 	ret = icss_iep_perout_enable_hw(iep, req, on);
 	if (!ret)
 		iep->perout_enabled = !!on;
-	spin_unlock_irqrestore(&iep->irq_lock, flags);
 
 exit:
 	mutex_unlock(&iep->ptp_clk_mutex);
@@ -578,7 +570,6 @@ static int icss_iep_pps_enable(struct icss_iep *iep, int on)
 {
 	struct ptp_clock_request rq;
 	struct timespec64 ts;
-	unsigned long flags;
 	int ret = 0;
 	u64 ns;
 
@@ -592,8 +583,6 @@ static int icss_iep_pps_enable(struct icss_iep *iep, int on)
 	if (iep->pps_enabled == !!on)
 		goto exit;
 
-	spin_lock_irqsave(&iep->irq_lock, flags);
-
 	rq.perout.index = 0;
 	if (on) {
 		ns = icss_iep_gettime(iep, NULL);
@@ -610,8 +599,6 @@ static int icss_iep_pps_enable(struct icss_iep *iep, int on)
 	if (!ret)
 		iep->pps_enabled = !!on;
 
-	spin_unlock_irqrestore(&iep->irq_lock, flags);
-
 exit:
 	mutex_unlock(&iep->ptp_clk_mutex);
 
@@ -861,7 +848,6 @@ static int icss_iep_probe(struct platform_device *pdev)
 
 	iep->ptp_info = icss_iep_ptp_info;
 	mutex_init(&iep->ptp_clk_mutex);
-	spin_lock_init(&iep->irq_lock);
 	dev_set_drvdata(dev, iep);
 	icss_iep_disable(iep);
 
-- 
2.39.5



