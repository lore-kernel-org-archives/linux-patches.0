Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2806327FD6F;
	Tue, 27 May 2025 17:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366126; cv=none; b=X0m2kM+dwKzkQ1vkAAEzzJAUvxtA5k1HcuRcrsrjnNqx+HFqAQNGcNi+O/Yca9tTZyjPo9QGLnd/WHFMWizD3jPpnA12WIDaNlpGhPI9QwtzqiMdyDThR5/MflLvpJhZVkblXXMUOwUj/ZPecNpEt3Al05N6Nm/XdX41zNQbFbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366126; c=relaxed/simple;
	bh=bbGiqNIs8sZXQPwktYU1BzVMd9BxlCR9p06XVmtyjS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OybHs+CHMTgcxmMZLVC2wdE9WVuUtTkjAskIsyobtJCLl4SaAueZ34z+9SNx8a80fcYrkj3Qo7LfxdcKhj3zsNbF2wpK8LXGdaTB85mNMJIxdYR+x9hC3TgI3QR/5MEc8xSk1e0Sl/sViBqbL5NWZ/HeAHaRIth7s7bU2HhQskM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yy5Af0EF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yy5Af0EF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6243C4CEE9;
	Tue, 27 May 2025 17:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366126;
	bh=bbGiqNIs8sZXQPwktYU1BzVMd9BxlCR9p06XVmtyjS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yy5Af0EF1H8UTUAl/AqEViquxGh+SFbYiJzuw5G1IZno4iIq8jeFQ6zxSQDspgo0w
	 sWRJyMF0fq6sV6znItDpULTX+XAmqUFg2Ace5v+yUQV8tjHbDtc1KXnpOCGh3EtfaS
	 h0QnYPfddKOyFAGUTGxu/8Wvzt9CHEvPS7EkKDuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyang Zhang <zhangtianyang@loongson.cn>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 599/626] mm/page_alloc.c: avoid infinite retries caused by cpuset race
Date: Tue, 27 May 2025 18:28:12 +0200
Message-ID: <20250527162509.336122569@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Tianyang Zhang <zhangtianyang@loongson.cn>

commit e05741fb10c38d70bbd7ec12b23c197b6355d519 upstream.

__alloc_pages_slowpath has no change detection for ac->nodemask in the
part of retry path, while cpuset can modify it in parallel.  For some
processes that set mempolicy as MPOL_BIND, this results ac->nodemask
changes, and then the should_reclaim_retry will judge based on the latest
nodemask and jump to retry, while the get_page_from_freelist only
traverses the zonelist from ac->preferred_zoneref, which selected by a
expired nodemask and may cause infinite retries in some cases

cpu 64:
__alloc_pages_slowpath {
        /* ..... */
retry:
        /* ac->nodemask = 0x1, ac->preferred->zone->nid = 1 */
        if (alloc_flags & ALLOC_KSWAPD)
                wake_all_kswapds(order, gfp_mask, ac);
        /* cpu 1:
        cpuset_write_resmask
            update_nodemask
                update_nodemasks_hier
                    update_tasks_nodemask
                        mpol_rebind_task
                         mpol_rebind_policy
                          mpol_rebind_nodemask
		// mempolicy->nodes has been modified,
		// which ac->nodemask point to

        */
        /* ac->nodemask = 0x3, ac->preferred->zone->nid = 1 */
        if (should_reclaim_retry(gfp_mask, order, ac, alloc_flags,
                                 did_some_progress > 0, &no_progress_loops))
                goto retry;
}

Simultaneously starting multiple cpuset01 from LTP can quickly reproduce
this issue on a multi node server when the maximum memory pressure is
reached and the swap is enabled

Link: https://lkml.kernel.org/r/20250416082405.20988-1-zhangtianyang@loongson.cn
Fixes: c33d6c06f60f ("mm, page_alloc: avoid looking up the first zone in a zonelist twice")
Signed-off-by: Tianyang Zhang <zhangtianyang@loongson.cn>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4381,6 +4381,14 @@ restart:
 	}
 
 retry:
+	/*
+	 * Deal with possible cpuset update races or zonelist updates to avoid
+	 * infinite retries.
+	 */
+	if (check_retry_cpuset(cpuset_mems_cookie, ac) ||
+	    check_retry_zonelist(zonelist_iter_cookie))
+		goto restart;
+
 	/* Ensure kswapd doesn't accidentally go to sleep as long as we loop */
 	if (alloc_flags & ALLOC_KSWAPD)
 		wake_all_kswapds(order, gfp_mask, ac);


