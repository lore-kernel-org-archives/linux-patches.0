Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB9C24BD02;
	Tue, 29 Apr 2025 17:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946439; cv=none; b=Sm7WTfOc37J0Rz+kidogWDo1NZ9iNh0+JeriZl+HhjxYovxDUZ4R83+rEN6SlM0I4cmMZr0vzQw7letWvkzwXYwKHfu5iRp0YP1ODqwUdqdxGmr703EixlJufUQt/BmyVsjhcAKEIyERY7r6vVLiHXZOfSYBVQwPYWMtnuOdQV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946439; c=relaxed/simple;
	bh=Zkuk6hTP8ve8VN9VBe02HV5jAYCj2jLmNtSPZvQ5GwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+6+rH3dx/FTeARrszmcJotdzLL2vj2L3xOuIuvb8Bnj4mKxxysyn9ZtN7GT46o93qdXVLKHCx3qjxQFQyyaiNI8qpEYQh/By30FZiibs704jFFbOj7GhPzIV1l18Ytt7pJsxx/bL/UKkaLEoAm9nSymw+Lhx3iWl7kYttTu29E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pSWsMEXB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pSWsMEXB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2724C4CEE9;
	Tue, 29 Apr 2025 17:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946439;
	bh=Zkuk6hTP8ve8VN9VBe02HV5jAYCj2jLmNtSPZvQ5GwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pSWsMEXBEwJLv41V6A0mtfyK2PTFPlvcPWxRNdth1xS2uXBVd2Ug6dHGm5+zof8ni
	 y0EpVBxj5vOo3HQDc/bnFMDR6s5VSltYQLcMQvr/+dX37V8KV+ksUfRcLxQHYZ0Zti
	 j91EoPJ/GtpaKp1uwMKkfTygMEDZPRKMxqhjKsJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 267/311] iommu: Clear iommu-dma ops on cleanup
Date: Tue, 29 Apr 2025 18:41:44 +0200
Message-ID: <20250429161131.965605044@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 280e5a30100578106a4305ce0118e0aa9b866f12 ]

If iommu_device_register() encounters an error, it can end up tearing
down already-configured groups and default domains, however this
currently still leaves devices hooked up to iommu-dma (and even
historically the behaviour in this area was at best inconsistent across
architectures/drivers...) Although in the case that an IOMMU is present
whose driver has failed to probe, users cannot necessarily expect DMA to
work anyway, it's still arguable that we should do our best to put
things back as if the IOMMU driver was never there at all, and certainly
the potential for crashing in iommu-dma itself is undesirable. Make sure
we clean up the dev->dma_iommu flag along with everything else.

Reported-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Closes: https://lore.kernel.org/all/CAGXv+5HJpTYmQ2h-GD7GjyeYT7bL9EBCvu0mz5LgpzJZtzfW0w@mail.gmail.com/
Tested-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/e788aa927f6d827dd4ea1ed608fada79f2bab030.1744284228.git.robin.murphy@arm.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index e3df1f06afbeb..1efe7cddb4fe3 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -508,6 +508,9 @@ static void iommu_deinit_device(struct device *dev)
 	dev->iommu_group = NULL;
 	module_put(ops->owner);
 	dev_iommu_free(dev);
+#ifdef CONFIG_IOMMU_DMA
+	dev->dma_iommu = false;
+#endif
 }
 
 DEFINE_MUTEX(iommu_probe_device_lock);
-- 
2.39.5



