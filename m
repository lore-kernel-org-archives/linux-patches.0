Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC0B280304;
	Tue, 27 May 2025 17:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368587; cv=none; b=RHNPfrzJdKHNncybwqRsRDnVkppvB+r2OIDQJBgN04I2Iv9acO9IqQk/UJIGllJylEL9OuDPoitAX1g0Qp1JTa+Z9xddpgnDv+qV4i26DY7j6ZCAVoTUmups+4pkv1at8fjSPLwkNYv2oV1iXUhO99vKbWQLNXnrsTaF8N+j0G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368587; c=relaxed/simple;
	bh=le0UuCN4R71ZxQ1u9NzRZK439azmXSUIhYjmbemx5t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJCuamzhLm1glDgoFPc9BIxKcIBRT1ENweYYeKBgtKOODcElT3sowUPjV77laEWX/1k27vmSiznM3WiSvMvnb+fNTr9p+MSk53hYiEJJRNL2tntTu041ENRm1iQb3kFIEqMipOxIFDuYR7oFMZjsYf4UyWZ2867DwHZB8XeWZgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pak8///A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pak8///A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41209C4AF09;
	Tue, 27 May 2025 17:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368586;
	bh=le0UuCN4R71ZxQ1u9NzRZK439azmXSUIhYjmbemx5t8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pak8///ArajR3m57cU+xCMJm+0Gbt1c3SgYZWoGvVbSOY+vWf8qog9Met960lQAtH
	 zsAR8uB1UmkTgVOLBlxmuqdmNYuqVgCBZmaQGnXl5Ma1p/sYTB2cKZ9DKTwrCiw4PM
	 ZK1cNJI+BiyGYWPo0XLr9dWcWxPo1+LAiHv8GAY4=
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
Subject: [PATCH 6.14 756/783] mm/page_alloc.c: avoid infinite retries caused by cpuset race
Date: Tue, 27 May 2025 18:29:13 +0200
Message-ID: <20250527162543.910521488@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


