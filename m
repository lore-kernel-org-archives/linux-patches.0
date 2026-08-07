Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A864B0482;
	Fri,  7 Aug 2026 14:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114203; cv=none; b=jGzlQhNS7vIiQtBJuntQIuPIt5VrSCnIG7ZGsgQP7IknoXEy9myRNV/rBJCWI4xUpkObM4HWJxFzva32EgTVdftloX8gYW6ysf18oTdw/6N305ZVw+ZBtEbpINnpcj8JP3OLa4ZrJU/roMt74PHwMAIaWkDNB3ObNeJ9vrqWVQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114203; c=relaxed/simple;
	bh=BJ2uEqZ8jgDP5WcfCzpfzej3GtXmpqToHoxBatDxUNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GhOLHOqrWLBWoCQin/vw2IaFp8qfIjyznY9qmgXEboPA+8mH1OxJs0tUWQ6MqmUrXhK/oS7wRSmKHymh+G7gVEeUg74YcXJ79VjQIm5Duzb9zuhoSQ3FkA5tA+x93IpIgmIjcHw6UhtHFgkOB7nLl5Ti16KpNJ6hr9Kjb/gh6G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xiMGObqC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xiMGObqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6C41F000E9;
	Fri,  7 Aug 2026 14:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114201;
	bh=pfNsIzxZMQWdSvpev7PMowm1Dpq5aIUMZGtH9XNAEEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xiMGObqCs1nBjaOmUqJbi652k5tlPWVMG4QkKLq3d/FDEi1zcRVeidtqHCy2+emDp
	 AQgFiOd1k1lfc/wJiJFTEUjYV5o9NKhQArajz/7MqwUHfwFT069o7PwexDSDsAxcmD
	 QBByeFx8Lwhoq1IdjI6Ot/rWvtsWk6ycTu7JAfeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	SeongJae Park <sj@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 181/337] mm: memcg: initialize *locked in memcg1_oom_prepare() stub
Date: Fri,  7 Aug 2026 16:36:24 +0200
Message-ID: <20260807143422.483464410@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

commit 1833ce36b35426504c64600c94f322437ea44bb2 upstream.

mem_cgroup_oom() passes an uninitialized "locked" to memcg1_oom_prepare()
and reads it back in memcg1_oom_finish():

	bool locked, ret;
	...
	if (!memcg1_oom_prepare(memcg, &locked))
		return false;
	ret = mem_cgroup_out_of_memory(memcg, mask, order);
	memcg1_oom_finish(memcg, locked);

This relies on memcg1_oom_prepare() setting *locked whenever it returns
true.  The CONFIG_MEMCG_V1=y version does, but the stub used when
CONFIG_MEMCG_V1=n returns true without touching *locked, so
memcg1_oom_finish() consumes an uninitialized value.  On a memcg OOM this
is reported by UBSAN:

  UBSAN: invalid-load in mm/memcontrol.c:1932:27
  load of value 0 is not a valid value for type 'bool' (aka '_Bool')

Initialize *locked to false in the stub; with cgroup v1 compiled out there
is no OOM lock to take.

Link: https://lore.kernel.org/20260716-memcg-oom-uninit-locked-v2-1-63631d878eb4@debian.org
Fixes: e93d4166b40a ("mm: memcg: put cgroup v1-specific code under a config option")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol-v1.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -133,7 +133,11 @@ static inline void memcg1_soft_limit_res
 static inline bool memcg1_wait_acct_move(struct mem_cgroup *memcg) { return false; }
 static inline void memcg1_css_offline(struct mem_cgroup *memcg) {}
 
-static inline bool memcg1_oom_prepare(struct mem_cgroup *memcg, bool *locked) { return true; }
+static inline bool memcg1_oom_prepare(struct mem_cgroup *memcg, bool *locked)
+{
+	*locked = false;
+	return true;
+}
 static inline void memcg1_oom_finish(struct mem_cgroup *memcg, bool locked) {}
 static inline void memcg1_oom_recover(struct mem_cgroup *memcg) {}
 


