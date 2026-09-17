Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7794DDB5A;
	Thu, 17 Sep 2026 19:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671824; cv=none; b=Gwj2nHI88pz7LX+NdHV0d9WkD76+RkWgZlpvEYAU1kbBPb9irUztdTVawbtAmy0623Eooi1ye9jNlEwnQdiaylOnTkIrHOv0m67MOT4FvQZnnFAxZs+0PfwrX6ZFV1mWrLzAxQU7gRGkurziG14OfrnAqnJRVAUFx2J0c6xlNHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671824; c=relaxed/simple;
	bh=JXMUm2qi9HXr3De7uKjR3gEL7qsdqNlgSMgtne7RDo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cVwRlcq8kP7EXfmIydw6mSJz4rl9Md3V0IuhJrdUuk/knX+dyD8dKrM7Z9Qo1awyd2ozCwpZHjilKlJuB9/3E6GEM50koTwhT/tW+/hJwOkG2DfMoZildjhBWmyf3gpchf29/gajJKqXqMrCktoGXVY7ouuXmDX0VfkgWa6dVpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnFLyPEl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnFLyPEl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F641F000FF;
	Thu, 17 Sep 2026 19:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671822;
	bh=AaVjgT2OF7RxKmAFYKPRjMfjpjI+lCFqcgAixAJqfzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rnFLyPElT58uYfcVcDjqIXOBu5iYoobTWAigTZmdT9a4Xa9H4zIT6sYBQarbk49ho
	 3bY6UyGPlgSp8wO7ScreOosFBfiwCJ+gH3A2UUz74td8EpjRguSRPz2Y557fPvV4u/
	 h0d4rP1oJ3ed8+906t9CTIe9pAJUOUXBpYvaJPMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ameer Hamza <ameer.hamza@truenas.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 1101/1102] SUNRPC: Restore NUMA_NO_NODE for svc thread allocations in global mode
Date: Thu, 17 Sep 2026 16:17:24 +0100
Message-ID: <20260917151608.515752005@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Ameer Hamza <ameer.hamza@truenas.com>

commit 0574da29ae12be7714df217c4ce7ff6ba9b0c23b upstream.

Commit d57e43b72bf2 ("SUNRPC: Update svcxdr_init_decode() to call
xdr_set_scratch_folio()") changed svc_pool_map_get_node() to return
numa_mem_id() instead of NUMA_NO_NODE, because __folio_alloc_node()
cannot accept NUMA_NO_NODE. That return value is not equivalent: it
is evaluated in the context of the task creating the nfsd threads,
once per thread created, and it is passed to kthread_create_on_node()
and to the per-thread allocations in svc_prepare_thread().

Since commit d1a89197589c ("kthread: Default affine kthread to its
preferred NUMA node"), the node argument of kthread_create_on_node()
no longer only places the task structure and stack: a kthread created
with a real node id normally affines itself to that node's CPUs when
it is first woken to run its thread function. All nfsd threads are
typically started together, by one task writing to
/proc/fs/nfsd/threads, so under the default pool_mode=global each
nfsd thread is now affined to the local-memory node of the CPU its
creating iteration happened to run on - typically the same node for
every thread. The CPUs of the other nodes are then unable to run
nfsd at all, and the threads' allocations - svc_rqst structures,
page pointer arrays, newly allocated task stacks, and the per-RPC
pages allocated at run time - all prefer that one node.

Restore the NUMA_NO_NODE behaviour that global mode has had since
commit 11fd165c68b7 ("sunrpc: use better NUMA affinities"), and
handle NUMA_NO_NODE at the one call site that cannot take it by
resolving it to numa_mem_id() there, exactly as alloc_pages_node()
did for the scratch page before the conversion. The mapped percpu
and pernode branches are unchanged. Unpooled services such as lockd
and the NFS client callback service also take this fallback when no
percpu or pernode map is active, restoring their thread placement in
that case.

A bisect of a 2x NFS READ throughput regression between v6.17 and
v6.18 converged on d57e43b72bf2. On the affected 4-node server every
nfsd thread comes up with its CPU affinity restricted to the CPUs of
a single node; with this change the threads are runnable on all CPUs
again and the observed regression is resolved.

Fixes: d57e43b72bf2 ("SUNRPC: Update svcxdr_init_decode() to call xdr_set_scratch_folio()")
Cc: stable@vger.kernel.org
Signed-off-by: Ameer Hamza <ameer.hamza@truenas.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260722182012.2063936-1-ameer.hamza@truenas.com
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/svc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -352,7 +352,7 @@ static int svc_pool_map_get_node(unsigne
 		if (m->mode == SVC_POOL_PERNODE)
 			return m->pool_to[pidx];
 	}
-	return numa_mem_id();
+	return NUMA_NO_NODE;
 }
 /*
  * Set the given thread's cpus_allowed mask so that it
@@ -763,7 +763,9 @@ svc_prepare_thread(struct svc_serv *serv
 	rqstp->rq_server = serv;
 	rqstp->rq_pool = pool;
 
-	rqstp->rq_scratch_folio = __folio_alloc_node(GFP_KERNEL, 0, node);
+	rqstp->rq_scratch_folio = __folio_alloc_node(GFP_KERNEL, 0,
+						     node == NUMA_NO_NODE ?
+						     numa_mem_id() : node);
 	if (!rqstp->rq_scratch_folio)
 		goto out_enomem;
 


