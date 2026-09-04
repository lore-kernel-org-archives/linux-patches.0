Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762B93A9629;
	Fri,  4 Sep 2026 05:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500423; cv=none; b=S1hfCpzHZctmNX2LZCr9Ft2KbygA9zQ577JKgouJxt/bpxLW4pyKwD48IvDiw4aA0WPgr249EiIQZS6e96x787/PqfS2mMHK202xiWpd4F2chLcO0/3RNETIMe85f7ZzFHl2jPCS/4XzB3g0IFrS34LFhYqLa39iaRnm4OuFoAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500423; c=relaxed/simple;
	bh=LCV5fpr3F/aWI2YqNUsEQFEz5p9KdjYmk2T6/2rAASs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFDteM2CB0QSb6uLZxHg+An8+l+0H9d0kfQXMl7Vm9tj6l3VDKRAmyHXltzJS7VdD36XIoMw2ElkoDGbfYkQoM0gXfY67dg1I5XkTxv7PPj7sS75vyUbVww3bO7hl9pKUYXZgTsNZc0BELA02GoiNQRdLvVIoQXOYGW1TT/qkxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ecd3c+k4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ecd3c+k4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6426F1F00A3D;
	Fri,  4 Sep 2026 05:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500422;
	bh=ksknkuZ9oZG1+KP9P1LM/SzX86hud4wEpiDZH49QXQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ecd3c+k4bgPukp2YyVRqitFaXRm+bqZ1G3oHWL78MW1M3bJtD7Vk3RDWZ+WNT+E4Z
	 1fZRWj4orx+7Ed/7e1NxlvXNQ7Xe99JabjoYi3oKAtJJAm52jDeWRvL6F746JN/6Se
	 2sMEZTo8vJf/KjL2hXACGQNfjhU/cRdJ3mgXUJZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridong Chen <chenridong@xiaomi.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Barry Song <baohua@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Song Hu <husong@kylinos.cn>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 051/552] mm: vmscan: fix node reclaim ignoring swappiness parameter
Date: Fri,  4 Sep 2026 06:53:28 +0200
Message-ID: <20260904045748.996266445@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ridong Chen <chenridong@xiaomi.com>

commit 8a905195850d383c0465ab5bdd3c91d94269b242 upstream.

sc_swappiness() had two separate definitions depending on CONFIG_MEMCG.
The !CONFIG_MEMCG variant simply returned vm_swappiness, ignoring the
proactive_swappiness value passed through scan_control.  This caused the
swappiness parameter written to /sys/devices/system/node/nodeX/reclaim to
have no effect when CONFIG_MEMCG is disabled.

Fix this by consolidating sc_swappiness() into a single definition that
checks sc->proactive_swappiness first, then falls back to
mem_cgroup_swappiness() which already handles both CONFIG_MEMCG and
!CONFIG_MEMCG.

Before fix (swappiness=max ignored, mostly file pages reclaimed):

    # cat /proc/sys/vm/swappiness
    60
    # cat /proc/vmstat | grep pgsteal
    pgsteal_kswapd 0
    pgsteal_direct 0
    pgsteal_khugepaged 0
    pgsteal_proactive 1840
    pgsteal_anon 25
    pgsteal_file 1815
    # echo "64M swappiness=max" > /sys/devices/system/node/node0/reclaim
    # cat /proc/vmstat | grep pgsteal
    pgsteal_kswapd 0
    pgsteal_direct 0
    pgsteal_khugepaged 0
    pgsteal_proactive 18013
    pgsteal_anon 337
    pgsteal_file 17676

After fix (swappiness=max honored, anon pages reclaimed as expected):

    # cat /proc/vmstat | grep pgsteal
    pgsteal_kswapd 0
    pgsteal_direct 0
    pgsteal_khugepaged 0
    pgsteal_proactive 0
    pgsteal_anon 0
    pgsteal_file 0
    # echo "64M swappiness=max" > /sys/devices/system/node/node0/reclaim
    # cat /proc/vmstat | grep pgsteal
    pgsteal_kswapd 0
    pgsteal_direct 0
    pgsteal_khugepaged 0
    pgsteal_proactive 16283
    pgsteal_anon 16283
    pgsteal_file 0

Link: https://lore.kernel.org/20260723032434.2016749-3-ridong.chen@linux.dev
Fixes: b980077899ea ("mm: introduce per-node proactive reclaim interface")
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Tested-by: Song Hu <husong@kylinos.cn>
Reviewed-by: Song Hu <husong@kylinos.cn>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: <stable@vger.kernel.org>	[6.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmscan.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -201,6 +201,13 @@ struct scan_control {
  */
 int vm_swappiness = 60;
 
+static int sc_swappiness(struct scan_control *sc, struct mem_cgroup *memcg)
+{
+	if (sc->proactive && sc->proactive_swappiness)
+		return *sc->proactive_swappiness;
+	return mem_cgroup_swappiness(memcg);
+}
+
 #ifdef CONFIG_MEMCG
 
 /* Returns true for reclaim through cgroup limits or cgroup interfaces. */
@@ -241,13 +248,6 @@ static bool writeback_throttling_sane(st
 #endif
 	return false;
 }
-
-static int sc_swappiness(struct scan_control *sc, struct mem_cgroup *memcg)
-{
-	if (sc->proactive && sc->proactive_swappiness)
-		return *sc->proactive_swappiness;
-	return mem_cgroup_swappiness(memcg);
-}
 #else
 static bool cgroup_reclaim(struct scan_control *sc)
 {
@@ -263,11 +263,6 @@ static bool writeback_throttling_sane(st
 {
 	return true;
 }
-
-static int sc_swappiness(struct scan_control *sc, struct mem_cgroup *memcg)
-{
-	return READ_ONCE(vm_swappiness);
-}
 #endif
 
 /* for_each_managed_zone_pgdat - helper macro to iterate over all managed zones in a pgdat up to


