Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5DA1B2194;
	Wed, 19 Mar 2025 14:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394850; cv=none; b=shoZFF5M7VHjhpqB6exZVYq8iQeWgZ+2babIryL+KpwgzM4/t8HqIdjVFPAncUuaxlm6V4BxVuHP2gJOyLyiVNoGwbQIjqAhbPUjWtndU0k83u4Y0D2QamxFLRlNnZuvR88wYenw3H0ELEf8S6F/4Q/Noez/p2GhIguIAzH+CMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394850; c=relaxed/simple;
	bh=C/aHKP2WAOv+sXObuIiNtagkYHlaeubX9B8MHS7C2Zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSSpJ3LkQze5544sI6udqpMi9a3ZU7qag/gp/grsm5LK/KawhIOprFBa5tR3l/dtoql8+eSTN0he2P4jQurNLaZXvioHqJpbNPhURb2DSV5csuD74FWlvFDIbIddBiJjHt/yVbCvc29Q4IHRhngAzo9KtFbxclH9AivBe4b7T80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xUq+tmcq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xUq+tmcq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A700C4CEED;
	Wed, 19 Mar 2025 14:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394850;
	bh=C/aHKP2WAOv+sXObuIiNtagkYHlaeubX9B8MHS7C2Zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xUq+tmcq6LINSBpBvRbyEpzI1SOimy2lEZqYfu6lqQVa0mWGAD3fJ0LAMbNiQacdV
	 +5NKBriNrigSrSJ2KpYmXtwL/pBy/+/4rwvPvq5iE0IJLhFAukzb3M0bcc7SMfsbTY
	 uwxQKIP3h+lvept3FeIRE47cjITYHHrxR3LRMBvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taehee Yoo <ap420073@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 037/241] eth: bnxt: fix memory leak in queue reset
Date: Wed, 19 Mar 2025 07:28:27 -0700
Message-ID: <20250319143028.635916113@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index a768b71054fcf..a79c78061d1d0 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -15486,6 +15486,7 @@ static void bnxt_queue_mem_free(struct net_device *dev, void *qmem)
 	struct bnxt_ring_struct *ring;
 
 	bnxt_free_one_rx_ring_skbs(bp, rxr);
+	bnxt_free_one_tpa_info(bp, rxr);
 
 	xdp_rxq_info_unreg(&rxr->xdp_rxq);
 
-- 
2.39.5



