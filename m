Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD61012C534;
	Tue, 30 Apr 2024 10:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474576; cv=none; b=XEt9SUJHXv+VM1BK9dHRr/73SG5IbpDkvgpXeZWR7sR24ke2isV6T9rzGpqFVfaUR1L3KXjlTyCOiofneElErdL+CX73PqpohJfZXCjH/YXr4uKcpFHJuPCaFvOcA2BF01MR8HJyw5x3VF01dWH+hvwrv9aTc45mVMPBzxnRca4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474576; c=relaxed/simple;
	bh=AO6y+YKJoirzJpk/UyWJsmb/mThT2G68Rv7R+xWkic8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q9xYuJ0jYo/XZ2R98pA0VZiQy56+WYJu9GotaAMgUM03YafmNhLgtoe7dtga8Amavh1tpdvYjkjR9s/wFk9xKcBXVnC8q0L4BPFVunQHIXGEdNr1o673k+smyfNOD6ocygW20MDu8KMJAuAFjAz5Clb8eZ2A7WGHLaJydWWGK5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qtdzgfS1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qtdzgfS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0E3C2BBFC;
	Tue, 30 Apr 2024 10:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474576;
	bh=AO6y+YKJoirzJpk/UyWJsmb/mThT2G68Rv7R+xWkic8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qtdzgfS1kSlPxUbd8gg19j4LArnnTCzlcAiA5AN5CoKGKAaD3B/rYWAbFSuy1+H3j
	 gCr3bMM4iT+jIhZmmkJqkxtSRCb8S02oPnz50TF+8RQyCWfQLIxGda4AkcRcnT5oL3
	 UJ/A+XbSHsqf3Dgm7c7GRS49sLttr2ag4mYTsWHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>,
	Christian Heusel <christian@heusel.eu>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Dan Streetman <ddstreet@ieee.org>,
	"Richard W.M. Jones" <rjones@redhat.com>,
	Seth Jennings <sjenning@redhat.com>,
	Vitaly Wool <vitaly.wool@konsulko.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.8 199/228] mm: zswap: fix shrinker NULL crash with cgroup_disable=memory
Date: Tue, 30 Apr 2024 12:39:37 +0200
Message-ID: <20240430103109.544924480@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Weiner <hannes@cmpxchg.org>

commit 682886ec69d22363819a83ddddd5d66cb5c791e1 upstream.

Christian reports a NULL deref in zswap that he bisected down to the zswap
shrinker.  The issue also cropped up in the bug trackers of libguestfs [1]
and the Red Hat bugzilla [2].

The problem is that when memcg is disabled with the boot time flag, the
zswap shrinker might get called with sc->memcg == NULL.  This is okay in
many places, like the lruvec operations.  But it crashes in
memcg_page_state() - which is only used due to the non-node accounting of
cgroup's the zswap memory to begin with.

Nhat spotted that the memcg can be NULL in the memcg-disabled case, and I
was then able to reproduce the crash locally as well.

[1] https://github.com/libguestfs/libguestfs/issues/139
[2] https://bugzilla.redhat.com/show_bug.cgi?id=2275252

Link: https://lkml.kernel.org/r/20240418124043.GC1055428@cmpxchg.org
Link: https://lkml.kernel.org/r/20240417143324.GA1055428@cmpxchg.org
Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Christian Heusel <christian@heusel.eu>
Debugged-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Tested-by: Christian Heusel <christian@heusel.eu>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Richard W.M. Jones <rjones@redhat.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: <stable@vger.kernel.org>	[v6.8]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/zswap.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

Two minor conflicts in the else branch:
- zswap_pool_total_size was get_zswap_pool_size() in 6.8
- zswap_nr_stored was pool->nr_stored in 6.8

--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -653,15 +653,22 @@ static unsigned long zswap_shrinker_coun
 	if (!gfp_has_io_fs(sc->gfp_mask))
 		return 0;
 
-#ifdef CONFIG_MEMCG_KMEM
-	mem_cgroup_flush_stats(memcg);
-	nr_backing = memcg_page_state(memcg, MEMCG_ZSWAP_B) >> PAGE_SHIFT;
-	nr_stored = memcg_page_state(memcg, MEMCG_ZSWAPPED);
-#else
-	/* use pool stats instead of memcg stats */
-	nr_backing = get_zswap_pool_size(pool) >> PAGE_SHIFT;
-	nr_stored = atomic_read(&pool->nr_stored);
-#endif
+	/*
+	 * For memcg, use the cgroup-wide ZSWAP stats since we don't
+	 * have them per-node and thus per-lruvec. Careful if memcg is
+	 * runtime-disabled: we can get sc->memcg == NULL, which is ok
+	 * for the lruvec, but not for memcg_page_state().
+	 *
+	 * Without memcg, use the zswap pool-wide metrics.
+	 */
+	if (!mem_cgroup_disabled()) {
+		mem_cgroup_flush_stats(memcg);
+		nr_backing = memcg_page_state(memcg, MEMCG_ZSWAP_B) >> PAGE_SHIFT;
+		nr_stored = memcg_page_state(memcg, MEMCG_ZSWAPPED);
+	} else {
+		nr_backing = get_zswap_pool_size(pool) >> PAGE_SHIFT;
+		nr_stored = atomic_read(&pool->nr_stored);
+	}
 
 	if (!nr_stored)
 		return 0;


