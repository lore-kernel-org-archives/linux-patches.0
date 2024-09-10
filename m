Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2617193431;
	Tue, 10 Sep 2024 10:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964791; cv=none; b=jFvGCDcKKEfIMAKFYrEiK4NYOsFvX4rSlgtxnlP8IRy9QlL+Esur1LxLESBppS0OVb4x+x/GYL5qYi8z3/4SXy8X+cpHoC3dwOSIr0vtosIHYJYGjqCWnx03joX71TL719XJsLvIppRfTVeUiCpnJSh+4FiJM8jdzn7SCquRZHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964791; c=relaxed/simple;
	bh=XB/dkXEgIvpdPdz1B24NN1xUKPytOiShk5qFrkO3+Kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YuI03Kxv2TC8RRJ0kqITneO79STWsJgF9ASa7LWL/2fCVqbN7zXMmNLCqJGCeH92Y0B/A3+tAo/tUHWQyzDE1xWplHtodhB6JViLZG0QzzSb3ki/2eLHDnN/D+bOTjoHRJtic7vLQ6RgO7+9zq+zgVbsIDpFGR45vNYE/NIzDHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cDZRx8Y2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cDZRx8Y2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42903C4CEC3;
	Tue, 10 Sep 2024 10:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964791;
	bh=XB/dkXEgIvpdPdz1B24NN1xUKPytOiShk5qFrkO3+Kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cDZRx8Y24HRohlr6b7elxJfLLfMi1HuvgVot7WmrFumRCDJcW/JPmjzWwkC94fO44
	 V1GbwJs0RNcYKEtJG5EzWC8MeZYhckluIug627EypUyhrC/CPMksXTBxpAiMM7D5i2
	 Yw1nP3K23kRRUocN/xpkxRb9yjGtmg/zb+S7LFjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rik van Riel <riel@surriel.com>,
	Konstantin Ovsepian <ovs@meta.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 005/186] dma-debug: avoid deadlock between dma debug vs printk and netconsole
Date: Tue, 10 Sep 2024 11:31:40 +0200
Message-ID: <20240910092554.869843648@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

From: Rik van Riel <riel@surriel.com>

[ Upstream commit bd44ca3de49cc1badcff7a96010fa2c64f04868c ]

Currently the dma debugging code can end up indirectly calling printk
under the radix_lock. This happens when a radix tree node allocation
fails.

This is a problem because the printk code, when used together with
netconsole, can end up inside the dma debugging code while trying to
transmit a message over netcons.

This creates the possibility of either a circular deadlock on the same
CPU, with that CPU trying to grab the radix_lock twice, or an ABBA
deadlock between different CPUs, where one CPU grabs the console lock
first and then waits for the radix_lock, while the other CPU is holding
the radix_lock and is waiting for the console lock.

The trace captured by lockdep is of the ABBA variant.

-> #2 (&dma_entry_hash[i].lock){-.-.}-{2:2}:
                  _raw_spin_lock_irqsave+0x5a/0x90
                  debug_dma_map_page+0x79/0x180
                  dma_map_page_attrs+0x1d2/0x2f0
                  bnxt_start_xmit+0x8c6/0x1540
                  netpoll_start_xmit+0x13f/0x180
                  netpoll_send_skb+0x20d/0x320
                  netpoll_send_udp+0x453/0x4a0
                  write_ext_msg+0x1b9/0x460
                  console_flush_all+0x2ff/0x5a0
                  console_unlock+0x55/0x180
                  vprintk_emit+0x2e3/0x3c0
                  devkmsg_emit+0x5a/0x80
                  devkmsg_write+0xfd/0x180
                  do_iter_readv_writev+0x164/0x1b0
                  vfs_writev+0xf9/0x2b0
                  do_writev+0x6d/0x110
                  do_syscall_64+0x80/0x150
                  entry_SYSCALL_64_after_hwframe+0x4b/0x53

-> #0 (console_owner){-.-.}-{0:0}:
                  __lock_acquire+0x15d1/0x31a0
                  lock_acquire+0xe8/0x290
                  console_flush_all+0x2ea/0x5a0
                  console_unlock+0x55/0x180
                  vprintk_emit+0x2e3/0x3c0
                  _printk+0x59/0x80
                  warn_alloc+0x122/0x1b0
                  __alloc_pages_slowpath+0x1101/0x1120
                  __alloc_pages+0x1eb/0x2c0
                  alloc_slab_page+0x5f/0x150
                  new_slab+0x2dc/0x4e0
                  ___slab_alloc+0xdcb/0x1390
                  kmem_cache_alloc+0x23d/0x360
                  radix_tree_node_alloc+0x3c/0xf0
                  radix_tree_insert+0xf5/0x230
                  add_dma_entry+0xe9/0x360
                  dma_map_page_attrs+0x1d2/0x2f0
                  __bnxt_alloc_rx_frag+0x147/0x180
                  bnxt_alloc_rx_data+0x79/0x160
                  bnxt_rx_skb+0x29/0xc0
                  bnxt_rx_pkt+0xe22/0x1570
                  __bnxt_poll_work+0x101/0x390
                  bnxt_poll+0x7e/0x320
                  __napi_poll+0x29/0x160
                  net_rx_action+0x1e0/0x3e0
                  handle_softirqs+0x190/0x510
                  run_ksoftirqd+0x4e/0x90
                  smpboot_thread_fn+0x1a8/0x270
                  kthread+0x102/0x120
                  ret_from_fork+0x2f/0x40
                  ret_from_fork_asm+0x11/0x20

This bug is more likely than it seems, because when one CPU has run out
of memory, chances are the other has too.

The good news is, this bug is hidden behind the CONFIG_DMA_API_DEBUG, so
not many users are likely to trigger it.

Signed-off-by: Rik van Riel <riel@surriel.com>
Reported-by: Konstantin Ovsepian <ovs@meta.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/debug.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index 0263983089097..654b039dfc335 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -447,8 +447,11 @@ void debug_dma_dump_mappings(struct device *dev)
  * dma_active_cacheline entry to track per event.  dma_map_sg(), on the
  * other hand, consumes a single dma_debug_entry, but inserts 'nents'
  * entries into the tree.
+ *
+ * Use __GFP_NOWARN because the printk from an OOM, to netconsole, could end
+ * up right back in the DMA debugging code, leading to a deadlock.
  */
-static RADIX_TREE(dma_active_cacheline, GFP_ATOMIC);
+static RADIX_TREE(dma_active_cacheline, GFP_ATOMIC | __GFP_NOWARN);
 static DEFINE_SPINLOCK(radix_lock);
 #define ACTIVE_CACHELINE_MAX_OVERLAP ((1 << RADIX_TREE_MAX_TAGS) - 1)
 #define CACHELINE_PER_PAGE_SHIFT (PAGE_SHIFT - L1_CACHE_SHIFT)
-- 
2.43.0



