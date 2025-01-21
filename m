Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286401F470A;
	Tue, 21 Jan 2025 18:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482583; cv=none; b=g9f9fUfDXCvloQYsBbyTQEsIIcKsGvodRZSGCaZqSJs1uAcS4q/e9MCgiWEynvseQncOoJ8VsiuqiGxb07pRTxioNdMy1z4P/DhAmU4i+QONyNTAP3B3fZEaYGAYyFHlx7shtFilBTzMOPT6qjNbYdeshsSSSduL4KfT7ZKJrUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482583; c=relaxed/simple;
	bh=+6iPB50Ojf2nbVJ1RzNmx4xcVC+nq8/OkbwsPEx6Lt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FnePLMu9XqiGMAuwX8fcTi55JBAVhz8VjxX1s3jP/PlntJS9vmtyP2IgpA2XbPTo7kHyBtfJEUo4Bhh4QUZ9ouzNtmRY9Z2JUYZbhs337W1nuauoHqPY5d2nrJWK2i9tsBGkU90C8oZODErRPVlU4Pf4rYAVQaIA3dtid5ZpTiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FCPUReii; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FCPUReii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75347C4CEDF;
	Tue, 21 Jan 2025 18:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482583;
	bh=+6iPB50Ojf2nbVJ1RzNmx4xcVC+nq8/OkbwsPEx6Lt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FCPUReii2liYu4uLj/wxvmKLTSNI2fwbQDeKjA0G/Ch9vlrJQrg/NWGeOImj1EmYe
	 QGsJjZJd/E3rrJsc1jMJmPWCod99FxX4HIxbG8WSFuLgS0+pb789oq3Fs9EPZSGtrc
	 VFE9wRO84PtE7U9IlqJWbTMLWFPDZR1OSefkCHBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donet Tom <donettom@linux.ibm.com>,
	Yu Zhao <yuzhao@google.com>,
	Li Zhijian <lizhijian@fujitsu.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kaiyang Zhao <kaiyang2@cs.cmu.edu>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Wei Xu <weixugc@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 101/122] mm: vmscan : pgdemote vmstat is not getting updated when MGLRU is enabled.
Date: Tue, 21 Jan 2025 18:52:29 +0100
Message-ID: <20250121174536.928619418@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donet Tom <donettom@linux.ibm.com>

commit bd3d56ffa2c450364acf02663ba88996da37079d upstream.

When MGLRU is enabled, the pgdemote_kswapd, pgdemote_direct, and
pgdemote_khugepaged stats in vmstat are not being updated.

Commit f77f0c751478 ("mm,memcg: provide per-cgroup counters for NUMA
balancing operations") moved the pgdemote vmstat update from
demote_folio_list() to shrink_inactive_list(), which is in the normal LRU
path.  As a result, the pgdemote stats are updated correctly for the
normal LRU but not for MGLRU.

To address this, we have added the pgdemote stat update in the
evict_folios() function, which is in the MGLRU path.  With this patch, the
pgdemote stats will now be updated correctly when MGLRU is enabled.

Without this patch vmstat output when MGLRU is enabled
======================================================
pgdemote_kswapd 0
pgdemote_direct 0
pgdemote_khugepaged 0

With this patch vmstat output when MGLRU is enabled
===================================================
pgdemote_kswapd 43234
pgdemote_direct 4691
pgdemote_khugepaged 0

Link: https://lkml.kernel.org/r/20250109060540.451261-1-donettom@linux.ibm.com
Fixes: f77f0c751478 ("mm,memcg: provide per-cgroup counters for NUMA balancing operations")
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Acked-by: Yu Zhao <yuzhao@google.com>
Tested-by: Li Zhijian <lizhijian@fujitsu.com>
Reviewed-by: Li Zhijian <lizhijian@fujitsu.com>
Cc: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kaiyang Zhao <kaiyang2@cs.cmu.edu>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmscan.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4637,6 +4637,9 @@ retry:
 		reset_batch_size(walk);
 	}
 
+	__mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(),
+					stat.nr_demoted);
+
 	item = PGSTEAL_KSWAPD + reclaimer_offset();
 	if (!cgroup_reclaim(sc))
 		__count_vm_events(item, reclaimed);


