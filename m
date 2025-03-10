Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF89234977;
	Mon, 10 Mar 2025 17:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627475; cv=none; b=n/PWnMDBhoxZ1FhOg0sxF/obL9PFbgu6DPyA71X9wwKhBFi2arBTGxvBUHLKtNde5yC2YCiwqWe0WtZcO2WnGsTdloUsZs5pnZh4nW+OR47jOccq6JXfr4gwXvPUIUqfqnqZvMbA6nK2Nl1rAmsyxwMm2SWhsZyOUjedaBR33y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627475; c=relaxed/simple;
	bh=P+Ojc9Nxub0WxyU3khEVmZMTx6hrvFT8AobOabCawag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SeHjmiTXVluofTfu/HsFthYAF4p42WI6UqMq/vaf/50eZ1Ei5FCvOR8W0yijVSgOVVynzAiGnRAi+K+Xq3sdstL/yBwoxHByGbWvKNzdvJtU7LAOoLJsdykzHGW9DjhEG/+Rh6XwZyEXjxK1/TdaDtOeJdE3kFNiHkYvh9EyQ5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dtnbmyfh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dtnbmyfh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A794EC4CEE5;
	Mon, 10 Mar 2025 17:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627475;
	bh=P+Ojc9Nxub0WxyU3khEVmZMTx6hrvFT8AobOabCawag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dtnbmyfhNVdTIei1xQMDiF+uEUoMdJFa3a8/B1cbSscyyUbBEi5ZNV4jqr1cZAHai
	 adv/bHCqooClvfJB5sAy3TZINDs669O6iD04Ab4izYh7qHfFBt4oUD4BBwuE4tuD+I
	 5xGiqfKfNaCZJ9Ry8WhuBnEuh+HCDhQSTLn1apFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Wupeng <mawupeng1@huawei.com>,
	David Hildenbrand <david@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Michal Hocko <mhocko@suse.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 140/269] mm: memory-hotplug: check folio ref count first in do_migrate_range
Date: Mon, 10 Mar 2025 18:04:53 +0100
Message-ID: <20250310170503.301111336@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

From: Ma Wupeng <mawupeng1@huawei.com>

commit 773b9a6aa6d38894b95088e3ed6f8a701d9f50fd upstream.

If a folio has an increased reference count, folio_try_get() will acquire
it, perform necessary operations, and then release it.  In the case of a
poisoned folio without an elevated reference count (which is unlikely for
memory-failure), folio_try_get() will simply bypass it.

Therefore, relocate the folio_try_get() function, responsible for checking
and acquiring this reference count at first.

Link: https://lkml.kernel.org/r/20250217014329.3610326-3-mawupeng1@huawei.com
Signed-off-by: Ma Wupeng <mawupeng1@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory_hotplug.c |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1795,12 +1795,12 @@ static void do_migrate_range(unsigned lo
 		if (folio_test_large(folio))
 			pfn = folio_pfn(folio) + folio_nr_pages(folio) - 1;
 
-		/*
-		 * HWPoison pages have elevated reference counts so the migration would
-		 * fail on them. It also doesn't make any sense to migrate them in the
-		 * first place. Still try to unmap such a page in case it is still mapped
-		 * (keep the unmap as the catch all safety net).
-		 */
+		if (!folio_try_get(folio))
+			continue;
+
+		if (unlikely(page_folio(page) != folio))
+			goto put_folio;
+
 		if (folio_test_hwpoison(folio) ||
 		    (folio_test_large(folio) && folio_test_has_hwpoisoned(folio))) {
 			if (WARN_ON(folio_test_lru(folio)))
@@ -1811,14 +1811,8 @@ static void do_migrate_range(unsigned lo
 				folio_unlock(folio);
 			}
 
-			continue;
-		}
-
-		if (!folio_try_get(folio))
-			continue;
-
-		if (unlikely(page_folio(page) != folio))
 			goto put_folio;
+		}
 
 		if (!isolate_folio_to_list(folio, &source)) {
 			if (__ratelimit(&migrate_rs)) {


