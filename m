Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0713446A2;
	Wed,  3 Dec 2025 16:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780892; cv=none; b=uR5ZHRm7+Wri66YzzvHvifhIjnrzEZJlvwKLukaQednMGbvHi3zEruhyNB5/2kkzKGCBj2YF589iSXaJllV6t1eqsmcwTbkJF0HPPqdJWxo9VddkIyZY6aRMaBylEc3uTmwkDHOY4AjKlYYacL3LfjIiRN/Nj3rvr/TXGPeNgeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780892; c=relaxed/simple;
	bh=zqCmK8HdnNshQA8R3eY5Ai680SFVO5m1DJDlhAVyuWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VImgtTSSPO0r+Uw2TlmKgYDv55n6SdMg534HadTH9H/YIyEgsBHvxEVrBvBbMWrey/K4pn6pr+YRfqRUwsUus65m/vhDJzxiYCEFqYTRN7iPXkOF0NOxADmDpsXiVYGXIiHIYAQ4pm9JYbv7ThpJhzJi7832YFk7+U//NOd02yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UIIxXob0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UIIxXob0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E7EC4CEF5;
	Wed,  3 Dec 2025 16:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780892;
	bh=zqCmK8HdnNshQA8R3eY5Ai680SFVO5m1DJDlhAVyuWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UIIxXob0cHkWDflC/7HJ8auvvhyCJnwc652cSVD/DCvVe+6kzwSiw3Wb/uHqlo9Ql
	 yTM4c/EqyuAltU2G/NIPTT4KOIPqAcKFwidF7H0RyNiPMRVQuCfk1t/9DUZv53hWZL
	 j6iYmNy4TMCRZvoSc24oR7PqZ1K/BdR1xXnTk+74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	Zi Yan <ziy@nvidia.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 120/132] mm/huge_memory: fix NULL pointer deference when splitting folio
Date: Wed,  3 Dec 2025 16:29:59 +0100
Message-ID: <20251203152347.757649744@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

From: Wei Yang <richard.weiyang@gmail.com>

[ Upstream commit cff47b9e39a6abf03dde5f4f156f841b0c54bba0 ]

Commit c010d47f107f ("mm: thp: split huge page to any lower order pages")
introduced an early check on the folio's order via mapping->flags before
proceeding with the split work.

This check introduced a bug: for shmem folios in the swap cache and
truncated folios, the mapping pointer can be NULL.  Accessing
mapping->flags in this state leads directly to a NULL pointer dereference.

This commit fixes the issue by moving the check for mapping != NULL before
any attempt to access mapping->flags.

Link: https://lkml.kernel.org/r/20251119235302.24773-1-richard.weiyang@gmail.com
Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ applied fix to split_huge_page_to_list_to_order() instead of __folio_split() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3404,6 +3404,16 @@ int split_huge_page_to_list_to_order(str
 	if (new_order >= folio_order(folio))
 		return -EINVAL;
 
+	/*
+	 * Folios that just got truncated cannot get split. Signal to the
+	 * caller that there was a race.
+	 *
+	 * TODO: this will also currently refuse shmem folios that are in the
+	 * swapcache.
+	 */
+	if (!is_anon && !folio->mapping)
+		return -EBUSY;
+
 	if (is_anon) {
 		/* order-1 is not supported for anonymous THP. */
 		if (new_order == 1) {
@@ -3466,13 +3476,6 @@ int split_huge_page_to_list_to_order(str
 		gfp_t gfp;
 
 		mapping = folio->mapping;
-
-		/* Truncated ? */
-		if (!mapping) {
-			ret = -EBUSY;
-			goto out;
-		}
-
 		min_order = mapping_min_folio_order(folio->mapping);
 		if (new_order < min_order) {
 			VM_WARN_ONCE(1, "Cannot split mapped folio below min-order: %u",


