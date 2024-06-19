Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC39482871;
	Wed, 19 Jun 2024 13:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802284; cv=none; b=GaEJf38yqxNlz0emhf5LXhS1LcSluRKAfOA8gkYTx52ScjGXI7eYsPHffK9/qkmsI5BAIALWQZn/HvNsUCS9IGmio5A8OYGrAB88N9R0D+2L+Poz65N4Mkp3ejc10U9rRdcDDJwPqZKGw4364TIdCr+hrK0qjwCqm+/mk84tVBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802284; c=relaxed/simple;
	bh=07s9xgPtBCCXOR2DpprlxXESAyeWiBd0EdywXzxK6Go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSJvkPXBLrRpTXpwx92ENiDda+tAg23yWWryZ9vRo46RntwM57fGbE5W3mNZfBF/RlIwMQ1nHjHhGRFaaIxSzSuDKHtzv6QYrPRQunGoC/eqvH6w239xaYbGBwt6sa8gqow0B8u2A0JR69xzMYDS/5a6ICLba1j9SjS9Bw8FRI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/hA/+PU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/hA/+PU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52490C2BBFC;
	Wed, 19 Jun 2024 13:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802284;
	bh=07s9xgPtBCCXOR2DpprlxXESAyeWiBd0EdywXzxK6Go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d/hA/+PUFqjmT7jvmBgxkIQzDNr+b+yv93Q3CrrHs5uZhZMiX0vPtJQuq6d/MaDS2
	 3L8KF/fkQBVkW3aQ5CEvsv+fUnjZZBZIZTtEQEAdiCJvMOvUIzlXpE3+KAcJPt5+JF
	 GBAgA3xBL7P/8qXMEHqsC4l9QHToLY+DwGVeHnL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Wang <wangjie125@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 144/267] net: hns3: add cond_resched() to hns3 ring buffer init process
Date: Wed, 19 Jun 2024 14:54:55 +0200
Message-ID: <20240619125611.875366823@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 677cfaa5fe08c..db9574e9fb7bc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3539,6 +3539,9 @@ static int hns3_alloc_ring_buffers(struct hns3_enet_ring *ring)
 		ret = hns3_alloc_and_attach_buffer(ring, i);
 		if (ret)
 			goto out_buffer_fail;
+
+		if (!(i % HNS3_RESCHED_BD_NUM))
+			cond_resched();
 	}
 
 	return 0;
@@ -5112,6 +5115,7 @@ int hns3_init_all_ring(struct hns3_nic_priv *priv)
 		}
 
 		u64_stats_init(&priv->ring[i].syncp);
+		cond_resched();
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index acd756b0c7c9a..d36c4ed16d8dd 100644
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



