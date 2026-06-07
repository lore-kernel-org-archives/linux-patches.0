Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7BF3246F4;
	Sun,  7 Jun 2026 10:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827944; cv=none; b=PUNDRIoqSHdrp2pk6qE5A4U+CfwjH8wAoo0i3YEFdwUToA7ztAkQ3MfvYAwEsP7GqLmiAhBHecsk6mEnyyR40wUjop/g91dDWN1j0mpLyKVBTlGcpvBn7x7KadH0MI56LN5EuYXLEZflagzXVXEzHG9idh5Bt1FqFndI4KM/qOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827944; c=relaxed/simple;
	bh=ulfO9nVm4gMbvwNAi6NkLsnhL3xYBGU443PjJNHJP00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ddm7OtXuq6exXdBRyR+p5Z2exC2voOCrUv41wTJXYLvtJKkJ2fTLVM8FD2zuCkAVZTEDD9rscxBcKZourtt7JeKOoX1XD+kq/64a+BltQcRXbc9yTJ1D3sPkWvURTbAI7qkG6j1aMKIt7rtNrON1F1mC6vIjWsT5eCM0+qjNaH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SAXSWGtX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SAXSWGtX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED421F00893;
	Sun,  7 Jun 2026 10:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827943;
	bh=7RmuAjw7q4F9c+oyJSvmRr+Lh2icvvMw+zcOKQ9QiJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SAXSWGtXx/3mTrTHHz1SPZAk+2j/WHxmTAbKsvkqTJq7yIuCnHqQdOUDmC3mDXMG4
	 wtTlQsjjCJ32mN1N8+VmG3hH2cJpojPwaaDmXzy0PuBt50UJG1I1Uc8m3oljhmVvkO
	 OVD8GTfa31ojvQDuOpoUDHIsspp0a8HaG/yM9CvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alex@ghiti.fr>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 139/332] mm: memcontrol: propagate NMI slab stats to memcg vmstats
Date: Sun,  7 Jun 2026 11:58:28 +0200
Message-ID: <20260607095733.200682108@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Ghiti <alex@ghiti.fr>

commit e16f17a9c5af50221184d1ef4be4056bf3c4209e upstream.

flush_nmi_stats() drains per-node NMI slab atomics into the per-node
lruvec_stats, but does not propagate them to the memcg-level vmstats.

For non NMI case, account_slab_nmi_safe() calls mod_memcg_lruvec_state()
which updates both per-node lruvec_stats and memcg-level vmstats, so
flush_nmi_stats() needs to flush to per-node lruvec_stats as well as
memcg-level vmstats.

So fix this by flushing to the memcg-level vmstats for NMI too.

Link: https://lore.kernel.org/20260518082830.599102-1-alex@ghiti.fr
Fixes: 940b01fc8dc1 ("memcg: nmi safe memcg stats for specific archs")
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4085,6 +4085,9 @@ static void flush_nmi_stats(struct mem_c
 			lstats->state[index] += slab;
 			if (plstats)
 				plstats->state_pending[index] += slab;
+			memcg->vmstats->state[index] += slab;
+			if (parent)
+				parent->vmstats->state_pending[index] += slab;
 		}
 		if (atomic_read(&pn->slab_unreclaimable)) {
 			int slab = atomic_xchg(&pn->slab_unreclaimable, 0);
@@ -4093,6 +4096,9 @@ static void flush_nmi_stats(struct mem_c
 			lstats->state[index] += slab;
 			if (plstats)
 				plstats->state_pending[index] += slab;
+			memcg->vmstats->state[index] += slab;
+			if (parent)
+				parent->vmstats->state_pending[index] += slab;
 		}
 	}
 }


