Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5627E22094;
	Tue, 22 Jul 2025 14:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193211; cv=none; b=X5Jb2Gyx27qeWQdyRWl72OTTlt03FCpYzdxgjto9sCKceAso/iJvRLZ8jEWv6wQTBH3sJc9n1otVTnQAce9cIu6WnyD5qPbwFQ50aumgIS5BShq71UAlIbgQsqFxprPk9ps7/1hu6Vzbk9zb5rMeeZ/TEuFbUfG9iSSa+SGb0lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193211; c=relaxed/simple;
	bh=Jxx4zu3fTLmqi9p5goUXN6BM5CMx5pbBOMeDbUko5FU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i93Z52f1G1sSlqntWBxYAWLMOlSnA4WCfXcLkFqj3fm3m4GvyDLBCNOxUTzweF9mveCsEZ0ldFHkv/IhApYYySQ2epTbczQalMrhnzOIQ9jNoDQS8xvHC8pZuTw3q+AMsTY7Pw3F/yv1+nKDJolE5hfSAawqI9IQ/l4W6VchFAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pw1jfOfB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pw1jfOfB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE83BC4CEF5;
	Tue, 22 Jul 2025 14:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193211;
	bh=Jxx4zu3fTLmqi9p5goUXN6BM5CMx5pbBOMeDbUko5FU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pw1jfOfBzGjLsFm1aIx4W9LelENSHoDqXfTwdD4zioGcduIAUFWskT0zEM9NajD7J
	 kR14IpJtVjcXjNbxlWGHy/Hcvj/RLHhbEXRwD8Vpv3E9LMRevyfYe2RRmCeya5fblv
	 /157WWVotXNFTCbDl78ewtc7sbVS/3c848981LUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Shuai <wangshuai12@xiaomi.com>,
	Sheng Yong <shengyong1@xiaomi.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.15 024/187] dm-bufio: fix sched in atomic context
Date: Tue, 22 Jul 2025 15:43:14 +0200
Message-ID: <20250722134346.658395669@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sheng Yong <shengyong1@xiaomi.com>

commit b1bf1a782fdf5c482215c0c661b5da98b8e75773 upstream.

If "try_verify_in_tasklet" is set for dm-verity, DM_BUFIO_CLIENT_NO_SLEEP
is enabled for dm-bufio. However, when bufio tries to evict buffers, there
is a chance to trigger scheduling in spin_lock_bh, the following warning
is hit:

BUG: sleeping function called from invalid context at drivers/md/dm-bufio.c:2745
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 123, name: kworker/2:2
preempt_count: 201, expected: 0
RCU nest depth: 0, expected: 0
4 locks held by kworker/2:2/123:
 #0: ffff88800a2d1548 ((wq_completion)dm_bufio_cache){....}-{0:0}, at: process_one_work+0xe46/0x1970
 #1: ffffc90000d97d20 ((work_completion)(&dm_bufio_replacement_work)){....}-{0:0}, at: process_one_work+0x763/0x1970
 #2: ffffffff8555b528 (dm_bufio_clients_lock){....}-{3:3}, at: do_global_cleanup+0x1ce/0x710
 #3: ffff88801d5820b8 (&c->spinlock){....}-{2:2}, at: do_global_cleanup+0x2a5/0x710
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 2 UID: 0 PID: 123 Comm: kworker/2:2 Not tainted 6.16.0-rc3-g90548c634bd0 #305 PREEMPT(voluntary)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
Workqueue: dm_bufio_cache do_global_cleanup
Call Trace:
 <TASK>
 dump_stack_lvl+0x53/0x70
 __might_resched+0x360/0x4e0
 do_global_cleanup+0x2f5/0x710
 process_one_work+0x7db/0x1970
 worker_thread+0x518/0xea0
 kthread+0x359/0x690
 ret_from_fork+0xf3/0x1b0
 ret_from_fork_asm+0x1a/0x30
 </TASK>

That can be reproduced by:

  veritysetup format --data-block-size=4096 --hash-block-size=4096 /dev/vda /dev/vdb
  SIZE=$(blockdev --getsz /dev/vda)
  dmsetup create myverity -r --table "0 $SIZE verity 1 /dev/vda /dev/vdb 4096 4096 <data_blocks> 1 sha256 <root_hash> <salt> 1 try_verify_in_tasklet"
  mount /dev/dm-0 /mnt -o ro
  echo 102400 > /sys/module/dm_bufio/parameters/max_cache_size_bytes
  [read files in /mnt]

Cc: stable@vger.kernel.org	# v6.4+
Fixes: 450e8dee51aa ("dm bufio: improve concurrent IO performance")
Signed-off-by: Wang Shuai <wangshuai12@xiaomi.com>
Signed-off-by: Sheng Yong <shengyong1@xiaomi.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-bufio.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -2750,7 +2750,11 @@ static unsigned long __evict_many(struct
 		__make_buffer_clean(b);
 		__free_buffer_wake(b);
 
-		cond_resched();
+		if (need_resched()) {
+			dm_bufio_unlock(c);
+			cond_resched();
+			dm_bufio_lock(c);
+		}
 	}
 
 	return count;


