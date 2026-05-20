Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957FD28DC4;
	Wed, 20 May 2026 17:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298358; cv=none; b=oyE/ikx0ak0GNLL2qvbrkyWgwdbWb0Vg1bjJBbVqsGxm0y57XjViaPYB2pZVNXKpIxaPR+OGgD9Pn0Cy+XYPmeo5hfsGWlzn7zECnQpvUwfjasjT6NASiHM5UhrvYWeRyalPgu7VBneTTXzIb++s4Dp/fNDfKsWZ9b3GBi7Q9xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298358; c=relaxed/simple;
	bh=TZRyAcKsa2UPecA3/5UF9yhddIi05dF9zVYf/lp9ir8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DYpqPaPASLhyjO742ghHL/VWQKScNuQZHRYqPT0Fm8QQncZgNmyIhMe+Pz2GIUay5vXT4DNkSS1ZtsVGAk5ivkgwlFPOB4AtR93JOfgGmKyX6IOv2Rmacw2bbh9Q3RIrLzJQ7Lxc+P9omDrFu8hYypHOyEBfA4ZmJ0EDdNR1khM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IRkbK47J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IRkbK47J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080691F000E9;
	Wed, 20 May 2026 17:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298357;
	bh=jlb8M8dfeVzM948NxSLXK4ddXDCgWmAeKSIYVIZnj98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IRkbK47JcydysHL4179um6GzXT7IuHS8F0acHBGSVLihsgVFQBZD/44KiqauiXu0O
	 xgmJ2vzgSAW2RBEj7V0T0K8PNubuu/AezjbTHnTYS9QDutp6VQyJNLR7eLVPdtl6nk
	 z90TMMWtJ5a34Y51UIFuT61toe74BNwxhsAy/2Ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 379/957] iommufd/selftest: Fix page leaks in mock_viommu_{init,destroy}
Date: Wed, 20 May 2026 18:14:22 +0200
Message-ID: <20260520162142.747121918@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index dc0947aaac625..8fd27f65d6237 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -699,7 +699,7 @@ static void mock_viommu_destroy(struct iommufd_viommu *viommu)
 	if (mock_viommu->mmap_offset)
 		iommufd_viommu_destroy_mmap(&mock_viommu->core,
 					    mock_viommu->mmap_offset);
-	free_page((unsigned long)mock_viommu->page);
+	free_pages((unsigned long)mock_viommu->page, 1);
 	mutex_destroy(&mock_viommu->queue_mutex);
 
 	/* iommufd core frees mock_viommu and viommu */
@@ -933,7 +933,7 @@ static int mock_viommu_init(struct iommufd_viommu *viommu,
 	iommufd_viommu_destroy_mmap(&mock_viommu->core,
 				    mock_viommu->mmap_offset);
 err_free_page:
-	free_page((unsigned long)mock_viommu->page);
+	free_pages((unsigned long)mock_viommu->page, 1);
 	return rc;
 }
 
-- 
2.53.0



