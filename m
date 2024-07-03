Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9209914F9ED;
	Wed,  3 Jul 2024 11:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005493; cv=none; b=NUcLh1S5hMACYepShQAc52k7O7FzflQ+8Dzh7LmXqrK/ko2UYvP+jqPISkUK+ZPdlAChPtcb+M1d+7ocfwqufNjaWaxdJIz+WpZ9SGbxmSgJeZki1D4uEsI2ncX2CvuSfI+gqdPEsRYZEU2mGhfzeGmvl91poSU2ebz7NnveEfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005493; c=relaxed/simple;
	bh=DA7VVPKS9lq1zHPTxh2koVQI1JYXEVDS/bL7+gClaRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GRE071iKR+lgLXuvWvMUIdXeUBhP2EqXbH9itZ76bOJ001weakYpRFd8ISP/gahEYkyf06HuX/Gs5gE0yU4QKrKvY9u0G6Uu7NQDyn0H3y7J3Kvp1Rv1JIcPwyLBsUSniKtofKKayGlC/w/SRLEYO/OTtXBryY+zQ5mNLF2VV2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rH/+z7IY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rH/+z7IY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F220EC32781;
	Wed,  3 Jul 2024 11:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005493;
	bh=DA7VVPKS9lq1zHPTxh2koVQI1JYXEVDS/bL7+gClaRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rH/+z7IYVdmaEdHPf4O0Rf7zq02bw9+fjSC5+Rf3xF9AcLaz5/a/mOg/rcDg8hfyE
	 r5T+doAzx5ycuNxhJ2dul25YKSFizJUVUy3lXP3tPHKiEIK3mruPVefI7Eu/WNTJA6
	 54vu8Ft5sy2FjElNzPGzA+S5mj6JhLu6Tb5Q4/4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Wang <wangjie125@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 099/356] net: hns3: add cond_resched() to hns3 ring buffer init process
Date: Wed,  3 Jul 2024 12:37:15 +0200
Message-ID: <20240703102916.849363011@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index bbbafd8aa1b09..e48d33927c176 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3342,6 +3342,9 @@ static int hns3_alloc_ring_buffers(struct hns3_enet_ring *ring)
 		ret = hns3_alloc_and_attach_buffer(ring, i);
 		if (ret)
 			goto out_buffer_fail;
+
+		if (!(i % HNS3_RESCHED_BD_NUM))
+			cond_resched();
 	}
 
 	return 0;
@@ -4887,6 +4890,7 @@ int hns3_init_all_ring(struct hns3_nic_priv *priv)
 		}
 
 		u64_stats_init(&priv->ring[i].syncp);
+		cond_resched();
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 91b656adaacb0..f60ba2ee8b8b1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -206,6 +206,8 @@ enum hns3_nic_state {
 #define HNS3_CQ_MODE_EQE			1U
 #define HNS3_CQ_MODE_CQE			0U
 
+#define HNS3_RESCHED_BD_NUM			1024
+
 enum hns3_pkt_l2t_type {
 	HNS3_L2_TYPE_UNICAST,
 	HNS3_L2_TYPE_MULTICAST,
-- 
2.43.0



