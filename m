Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1021E317141;
	Mon, 13 Apr 2026 16:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099277; cv=none; b=JAOrqcI1XRqNs2XygdCx7+ngYz2amhAR8XB8N9iw473nsr/lr4sQMXakVGqTQojVTv13R2fqyv6lISDXX7B8ltWkMdQudgVTtIs44h6lkJEahL0dGFdVe2CmehUa/xtQnLNUvrUS19OW+GUQius7eSHJj8Cy06CUidKAPBIYjQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099277; c=relaxed/simple;
	bh=AFOjurQDnK1coCWkHIGdglJOSL8iUXcMYLBMIVjNnRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lRKcXSGeFnQr5RFnYADh20de5aFUxVEKaAnef3w/YZ02f4+U0uMpg5OWx7LZMJygn8Q696MtpQZj5MTwBUCXaqyiQNyd30i5QpVzmRfp5T7nqsowxFwqQCFMqOjpPxYZc137vK0KXnFstDDX4lF/hbW9EC3hE6CoauhECobJtBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BO/x4/oJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BO/x4/oJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8B9C2BCAF;
	Mon, 13 Apr 2026 16:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099276;
	bh=AFOjurQDnK1coCWkHIGdglJOSL8iUXcMYLBMIVjNnRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BO/x4/oJYYz6wWrQygnzPilrMsNilj/ytKydD3YNFuZeVwj1mlVDsgVVpgo5bJSF6
	 ZrqT6x2Mlv6wLSFCUozCzGj02YyID3lI7Sx5JZsBBRdxjhcbxEm56JB4p5grhJFppZ
	 GE9diXRwWbn5bueoCV3QUbDg7pL3m3XAbymFskBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Valerio <pvalerio@redhat.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 277/491] net: macb: use the current queue number for stats
Date: Mon, 13 Apr 2026 17:58:42 +0200
Message-ID: <20260413155829.417338589@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Paolo Valerio <pvalerio@redhat.com>

[ Upstream commit 72d96e4e24bbefdcfbc68bdb9341a05d8f5cb6e5 ]

There's a potential mismatch between the memory reserved for statistics
and the amount of memory written.

gem_get_sset_count() correctly computes the number of stats based on the
active queues, whereas gem_get_ethtool_stats() indiscriminately copies
data using the maximum number of queues, and in the case the number of
active queues is less than MACB_MAX_QUEUES, this results in a OOB write
as observed in the KASAN splat.

==================================================================
BUG: KASAN: vmalloc-out-of-bounds in gem_get_ethtool_stats+0x54/0x78
  [macb]
Write of size 760 at addr ffff80008080b000 by task ethtool/1027

CPU: [...]
Tainted: [E]=UNSIGNED_MODULE
Hardware name: raspberrypi rpi/rpi, BIOS 2025.10 10/01/2025
Call trace:
 show_stack+0x20/0x38 (C)
 dump_stack_lvl+0x80/0xf8
 print_report+0x384/0x5e0
 kasan_report+0xa0/0xf0
 kasan_check_range+0xe8/0x190
 __asan_memcpy+0x54/0x98
 gem_get_ethtool_stats+0x54/0x78 [macb
   926c13f3af83b0c6fe64badb21ec87d5e93fcf65]
 dev_ethtool+0x1220/0x38c0
 dev_ioctl+0x4ac/0xca8
 sock_do_ioctl+0x170/0x1d8
 sock_ioctl+0x484/0x5d8
 __arm64_sys_ioctl+0x12c/0x1b8
 invoke_syscall+0xd4/0x258
 el0_svc_common.constprop.0+0xb4/0x240
 do_el0_svc+0x48/0x68
 el0_svc+0x40/0xf8
 el0t_64_sync_handler+0xa0/0xe8
 el0t_64_sync+0x1b0/0x1b8

The buggy address belongs to a 1-page vmalloc region starting at
  0xffff80008080b000 allocated at dev_ethtool+0x11f0/0x38c0
The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000
  index:0xffff00000a333000 pfn:0xa333
flags: 0x7fffc000000000(node=0|zone=0|lastcpupid=0x1ffff)
raw: 007fffc000000000 0000000000000000 dead000000000122 0000000000000000
raw: ffff00000a333000 0000000000000000 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff80008080b080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff80008080b100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff80008080b180: 00 00 00 00 00 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
                                  ^
 ffff80008080b200: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
 ffff80008080b280: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
==================================================================

Fix it by making sure the copied size only considers the active number of
queues.

Fixes: 512286bbd4b7 ("net: macb: Added some queue statistics")
Signed-off-by: Paolo Valerio <pvalerio@redhat.com>
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://patch.msgid.link/20260323191634.2185840-1-pvalerio@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index f49e4e0494db3..bdbb05a95519b 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -2786,7 +2786,7 @@ static void gem_get_ethtool_stats(struct net_device *dev,
 	spin_lock_irq(&bp->stats_lock);
 	gem_update_stats(bp);
 	memcpy(data, &bp->ethtool_stats, sizeof(u64)
-			* (GEM_STATS_LEN + QUEUE_STATS_LEN * MACB_MAX_QUEUES));
+			* (GEM_STATS_LEN + QUEUE_STATS_LEN * bp->num_queues));
 	spin_unlock_irq(&bp->stats_lock);
 }
 
-- 
2.51.0



