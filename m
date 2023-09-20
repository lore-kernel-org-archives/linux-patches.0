Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28AD28E00
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:53:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3633DC433C9;
	Wed, 20 Sep 2023 11:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210803;
	bh=EMXBAcWlUrIRala+pJkUpmBOThAZqd28xF0t4g6RRys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jXWmp5yEKmLbFAUEwNvmHeohjkBxHRnWhv4/zCMs77wF5yOrp9jIdhOEcGxLYBse+
	 TMwIHIlOHxD5Nuv0tsHlzLD68L+8+ipBPJzrKYKYbK/uC4WCpoZuf7S/quSCjpW0Bs
	 xmyB6n/LMoU02VtGn7k63VIMHAc0iSoXZfTKoAGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
	Michal Hocko <mhocko@suse.com>,
	Shakeel Butt <shakeelb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.5 210/211] Revert "memcg: drop kmem.limit_in_bytes"
Date: Wed, 20 Sep 2023 13:30:54 +0200
Message-ID: <20230920112852.370864789@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 75bb29b6c44f486e9bd048759669c205dccb2048 which is
commit 86327e8eb94c52eca4f93cfece2e29d1bf52acbf upstream.

It breaks existing runc systems, as the tool always thinks the file
should be present.

Reported-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Link: https://lore.kernel.org/r/20230920081101.GA12096@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/cgroup-v1/memory.rst |    2 ++
 mm/memcontrol.c                                |   10 ++++++++++
 2 files changed, 12 insertions(+)

--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -92,6 +92,8 @@ Brief summary of control files.
  memory.oom_control		     set/show oom controls.
  memory.numa_stat		     show the number of memory usage per numa
 				     node
+ memory.kmem.limit_in_bytes          This knob is deprecated and writing to
+                                     it will return -ENOTSUPP.
  memory.kmem.usage_in_bytes          show current kernel memory allocation
  memory.kmem.failcnt                 show the number of kernel memory usage
 				     hits limits
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3871,6 +3871,10 @@ static ssize_t mem_cgroup_write(struct k
 		case _MEMSWAP:
 			ret = mem_cgroup_resize_max(memcg, nr_pages, true);
 			break;
+		case _KMEM:
+			/* kmem.limit_in_bytes is deprecated. */
+			ret = -EOPNOTSUPP;
+			break;
 		case _TCP:
 			ret = memcg_update_tcp_max(memcg, nr_pages);
 			break;
@@ -5082,6 +5086,12 @@ static struct cftype mem_cgroup_legacy_f
 	},
 #endif
 	{
+		.name = "kmem.limit_in_bytes",
+		.private = MEMFILE_PRIVATE(_KMEM, RES_LIMIT),
+		.write = mem_cgroup_write,
+		.read_u64 = mem_cgroup_read_u64,
+	},
+	{
 		.name = "kmem.usage_in_bytes",
 		.private = MEMFILE_PRIVATE(_KMEM, RES_USAGE),
 		.read_u64 = mem_cgroup_read_u64,


