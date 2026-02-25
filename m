Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0791E2834;
	Wed, 25 Feb 2026 01:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771984019; cv=none; b=Ju+B00yseYdKjq54G8X1CwqXGGfQRs4lAHryegssGXH9yJ06VMR6n1jNt9hIBCDutF5oF4qpc7IsrVj0vEoXVlmTh4UbEhw4dfr/MYUfAJHt9YIOVuIU0DqppFGjubviCwCpWv6HXfQC/bnnor/VNCjczgXdpS8e3IfHy/70D/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771984019; c=relaxed/simple;
	bh=XkAPmIaZlhyulJdkVPNQSoh3VXYFDR5n0z1gQ6d2YOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2/LRJCHVf7ivfP61mvInCu0o0pl1Z5LRuOIwQihZw/GynGfVM912GiH3vV1JXyke+3PRo9fKOtpD30KSssJvs9oVSdoAx97tSsYIXlOOU1OxWzgSglg0MvRaiKg7cjueyeco/Z6qZyy1kflzCiXUJHgnsP2gHN1qOYrvtF96x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a+CcOgQn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a+CcOgQn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D7C0C116D0;
	Wed, 25 Feb 2026 01:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771984019;
	bh=XkAPmIaZlhyulJdkVPNQSoh3VXYFDR5n0z1gQ6d2YOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a+CcOgQnpfeh4hAUVWKbWBMlnn1vFKcaNUyU1rjafSNuyKqbg5Z+lNtzBxRO3P5oh
	 +tkXgKcdHKwlifaWP+xL5/BFruEzMwYnL0BB30CryexT2CvBU/q2FXJ+izAgbPtpKK
	 qpzBgSUol3Zzb/Ii9CiXJCr8QVADoHTEdMXNXR1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmytro Maluka <dmaluka@chromium.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 266/641] iommu/vt-d: Flush cache for PASID table before using it
Date: Tue, 24 Feb 2026 17:19:52 -0800
Message-ID: <20260225012355.255498405@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Dmytro Maluka <dmaluka@chromium.org>

[ Upstream commit 22d169bdd2849fe6bd18c2643742e1c02be6451c ]

When writing the address of a freshly allocated zero-initialized PASID
table to a PASID directory entry, do that after the CPU cache flush for
this PASID table, not before it, to avoid the time window when this
PASID table may be already used by non-coherent IOMMU hardware while
its contents in RAM is still some random old data, not zero-initialized.

Fixes: 194b3348bdbb ("iommu/vt-d: Fix PASID directory pointer coherency")
Signed-off-by: Dmytro Maluka <dmaluka@chromium.org>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20251221123508.37495-1-dmaluka@chromium.org
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/pasid.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 52f678975da74..67cbf53d18c8f 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -153,6 +153,9 @@ static struct pasid_entry *intel_pasid_get_entry(struct device *dev, u32 pasid)
 		if (!entries)
 			return NULL;
 
+		if (!ecap_coherent(info->iommu->ecap))
+			clflush_cache_range(entries, VTD_PAGE_SIZE);
+
 		/*
 		 * The pasid directory table entry won't be freed after
 		 * allocation. No worry about the race with free and
@@ -165,10 +168,8 @@ static struct pasid_entry *intel_pasid_get_entry(struct device *dev, u32 pasid)
 			iommu_free_pages(entries);
 			goto retry;
 		}
-		if (!ecap_coherent(info->iommu->ecap)) {
-			clflush_cache_range(entries, VTD_PAGE_SIZE);
+		if (!ecap_coherent(info->iommu->ecap))
 			clflush_cache_range(&dir[dir_index].val, sizeof(*dir));
-		}
 	}
 
 	return &entries[index];
-- 
2.51.0



