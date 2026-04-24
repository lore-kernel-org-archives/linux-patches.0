Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A964F78F4A;
	Fri, 24 Apr 2026 13:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037603; cv=none; b=qv5zi/Pg4c3nlY+g4cPfwaq5PHTsonUw+fabr9GmqMCATnUVQ2K+YA7PAY6iFYK0sdfjoEgE1uQyL3HPNBaafPvapXomMYs32If0vbdJUBGbiHqUPfPhqjhxJ8MaIcVqr5O/MbEH8MYRnNFzfP4wRsEAMZRlT3W41mYbi4HS13A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037603; c=relaxed/simple;
	bh=87Ra6/+lT8PcCJeem1ZKrLHxst43dAsB4dLTgMKf1os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZFpYLEFXrRS/SaBB/eCnQQB/8GhBE/0JWb3CmITjsipcJToQTRtuqUbGSz+eRKqJ7UtIi5dAxBcQNMX5CaW+gWRxdx25ZI2QuaucdQQZYErwWPuCfjV1yHc7ZtglRvc0L3drN9ANDwd60QO4WpVoY96zRM8iNU3lA2a/xH1E8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KG4MPUB2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KG4MPUB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E1FC19425;
	Fri, 24 Apr 2026 13:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037603;
	bh=87Ra6/+lT8PcCJeem1ZKrLHxst43dAsB4dLTgMKf1os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KG4MPUB23RG9f+Zm806UMAaegE98WXGZGS5MpAJ8vpyLdwJzCc+HcdY/ZD7j4w9kt
	 WIs1A6CAZrtyKPcQstYEB7gfOvDl+KFcPhWA6KvLFqWAYS/+zohx1IZROUUvO9DEi9
	 i9lJFe+ypT0N6zCkVH8WT/FuV2hz3EJqsPcHvCHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naman Jain <namjain@linux.microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 7.0 42/42] mshv_vtl: Fix vmemmap_shift exceeding MAX_FOLIO_ORDER
Date: Fri, 24 Apr 2026 15:31:07 +0200
Message-ID: <20260424132429.327746311@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132420.410310336@linuxfoundation.org>
References: <20260424132420.410310336@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naman Jain <namjain@linux.microsoft.com>

commit 404cd6bffe17e25e0f94ed2775ffdd6cd10ac3fd upstream.

When registering VTL0 memory via MSHV_ADD_VTL0_MEMORY, the kernel
computes pgmap->vmemmap_shift as the number of trailing zeros in the
OR of start_pfn and last_pfn, intending to use the largest compound
page order both endpoints are aligned to.

However, this value is not clamped to MAX_FOLIO_ORDER, so a
sufficiently aligned range (e.g. physical range
[0x800000000000, 0x800080000000), corresponding to start_pfn=0x800000000
with 35 trailing zeros) can produce a shift larger than what
memremap_pages() accepts, triggering a WARN and returning -EINVAL:

  WARNING: ... memremap_pages+0x512/0x650
  requested folio size unsupported

The MAX_FOLIO_ORDER check was added by
commit 646b67d57589 ("mm/memremap: reject unreasonable folio/compound
page sizes in memremap_pages()").

Fix this by clamping vmemmap_shift to MAX_FOLIO_ORDER so we always
request the largest order the kernel supports, in those cases, rather
than an out-of-range value.

Also fix the error path to propagate the actual error code from
devm_memremap_pages() instead of hard-coding -EFAULT, which was
masking the real -EINVAL return.

Fixes: 7bfe3b8ea6e3 ("Drivers: hv: Introduce mshv_vtl driver")
Cc: stable@vger.kernel.org
Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hv/mshv_vtl_main.c |   12 +++++++++---
 include/uapi/linux/mshv.h  |    2 +-
 2 files changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/hv/mshv_vtl_main.c
+++ b/drivers/hv/mshv_vtl_main.c
@@ -386,7 +386,6 @@ static int mshv_vtl_ioctl_add_vtl0_mem(s
 
 	if (copy_from_user(&vtl0_mem, arg, sizeof(vtl0_mem)))
 		return -EFAULT;
-	/* vtl0_mem.last_pfn is excluded in the pagemap range for VTL0 as per design */
 	if (vtl0_mem.last_pfn <= vtl0_mem.start_pfn) {
 		dev_err(vtl->module_dev, "range start pfn (%llx) > end pfn (%llx)\n",
 			vtl0_mem.start_pfn, vtl0_mem.last_pfn);
@@ -397,6 +396,10 @@ static int mshv_vtl_ioctl_add_vtl0_mem(s
 	if (!pgmap)
 		return -ENOMEM;
 
+	/*
+	 * vtl0_mem.last_pfn is excluded in the pagemap range for VTL0 as per design.
+	 * last_pfn is not reserved or wasted, and reflects 'start_pfn + size' of pagemap range.
+	 */
 	pgmap->ranges[0].start = PFN_PHYS(vtl0_mem.start_pfn);
 	pgmap->ranges[0].end = PFN_PHYS(vtl0_mem.last_pfn) - 1;
 	pgmap->nr_range = 1;
@@ -405,8 +408,11 @@ static int mshv_vtl_ioctl_add_vtl0_mem(s
 	/*
 	 * Determine the highest page order that can be used for the given memory range.
 	 * This works best when the range is aligned; i.e. both the start and the length.
+	 * Clamp to MAX_FOLIO_ORDER to avoid a WARN in memremap_pages() when the range
+	 * alignment exceeds the maximum supported folio order for this kernel config.
 	 */
-	pgmap->vmemmap_shift = count_trailing_zeros(vtl0_mem.start_pfn | vtl0_mem.last_pfn);
+	pgmap->vmemmap_shift = min(count_trailing_zeros(vtl0_mem.start_pfn | vtl0_mem.last_pfn),
+				   MAX_FOLIO_ORDER);
 	dev_dbg(vtl->module_dev,
 		"Add VTL0 memory: start: 0x%llx, end_pfn: 0x%llx, page order: %lu\n",
 		vtl0_mem.start_pfn, vtl0_mem.last_pfn, pgmap->vmemmap_shift);
@@ -415,7 +421,7 @@ static int mshv_vtl_ioctl_add_vtl0_mem(s
 	if (IS_ERR(addr)) {
 		dev_err(vtl->module_dev, "devm_memremap_pages error: %ld\n", PTR_ERR(addr));
 		kfree(pgmap);
-		return -EFAULT;
+		return PTR_ERR(addr);
 	}
 
 	/* Don't free pgmap, since it has to stick around until the memory
--- a/include/uapi/linux/mshv.h
+++ b/include/uapi/linux/mshv.h
@@ -357,7 +357,7 @@ struct mshv_vtl_sint_post_msg {
 
 struct mshv_vtl_ram_disposition {
 	__u64 start_pfn;
-	__u64 last_pfn;
+	__u64 last_pfn; /* last_pfn is excluded from the range [start_pfn, last_pfn) */
 };
 
 struct mshv_vtl_set_poll_file {


