Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508DA412BF7;
	Fri,  4 Sep 2026 05:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500409; cv=none; b=J0FDfI2s2VlYgXATsmVBWLpmgAINhsiCyYO/biaSPR/ZaZmWUm7suEPvcvKk1F4qqEFMuPllvvPhXIrUO+VDRvsFVqM6B4ok5RsNmG2Ep0CtMVOIZu9Lb/2Y9mojgn+NifL8EgAxPgx8eRRPLJ/d2+PXEQRolkxDfKrim8A8y4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500409; c=relaxed/simple;
	bh=Qfj7x8Il7RkJHRYRvThw/59j2xBRf3y9zEEJqcpJFGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1ZE9XWYJ4NSnKylbwmD5ZwcyLuAPAwSItB9WBnE0wo6jFvAMN6gluIgJlDZiJ/K7SZ89bzUjHZVgTKSxWyprtwQchpDflfMt105F5IkkspHDppvbeZGbF8FgksDX68XjwAiv5o9q73UhT+2rQQ3lY8IXngSHrpFd0gRsvp4W+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vtb5RuBN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vtb5RuBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B24131F00A3D;
	Fri,  4 Sep 2026 05:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500408;
	bh=V71ZBCqfZg1QWJ/4I/sNkcYR95OsBU2tf4hXOd/Mp04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vtb5RuBNZcYPYw638JaOFkezq7+8rRidsTvZqFbX79whMmPhYQ8h7zGXHtYPhUHaD
	 1VZnUST6Ihisc3v8IZwjDyQ7oN7OJ/k9KM867SQFnLzO6AzhE3+3bnETRY33TQfdLC
	 yYyj1bb/1dd63mca1th+45sNH3oUTrbAhpi8hTnQ=
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
Subject: [PATCH 6.18 046/552] mm: memcontrol: update state_local when flushing NMI stats
Date: Fri,  4 Sep 2026 06:53:23 +0200
Message-ID: <20260904045748.879044868@linuxfoundation.org>
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
@@ -4030,6 +4030,7 @@ static void flush_nmi_stats(struct mem_c
 		int index = memcg_stats_index(MEMCG_KMEM);
 
 		memcg->vmstats->state[index] += kmem;
+		memcg->vmstats->state_local[index] += kmem;
 		if (parent)
 			parent->vmstats->state_pending[index] += kmem;
 	}
@@ -4047,9 +4048,11 @@ static void flush_nmi_stats(struct mem_c
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
@@ -4058,9 +4061,11 @@ static void flush_nmi_stats(struct mem_c
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


