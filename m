Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBE017BEAE;
	Tue, 10 Sep 2024 09:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962199; cv=none; b=TKco8lUdZAREqtbIkV9af8FS2ox6eWy2htsLVIohqXuVAvqEpYjmzdixr8aSPwROYObI0xM3BTP5R4yPbsjsMFRvmpoOqSngEKkCAgU/tLQwJC20rQq9XWyTIwOT5vOjHNMBLSIhwc7SI5PNJIXbcr4K7boQt8QCD00Effbf1dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962199; c=relaxed/simple;
	bh=QUfbPhhLGRuxzmSmLiBKoM7VsOCtgqT35BvVZIFxqfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iNeQhRaPoD4hXIFLXTxUvKy/hHX5COoybnts2wPvmL9IR+zMEEXxp21dfh70H/Oy0t69eNgeOovK2Lylcj580AAFkM9NgiUSPzSsL3O+YLK/Mm5uLBAUOeEoTg3GdGK8MOt3l4akOrkVRVSHIEeaXzK9rk0sBcf4rxxWR41qz/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g+EB9ZGT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g+EB9ZGT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B7CC4CECD;
	Tue, 10 Sep 2024 09:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962199;
	bh=QUfbPhhLGRuxzmSmLiBKoM7VsOCtgqT35BvVZIFxqfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g+EB9ZGTq4zj75Yw5SQeHAYqWSxiDjGhvxLotsSfUkc+VLSNcOfR+mq5DfVIKiRbu
	 +doc6eT83Yl3hbjSx9OGC2him75UFJMple33rnGsxngOu1T4iQ5GvwZ8ePgpOW5uUF
	 lYDP+R0/McwpPu2AKey7FDN/FUR5ttEr9RLVObhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Yuan <me@yhndnzj.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 311/375] mm/memcontrol: respect zswap.writeback setting from parent cg too
Date: Tue, 10 Sep 2024 11:31:48 +0200
Message-ID: <20240910092633.004017679@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Yuan <me@yhndnzj.com>

[ Upstream commit e399257349098bf7c84343f99efb2bc9c22eb9fd ]

Currently, the behavior of zswap.writeback wrt.  the cgroup hierarchy
seems a bit odd.  Unlike zswap.max, it doesn't honor the value from parent
cgroups.  This surfaced when people tried to globally disable zswap
writeback, i.e.  reserve physical swap space only for hibernation [1] -
disabling zswap.writeback only for the root cgroup results in subcgroups
with zswap.writeback=1 still performing writeback.

The inconsistency became more noticeable after I introduced the
MemoryZSwapWriteback= systemd unit setting [2] for controlling the knob.
The patch assumed that the kernel would enforce the value of parent
cgroups.  It could probably be workarounded from systemd's side, by going
up the slice unit tree and inheriting the value.  Yet I think it's more
sensible to make it behave consistently with zswap.max and friends.

[1] https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Disable_zswap_writeback_to_use_the_swap_space_only_for_hibernation
[2] https://github.com/systemd/systemd/pull/31734

Link: https://lkml.kernel.org/r/20240823162506.12117-1-me@yhndnzj.com
Fixes: 501a06fe8e4c ("zswap: memcontrol: implement zswap writeback disabling")
Signed-off-by: Mike Yuan <me@yhndnzj.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/cgroup-v2.rst |  7 ++++---
 mm/memcontrol.c                         | 12 +++++++++---
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index b69f701b2485..4a7a59bbf76f 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1706,9 +1706,10 @@ PAGE_SIZE multiple when read back.
 	entries fault back in or are written out to disk.
 
   memory.zswap.writeback
-	A read-write single value file. The default value is "1". The
-	initial value of the root cgroup is 1, and when a new cgroup is
-	created, it inherits the current value of its parent.
+	A read-write single value file. The default value is "1".
+	Note that this setting is hierarchical, i.e. the writeback would be
+	implicitly disabled for child cgroups if the upper hierarchy
+	does so.
 
 	When this is set to 0, all swapping attempts to swapping devices
 	are disabled. This included both zswap writebacks, and swapping due
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ff1e7d2260ab..5c44d3d304da 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5804,8 +5804,7 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 	WRITE_ONCE(memcg->soft_limit, PAGE_COUNTER_MAX);
 #if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_ZSWAP)
 	memcg->zswap_max = PAGE_COUNTER_MAX;
-	WRITE_ONCE(memcg->zswap_writeback,
-		!parent || READ_ONCE(parent->zswap_writeback));
+	WRITE_ONCE(memcg->zswap_writeback, true);
 #endif
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	if (parent) {
@@ -8444,7 +8443,14 @@ void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size)
 bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
 {
 	/* if zswap is disabled, do not block pages going to the swapping device */
-	return !zswap_is_enabled() || !memcg || READ_ONCE(memcg->zswap_writeback);
+	if (!zswap_is_enabled())
+		return true;
+
+	for (; memcg; memcg = parent_mem_cgroup(memcg))
+		if (!READ_ONCE(memcg->zswap_writeback))
+			return false;
+
+	return true;
 }
 
 static u64 zswap_current_read(struct cgroup_subsys_state *css,
-- 
2.43.0



