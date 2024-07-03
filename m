Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E784176AC8;
	Wed,  3 Jul 2024 11:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004501; cv=none; b=G7Ek88DsO/utvilc4chPTOPKpF2HvMWHsuaQiNMPWQ5PcUc9oBdE2WslrOUK3Vlg/mAa06rHmU0mcW4uW2IlqkBIYyxTpaGYZmOceY2VhSnmRHrGDlxgURX+fAqQetelhunLdLYSEo+hcDJbnblLdWm/A+t63R3urvmVx582S20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004501; c=relaxed/simple;
	bh=IEjjIJsrgueaTjaep/OUh3GNMSaQ6HtpgJ8y8qJRmyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oeMkTS3ZgjGBm1ejNclI9YuVLHZ67KyS6o9YxriNfk4jFHsqtqNtC2nVGXNcRUeQi0MNSr34DHm9HERfl48JtoxJWG9osE5VTl5hCj76+QpsRDsps+IHF5NJ13LJuGqdW66qHhdlAa/38B9fbN2t1p3JChizXZ2b566W0JklLy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wLTqRVWZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wLTqRVWZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533A6C2BD10;
	Wed,  3 Jul 2024 11:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004500;
	bh=IEjjIJsrgueaTjaep/OUh3GNMSaQ6HtpgJ8y8qJRmyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wLTqRVWZqDT7kAPUoTy7Ke234Z+6NFI5IZmPMHI8c3wwjVjDfXdYr9Sixm8qJ8+Oo
	 o+lWNZsXSMqBJgSxidggqh4jVAGY7na5btPjJLbg+lrsumxkeRKPjPqrjy+Kr1u86q
	 X8vm0HzyX4D+M4dtnPoSCsSs9Kihr/7RImFAJMyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Wang <wangjie125@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/290] net: hns3: add cond_resched() to hns3 ring buffer init process
Date: Wed,  3 Jul 2024 12:37:24 +0200
Message-ID: <20240703102906.581279098@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jie Wang <wangjie125@huawei.com>

[ Upstream commit 968fde83841a8c23558dfbd0a0c69d636db52b55 ]

Currently hns3 ring buffer init process would hold cpu too long with big
Tx/Rx ring depth. This could cause soft lockup.

So this patch adds cond_resched() to the process. Then cpu can break to
run other tasks instead of busy looping.

Fixes: a723fb8efe29 ("net: hns3: refine for set ring parameters")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 4 ++++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index a4ab3e7efa5e4..f8275534205a7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2513,6 +2513,9 @@ static int hns3_alloc_ring_buffers(struct hns3_enet_ring *ring)
 		ret = hns3_alloc_and_attach_buffer(ring, i);
 		if (ret)
 			goto out_buffer_fail;
+
+		if (!(i % HNS3_RESCHED_BD_NUM))
+			cond_resched();
 	}
 
 	return 0;
@@ -3946,6 +3949,7 @@ int hns3_init_all_ring(struct hns3_nic_priv *priv)
 		}
 
 		u64_stats_init(&priv->ring[i].syncp);
+		cond_resched();
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 54d02ea4aaa7c..669cd30b9871b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -182,6 +182,8 @@ enum hns3_nic_state {
 
 #define HNS3_RING_EN_B				0
 
+#define HNS3_RESCHED_BD_NUM			1024
+
 enum hns3_pkt_l2t_type {
 	HNS3_L2_TYPE_UNICAST,
 	HNS3_L2_TYPE_MULTICAST,
-- 
2.43.0



