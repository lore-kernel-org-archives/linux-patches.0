Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3E71C57B1;
	Tue, 15 Oct 2024 12:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993701; cv=none; b=X/B5Jnq5wLa17eSDUGjLKf6WQ/utWgiA+E8y1kk5t0GUG6hM3tR0ictdIaiggl/Vn6wGkdvWBl8labuYeaSKxk8emFosE2tTS1agzQrZe+I7Ff7Z9jRTsmOmUheBZfI1bZ2sfBdDaj+1nBgzzKIRJNcjqYmHwy2qfF2BxhzcEEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993701; c=relaxed/simple;
	bh=bIh0UWv0bgVV1KmR6gN9FveW+VGJhwLvvOlMR1QmUy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l58AvXQzNdFJAWyDCSPcBDxKBkiDAqRHUgMQxq17+LDS1BNn3dFZng9jgDEBNT1afDqyVYD6/b9aqLHZXivudAKF5Bd8oZHWmkBXe16iScO2uSk9zz6sk1/bsyxOK1cEumLBUjud4jC+fTktUpSXzewsrDEgLIhUOVzC+doKqJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EiJenGMZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EiJenGMZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53089C4CEC6;
	Tue, 15 Oct 2024 12:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993701;
	bh=bIh0UWv0bgVV1KmR6gN9FveW+VGJhwLvvOlMR1QmUy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EiJenGMZ2AtHAaaBSAVzbDDzFgI2AVIIgO9NEfCnKZYhVDr8Ylua4asjJB7tUYi8+
	 Dukii2jR+qtwHWqGEF3LlcSUWGLj24qM8WZF18jj5VfjQvy8R+A8h3Fb6ScUqT6Mbz
	 9G1JR7nDPX63UFSxCBncswoLgIGDr4IzBWiy4QlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 448/691] iommu/vt-d: Always reserve a domain ID for identity setup
Date: Tue, 15 Oct 2024 13:26:36 +0200
Message-ID: <20241015112458.129442476@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 2c13012e09190174614fd6901857a1b8c199e17d ]

We will use a global static identity domain. Reserve a static domain ID
for it.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Link: https://lore.kernel.org/r/20240809055431.36513-4-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 46b2751c3f003..acb870a877ec0 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1846,10 +1846,10 @@ static int iommu_init_domains(struct intel_iommu *iommu)
 	 * entry for first-level or pass-through translation modes should
 	 * be programmed with a domain id different from those used for
 	 * second-level or nested translation. We reserve a domain id for
-	 * this purpose.
+	 * this purpose. This domain id is also used for identity domain
+	 * in legacy mode.
 	 */
-	if (sm_supported(iommu))
-		set_bit(FLPT_DEFAULT_DID, iommu->domain_ids);
+	set_bit(FLPT_DEFAULT_DID, iommu->domain_ids);
 
 	return 0;
 }
-- 
2.43.0



