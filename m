Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C3E1E492;
	Wed, 19 Jun 2024 13:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803989; cv=none; b=vFw8mEMGKvfsr6a5QYlDvHZ5wxir5bE0aVGU35bXdbZKIpXsDmzJr5xmxKLV3XNFnHaS4/5EBhUKNl3lcyvT3c7TaHW5eZ0aeNrlRryGf3umfrPfARVmTfW0x6BZXsJWNkvtP/7LEeua67uVIoj2SUICFkVFSHb9VjSgjAcycpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803989; c=relaxed/simple;
	bh=/rqKBATqmO+K5lFz5Yw0p3HvV8EC3epEMtAisgNteRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AHsKbi/8SPQeOuWaorcTDxeqC+IpZVy+pKY/xgglCOaPZ2/j9dIjxqQV4KTbJOxht51rIF62dvAmV7fhfiCB504vnuGqT85/w/0cjULA7992GrnesYuMQ2fbWhZD56oVcUBgIix5Aw8m0fdVZY/vpsbRAkljsMLUCsJAVht8amg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MZVJQO32; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MZVJQO32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C23CC2BBFC;
	Wed, 19 Jun 2024 13:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803988;
	bh=/rqKBATqmO+K5lFz5Yw0p3HvV8EC3epEMtAisgNteRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MZVJQO32ibw5dBnRVOa46frswKIlnesbm+IFF4Jg2wu1O4Cla5+fqijzxcj5KKCyZ
	 fz52nvN2TsT4lNzpQBBabffJ8H8WgVqXPLffxwAdyFzyvrIDDb4Wgvxw+NIeTKXW1p
	 nEdJRbND09coDQrOInhyU1ZggmBFwIYZodlxAcWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Wang <wangjie125@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 140/217] net: hns3: add cond_resched() to hns3 ring buffer init process
Date: Wed, 19 Jun 2024 14:56:23 +0200
Message-ID: <20240619125602.093930143@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 78d6752fe0519..4ce43c3a00a37 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3538,6 +3538,9 @@ static int hns3_alloc_ring_buffers(struct hns3_enet_ring *ring)
 		ret = hns3_alloc_and_attach_buffer(ring, i);
 		if (ret)
 			goto out_buffer_fail;
+
+		if (!(i % HNS3_RESCHED_BD_NUM))
+			cond_resched();
 	}
 
 	return 0;
@@ -5111,6 +5114,7 @@ int hns3_init_all_ring(struct hns3_nic_priv *priv)
 		}
 
 		u64_stats_init(&priv->ring[i].syncp);
+		cond_resched();
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 294a14b4fdefb..1aac93f9aaa15 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -214,6 +214,8 @@ enum hns3_nic_state {
 #define HNS3_CQ_MODE_EQE			1U
 #define HNS3_CQ_MODE_CQE			0U
 
+#define HNS3_RESCHED_BD_NUM			1024
+
 enum hns3_pkt_l2t_type {
 	HNS3_L2_TYPE_UNICAST,
 	HNS3_L2_TYPE_MULTICAST,
-- 
2.43.0



