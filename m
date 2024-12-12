Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234CF221D88;
	Thu, 12 Dec 2024 15:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018834; cv=none; b=LsqF4X8Zvvk0HloiUUKACgJe7jZhb/eBgL+raPTrDQcHDJf41xNpFcvU2RJkiauivUU9rDM7ruRt2XlUZFr1ZDM+vxu4Ryw16CNTN0/0p6fAuw9zBO7jIC1657dbytyCCUzdj36Tuja9vrpO8nup9OsLsHnsw+Mx+S484+PFbYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018834; c=relaxed/simple;
	bh=dxmedroYItT/TE2fDRLU3SdtJZWBDUZ+wLIqVz2bqG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBqNwugjeadYJP9eWgD2mYSbAxmqHK4aPtQGoUci0/Oj1yf/t/4CTqMPWRn1X8FswTHrqb+X7aTcjgaF7HaSWP4DFV84LVKL3caaBB0BhKpmSDt8Ph9tLd5jNszgfPuW4qQ6XLyBiimX96dsN9jNvCwg+4NYNDlzqPkSL3yfDGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bm3dADX2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bm3dADX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65652C4CED0;
	Thu, 12 Dec 2024 15:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018834;
	bh=dxmedroYItT/TE2fDRLU3SdtJZWBDUZ+wLIqVz2bqG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bm3dADX2w3tdijuPTH0vvF+yzhS86b2xqhRKwV91lcyErCd++ubzwM5WakpEnpMh6
	 03zppnt+0RdKx6hsWMglwA6gG36fPziEUMUrv8z45W69rGi1MsskQ5/pq5ESzNP0um
	 +bEw3QfYZynW+Oz+PXJQCwGxudwwpgc+glWF4WpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Bin Lan <bin.lan.cn@windriver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/772] closures: Change BUG_ON() to WARN_ON()
Date: Thu, 12 Dec 2024 15:49:34 +0100
Message-ID: <20241212144351.153147754@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Kent Overstreet <kent.overstreet@linux.dev>

[ Upstream commit 339b84ab6b1d66900c27bd999271cb2ae40ce812 ]

If a BUG_ON() can be hit in the wild, it shouldn't be a BUG_ON()

For reference, this has popped up once in the CI, and we'll need more
info to debug it:

03240 ------------[ cut here ]------------
03240 kernel BUG at lib/closure.c:21!
03240 kernel BUG at lib/closure.c:21!
03240 Internal error: Oops - BUG: 00000000f2000800 [#1] SMP
03240 Modules linked in:
03240 CPU: 15 PID: 40534 Comm: kworker/u80:1 Not tainted 6.10.0-rc4-ktest-ga56da69799bd #25570
03240 Hardware name: linux,dummy-virt (DT)
03240 Workqueue: btree_update btree_interior_update_work
03240 pstate: 00001005 (nzcv daif -PAN -UAO -TCO -DIT +SSBS BTYPE=--)
03240 pc : closure_put+0x224/0x2a0
03240 lr : closure_put+0x24/0x2a0
03240 sp : ffff0000d12071c0
03240 x29: ffff0000d12071c0 x28: dfff800000000000 x27: ffff0000d1207360
03240 x26: 0000000000000040 x25: 0000000000000040 x24: 0000000000000040
03240 x23: ffff0000c1f20180 x22: 0000000000000000 x21: ffff0000c1f20168
03240 x20: 0000000040000000 x19: ffff0000c1f20140 x18: 0000000000000001
03240 x17: 0000000000003aa0 x16: 0000000000003ad0 x15: 1fffe0001c326974
03240 x14: 0000000000000a1e x13: 0000000000000000 x12: 1fffe000183e402d
03240 x11: ffff6000183e402d x10: dfff800000000000 x9 : ffff6000183e402e
03240 x8 : 0000000000000001 x7 : 00009fffe7c1bfd3 x6 : ffff0000c1f2016b
03240 x5 : ffff0000c1f20168 x4 : ffff6000183e402e x3 : ffff800081391954
03240 x2 : 0000000000000001 x1 : 0000000000000000 x0 : 00000000a8000000
03240 Call trace:
03240  closure_put+0x224/0x2a0
03240  bch2_check_for_deadlock+0x910/0x1028
03240  bch2_six_check_for_deadlock+0x1c/0x30
03240  six_lock_slowpath.isra.0+0x29c/0xed0
03240  six_lock_ip_waiter+0xa8/0xf8
03240  __bch2_btree_node_lock_write+0x14c/0x298
03240  bch2_trans_lock_write+0x6d4/0xb10
03240  __bch2_trans_commit+0x135c/0x5520
03240  btree_interior_update_work+0x1248/0x1c10
03240  process_scheduled_works+0x53c/0xd90
03240  worker_thread+0x370/0x8c8
03240  kthread+0x258/0x2e8
03240  ret_from_fork+0x10/0x20
03240 Code: aa1303e0 d63f0020 a94363f7 17ffff8c (d4210000)
03240 ---[ end trace 0000000000000000 ]---
03240 Kernel panic - not syncing: Oops - BUG: Fatal exception
03240 SMP: stopping secondary CPUs
03241 SMP: failed to stop secondary CPUs 13,15
03241 Kernel Offset: disabled
03241 CPU features: 0x00,00000003,80000008,4240500b
03241 Memory Limit: none
03241 ---[ end Kernel panic - not syncing: Oops - BUG: Fatal exception ]---
03246 ========= FAILED TIMEOUT copygc_torture_no_checksum in 7200s

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
[ Resolve minor conflicts to fix CVE-2024-42252 ]
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/closure.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/closure.c b/drivers/md/bcache/closure.c
index d8d9394a6beb1..18f21d4e9aaae 100644
--- a/drivers/md/bcache/closure.c
+++ b/drivers/md/bcache/closure.c
@@ -17,10 +17,16 @@ static inline void closure_put_after_sub(struct closure *cl, int flags)
 {
 	int r = flags & CLOSURE_REMAINING_MASK;
 
-	BUG_ON(flags & CLOSURE_GUARD_MASK);
-	BUG_ON(!r && (flags & ~CLOSURE_DESTRUCTOR));
+	if (WARN(flags & CLOSURE_GUARD_MASK,
+		 "closure has guard bits set: %x (%u)",
+		 flags & CLOSURE_GUARD_MASK, (unsigned) __fls(r)))
+		r &= ~CLOSURE_GUARD_MASK;
 
 	if (!r) {
+		WARN(flags & ~CLOSURE_DESTRUCTOR,
+		     "closure ref hit 0 with incorrect flags set: %x (%u)",
+		     flags & ~CLOSURE_DESTRUCTOR, (unsigned) __fls(flags));
+
 		if (cl->fn && !(flags & CLOSURE_DESTRUCTOR)) {
 			atomic_set(&cl->remaining,
 				   CLOSURE_REMAINING_INITIALIZER);
-- 
2.43.0



