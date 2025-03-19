Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A097E1D47C3;
	Wed, 19 Mar 2025 14:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395023; cv=none; b=Rri9MVhJtV0Jgp/OcJtloy1OEKZMxBBXLuevGpylO4dz7sIwsgifMruKHbJrxU4hxHzkni90O2EG3zYi2X/YjkXOcAay2JO9wrcrrrGUkMCi4WNVtu/+Qt+xuExIT/uLz88JVtn8OfFGc186xinL2Ox3xY5JfdYcUhf+B3agzh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395023; c=relaxed/simple;
	bh=vMSFtvD8H0tXVIXRvxaAtcmWKBefTDUZGekZ3Y4HLjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pJExylq0XyqBiqHrB+k8N9+L5jMsQDLhofDxr7Qn1tJMzlkW9yGKERZ36AQZjR4zJLmanKnPWlCyPGYFfj3g+sUZgr9OTUkOWhhhxj2k6Kwqcea00OywWW+OBaRZI0He9gYxhcgpMSESJatHP/uLjEbDHtvkRyHN7ql+G/6BRYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oyouoDy/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oyouoDy/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F39FC4CEE4;
	Wed, 19 Mar 2025 14:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395023;
	bh=vMSFtvD8H0tXVIXRvxaAtcmWKBefTDUZGekZ3Y4HLjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oyouoDy/X9oWDVT/RTbECQdu4mfJ9s1oN/Fii9uzny+9bIcMSL2OtlukmYDmezR0H
	 MTIf1sseZms0ks7m8WOhV41tWE3mmkKTZFZL4Fw0Feb+or3N3QFLIAcSQCezIRCjGq
	 MYpM/+vjF/hk93/eEspQbYkRxULpqVZwaYnhRnCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taehee Yoo <ap420073@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 038/231] eth: bnxt: fix memory leak in queue reset
Date: Wed, 19 Mar 2025 07:28:51 -0700
Message-ID: <20250319143027.754999239@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 87dd2850835dd7886726b428a8ef7d73a60520c7 ]

When the queue is reset, the bnxt_alloc_one_tpa_info() is called to
allocate tpa_info for the new queue.
And then the old queue's tpa_info should be removed by the
bnxt_free_one_tpa_info(), but it is not called.
So memory leak occurs.
It adds the bnxt_free_one_tpa_info() in the bnxt_queue_mem_free().

unreferenced object 0xffff888293cc0000 (size 16384):
  comm "ncdevmem", pid 2076, jiffies 4296604081
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 40 75 78 93 82 88 ff ff  ........@ux.....
    40 75 78 93 02 00 00 00 00 00 00 00 00 00 00 00  @ux.............
  backtrace (crc 5d7d4798):
    ___kmalloc_large_node+0x10d/0x1b0
    __kmalloc_large_node_noprof+0x17/0x60
    __kmalloc_noprof+0x3f6/0x520
    bnxt_alloc_one_tpa_info+0x5f/0x300 [bnxt_en]
    bnxt_queue_mem_alloc+0x8e8/0x14f0 [bnxt_en]
    netdev_rx_queue_restart+0x233/0x620
    net_devmem_bind_dmabuf_to_queue+0x2a3/0x600
    netdev_nl_bind_rx_doit+0xc00/0x10a0
    genl_family_rcv_msg_doit+0x1d4/0x2b0
    genl_rcv_msg+0x3fb/0x6c0
    netlink_rcv_skb+0x12c/0x360
    genl_rcv+0x24/0x40
    netlink_unicast+0x447/0x710
    netlink_sendmsg+0x712/0xbc0
    __sys_sendto+0x3fd/0x4d0
    __x64_sys_sendto+0xdc/0x1b0

Fixes: 2d694c27d32e ("bnxt_en: implement netdev_queue_mgmt_ops")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Link: https://patch.msgid.link/20250309134219.91670-7-ap420073@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index ee52ac821ef9a..e7580df13229a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -15240,6 +15240,7 @@ static void bnxt_queue_mem_free(struct net_device *dev, void *qmem)
 	struct bnxt_ring_struct *ring;
 
 	bnxt_free_one_rx_ring_skbs(bp, rxr);
+	bnxt_free_one_tpa_info(bp, rxr);
 
 	xdp_rxq_info_unreg(&rxr->xdp_rxq);
 
-- 
2.39.5



