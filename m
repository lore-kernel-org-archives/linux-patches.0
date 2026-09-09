Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A23423A85;
	Wed,  9 Sep 2026 13:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962194; cv=none; b=LcusF7AQINmYyy2P0AgVNzNIrTo8JKWyGmTgkPFJVAYE2Q2Xi+taRmjrm81fvQc/LpL0OSqZtNs/9tbDREZTecEa2wyGPzhFbWvk8vy79FRd0UWctsWXYWKJFMDyQnvuGbzu6pfhC2//K9SJPnDjrcniz7LHd+Ag+MSsF2lfUF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962194; c=relaxed/simple;
	bh=40OcSlearyg1QnGyy2DRQ4++Irw3esH66IfLjP//8G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0Bk3WyhHxuDKXGWStG/lZF35UwNqzj8eW7VB+NVX4/Z+FMQw31IZvdBzVWtRAHjf7LGcZ/hAsVmugbPVVxe8FxjE9mrzeR3GX4UcVvt4mHo+VW1K3M0VC5juU1/j8lt3EKLHAQo9TJRywsBPodtX2F2bBN03Vz9NvFdxejc2Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=obBUxcHC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="obBUxcHC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 254B11F00A3A;
	Wed,  9 Sep 2026 13:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962192;
	bh=slJgZeAajCAayeXOkozSU0evczyMo0yiChq0XM9r2/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=obBUxcHCAYfMNvlMTRIfK0BJLWW9DLB2ON9w3CDsGh8DsIL6UN9MU5IogNheS99yU
	 I5DcQrdl3FD+Hna/xPspV2uxraEU3pU3AX1nx9O9Ee2Z7t7/7lYRonj2LkSGVjaFjA
	 sJRAODbX910FYRBGQD9peRmAamJDNbV4wtZHWFyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 169/556] mm/migrate_device: avoid out-of-bounds writes for compound folios
Date: Wed,  9 Sep 2026 15:37:29 +0200
Message-ID: <20260909134236.366567264@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Su <sh_def@163.com>

commit dc41e961a269f2ca4196e669d6d8e05480899cd4 upstream.

migrate_device_range() and migrate_device_pfns() clear the entries
following a compound folio so that the PFN arrays retain their
page-granular representation.

If a compound folio extends beyond the end of the caller-provided range,
the loops clear all following folio entries without limiting them to the
number of slots remaining in the npages-sized array, causing an
out-of-bounds write.

Do not proceed with a compound folio if its page-granular representation
does not fit entirely in the remaining PFN array.  If this happens, drop
any reference and lock acquired for the folio, clear the remaining
entries, and stop collecting.

Observed with a KASAN x86 QEMU kernel using the HMM migrate_anon_huge_zero
selftest.  Closing /dev/hmm_dmirror0 after migrating an anonymous huge
page to device memory exercises:

  dmirror_fops_release()
    -> dmirror_device_evict_chunk()
      -> migrate_device_range()

Link: https://lore.kernel.org/20260817120758.669807-3-sh_def@163.com
Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Signed-off-by: Hui Su <sh_def@163.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/migrate_device.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -1413,6 +1413,15 @@ int migrate_device_range(unsigned long *
 
 		src_pfns[i] = migrate_device_pfn_lock(pfn);
 		nr = folio_nr_pages(folio);
+		if (nr > npages - i) {
+			if (src_pfns[i] & MIGRATE_PFN_MIGRATE) {
+				folio_unlock(folio);
+				folio_put(folio);
+			}
+			memset(&src_pfns[i], 0,
+			       (npages - i) * sizeof(*src_pfns));
+			break;
+		}
 		if (nr > 1) {
 			src_pfns[i] |= MIGRATE_PFN_COMPOUND;
 			for (j = 1; j < nr; j++)
@@ -1447,6 +1456,15 @@ int migrate_device_pfns(unsigned long *s
 
 		src_pfns[i] = migrate_device_pfn_lock(src_pfns[i]);
 		nr = folio_nr_pages(folio);
+		if (nr > npages - i) {
+			if (src_pfns[i] & MIGRATE_PFN_MIGRATE) {
+				folio_unlock(folio);
+				folio_put(folio);
+			}
+			memset(&src_pfns[i], 0,
+			       (npages - i) * sizeof(*src_pfns));
+			break;
+		}
 		if (nr > 1) {
 			src_pfns[i] |= MIGRATE_PFN_COMPOUND;
 			for (j = 1; j < nr; j++)


