Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA62A1DFE10;
	Wed,  6 Nov 2024 12:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897274; cv=none; b=fIIWoGlQD9IyljU9L8pPBtPkDdU5NQhO/VX2Me931RNyQt36nmtMrlrgEDkYXinOX1xcq9r5fJ1pPY/hTu2wmsUv7sT+yxPMLaOVtg9+uIcp+jHPYT1LoGBJF1g43IQcd8jIy1F4snfwRsnKnAi1UVn3oTYJHtnbXGRdqtM6exM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897274; c=relaxed/simple;
	bh=U8NymE6IUkCQbiQnuUWQHf8RpopgEwbjKDLCSHcUVgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L0tnyM/6YTlLADTxNRzTWHrTeF14IlnD2msvWbd4vxpJXMkriZ+yAOPgM/0VSfAc/s9RPJdpy9dn4PxZdtJo/TUQylxvO5HPla8jgeL/DxuwlH0kQTqGRmKL12N2DS82M4LveUuu9Q2mN4D7ZsX1kNb/kNGgXEeSSFBinieYc0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ICF5mkSf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ICF5mkSf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9181C4CECD;
	Wed,  6 Nov 2024 12:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897274;
	bh=U8NymE6IUkCQbiQnuUWQHf8RpopgEwbjKDLCSHcUVgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ICF5mkSfy1ATt0tQLV4dKXllIR/Gf7IA+BTXI0Vdv4XEsQU6NItL0E8Wqimgile09
	 UckcoSyW8fhi0+gJ9KovktuQVzewrvEA+e5K/QxiBivdouvUjC6Hh6obtE9oOh24kS
	 4vpaMuL8sWWjiY4Z6FbeWNzPkNijnN3ZgBbCUb4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Huang, Ying" <ying.huang@intel.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	David Hildenbrand <david@redhat.com>,
	Yang Shi <shy828301@gmail.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 126/126] migrate_pages_batch: fix statistics for longterm pin retry
Date: Wed,  6 Nov 2024 13:05:27 +0100
Message-ID: <20241106120309.460117907@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

From: Huang Ying <ying.huang@intel.com>

commit 851ae6424697d1c4f085cb878c88168923ebcad1 upstream.

In commit fd4a7ac32918 ("mm: migrate: try again if THP split is failed due
to page refcnt"), if the THP splitting fails due to page reference count,
we will retry to improve migration successful rate.  But the failed
splitting is counted as migration failure and migration retry, which will
cause duplicated failure counting.  So, in this patch, this is fixed via
undoing the failure counting if we decide to retry.  The patch is tested
via failure injection.

Link: https://lkml.kernel.org/r/20230416235929.1040194-1-ying.huang@intel.com
Fixes: fd4a7ac32918 ("mm: migrate: try again if THP split is failed due to page refcnt")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/migrate.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1700,6 +1700,9 @@ split_folio_migration:
 							large_retry++;
 							thp_retry += is_thp;
 							nr_retry_pages += nr_pages;
+							/* Undo duplicated failure counting. */
+							nr_large_failed--;
+							stats->nr_thp_failed -= is_thp;
 							break;
 						}
 					}


