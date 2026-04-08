Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D627C25A321;
	Wed,  8 Apr 2026 18:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674311; cv=none; b=vBgxFskuHRDTPn6UoFnl6kPsUuDZQtu7FFDccTAHcmu8LjdH7Fe7VqmnbsDo0pVbd3TRrnpCVVGyXRIrd6rY1k8Oio81V+j96iv1BKVtKchh1WUKr8FdxtiFKWyrZDr8tWtUoZu6XWniscI+jyjpk+Sh11eMa9HFMXk/XEr6QGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674311; c=relaxed/simple;
	bh=u3uz7r1du6oPXjhQ1EbLJllLbxHhw7aATIitmC60MBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fmvCIUVhEh2njaV9nTcbv8a22UzKeXgRTR+NSEb61bIilOBAg67n/CPtvm7WGd/J2K/j964z4bV48+GDf5a9DX3shDbU2KBfvyBPIZrnEEVbKAqtIjqKOvWbgQKwswU0+pF3AVNelpYhHtdctwdFX/59z47CC87hoq/x+EFzpwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OSZYFCDd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OSZYFCDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE2AC19421;
	Wed,  8 Apr 2026 18:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674311;
	bh=u3uz7r1du6oPXjhQ1EbLJllLbxHhw7aATIitmC60MBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OSZYFCDd+ryC9L2VvA2+r67pHJUmlQXYg4Oqd5pbXzK4bpatJL+poZxIeXKF+JZP5
	 CxMWjKjJqwoMK3cEO9exU4oD2TEL6iOeSIPorRtKvxdi9D0Q6oR0LQ6hQDRFfn/dRs
	 dy315Q3WtBsxb6vThYSxWP+kjM1PCgRkefeuDAAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sherry Yang <sherry.yang@oracle.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 049/311] iommupt/amdv1: mark amdv1pt_install_leaf_entry as __always_inline
Date: Wed,  8 Apr 2026 20:00:49 +0200
Message-ID: <20260408175941.246671349@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sherry Yang <sherry.yang@oracle.com>

[ Upstream commit 8b72aa5704c77380742346d4ac755b074b7f9eaa ]

After enabling CONFIG_GCOV_KERNEL and CONFIG_GCOV_PROFILE_ALL, following
build failure is observed under GCC 14.2.1:

In function 'amdv1pt_install_leaf_entry',
    inlined from '__do_map_single_page' at drivers/iommu/generic_pt/fmt/../iommu_pt.h:650:3,
    inlined from '__map_single_page0' at drivers/iommu/generic_pt/fmt/../iommu_pt.h:661:1,
    inlined from 'pt_descend' at drivers/iommu/generic_pt/fmt/../pt_iter.h:391:9,
    inlined from '__do_map_single_page' at drivers/iommu/generic_pt/fmt/../iommu_pt.h:657:10,
    inlined from '__map_single_page1.constprop' at drivers/iommu/generic_pt/fmt/../iommu_pt.h:661:1:
././include/linux/compiler_types.h:706:45: error: call to '__compiletime_assert_71' declared with attribute error: FIELD_PREP: value too large for the field
  706 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
      |

......

drivers/iommu/generic_pt/fmt/amdv1.h:220:26: note: in expansion of macro 'FIELD_PREP'
  220 |                          FIELD_PREP(AMDV1PT_FMT_OA,
      |                          ^~~~~~~~~~

In the path '__do_map_single_page()', level 0 always invokes
'pt_install_leaf_entry(&pts, map->oa, PAGE_SHIFT, …)'. At runtime that
lands in the 'if (oasz_lg2 == isz_lg2)' arm of 'amdv1pt_install_leaf_entry()';
the contiguous-only 'else' block is unreachable for 4 KiB pages.

With CONFIG_GCOV_KERNEL + CONFIG_GCOV_PROFILE_ALL, the extra
instrumentation changes GCC's inlining so that the "dead" 'else' branch
still gets instantiated. The compiler constant-folds the contiguous OA
expression, runs the 'FIELD_PREP()' compile-time check, and produces:

    FIELD_PREP: value too large for the field

gcov-enabled builds therefore fail even though the code path never executes.

Fix this by marking amdv1pt_install_leaf_entry as __always_inline.

Fixes: dcd6a011a8d5 ("iommupt: Add map_pages op")
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sherry Yang <sherry.yang@oracle.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/generic_pt/fmt/amdv1.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/generic_pt/fmt/amdv1.h b/drivers/iommu/generic_pt/fmt/amdv1.h
index 3b2c41d9654d7..8d11b08291d73 100644
--- a/drivers/iommu/generic_pt/fmt/amdv1.h
+++ b/drivers/iommu/generic_pt/fmt/amdv1.h
@@ -191,7 +191,7 @@ static inline enum pt_entry_type amdv1pt_load_entry_raw(struct pt_state *pts)
 }
 #define pt_load_entry_raw amdv1pt_load_entry_raw
 
-static inline void
+static __always_inline void
 amdv1pt_install_leaf_entry(struct pt_state *pts, pt_oaddr_t oa,
 			   unsigned int oasz_lg2,
 			   const struct pt_write_attrs *attrs)
-- 
2.53.0



