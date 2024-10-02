Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A3A16F84F;
	Wed,  2 Oct 2024 13:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875681; cv=none; b=a4CkhaD4YwJwZmbLwqNgVMQRMvsg7zRSuw9Lqld3heMmXz7eOyCEXtoVCm8oa3ALMUv5QihgI0z2scH8OO0B0h6a4osXqWHXuRh4SAtBk7qX02T4M3C3qXg5nAOEO+BTRBACr9FFpzXVV7Rb90I0iJjBxJmuET9ZZRdV93Ae7JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875681; c=relaxed/simple;
	bh=h4cTSABUZFcyDiF9hRRc4WBTDI55i9A4bLsyQTPuvns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qhn7UlzRiqUQpMT8xdFfsFUFiOR7eFPhip2dQM/xZDU3WvlRP1UyG3TtzThxPCH+uR5ZAOs7CDZHqGqg0Gci9mXpwcocJ3lshR85TKiGZKWB5iHhl7T6r07+t1LojZNk03cHiC03LQjnxSqH6QnwraPHEkdgjUDAob6vQQNhUOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nw+dpUdr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nw+dpUdr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04DCC4CEC5;
	Wed,  2 Oct 2024 13:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875681;
	bh=h4cTSABUZFcyDiF9hRRc4WBTDI55i9A4bLsyQTPuvns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nw+dpUdry59GX2RPOdQWhy3fv06eFGoZWvX/hu3Pa4CHu2Nj7oK4amdr4P7XrUhWA
	 a0WdgfK2FadujOMgRPLCzCBJcc6SEavQ9l61h3APoro67qgV2cszBaWSEmBuuBbgEx
	 bIq6Jytw4NHBuY3loQx50OMLJHCf6dC6LKiGLhpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 183/695] iommu/amd: Handle error path in amd_iommu_probe_device()
Date: Wed,  2 Oct 2024 14:53:01 +0200
Message-ID: <20241002125829.775480057@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasant Hegde <vasant.hegde@amd.com>

[ Upstream commit 293aa9ec694e633bff83ab93715a2684e15fe214 ]

Do not try to set max_pasids in error path as dev_data is not allocated.

Fixes: a0c47f233e68 ("iommu/amd: Introduce iommu_dev_data.max_pasids")
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Link: https://lore.kernel.org/r/20240828111029.5429-5-vasant.hegde@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index b19e8c0f48fa2..fc660d4b10ac8 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2185,11 +2185,12 @@ static struct iommu_device *amd_iommu_probe_device(struct device *dev)
 		dev_err(dev, "Failed to initialize - trying to proceed anyway\n");
 		iommu_dev = ERR_PTR(ret);
 		iommu_ignore_device(iommu, dev);
-	} else {
-		amd_iommu_set_pci_msi_domain(dev, iommu);
-		iommu_dev = &iommu->iommu;
+		goto out_err;
 	}
 
+	amd_iommu_set_pci_msi_domain(dev, iommu);
+	iommu_dev = &iommu->iommu;
+
 	/*
 	 * If IOMMU and device supports PASID then it will contain max
 	 * supported PASIDs, else it will be zero.
@@ -2201,6 +2202,7 @@ static struct iommu_device *amd_iommu_probe_device(struct device *dev)
 					     pci_max_pasids(to_pci_dev(dev)));
 	}
 
+out_err:
 	iommu_completion_wait(iommu);
 
 	return iommu_dev;
-- 
2.43.0



