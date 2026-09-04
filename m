Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197E1402B8C;
	Fri,  4 Sep 2026 05:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498479; cv=none; b=Dzbd3I42uW84XM7YaSeVSOLKT8ie0cZqRayWpNLx65mRfw6QcMb4xgqn3RpEEreqK6HuVjPxadiuRfS4y0MmH7pZDgBBZH8h181VRNUeqvKZe4DP1hBsHNsNhYVZI4A7NLJYubrmiroAPutzxbTmatwfmrrjpAYB1hks/x6yxYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498479; c=relaxed/simple;
	bh=1yW1iWFLm0LBp2+sVjk0Ckn87V3wuTXFY4x9b7s63v4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aKeidpAfx1Qf4A+bVtG8O01lCzW0tYtNNg3gsc1oCmXfH6CmvsjVAeGWQ05ED2WBo9muxvObARG4kG/mJfPwwGZY9R8oJ1EyTZYtmFYNWY8C8inu3VjzAinbNq3t2BPrBV4abGS0aqvlM2xubHyRKGSr3hZiXEfVUkxrf+bRtMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RBy7WD4j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RBy7WD4j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758B81F00A3D;
	Fri,  4 Sep 2026 05:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498478;
	bh=wz5OWCRJVIk0tgh8cmphscTN8GUupiD6ZQ3HzwO0Kmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RBy7WD4j/PU99fOi0hvKJ4wqTzLnuUXEh8BWzNef/47sGD46TAg3+utXfdZajWKRe
	 p0Xo12aQ3YhpkUj689SYj008bx52+O3Y6gV0HEV4VfepbCui+s/wMJuRP52yTXCtXV
	 1ig6MTysrqE3xMptDWJm5VhVVgAIF3stK1HPQwPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Tao Cui <cuitao@kylinos.cn>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 075/713] mm: memcontrol: update state_local when flushing NMI stats
Date: Fri,  4 Sep 2026 06:50:43 +0200
Message-ID: <20260904045805.522366811@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

commit 72f522bbf473f03a77e83547b677dc1505c5d41a upstream.

flush_nmi_stats() updates state[] for kmem and slab counters but leaves
the corresponding state_local[] counters unchanged.  Local kmem and slab
statistics therefore miss updates collected through the NMI-safe atomic
path.

Update state_local[] together with state[].

Link: https://lore.kernel.org/20260713085053.2916813-1-guopeng.zhang@linux.dev
Fixes: 940b01fc8dc1 ("memcg: nmi safe memcg stats for specific archs")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Acked-by: Tao Cui <cuitao@kylinos.cn>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4440,6 +4440,7 @@ static void flush_nmi_stats(struct mem_c
 		int index = memcg_stats_index(MEMCG_KMEM);
 
 		memcg->vmstats->state[index] += kmem;
+		memcg->vmstats->state_local[index] += kmem;
 		if (parent)
 			parent->vmstats->state_pending[index] += kmem;
 	}
@@ -4457,9 +4458,11 @@ static void flush_nmi_stats(struct mem_c
 			int index = memcg_stats_index(NR_SLAB_RECLAIMABLE_B);
 
 			lstats->state[index] += slab;
+			lstats->state_local[index] += slab;
 			if (plstats)
 				plstats->state_pending[index] += slab;
 			memcg->vmstats->state[index] += slab;
+			memcg->vmstats->state_local[index] += slab;
 			if (parent)
 				parent->vmstats->state_pending[index] += slab;
 		}
@@ -4468,9 +4471,11 @@ static void flush_nmi_stats(struct mem_c
 			int index = memcg_stats_index(NR_SLAB_UNRECLAIMABLE_B);
 
 			lstats->state[index] += slab;
+			lstats->state_local[index] += slab;
 			if (plstats)
 				plstats->state_pending[index] += slab;
 			memcg->vmstats->state[index] += slab;
+			memcg->vmstats->state_local[index] += slab;
 			if (parent)
 				parent->vmstats->state_pending[index] += slab;
 		}


