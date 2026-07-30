Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102F9430CDD;
	Thu, 30 Jul 2026 14:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421722; cv=none; b=PrSxtjyIv4IPUSxKhgfu2giZNBNNkFH3IMwMcYwMLuZw1SbPl6foHQgLNcAC0wxVUVea28+fsb2SXeKWlW8CjzMMP4XNMlJfwACxvv5IDUMvsuUN713yudapm68xEsFVOWamfNfozmBNtJNhdiRjLWBCtWPcgkFyOcloRocNQ4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421722; c=relaxed/simple;
	bh=+B6U9WmcDSZV4tztH8amfJUoy2+750K8xMF+YuepQH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=biC4t/BBoCEYci5mlX44aBsm1qwmw1gEEms93CLQfT2vOfiiycm7/oul+RZjiyUCuNNvPHBi+iOdBdKtiwMjgwH2Tk6Y4cECDq5VWtnqGkBUNvgqBSR9O9K957PH4DChJIlF2kvZMgAtIWSAbL5o53iQLcrINvEcT0p1CQIV7d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jMr8k7Qy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jMr8k7Qy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59DBB1F000E9;
	Thu, 30 Jul 2026 14:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421721;
	bh=WxpO5ZC7CPBl3LzeOvrKLwnWOmeeFZxowFJuRPOiKuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jMr8k7QynzKfWyldep+FKS6b+moA/g6jXlfFX++B3lkyt3JlFhnMaVGPdZa0dk5tz
	 1P6j0gZ7npRZO9nAcoO1R39NJ1X7w+wUFGs6rJpRKJEK4/Gytzzb65PmVJGdCBWSaz
	 vCrmNWc9udv2sIb8jxxDGA5CikMbTQ92mxzCab6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Ankit Soni <Ankit.Soni@amd.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 199/744] iommu/amd: Fix nested domain leak
Date: Thu, 30 Jul 2026 16:07:52 +0200
Message-ID: <20260730141448.509876325@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Tycho Andersen (AMD) <tycho@kernel.org>

[ Upstream commit 283c5c4c34b4c8d1ebd038d8f360c5ba7fcc767b ]

A couple of runs of different AI tools have generated something like the
following bug report:

    In nested_domain_free(), when refcount_dec_and_test() returns false
    (other nested domains still reference the same gdom_info), the function
    returns without calling kfree(ndom), leaking the nested_domain
    structure. This problem wasn't introduced by this patch, but exists in
    the code from commit 757d2b1fdf5b that the patch modifies. Each
    nested_domain (ndom) is allocated individually in
    amd_iommu_alloc_domain_nested() via kzalloc_obj(*ndom). The .free
    callback is the sole point responsible for freeing this domain. When
    the refcount is > 0, only the xa_unlock_irqrestore is performed and the
    function returns, leaving ndom permanently allocated. This leak occurs
    every time a nested domain sharing a gDomID is destroyed while other
    domains still use that gDomID.

There is a similar leak later in this function in the WARN_ON() test when
the mapping is already NULL. Switch to a RAII-based cleanup for ndom, since
it should always be freed in this function.

Fixes: 757d2b1fdf5b ("iommu/amd: Introduce gDomID-to-hDomID Mapping and handle parent domain invalidation")
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Reviewed-by: Ankit Soni <Ankit.Soni@amd.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/nested.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iommu/amd/nested.c b/drivers/iommu/amd/nested.c
index 5c9405223f9115..63b53b29e02989 100644
--- a/drivers/iommu/amd/nested.c
+++ b/drivers/iommu/amd/nested.c
@@ -263,7 +263,7 @@ static void nested_domain_free(struct iommu_domain *dom)
 {
 	unsigned long irqflags;
 	struct guest_domain_mapping_info *curr;
-	struct nested_domain *ndom = to_ndomain(dom);
+	struct nested_domain *ndom __free(kfree) = to_ndomain(dom);
 	struct amd_iommu_viommu *aviommu = ndom->viommu;
 
 	xa_lock_irqsave(&aviommu->gdomid_array, irqflags);
@@ -290,7 +290,6 @@ static void nested_domain_free(struct iommu_domain *dom)
 
 	amd_iommu_pdom_id_free(ndom->gdom_info->hdom_id);
 	kfree(curr);
-	kfree(ndom);
 }
 
 static const struct iommu_domain_ops nested_domain_ops = {
-- 
2.53.0



