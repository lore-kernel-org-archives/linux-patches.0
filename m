Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421481D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2S5fQ6pE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD10C433C8;
	Wed,  4 Oct 2023 18:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443724;
	bh=mZ7zfZwjYPMvzvbR8DOWr1zecipKznuaOPsGWNQSNfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2S5fQ6pEQsFzQ8l7Eu09KJwdlMKoNtaJ3V7dEcWOHMlbgiegcR9thS8JdNXlNK+sf
	 yh6yM/QYy7yO5gXNDyi2yXky8EL6wZJ6sQRdl0Kd/ZTikTVr1RKLnrUjvwW9yyyPoa
	 4wG6gBp2RxX0mxjyA4qxOIH42w6nGCblL28Y94EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Hocko <mhocko@suse.com>,
	Shakeel Butt <shakeelb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Tejun heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 258/259] mm, memcg: reconsider kmem.limit_in_bytes deprecation
Date: Wed,  4 Oct 2023 19:57:11 +0200
Message-ID: <20231004175229.252231587@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Hocko <mhocko@suse.com>

commit 4597648fddeadef5877610d693af11906aa666ac upstream.

This reverts commits 86327e8eb94c ("memcg: drop kmem.limit_in_bytes") and
partially reverts 58056f77502f ("memcg, kmem: further deprecate
kmem.limit_in_bytes") which have incrementally removed support for the
kernel memory accounting hard limit.  Unfortunately it has turned out that
there is still userspace depending on the existence of
memory.kmem.limit_in_bytes [1].  The underlying functionality is not
really required but the non-existent file just confuses the userspace
which fails in the result.  The patch to fix this on the userspace side
has been submitted but it is hard to predict how it will propagate through
the maze of 3rd party consumers of the software.

Now, reverting alone 86327e8eb94c is not an option because there is
another set of userspace which cannot cope with ENOTSUPP returned when
writing to the file.  Therefore we have to go and revisit 58056f77502f as
well.  There are two ways to go ahead.  Either we give up on the
deprecation and fully revert 58056f77502f as well or we can keep
kmem.limit_in_bytes but make the write a noop and warn about the fact.
This should work for both known breaking workloads which depend on the
existence but do not depend on the hard limit enforcement.

Note to backporters to stable trees.  a8c49af3be5f ("memcg: add per-memcg
total kernel memory stat") introduced in 4.18 has added memcg_account_kmem
so the accounting is not done by obj_cgroup_charge_pages directly for v1
anymore.  Prior kernels need to add it explicitly (thanks to Johannes for
pointing this out).

[akpm@linux-foundation.org: fix build - remove unused local]
Link: http://lkml.kernel.org/r/20230920081101.GA12096@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net [1]
Link: https://lkml.kernel.org/r/ZRE5VJozPZt9bRPy@dhcp22.suse.cz
Fixes: 86327e8eb94c ("memcg: drop kmem.limit_in_bytes")
Fixes: 58056f77502f ("memcg, kmem: further deprecate kmem.limit_in_bytes")
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/cgroup-v1/memory.rst |    7 +++++++
 mm/memcontrol.c                                |   13 +++++++++++++
 2 files changed, 20 insertions(+)

--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -91,6 +91,13 @@ Brief summary of control files.
  memory.oom_control		     set/show oom controls.
  memory.numa_stat		     show the number of memory usage per numa
 				     node
+ memory.kmem.limit_in_bytes          Deprecated knob to set and read the kernel
+                                     memory hard limit. Kernel hard limit is not
+                                     supported since 5.16. Writing any value to
+                                     do file will not have any effect same as if
+                                     nokmem kernel parameter was specified.
+                                     Kernel memory is still charged and reported
+                                     by memory.kmem.usage_in_bytes.
  memory.kmem.usage_in_bytes          show current kernel memory allocation
  memory.kmem.failcnt                 show the number of kernel memory usage
 				     hits limits
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3841,6 +3841,13 @@ static ssize_t mem_cgroup_write(struct k
 		case _MEMSWAP:
 			ret = mem_cgroup_resize_max(memcg, nr_pages, true);
 			break;
+		case _KMEM:
+			pr_warn_once("kmem.limit_in_bytes is deprecated and will be removed. "
+				     "Writing any value to this file has no effect. "
+				     "Please report your usecase to linux-mm@kvack.org if you "
+				     "depend on this functionality.\n");
+			ret = 0;
+			break;
 		case _TCP:
 			ret = memcg_update_tcp_max(memcg, nr_pages);
 			break;
@@ -5052,6 +5059,12 @@ static struct cftype mem_cgroup_legacy_f
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


