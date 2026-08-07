Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595273806B0;
	Fri,  7 Aug 2026 15:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117101; cv=none; b=GCeBkJ+vhh6lm9OC7lzVI8LW61bGHDfx6XnnztEAbnzfbv7pWOCCUspx05iaSNvYs0/Z2VHXsDY0CUSknsYeUO716EZ6Q5rpiqlS3UjdBC4TsZj7uxJtxS0J7KYieEH+BTpyR4Lob5nHgxRBBfWjQIhNKBZwTogTqpch4lmtL/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117101; c=relaxed/simple;
	bh=Q05TKpqbWOd/g3KzG9ITA9JEBYc/VEp8i7USZvC4ei8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YsLMup8nM2GZ0KShSfuSZ5yMlxKoqYtvSRTXu05sPZNqtrU4JhmEb3zNSUDMoYHwaJHMYFfvAHmaqi9mv/W9ACvmaQiTGhvNHyZTZPeFL1aliH//jMRdiHdMWkUs5jS3Gxvbh5IqwBzxkaZcFoeEQs4gGVn+FairrSu0WCL1+n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sBHBrsjE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sBHBrsjE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55D91F000E9;
	Fri,  7 Aug 2026 15:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117100;
	bh=1TQv6eNKTS6Rzjq/Qst1PE3oFgM/3OBunIvz67lSMF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sBHBrsjEyAo/iaJkz5h8hSfUD3uenV3xSYIn1UBJO56ni7Y58PfEu71DnVS4mj7z7
	 yROdo8XlvqxbIjfNACPq8lSxdIivdyX9ugHTYrbIiQUVQDfiW3L1GKPoQF0/Xvt6Vm
	 nHxO+KLXltU8f+YdcZQ90qdiYRf+FtN6198/2QrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peiyang He <peiyang_he@smail.nju.edu.cn>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.1 199/438] iommufd: Reject DMABUF pages from the access pin path
Date: Fri,  7 Aug 2026 16:36:35 +0200
Message-ID: <20260807143432.265252162@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peiyang He <peiyang_he@smail.nju.edu.cn>

commit 5f3fc0ad9a41883a62098359b9fdbe4257f20e53 upstream.

DMABUF pages are not supported for iommufd access pinning.
iommufd_access_pin_pages() returns struct page pointers for
in-kernel CPU access, but DMABUF-backed iopt_pages do not carry
a userspace address that can be passed to the GUP path.

iopt_pages_rw_access() already rejects IOPT_ADDRESS_DMABUF before doing
CPU access. Apply the same rejection to iopt_area_add_access() before it
takes pages->mutex and calls iopt_pages_fill_xarray().
Otherwise a DMABUF-backed iopt_pages can reach the hole-fill path, where
pfn_reader_user_pin() interprets the union as uptr and
calls pin_user_pages_fast()/pin_user_pages_remote().

This fix also avoids the lockdep warning reported from that path, where
pages_dmabuf_mutex_key is held while gup_fast_fallback() may acquire
mmap_lock.

Link: https://patch.msgid.link/r/CD68F549BF3761B7+20260709050800.520607-1-peiyang_he@smail.nju.edu.cn
Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
Closes: https://lore.kernel.org/all/E8540D7D05768C91+8b2ef227-3368-494e-909d-7b28e1489dfb@smail.nju.edu.cn/
Fixes: 71db84a092c3 ("iommufd: Add DMABUF to iopt_pages")
Cc: stable@vger.kernel.org
Tested-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
Signed-off-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/pages.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -2451,6 +2451,9 @@ int iopt_area_add_access(struct iopt_are
 	if ((flags & IOMMUFD_ACCESS_RW_WRITE) && !pages->writable)
 		return -EPERM;
 
+	if (iopt_is_dmabuf(pages))
+		return -EINVAL;
+
 	mutex_lock(&pages->mutex);
 	access = iopt_pages_get_exact_access(pages, start_index, last_index);
 	if (access) {


