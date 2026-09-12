Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFFB339D6C9;
	Sat, 12 Sep 2026 08:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202869; cv=none; b=ksBf0Ki7Aa1ilcDCeiRJ+gT4n4+sDYHFcDmkgv2SKF+W5q1ri2me0xf56uvFs87dmjqBjmQaQJXSovT94FzJTVSSh2oc7Xl/+3PR/Kd1DdSr+DXzS0msiQjuB1itvF5q4aKMnIJ30y6GVXHYCpx4WC1LHgxrrZ07OFCNNpBaXVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202869; c=relaxed/simple;
	bh=lGUl8b7YP9RChUOBoHEVX7YXyRxr2eiOldMS/0asGwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pNwslC00dN8bJ5xQ5kWpRuMoqZ2tS5zHz6pR2mu/G4Q6gnfGcaP25JFRzWPbisnoRdxTXCmzm+31qqX4XxXT6uVk+GXxVK18ADNiZaFBggKLjVpFb+BCRM+RKGrHpF/A+SNeBJuGxJrSvLVtmdlMFpIMqm6sNjFJhS93uka6p9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CCvTOyhb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CCvTOyhb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9453D1F000FF;
	Sat, 12 Sep 2026 08:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202868;
	bh=ZVuFkYz0pfmXxao2Tc+WScM/lqPfFHEueJjK+Qnka0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CCvTOyhbYtW2f6v0ZJZ1b2UOgiRvnpmGnwO9mDh3WGi7LWi0w+vhNGT7r3gH13pzZ
	 2gVTkUO+CGwWJWEOttfeGlS7Tj32aHg4GyIP2BlhcFFOxxEMRkmI3uB05IgxhsNG59
	 Q5+/3MHb7z0FgDQx+daUhHZorSLBCYU6fOYlAY5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1293/1815] iommu/vt-d: Tear down scalable-mode context on probe failure
Date: Sat, 12 Sep 2026 08:50:43 +0200
Message-ID: <20260912065719.369677438@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit c509fb73a1093a15accd7d43a61645d4b520f6ac ]

intel_pasid_setup_sm_context() walks a PCI device’s DMA aliases via
pci_for_each_dma_alias() and programs a scalable-mode context entry for
each RID. For a device with a dma_alias_mask, the callback is invoked
once for the device’s own RID and once for each alias bit, all with the
same pci_dev, so device_pasid_table_setup() runs for multiple RIDs.

pci_for_each_dma_alias() stops at the first callback error. Therefore, a
failure partway through the walk can leave context entries for already
processed RIDs present and still pointing to the device’s PASID table.

On this error path, intel_iommu_probe_device() currently jumps directly
to intel_pasid_free_table(), which frees the PASID table without
first tearing down those context entries. The IOMMU may then walk a
present context entry whose PASID table pointer references freed
memory.

intel_iommu_release_device() already performs teardown before freeing the
table. Apply the same ordering on the probe failure path.

device_pasid_table_teardown() safely handles RIDs that were never
programmed: iommu_context_addr() returns NULL when no context table has
been allocated, and clearing the Present bit of an already non-present
entry is a no-op. So unwind is safe for both the alias that failed and
any aliases not yet reached.

Fixes: 301f1a80487fd ("iommu/vt-d: Setup scalable mode context entry in probe path")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260602233426.357499-1-baolu.lu%40linux.intel.com
Assisted-by: Claude:claude-opus-5
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 14118b353fcf4..79aaeb3d2b7f7 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3322,6 +3322,7 @@ static struct iommu_device *intel_iommu_probe_device(struct device *dev)
 
 	return &iommu->iommu;
 free_table:
+	intel_pasid_teardown_sm_context(dev);
 	intel_pasid_free_table(dev);
 clear_rbtree:
 	device_rbtree_remove(info);
-- 
2.53.0



