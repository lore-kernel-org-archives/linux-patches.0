Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EEF42C21F7;
	Tue, 12 Aug 2025 19:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026892; cv=none; b=jYgzGQOXX/s8rSgkR2jmy+396wj6nNE7MyCeKc1JDF6VhjOMecbL6+bfqhyKS9UEraAemhUORgANMUJ4xjJm9fg7iVbca/kJUDFhF+izfQVttsVEE5F5EHroHVfQYH6n4g2TkedCcmO5zWOk0FciAdfhErPdQo9NIRQ6mdiLGKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026892; c=relaxed/simple;
	bh=sZ1MvrfYTiXMWEk+jqegw5/6bO1O66mb21o9fFr/I7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gnfiD5Qu1SeejU1792d+/yfzneVmYqI/7rnHumB2UjD1XZdC5f039+1DyCoZEblDiCeR0X/mwKOgHNchM4omcub2O5exGyOqMlroklA3w2HytBlSYgLXNPB7i+216nPkvFfR68bTy4YUK8IgRnq+f8aO7OEL+ffHp7y/YGXb7iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H2ut/tLH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H2ut/tLH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3860C4CEF0;
	Tue, 12 Aug 2025 19:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026892;
	bh=sZ1MvrfYTiXMWEk+jqegw5/6bO1O66mb21o9fFr/I7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H2ut/tLHcnGDxRXCMQr2rlzwv1bLr4t7zB+CD6+kKZwjEHOxJl+lY4tPMmT9Ymkla
	 Gh5hikM2s6VmKOPPAzLA2gV4NMh/XMKZa+rD3HyQnRELaNbAVbx7DRMfOmb0IYDRUR
	 RJWAgYjSnUc+m92eXSJaN76x7nQcyok6XB/vcU68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Baoquan He <bhe@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.15 470/480] mm: swap: move nr_swap_pages counter decrement from folio_alloc_swap() to swap_range_alloc()
Date: Tue, 12 Aug 2025 19:51:18 +0200
Message-ID: <20250812174416.767692496@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

commit 4f78252da887ee7e9d1875dd6e07d9baa936c04f upstream.

Patch series "Some randome fixes and cleanups to swapfile".

Patch 0-3 are some random fixes.  Patch 4 is a cleanup.  More details can
be found in respective patches.


This patch (of 4):

When folio_alloc_swap() encounters a failure in either
mem_cgroup_try_charge_swap() or add_to_swap_cache(), nr_swap_pages counter
is not decremented for allocated entry.  However, the following
put_swap_folio() will increase nr_swap_pages counter unpairly and lead to
an imbalance.

Move nr_swap_pages decrement from folio_alloc_swap() to swap_range_alloc()
to pair the nr_swap_pages counting.

Link: https://lkml.kernel.org/r/20250522122554.12209-1-shikemeng@huaweicloud.com
Link: https://lkml.kernel.org/r/20250522122554.12209-2-shikemeng@huaweicloud.com
Fixes: 0ff67f990bd4 ("mm, swap: remove swap slot cache")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1115,6 +1115,7 @@ static void swap_range_alloc(struct swap
 		if (vm_swap_full())
 			schedule_work(&si->reclaim_work);
 	}
+	atomic_long_sub(nr_entries, &nr_swap_pages);
 }
 
 static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
@@ -1313,7 +1314,6 @@ int folio_alloc_swap(struct folio *folio
 	if (add_to_swap_cache(folio, entry, gfp | __GFP_NOMEMALLOC, NULL))
 		goto out_free;
 
-	atomic_long_sub(size, &nr_swap_pages);
 	return 0;
 
 out_free:


