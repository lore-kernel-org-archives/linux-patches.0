Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9085412C47A;
	Tue, 30 Apr 2024 10:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474529; cv=none; b=EOHWt8pHy0fVNogsYDC0YuuDiMgp54swJBPy5Ru44evk6iZXPXjv57Zjv9EWK4LXW8XCinJhSnYz2hMT+zljx5inhKEBRgudRETDKsiyrxqZFrK9n21TXYN/X6UrI5t6qwjiG8cPk9U+IPLPki5ynq/2a2lvEsuaOsnrvIWT2/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474529; c=relaxed/simple;
	bh=FJVCFCmbA8z00j5VuAr1u5A3pYl7BfJCI6eNk6DT/u4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvTb/5INTb+Y6JOs+yaPZRO52NFOpXH3xJdxl85LJzKFX4RV+bDede63E2VF/tAVcCZ+XvCKago+0n4fmzYMcVcktFn7Zz2EVGxETh7WmWtS1SduDgwBMHUetggSh19gZiF0g11zssT+Cy9QVbwpONIPcy3sOG7yPowQScGkMlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJ+zOF0d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJ+zOF0d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A56CC2BBFC;
	Tue, 30 Apr 2024 10:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474529;
	bh=FJVCFCmbA8z00j5VuAr1u5A3pYl7BfJCI6eNk6DT/u4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dJ+zOF0dhIuuLFaZbq3yIpJFADdvbPq90S7g+p2KNWurwjPecA5lhyh8HXtIoE97c
	 SkRh8FON8fDmCdsuoQ1hWsyLuXMqy6eKxbAlQUT/Nj0YfAdgAee0elMXxdqJjD+7hG
	 jhj2rNRG4p4h6xkhy0txB3JsjqpuQqrR9PnPtLK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Xu <peterx@redhat.com>,
	syzbot+4b8077a5fccc61c385a1@syzkaller.appspotmail.com,
	Mina Almasry <almasrymina@google.com>,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.8 147/228] mm/hugetlb: fix missing hugetlb_lock for resv uncharge
Date: Tue, 30 Apr 2024 12:38:45 +0200
Message-ID: <20240430103108.050279662@linuxfoundation.org>
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

From: Peter Xu <peterx@redhat.com>

commit b76b46902c2d0395488c8412e1116c2486cdfcb2 upstream.

There is a recent report on UFFDIO_COPY over hugetlb:

https://lore.kernel.org/all/000000000000ee06de0616177560@google.com/

350:	lockdep_assert_held(&hugetlb_lock);

Should be an issue in hugetlb but triggered in an userfault context, where
it goes into the unlikely path where two threads modifying the resv map
together.  Mike has a fix in that path for resv uncharge but it looks like
the locking criteria was overlooked: hugetlb_cgroup_uncharge_folio_rsvd()
will update the cgroup pointer, so it requires to be called with the lock
held.

Link: https://lkml.kernel.org/r/20240417211836.2742593-3-peterx@redhat.com
Fixes: 79aa925bf239 ("hugetlb_cgroup: fix reservation accounting")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: syzbot+4b8077a5fccc61c385a1@syzkaller.appspotmail.com
Reviewed-by: Mina Almasry <almasrymina@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3266,9 +3266,12 @@ struct folio *alloc_hugetlb_folio(struct
 
 		rsv_adjust = hugepage_subpool_put_pages(spool, 1);
 		hugetlb_acct_memory(h, -rsv_adjust);
-		if (deferred_reserve)
+		if (deferred_reserve) {
+			spin_lock_irq(&hugetlb_lock);
 			hugetlb_cgroup_uncharge_folio_rsvd(hstate_index(h),
 					pages_per_huge_page(h), folio);
+			spin_unlock_irq(&hugetlb_lock);
+		}
 	}
 
 	if (!memcg_charge_ret)


