Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD4B1AF0B6;
	Sun,  7 Sep 2025 20:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276181; cv=none; b=BV7c7dkAImO9esJ3Qj59O7Ze8joRKSEEPhBwcc6A0hB0Bhs8BPTBz1Mt5jataXtj5v4o799J3erVOmQ+ACudauHfgyTmOismGm5j/jm91PmANgoYm4DU3W/PWHxvwykef2PI+uFVD+o+RpnNWl5KAMbLO9B8qr9w+7XFPaeDb38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276181; c=relaxed/simple;
	bh=e9t3VRtqQDI366+OOGfNXqn/rh/1HFITj4OFIzUDJHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CNE2K6q0YCfW4fVCIZ37gqSp7yHwlBx9d2vY0fXk2kxm5Ey30/zn0mehb/zH09RBRsMKsQarevj0h8Kp2uz6MvZ8Hl238+tEHXq6D0cFveVfZb29NQrxdyl6jwPLR7R6FvrXWqokN8Xl/GUyXCkRSOjXNpW5748wBPd+7hqk8hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nzn1r2jY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nzn1r2jY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E45EC4CEF0;
	Sun,  7 Sep 2025 20:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276181;
	bh=e9t3VRtqQDI366+OOGfNXqn/rh/1HFITj4OFIzUDJHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nzn1r2jY7RMZNh/6CUpIAfRaWymItdE+qxGCayQdzNrm2i8mYPF4AhOcnS5WWPUhO
	 +XElu9nZvxUnZVH9U8rOn7hf9XftgkEa8/z0DBSLjZoDY73CUhNUyncfYvak5rvldX
	 diE1xCDU2uwPDwL8LCN6f+S5P8QlOKxUNbGuRh8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Jian <liujian56@huawei.com>,
	Guangguan Wang <guangguan.wang@linux.alibaba.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/104] net/smc: fix one NULL pointer dereference in smc_ib_is_sg_need_sync()
Date: Sun,  7 Sep 2025 21:57:41 +0200
Message-ID: <20250907195608.319493883@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Jian <liujian56@huawei.com>

[ Upstream commit ba1e9421cf1a8369d25c3832439702a015d6b5f9 ]

BUG: kernel NULL pointer dereference, address: 00000000000002ec
PGD 0 P4D 0
Oops: Oops: 0000 [#1] SMP PTI
CPU: 28 UID: 0 PID: 343 Comm: kworker/28:1 Kdump: loaded Tainted: G        OE       6.17.0-rc2+ #9 NONE
Tainted: [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
Workqueue: smc_hs_wq smc_listen_work [smc]
RIP: 0010:smc_ib_is_sg_need_sync+0x9e/0xd0 [smc]
...
Call Trace:
 <TASK>
 smcr_buf_map_link+0x211/0x2a0 [smc]
 __smc_buf_create+0x522/0x970 [smc]
 smc_buf_create+0x3a/0x110 [smc]
 smc_find_rdma_v2_device_serv+0x18f/0x240 [smc]
 ? smc_vlan_by_tcpsk+0x7e/0xe0 [smc]
 smc_listen_find_device+0x1dd/0x2b0 [smc]
 smc_listen_work+0x30f/0x580 [smc]
 process_one_work+0x18c/0x340
 worker_thread+0x242/0x360
 kthread+0xe7/0x220
 ret_from_fork+0x13a/0x160
 ret_from_fork_asm+0x1a/0x30
 </TASK>

If the software RoCE device is used, ibdev->dma_device is a null pointer.
As a result, the problem occurs. Null pointer detection is added to
prevent problems.

Fixes: 0ef69e788411c ("net/smc: optimize for smc_sndbuf_sync_sg_for_device and smc_rmb_sync_sg_for_cpu")
Signed-off-by: Liu Jian <liujian56@huawei.com>
Reviewed-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Reviewed-by: D. Wythe <alibuda@linux.alibaba.com>
Link: https://patch.msgid.link/20250828124117.2622624-1-liujian56@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_ib.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 6de53431629ca..8e41034d8d96f 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -743,6 +743,9 @@ bool smc_ib_is_sg_need_sync(struct smc_link *lnk,
 	unsigned int i;
 	bool ret = false;
 
+	if (!lnk->smcibdev->ibdev->dma_device)
+		return ret;
+
 	/* for now there is just one DMA address */
 	for_each_sg(buf_slot->sgt[lnk->link_idx].sgl, sg,
 		    buf_slot->sgt[lnk->link_idx].nents, i) {
-- 
2.50.1



