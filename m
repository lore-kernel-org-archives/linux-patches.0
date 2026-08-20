Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5643377A82;
	Thu, 20 Aug 2026 17:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248504; cv=none; b=NujseZWi5ObAk8/ajFXK6R3xHXEz54380INzuFteQwMkFW1NF76dznaOB0pnSlILBeA5SbgvWmWpVDDMpDkM63vjyh5XQjckHJY8UyVLcH+t+RFEGEj83KNwwB0gtiHgPF3slPjreX0JX+/InsydbdSsWD+FqJbKFsKpLp40XPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248504; c=relaxed/simple;
	bh=bwSxvUn4CYbvksIQn/W9tb3fKuoVWtz2vg/bmFG0+pM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJgpNN+DnrPN+ZjcwXqHLsyemDckgIjk7mIlIfxwH72V30ZDh5CisyfWTGjCIH/lvqM1wJ3LTwJiDOoTp0vRf1MLcUG9GRPh2Rt8LlpIZOTzBhgYacjSGhqANJlt4lRwTND55dogoounm4f3u1UzCMAa2HGO8ud9y5DP2MrtCwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k7QtVejc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k7QtVejc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B03D1F000E9;
	Thu, 20 Aug 2026 17:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248503;
	bh=2O242QYfhJHEWXvgMWTGyWajKOjQn9jrxbY2dN19Llc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k7QtVejcrF7lXI8HIenjmmvIvH5Uze15Tq/ADyJ73VcI/EYtQnduYN4Rgp4ouR6Kf
	 d98V2Dh0ixvKRfQD15ADKMMF9uEUxT180c3H0jhpk5ELV/J/tjU3Ip23QKuhfzDsLW
	 Yxwd6NMCkDW9YJpUFMv3qwXP5gvPUIDo4eK31Ytw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 250/303] net: pktgen: fix proc entry use-after-free
Date: Thu, 20 Aug 2026 16:56:26 +0200
Message-ID: <20260820145300.962837334@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <nicoyip.dev@gmail.com>

[ Upstream commit 817ff6efdb7f484ea547218e11e17d8e43daa3b4 ]

pktgen_change_name() replaces pkt_dev->entry while holding t->if_lock.
pktgen_remove_device() removes the same entry before
_rem_dev_from_if_list() takes that lock.

This allows the following interleaving:

  CPU 0 (NETDEV_CHANGENAME)       CPU 1 (kpktgend)
  if_lock(t)
  proc_remove(pkt_dev->entry)
                                  proc_remove(pkt_dev->entry)
  pkt_dev->entry = proc_create_data(...)
  if_unlock(t)

The kthread can pass the stale proc_dir_entry to proc_remove() after the
rename path has freed it. A reproducer with a widened race window reports:

  BUG: KASAN: slab-use-after-free in proc_remove+0x78/0x80
  Read of size 8 at addr ffff8881478fea70 by task kpktgend_0/67
  Call Trace:
   proc_remove+0x78/0x80
   pktgen_remove_device.isra.0+0x11c/0x4c0
   pktgen_thread_worker+0x1214/0x6bc0
   kthread+0x2c6/0x3b0
  Allocated by task 95:
   __proc_create+0x204/0x790
   proc_create_data+0x72/0xe0
   pktgen_thread_write+0xd61/0x1510
  Freed by task 28:
   kmem_cache_free+0xcb/0x3d0
   proc_free_inode+0x5b/0x80
   rcu_core+0x50a/0x1850
  The buggy address belongs to the object at ffff8881478fea00
   which belongs to the cache proc_dir_entry of size 192

Move proc_remove() into the if_lock-protected list removal helper. Keep it
before list_del_rcu() to preserve the ordering required by add_device().
The rename path must then finish replacing the entry before removal, or
it observes that the device is no longer on the list.

Fixes: 39df232f1a9b ("[PKTGEN]: fix device name handling")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260719145740.2888967-1-nicoyip.dev@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/pktgen.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -3888,6 +3888,7 @@ static void _rem_dev_from_if_list(struct
 	struct pktgen_dev *p;
 
 	if_lock(t);
+	proc_remove(pkt_dev->entry);
 	list_for_each_safe(q, n, &t->if_list) {
 		p = list_entry(q, struct pktgen_dev, list);
 		if (p == pkt_dev)
@@ -3917,9 +3918,6 @@ static int pktgen_remove_device(struct p
 	 * list to determine if interface already exist, avoid race
 	 * with proc_create_data()
 	 */
-	proc_remove(pkt_dev->entry);
-
-	/* And update the thread if_list */
 	_rem_dev_from_if_list(t, pkt_dev);
 
 #ifdef CONFIG_XFRM


