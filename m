Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BEF423782;
	Thu, 30 Jul 2026 15:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426645; cv=none; b=LRQ2ZInYLnW+zw2fYRT1rtO1GzKVq3nJH9jqgjb4gIsSWxFhEzlZTPEdV319tJuhKig6yI9E5SkYhW0WZlzeVqh8AmUusz0bK7Kd4XZ4PZh1PT7QPvOimFs3/iYvGPEt9/MyhSwPxCtYgDKDxbZiLZa7trfXJnkfbDrPZHjQxHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426645; c=relaxed/simple;
	bh=El9HM+HUzwqpB9zsAhuo9PVseNNfhP7mIdAQpr4yAXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cVVDLhMz2Cwo7LT2EwmXCeSTwpvnHTsLdgRnTJMxnh1bqkirvHj32ttzR116uhhWoszBheuQunP/LYExYFKzs5qA4BarS/XCnWdCMAGk/FxEqC64dWOLnX8kcS8fpd9J0ksQMfuCE1QYZqFkVJjIqoLh5hhoM7NaTwcrsVNZFGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iEKACTMb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iEKACTMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43731F000E9;
	Thu, 30 Jul 2026 15:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426644;
	bh=m9rKGVGhYL7ZlRGyAsvxsiT81TijucDkCN2HrPSK/js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iEKACTMbJtZVYBF/0EsNuUihqQeKQDby+xEJmVZvcVLUMcF6+NwokHRktG6IxQLdq
	 vONCRmGq6v7pVREdC7ksLezWAe5MYWETZeMYk+rGoqJQP7Mc7GbFDtoBKZU9ewV+S+
	 9uZa31y5eR5PRNb8suExYM5J2eBRujksfTknQO+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	Xie Yongji <xieyongji@bytedance.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 492/602] VDUSE: avoid leaking information to userspace
Date: Thu, 30 Jul 2026 16:14:44 +0200
Message-ID: <20260730141446.307665115@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 9c1523803445ee0348f62b77793266dd981596e0 ]

The bounceing is not necessarily page aligned, so current VDUSE can
leak kernel information through mapping bounce pages to
userspace. Allocate bounce pages with __GFP_ZERO to avoid leaking
information to userspace.

Fixes: 8c773d53fb7b ("vduse: Implement an MMU-based software IOTLB")
Cc: stable@vger.kernel.org
Signed-off-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Xie Yongji <xieyongji@bytedance.com>
Reviewed-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260130050750.4050-1-jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/vdpa_user/iova_domain.c |    2 +-
 drivers/vdpa/vdpa_user/vduse_dev.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/vdpa/vdpa_user/iova_domain.c
+++ b/drivers/vdpa/vdpa_user/iova_domain.c
@@ -124,7 +124,7 @@ static int vduse_domain_map_bounce_page(
 		if (!map->bounce_page) {
 			head_map = &domain->bounce_maps[(iova & PAGE_MASK) >> BOUNCE_MAP_SHIFT];
 			if (!head_map->bounce_page) {
-				tmp_page = alloc_page(GFP_ATOMIC);
+				tmp_page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
 				if (!tmp_page)
 					return -ENOMEM;
 				if (cmpxchg(&head_map->bounce_page, NULL, tmp_page))
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -887,7 +887,7 @@ static void *vduse_dev_alloc_coherent(st
 
 	*dma_addr = DMA_MAPPING_ERROR;
 
-	addr = alloc_pages_exact(size, flag);
+	addr = alloc_pages_exact(size, flag | __GFP_ZERO);
 	if (!addr)
 		return NULL;
 


