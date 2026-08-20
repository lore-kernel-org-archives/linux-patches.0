Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5CFF25C6EE;
	Thu, 20 Aug 2026 16:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244510; cv=none; b=E1xtxTeTWcAQy7elf+DVfa1/s4+pCYUIfKMiJLvbEvL8JBj8TMUdUK4sClVWURkY0+AeWZNhinaiDpmrgP4bSsjII/q6YX7h7YJTSXZo65v0xw+TovQTTKIXcuXJ4+3+z3PIglpzSrSlSOWHX5SPPttIGev6S8brRHmz9Okl5M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244510; c=relaxed/simple;
	bh=k95vOtx04LEhJcoQrUC6/zyk/zaGlUDjAEbUp2JGveU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aMCi8p/sv3OtUvf4MdkXIt2zNi/qqmuFQCSjlVtDQjJH7e5vFgQgVAlMgOs/eEQiMuoyWuymI3HweAGurIG5sd3RH+kuzXUFNoeO0tn7zibYXtx+QH0ZYmX6PCjZw1oXv8BgucruVzp0EstGiV7ySAOEwIw6ZgjDFDpIZ3+8eJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EbN24DsL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EbN24DsL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD3D1F000E9;
	Thu, 20 Aug 2026 16:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244508;
	bh=xPCrjB79V3/yRM8BtJrOjf1wp46QxwVIRr6gEpYyE3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EbN24DsLqWejxEG1P6FssGWEQH6hoNDf5N6V0coCrvSWxI+oZudRzBy5UmD/sYntv
	 VtpcsjRwRp3XoNypKGX0hVn5Zk0vijry1rS7FNcPUrWEZg41fBCGkm1j6/wF5RpC/j
	 C0RMCSFOfxyBAOJZH2bkIFBK7SnICJ/ww+GkXFus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 194/235] net: pktgen: fix proc entry use-after-free
Date: Thu, 20 Aug 2026 16:57:10 +0200
Message-ID: <20260820145222.429500536@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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
@@ -3745,6 +3745,7 @@ static void _rem_dev_from_if_list(struct
 	struct pktgen_dev *p;
 
 	if_lock(t);
+	proc_remove(pkt_dev->entry);
 	list_for_each_safe(q, n, &t->if_list) {
 		p = list_entry(q, struct pktgen_dev, list);
 		if (p == pkt_dev)
@@ -3774,9 +3775,6 @@ static int pktgen_remove_device(struct p
 	 * list to determine if interface already exist, avoid race
 	 * with proc_create_data()
 	 */
-	proc_remove(pkt_dev->entry);
-
-	/* And update the thread if_list */
 	_rem_dev_from_if_list(t, pkt_dev);
 
 #ifdef CONFIG_XFRM


