Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A84D4EB85E;
	Thu, 17 Sep 2026 15:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659645; cv=none; b=O61SmyOlu+e6NnOLk1ArcoplogNt8ziZNcU4ZWlVknFZkVZNLxL2aa0ilBadKY7G9gNDnNs3c5wApR+PfP4SWKx0wT7M9a2NC9cTJBc3mp0MUV0KlCK0TPOZI6eMIaBHiCaFIFCVvmvv1EgFCsZWKUfpl5Xgj+5XOqGPQt72jMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659645; c=relaxed/simple;
	bh=tFP8linhE3aBmNkwGo0if/TqaCycd0iPlX/4L8IXIK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AOwt/CNYqJIyo87EHO+THaRqqURlZEljRQzz0FrsRaoOhTSQ1GkbeHv/mMowFktnu5O31DCTqf50Tg3d2LaqDPO+oS9+vozhf+pbDJ1KzjYJ4pJBrhFgF/Y1APx90/CS//JhulfYTTB3nW0pBMlGSFGPp87UkqUmSDeYSTFL+UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kP1WRaDS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kP1WRaDS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47561F00899;
	Thu, 17 Sep 2026 15:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659634;
	bh=LjBUDz7IC+c1Yb2C9gkK5/jQQGXGLfMWvSBamdmxrBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kP1WRaDSR7VIUb9ttdr5Ackse+K6c03a+BIkkcLNeJlTFwQK79LIpKJXNFA7ocs1Q
	 78qd/QETjUv7er8zV0YUp3a/iYyBOsKanvXo+8PNt2SFag+dIWD3sTsS+zXWFJP6sl
	 eINzZrmXVhC3ZAmGfz219ZJpP4h1j+WWIREphrXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hemanth Selam <hemanth.selam@gmail.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 321/733] iommu/amd: Fix ineffective error check in nested domain allocation
Date: Thu, 17 Sep 2026 16:10:29 +0100
Message-ID: <20260917151359.496058195@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Hemanth Selam <hemanth.selam@gmail.com>

[ Upstream commit fa5c0827f0b7bac6d0a188f10118151769ae68fd ]

amd_iommu_pdom_id_alloc() returns an int: a domain ID on success, or the
negative errno from ida_alloc_range() when the ID space is exhausted or
memory is short.  amd_iommu_alloc_domain_nested() stores that return value
in gdom_info->hdom_id, which is a u32, and only then tests it:

	gdom_info->hdom_id = amd_iommu_pdom_id_alloc();
	if (gdom_info->hdom_id <= 0) {

The assignment discards the sign, so -ENOSPC becomes 0xffffffe4 and the
test never fires.  The nested domain is then set up with a host domain ID
that was never allocated, instead of the allocation failing with -ENOSPC.

Keep the value in an int, test it there, and store it only once it is
known to be valid, which is what the other amd_iommu_pdom_id_alloc()
callers already do.

Fixes: 757d2b1fdf5b ("iommu/amd: Introduce gDomID-to-hDomID Mapping and handle parent domain invalidation")
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/nested.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd/nested.c b/drivers/iommu/amd/nested.c
index 63b53b29e0298..f1c7987fc5859 100644
--- a/drivers/iommu/amd/nested.c
+++ b/drivers/iommu/amd/nested.c
@@ -96,7 +96,7 @@ struct iommu_domain *
 amd_iommu_alloc_domain_nested(struct iommufd_viommu *viommu, u32 flags,
 			      const struct iommu_user_data *user_data)
 {
-	int ret;
+	int ret, hdom_id;
 	unsigned long irqflags;
 	struct nested_domain *ndom;
 	struct guest_domain_mapping_info *gdom_info;
@@ -161,8 +161,8 @@ amd_iommu_alloc_domain_nested(struct iommufd_viommu *viommu, u32 flags,
 	}
 
 	/* The gDomID does not exist. We allocate new hdom_id */
-	gdom_info->hdom_id = amd_iommu_pdom_id_alloc();
-	if (gdom_info->hdom_id <= 0) {
+	hdom_id = amd_iommu_pdom_id_alloc();
+	if (hdom_id <= 0) {
 		__xa_cmpxchg(&aviommu->gdomid_array,
 			     ndom->gdom_id, gdom_info, NULL, GFP_ATOMIC);
 		xa_unlock_irqrestore(&aviommu->gdomid_array, irqflags);
@@ -170,6 +170,7 @@ amd_iommu_alloc_domain_nested(struct iommufd_viommu *viommu, u32 flags,
 		goto out_err_gdom_info;
 	}
 
+	gdom_info->hdom_id = hdom_id;
 	ndom->gdom_info = gdom_info;
 	refcount_set(&gdom_info->users, 1);
 
-- 
2.53.0



