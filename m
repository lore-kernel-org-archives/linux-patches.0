Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3E715FCF0;
	Mon, 27 May 2024 19:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838638; cv=none; b=d11wijTdXQhXLvwFt19TSn23Nsr3W9m3wC/dJwZcNLuQTp20sBhOH4f9Hv/B553MvT4p8FSm2r0Rmdu/zX6jHsg5pigIa6K1OkJo5wZmc4Wa5da4z0zx0/am+B/9ATHF6KR/aiCI4LR0zBE0lmR0M+6U9gXiCRbk4EWx95GP10c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838638; c=relaxed/simple;
	bh=QN5F6C9MxlpfRqjSL/INbWmW2Nv7ZRrsasGRKJJ7/sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWTbslnBE+f7SzUkvTT8hlqYFgvwxk9ZHO9/MWCynB/Io5OEG5okDxgPlK5t9OM6r3Db9V1YJizCEZFb//sBow3VyXvZy14Qa7iTo1fKrBIm7XboS2j56gG+2s1xuMHwAfxCtKEGzOHnYrF0+Pujl9ADNmea7SU+iw+91VoQC8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jqNjhtRc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jqNjhtRc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157A8C2BBFC;
	Mon, 27 May 2024 19:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838638;
	bh=QN5F6C9MxlpfRqjSL/INbWmW2Nv7ZRrsasGRKJJ7/sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jqNjhtRcu6ttxUmmPASRcICo6E6PQscHHqoJukip6Iq39TEVPKkt96ZDmJj2Zp5U4
	 yADeLVBQzuUjBYfO/xQ9BBwqOdd6dvttr9G5MWCXk5YPRXWLWWssdRYnDIOWPRrdd7
	 6LD5U34oA3d08ZS2GE0fuMT6qFyy/aR/zQBdav5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Yi Zhang <yi.zhang@redhat.com>
Subject: [PATCH 6.8 469/493] RDMA/cma: Fix kmemleak in rdma_core observed during blktests nvme/rdma use siw
Date: Mon, 27 May 2024 20:57:51 +0200
Message-ID: <20240527185645.512305504@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Yanjun <yanjun.zhu@linux.dev>

[ Upstream commit 9c0731832d3b7420cbadba6a7f334363bc8dfb15 ]

When running blktests nvme/rdma, the following kmemleak issue will appear.

kmemleak: Kernel memory leak detector initialized (mempool available:36041)
kmemleak: Automatic memory scanning thread started
kmemleak: 2 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
kmemleak: 8 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
kmemleak: 17 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
kmemleak: 4 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

unreferenced object 0xffff88855da53400 (size 192):
  comm "rdma", pid 10630, jiffies 4296575922
  hex dump (first 32 bytes):
    37 00 00 00 00 00 00 00 c0 ff ff ff 1f 00 00 00  7...............
    10 34 a5 5d 85 88 ff ff 10 34 a5 5d 85 88 ff ff  .4.].....4.]....
  backtrace (crc 47f66721):
    [<ffffffff911251bd>] kmalloc_trace+0x30d/0x3b0
    [<ffffffffc2640ff7>] alloc_gid_entry+0x47/0x380 [ib_core]
    [<ffffffffc2642206>] add_modify_gid+0x166/0x930 [ib_core]
    [<ffffffffc2643468>] ib_cache_update.part.0+0x6d8/0x910 [ib_core]
    [<ffffffffc2644e1a>] ib_cache_setup_one+0x24a/0x350 [ib_core]
    [<ffffffffc263949e>] ib_register_device+0x9e/0x3a0 [ib_core]
    [<ffffffffc2a3d389>] 0xffffffffc2a3d389
    [<ffffffffc2688cd8>] nldev_newlink+0x2b8/0x520 [ib_core]
    [<ffffffffc2645fe3>] rdma_nl_rcv_msg+0x2c3/0x520 [ib_core]
    [<ffffffffc264648c>]
rdma_nl_rcv_skb.constprop.0.isra.0+0x23c/0x3a0 [ib_core]
    [<ffffffff9270e7b5>] netlink_unicast+0x445/0x710
    [<ffffffff9270f1f1>] netlink_sendmsg+0x761/0xc40
    [<ffffffff9249db29>] __sys_sendto+0x3a9/0x420
    [<ffffffff9249dc8c>] __x64_sys_sendto+0xdc/0x1b0
    [<ffffffff92db0ad3>] do_syscall_64+0x93/0x180
    [<ffffffff92e00126>] entry_SYSCALL_64_after_hwframe+0x71/0x79

The root cause: rdma_put_gid_attr is not called when sgid_attr is set
to ERR_PTR(-ENODEV).

Reported-and-tested-by: Yi Zhang <yi.zhang@redhat.com>
Closes: https://lore.kernel.org/all/19bf5745-1b3b-4b8a-81c2-20d945943aaf@linux.dev/T/
Fixes: f8ef1be816bf ("RDMA/cma: Avoid GID lookups on iWARP devices")
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Link: https://lore.kernel.org/r/20240510211247.31345-1-yanjun.zhu@linux.dev
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 1e2cd7c8716e8..64ace0b968f07 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -715,8 +715,10 @@ cma_validate_port(struct ib_device *device, u32 port,
 		rcu_read_lock();
 		ndev = rcu_dereference(sgid_attr->ndev);
 		if (!net_eq(dev_net(ndev), dev_addr->net) ||
-		    ndev->ifindex != bound_if_index)
+		    ndev->ifindex != bound_if_index) {
+			rdma_put_gid_attr(sgid_attr);
 			sgid_attr = ERR_PTR(-ENODEV);
+		}
 		rcu_read_unlock();
 		goto out;
 	}
-- 
2.43.0



