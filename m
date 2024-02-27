Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E289913B2B8;
	Tue, 27 Feb 2024 14:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043664; cv=none; b=eYo7Bsv2gLGWWTItsiuKA3PbhhCbHoSzqUPGX8qM2lBTuPn095pwi9h1znQo1XL2IZidUwiIjl6PXw0+lmjBRMjbXp+0XpK8u0Q4ZXCccJYT/zOu4sCOefEtExccFf8AXItu9hxqT8DpARiAMEzRoO7pXLB3eWPxfI8fzZVGHb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043664; c=relaxed/simple;
	bh=Rl8zk2vz8mMeKSZyBPK4W2tOjw9TzWaEGzZ2F05eHUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cr1t3TlKYSYpFN6KLCLMcj9EKOAB8vkylcqikspLczCgGqiuAhLRSj1o2o1tMKzLaoQ4H9ATSsoqBphsDuBTl2o5dSTBLs/AB/eE2u98KQjIB0FMe3tZGRa60OgVC/9gLydclCA7VeRtoSDV+ImjWB0cA3hjudf6+/F4UEKBDtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jlnvX6Bu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jlnvX6Bu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2879FC433C7;
	Tue, 27 Feb 2024 14:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043663;
	bh=Rl8zk2vz8mMeKSZyBPK4W2tOjw9TzWaEGzZ2F05eHUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jlnvX6Bu6A7L+lbH/UtbHDMBhQhPXjA9YkAmjHEhNa3qp3z56Rbvs4bsBMA9Q/Wlk
	 D1vG4j6rbv0OnGf27E6nQrTv00Bs+E9Xft49zkqrjeVUxSoxiHZnFtfZLoR/Gnha84
	 GmiuVXHv5uKjpptIPXTswC5QEpStqPzYSngBiad0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosryahmed@google.com>,
	Chengming Zhou <zhouchengming@bytedance.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Domenico Cerasuolo <cerasuolodomenico@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 189/195] mm: zswap: fix missing folio cleanup in writeback race path
Date: Tue, 27 Feb 2024 14:27:30 +0100
Message-ID: <20240227131616.645069638@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

From: Yosry Ahmed <yosryahmed@google.com>

commit e3b63e966cac0bf78aaa1efede1827a252815a1d upstream.

In zswap_writeback_entry(), after we get a folio from
__read_swap_cache_async(), we grab the tree lock again to check that the
swap entry was not invalidated and recycled.  If it was, we delete the
folio we just added to the swap cache and exit.

However, __read_swap_cache_async() returns the folio locked when it is
newly allocated, which is always true for this path, and the folio is
ref'd.  Make sure to unlock and put the folio before returning.

This was discovered by code inspection, probably because this path handles
a race condition that should not happen often, and the bug would not crash
the system, it will only strand the folio indefinitely.

Link: https://lkml.kernel.org/r/20240125085127.1327013-1-yosryahmed@google.com
Fixes: 04fc7816089c ("mm: fix zswap writeback race condition")
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/zswap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1013,6 +1013,8 @@ static int zswap_writeback_entry(struct
 		if (zswap_rb_search(&tree->rbroot, entry->offset) != entry) {
 			spin_unlock(&tree->lock);
 			delete_from_swap_cache(page_folio(page));
+			unlock_page(page);
+			put_page(page);
 			ret = -ENOMEM;
 			goto fail;
 		}


