Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D9F411689;
	Thu, 30 Jul 2026 15:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426578; cv=none; b=GTDjA7YEJ3dSsmMerlW3QdK99KYrH8uSqlLzhRM+OIky5b6melb9omMXSt/rVwFoX1Ux2OAGonmcpLF+wG63BWliwqZmuG+gaf6oSgdAJM5xGdP0F2oy2+nyyOzzV/2Rk10gOo1YSOoxUDEjj8OAZgc5s9kQQrCZJFU0/Pgyvmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426578; c=relaxed/simple;
	bh=aXgKo4YJJ9XFm7AWWr8H3WmdepSNgoDqPDtIdMATxYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PtWnr+eu27/7d5JArugU7rmwx3LTTaaSzR8Uce1Iy0V44ssjOw2mhbwIZa0Id3HcL3TnWKIpiaJTJlT5oS6YCOLOpsh9ZVSOsRmfynF0nBzJNfle4EI7EtUklN7qf5Ek4YUB7aBEBFrVCXdoaIx/xCEtDoZG1Llf71igOeCfsbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UxTpd1Q9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UxTpd1Q9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C811F00A3A;
	Thu, 30 Jul 2026 15:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426575;
	bh=K/PEfqt92C1NsMCJI8lm3epsOBvLEnx+DogEA6tuPWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UxTpd1Q9kpmL7kOVeRg0aeV/gXjRETLpSwo5IYcQUjiIHxFwttM0ZPfVW8ATN80zx
	 9A8eO//PE67usZP6Qxyus8teKsSgF8mwiwNui+mLrkf2rq9mtK0Sb0BxdnnWGlbA4H
	 7UjwKS2tEc13imGby8I60du8YPA9Vufq4xZsTT1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 466/602] iommufd: Break the loop on failure in iommufd_fault_fops_read()
Date: Thu, 30 Jul 2026 16:14:18 +0200
Message-ID: <20260730141445.753714653@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

[ Upstream commit 172fc8b19825a0f5884c38f2289188284e2d45ee ]

On a copy_to_user() failure inside the inner list_for_each_entry, only the
inner loop breaks; the outer while re-fetches the just-restored fault group
and retries the failing copy_to_user() forever, spinning the reader at 100%
CPU with fault->mutex held.

Check rc after the inner loop and break the outer while as well.

Fixes: 07838f7fd529 ("iommufd: Add iommufd fault object")
Link: https://patch.msgid.link/r/336a9b6e44fe66a24199d3be777c405c85c98622.1780343944.git.nicolinc@nvidia.com
Cc: stable@vger.kernel.org
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/fault.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iommu/iommufd/fault.c
+++ b/drivers/iommu/iommufd/fault.c
@@ -299,6 +299,8 @@ static ssize_t iommufd_fault_fops_read(s
 			}
 			done += fault_size;
 		}
+		if (rc)
+			break;
 	}
 	mutex_unlock(&fault->mutex);
 


