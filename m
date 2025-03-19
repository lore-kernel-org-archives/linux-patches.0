Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5096B1DE2B2;
	Wed, 19 Mar 2025 14:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395139; cv=none; b=T4Ww/8KzMLEHXuU/90OUhDUU3hf/MshjE2dALJkzvZP74T7bYUiNTFdtL4bcOSDwqqEheorKHhtLL8DcLZ+73SHCy7a+EvX0ks3o8Dn+FPHV+4lgq+mt2LWW+6YqExim6HTRZ0tjhUGWbPP6YxoLzLjwPzM2Hz1yIMms/6CoLkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395139; c=relaxed/simple;
	bh=GRgBoOtdnz0RGhoBld7ku4LGtGC+RJ/2yThL+OQgqxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qoHrUeGg9O64hshjwAGiEanr3fb4CqM7zmE8sNXE58vpY8YKhtvJBPF6uNezACZNm7MH5eWjIYFLitcuLhmSkhugnA4bVCWdIVlgXg5P/S5JMiplKlMqbE3FNQcRldlBgn2C9S+NPqvOsmVqcO0JgLr+yOcRCLqSvowKg2zkKsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2j3sN0St; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2j3sN0St"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25452C4CEE4;
	Wed, 19 Mar 2025 14:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395139;
	bh=GRgBoOtdnz0RGhoBld7ku4LGtGC+RJ/2yThL+OQgqxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2j3sN0St06N/IhHTD9UCyLyHAIxCdDRhxof+9mhC9rHrFjwSFWG5N07Aas45DfC0N
	 J4lQy3z3IWwq84WLD+CoZ2ZqxWq/QjRt+s5jbwMK1XHihw5HmL1H5TYcIq+pdCoM1V
	 S2tNS02/cuqtEI2zgJQHghZUiqCTsWHO9xJcsTok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 206/231] drm/xe/userptr: Fix an incorrect assert
Date: Wed, 19 Mar 2025 07:31:39 -0700
Message-ID: <20250319143031.934576949@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellström <thomas.hellstrom@linux.intel.com>

[ Upstream commit 9106713bd2ab0cacd380cda0d3f0219f2e488086 ]

The assert incorrectly checks the total length processed which
can in fact be greater than the number of pages. Fix.

Fixes: 0a98219bcc96 ("drm/xe/hmm: Don't dereference struct page pointers without notifier lock")
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250307100109.21397-1-thomas.hellstrom@linux.intel.com
(cherry picked from commit 70e5043ba85eae199b232e39921abd706b5c1fa4)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_hmm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_hmm.c b/drivers/gpu/drm/xe/xe_hmm.c
index d7a9408b3a97c..f6bc4f29d7538 100644
--- a/drivers/gpu/drm/xe/xe_hmm.c
+++ b/drivers/gpu/drm/xe/xe_hmm.c
@@ -138,13 +138,17 @@ static int xe_build_sg(struct xe_device *xe, struct hmm_range *range,
 		i += size;
 
 		if (unlikely(j == st->nents - 1)) {
+			xe_assert(xe, i >= npages);
 			if (i > npages)
 				size -= (i - npages);
+
 			sg_mark_end(sgl);
+		} else {
+			xe_assert(xe, i < npages);
 		}
+
 		sg_set_page(sgl, page, size << PAGE_SHIFT, 0);
 	}
-	xe_assert(xe, i == npages);
 
 	return dma_map_sgtable(dev, st, write ? DMA_BIDIRECTIONAL : DMA_TO_DEVICE,
 			       DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_NO_KERNEL_MAPPING);
-- 
2.39.5



