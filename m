Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6907434752E;
	Sat, 12 Sep 2026 10:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210623; cv=none; b=akc6HInFtMASJZb5o/RKug92nhGBbn/BvvTdIu1eKAqBycbryWhSniezpP0j7OIo1Gy9z88xPBG+x5/lUXyj3I4dYiW0cAF0zpl+e7KiERIScvWiG+l2O6k3xZF74nK6kKuf30I91d/XkLjuqdh+QEvM0Eopxg3O/4ECaxQuxMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210623; c=relaxed/simple;
	bh=GYYYqKD5WNgqAEGsaoxaukIhHkRfggalkY/brHHMb0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ub2FwVkvBVDpgznrxxPyHLNhN/2bJ9yhXHNeKGlx+KUjiP0owwfZzVnqvnJMahrUxfHsrwGvFtHrgHkYzwr1QK5hiYvhk7ipP0OmyLK6NqXX9Jcej0qBPoVIgFEXhm2Qs1rZhNeEZjmZxYj8GxXGZhP78E6A7Wk7lN26XIn/AIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cH226eB4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cH226eB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9F91F000FF;
	Sat, 12 Sep 2026 10:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210622;
	bh=3uj2tVdaFZr3uykTgGOlQqKxF4HKRc1NJlikpZvx9bQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cH226eB4y5lnzUMOIrTRSPQPV4+O+J8vDw934935Y1GfUQMMHR2aOaPsn+ZSNoelB
	 2uUU80IK3jsITKpoRwrPm9849fWQaX/1xjPG1oDwbUYxu12NY5903ocWhkpm3Mq+Du
	 aR2rRVMWF+a9VNyJJ1YLzfKl6ew0Jyp8TYcBfItA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1065/1518] iommu/vt-d: Tear down scalable-mode context on probe failure
Date: Sat, 12 Sep 2026 08:53:54 +0200
Message-ID: <20260912065647.541779566@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 21d124aadc635..183310979ba0d 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3864,6 +3864,7 @@ static struct iommu_device *intel_iommu_probe_device(struct device *dev)
 
 	return &iommu->iommu;
 free_table:
+	intel_pasid_teardown_sm_context(dev);
 	intel_pasid_free_table(dev);
 clear_rbtree:
 	device_rbtree_remove(info);
-- 
2.53.0



