Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C2136605E;
	Wed, 20 May 2026 16:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295615; cv=none; b=gONrY8YBUobjGjVA4I0MpjPtbFm8dVZWraOG9p8dwenFSkp3z53/eL9jd9Mc67KqgH+XcFDv0kcVqNivPElg9N5Ud+jeZirEWNuqG9ceZDAG8wL/6FvjLGxL2lfXrDUv0hHOen9U3xPC/bFyO4TWXtNhJ0egx8LVKIJdR2bLbEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295615; c=relaxed/simple;
	bh=H0hXx9eyyr4Hp73Aqh//r404FXGam56opQruvIWSbLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=InpGedrbBbkLHC5mfZjK6EFQwcydtDC0rSdSzmUobdXIgJHKHh+OiXFAGyKSQmfpAuTsioKHnaE5ushrsKLJ1z7ak5RtnIK9+olRiOuCHGTfNkFMtnGpu/EubQ2zkmvqXFhz35I4J67K7M+1Q3caGiU+xdGM14taBluhGxef54g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P+v+RhNT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P+v+RhNT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E581F00893;
	Wed, 20 May 2026 16:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295613;
	bh=vmcNVuFdyFS9sCaetS0baRZ+ms5d/UtnooohlYBUXQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P+v+RhNTsLFVve3ByA66h9hTN/RPtoAKkBvt+6sSr5geElw8TnBFvT+krDsFwg2sl
	 YYBYWPSPMQ/igsc5G5JP06o5V33+x1qQ9/mnVwwtIrGt695fYSCc1aVIcgaCitdwuN
	 NXWLgitO+j70hsUgFbqwpnSakG/yMETh5BOOfeys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0487/1146] iommufd/selftest: Fix page leaks in mock_viommu_{init,destroy}
Date: Wed, 20 May 2026 18:12:17 +0200
Message-ID: <20260520162159.214203995@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 09c091fddb0b93297ea659ab48ee64f54ebeeaa2 ]

mock_viommu_init() allocates two pages using __get_free_pages(..., 1),
but its error path and mock_viommu_destroy() only release the first page
using free_page(), leaking the second page. Use free_pages() with the
matching order instead to avoid any page leaks.

Fixes: 80478a2b450e ("iommufd/selftest: Add coverage for the new mmap interface")
Link: https://patch.msgid.link/r/20260312164040.457293-3-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/selftest.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index 7823142097d47..83e2215e7800d 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -636,7 +636,7 @@ static void mock_viommu_destroy(struct iommufd_viommu *viommu)
 	if (mock_viommu->mmap_offset)
 		iommufd_viommu_destroy_mmap(&mock_viommu->core,
 					    mock_viommu->mmap_offset);
-	free_page((unsigned long)mock_viommu->page);
+	free_pages((unsigned long)mock_viommu->page, 1);
 	mutex_destroy(&mock_viommu->queue_mutex);
 
 	/* iommufd core frees mock_viommu and viommu */
@@ -870,7 +870,7 @@ static int mock_viommu_init(struct iommufd_viommu *viommu,
 	iommufd_viommu_destroy_mmap(&mock_viommu->core,
 				    mock_viommu->mmap_offset);
 err_free_page:
-	free_page((unsigned long)mock_viommu->page);
+	free_pages((unsigned long)mock_viommu->page, 1);
 	return rc;
 }
 
-- 
2.53.0



