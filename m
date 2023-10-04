Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB02A1C29E
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cq/tTjsc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7F8C433CC;
	Wed,  4 Oct 2023 18:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444630;
	bh=onHrFRPA+9j6npSpupJvCVNeZcgJ+kGnwq1n47Xgu5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cq/tTjsc/NZTpfDurZtBuGnQYNx7qp9X1TSg/NgnOh9ApQweUiAyHS5TTcO7pCJ0/
	 B3TS6tQ5n+eFNs5apv+agpZodMuLxajWOObuKoZ/waFl/fOOLil8UYkXKfZ6enU81w
	 G88UXTYl615wCp9zNqk4cVlsrYd9BZ8zoCSpNkPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Hocko <mhocko@suse.com>,
	Shakeel Butt <shakeelb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.5 319/321] memcg: drop kmem.limit_in_bytes
Date: Wed,  4 Oct 2023 19:57:44 +0200
Message-ID: <20231004175244.063443497@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Hocko <mhocko@suse.com>

commit 86327e8eb94c52eca4f93cfece2e29d1bf52acbf upstream.

kmem.limit_in_bytes (v1 way to limit kernel memory usage) has been
deprecated since 58056f77502f ("memcg, kmem: further deprecate
kmem.limit_in_bytes") merged in 5.16.  We haven't heard about any serious
users since then but it seems that the mere presence of the file is
causing more harm thatn good.  We (SUSE) have had several bug reports from
customers where Docker based containers started to fail because a write to
kmem.limit_in_bytes has failed.

This was unexpected because runc code only expects ENOENT (kmem disabled)
or EBUSY (tasks already running within cgroup).  So a new error code was
unexpected and the whole container startup failed.  This has been later
addressed by
https://github.com/opencontainers/runc/commit/52390d68040637dfc77f9fda6bbe70952423d380
so current Docker runtimes do not suffer from the problem anymore.  There
are still older version of Docker in use and likely hard to get rid of
completely.

Address this by wiping out the file completely and effectively get back to
pre 4.5 era and CONFIG_MEMCG_KMEM=n configuration.

I would recommend backporting to stable trees which have picked up
58056f77502f ("memcg, kmem: further deprecate kmem.limit_in_bytes").

[mhocko@suse.com: restore _KMEM switch case]
  Link: https://lkml.kernel.org/r/ZKe5wxdbvPi5Cwd7@dhcp22.suse.cz
Link: https://lkml.kernel.org/r/20230704115240.14672-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/cgroup-v1/memory.rst |    2 --
 mm/memcontrol.c                                |   10 ----------
 2 files changed, 12 deletions(-)

--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -92,8 +92,6 @@ Brief summary of control files.
  memory.oom_control		     set/show oom controls.
  memory.numa_stat		     show the number of memory usage per numa
 				     node
- memory.kmem.limit_in_bytes          This knob is deprecated and writing to
-                                     it will return -ENOTSUPP.
  memory.kmem.usage_in_bytes          show current kernel memory allocation
  memory.kmem.failcnt                 show the number of kernel memory usage
 				     hits limits
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3871,10 +3871,6 @@ static ssize_t mem_cgroup_write(struct k
 		case _MEMSWAP:
 			ret = mem_cgroup_resize_max(memcg, nr_pages, true);
 			break;
-		case _KMEM:
-			/* kmem.limit_in_bytes is deprecated. */
-			ret = -EOPNOTSUPP;
-			break;
 		case _TCP:
 			ret = memcg_update_tcp_max(memcg, nr_pages);
 			break;
@@ -5086,12 +5082,6 @@ static struct cftype mem_cgroup_legacy_f
 	},
 #endif
 	{
-		.name = "kmem.limit_in_bytes",
-		.private = MEMFILE_PRIVATE(_KMEM, RES_LIMIT),
-		.write = mem_cgroup_write,
-		.read_u64 = mem_cgroup_read_u64,
-	},
-	{
 		.name = "kmem.usage_in_bytes",
 		.private = MEMFILE_PRIVATE(_KMEM, RES_USAGE),
 		.read_u64 = mem_cgroup_read_u64,


