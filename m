Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022547;
	b=R+MX8dtTb9kNdJlpypA5rRmX2oNNADkR96hbpeqb9p7NBmw55HRK1U3WaVKtXZBwOOqF
	 nw4MvEANRUGInQvc1wL6Af56RX3ytI5TTG4unEMt7TCqQ4tUKx9nVh+43FYg9jlvgsiJJ
	 +a/GIJfha+zcFnZzosblkkq90amhAV9iV0klWINSiftINYiZOQ+2Bx8vPUY5/fVmi2cw0
	 n6TXSlWp8uGzfVPJR8CLPa6WPTcUgsMN35ku+nw0pf6qrAU16FwxWC4KjsRsGozELcoDx
	 my+LB3qZYfNYo9C2Yt39dBWi5xII1jXModAJZaAsWLdclnf6XrrR9yZrXkGx2YQkRGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022547;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RP9FULVWyIq5KzDEGVlxWbxCZUw6lEs/ykSPFJXCoo4=;
	b=D5a41Q9IZYRe0urGj0Z7SspeemoyXZvL/duGQr/DR/lp38EjZTNtaw8kond2nwmpJAZC
	 dlAylJEwcC6xuttPjIr7wWwdMMyVtLZzuvqVyXjJH6oPmF/ipPAqaIsK5tmrxqcgz1yo9
	 OEGJg7IX0yGBJO4IQbViBmbLN3mwzxdwdG01Es3kxM9QER+tCn50rdii+L6cMEi4OQGfs
	 paAns3++emMsUKGEcgtF29axq+7/QQ1AoP7PesG39EuqKhX8syiUEN6mA2xcPobWH/os4
	 jSPJCm9Jm6HXdXeIjR4LSS1MVxPCNgK1nucF20HsRsGHImPw+s02vgN16ypGntt8Q6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JmhMyCbr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B431E606A338;
	Wed, 18 Nov 2026 17:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JmhMyCbr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E8A1F000C4;
	Wed, 18 Nov 2026 17:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022547;
	bh=RP9FULVWyIq5KzDEGVlxWbxCZUw6lEs/ykSPFJXCoo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JmhMyCbrJX5mND9GfsAwcU0tuonJ9ag5CpMOK3L9sTUTcTiS6Qt4JGNJzTS/uL56U
	 gTSi/Bj9vGk5yfKV7cBOM160Y8/pLrjj9X6YXVnwffFafNkwbKdMFZYC/a2tbPxURI
	 PjELz9uSF3bJwaijR/h2yJ0AQmyarxm1dkmvEtnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Hocko <mhocko@suse.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Rik van Riel <riel@surriel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0011/2151] mm/memcontrol: fix stuck FLUSHING_CACHED_CHARGE bit on isolated cpus
Date: Wed, 18 Nov 2026 15:29:06 +0100
Message-ID: <20261118150122.052622594@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rik van Riel <riel@surriel.com>

[ Upstream commit d2f28a1a652e0a43f6f63de9b4e4d8d5f2716803 ]

When drain_all_stock() sets FLUSHING_CACHED_CHARGE before checking
isolation, schedule_drain_work() can drop the work in a separate RCU
critical section, and housekeeping_update()'s synchronize_rcu() can race
that second check, leaving the flag set.

drain_local_stock() only clears the bit for work that ran, so the flag
remains set and the stock is never drained again.

Have schedule_drain_work() return whether the work was queued, and clear
FLUSHING_CACHED_CHARGE in drain_all_stock() when the remote CPU is
isolated, so future drains can retry.

Link: https://lore.kernel.org/20260828135036.7d44361f@fangorn
Fixes: 6a792697a53a ("memcg: do not drain charge pcp caches on remote isolated cpus")
Suggested-by: Michal Hocko <mhocko@suse.com>
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
[ sashal: Adapted the schedule_drain_work() changes to the direct isolation checks in drain_all_stock() because the helper is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memcontrol.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3ce613dab616e..bb267287b460e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2016,6 +2016,9 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 				drain_local_memcg_stock(&memcg_st->work);
 			else if (!cpu_is_isolated(cpu))
 				schedule_work_on(cpu, &memcg_st->work);
+			else
+				clear_bit(FLUSHING_CACHED_CHARGE,
+					  &memcg_st->flags);
 		}
 
 		if (!test_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags) &&
@@ -2026,6 +2029,9 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 				drain_local_obj_stock(&obj_st->work);
 			else if (!cpu_is_isolated(cpu))
 				schedule_work_on(cpu, &obj_st->work);
+			else
+				clear_bit(FLUSHING_CACHED_CHARGE,
+					  &obj_st->flags);
 		}
 	}
 	migrate_enable();
-- 
2.53.0



