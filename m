Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D26BE5A;
	Tue,  2 Jul 2024 17:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940153; cv=none; b=H3DBeKem9s1fIlLo/oci3I0mlzzVfYBd7DRiaxlgSxm2TMc80VC/ChSlebr7kI7hJZFM7qB7O1lIcTMogJszlXgbjI/zAEtr810e7dYxnrkh26ou6UElJYhsPgKE/JkhYW1UGJRmkykwH4KhOoUXw40FNX8d/lG4Hc/5oF5CxIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940153; c=relaxed/simple;
	bh=BV7XAeBYHQ/vKzmO6GTW3rrUxs2gcHRF09aVTqina1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdF+8P/dlHGYighwWvJKw1d8O9CxLRxuw3Bo29BNnP4sktD/deJhw2R+QdA+b75XXnIwKZS2sGvh6jO0+jsebX0f1dG8JBmfGt2uTjyt0ZMmyaClMgwKCBvuYUbcxlealK2vqq5ys3UfS4fMI7hyVQQHcMGLxrQdxcYVW+tX1CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LvjTaWqa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LvjTaWqa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C200C116B1;
	Tue,  2 Jul 2024 17:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940153;
	bh=BV7XAeBYHQ/vKzmO6GTW3rrUxs2gcHRF09aVTqina1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LvjTaWqa3/DOiuauF+ea2h/v1MENs+KA4Vm8oURG1ZWX6aiUt38cwsb8+fi5Rneou
	 +SIu2ZQHqo0VVWRMbIMByK66wfTmh2HYlQvQlIH4s/3iJsy3rJ+tOI2/JZqK7FjWcB
	 GGj7QsbFRrCjhAfY/GNFVJHc237AtjvWApiAJ9Z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 068/222] drm/xe: Fix potential integer overflow in page size calculation
Date: Tue,  2 Jul 2024 19:01:46 +0200
Message-ID: <20240702170246.580647354@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nirmoy Das <nirmoy.das@intel.com>

[ Upstream commit 4f4fcafde343a54465f85a2909fc684918507a4b ]

Explicitly cast tbo->page_alignment to u64 before bit-shifting to
prevent overflow when assigning to min_page_size.

Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240318164342.3094-1-nirmoy.das@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_ttm_vram_mgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_ttm_vram_mgr.c b/drivers/gpu/drm/xe/xe_ttm_vram_mgr.c
index 115ec745e5029..0678faf832126 100644
--- a/drivers/gpu/drm/xe/xe_ttm_vram_mgr.c
+++ b/drivers/gpu/drm/xe/xe_ttm_vram_mgr.c
@@ -91,7 +91,7 @@ static int xe_ttm_vram_mgr_new(struct ttm_resource_manager *man,
 
 	min_page_size = mgr->default_page_size;
 	if (tbo->page_alignment)
-		min_page_size = tbo->page_alignment << PAGE_SHIFT;
+		min_page_size = (u64)tbo->page_alignment << PAGE_SHIFT;
 
 	if (WARN_ON(min_page_size < mm->chunk_size)) {
 		err = -EINVAL;
-- 
2.43.0



