Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311613D953E;
	Thu, 16 Jul 2026 13:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210257; cv=none; b=mcLlzmmrBnt0QRdwVS2Gx7nFI369im8EW99hzUlYtDmrySO7sDa/Z29BFlRm+Mb5k545gWw0SyPZKioVSjDhp0jHBwgVWY16p0eRm7vDIxsjFjj9RW54Jvik6a3VOMQxjpSWzG5ntIJCcuE9IJ+xfgld9Y7JpWR/6VWFYCwB7T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210257; c=relaxed/simple;
	bh=WByqwjqHmVcCwXyzoel0sLlExyBmL/5oJSwvqGgtj+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MN3uZdFxQjqpY+8QLOyxQu7ZmwkPdm010+8GV2yAIVs43qv4vv62ikoMF9UARRW4MWJ8wfowVZLJZ61umRjz0AC4yZyXJ9b24o8vlw+mmRryw0UWEgezj+g2p9lWPslWUMI+xSOeaVT4IbegxgSvf//GMtNru+8ZLWAEOEN5RJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EtYXpWY3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EtYXpWY3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C2D1F000E9;
	Thu, 16 Jul 2026 13:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210256;
	bh=/vudjgnR5ev+jtNAundNX8wKGdGY2OD9oBUU0x3jiB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EtYXpWY3Tc9rNWfFroks/hPPUHdkH9dY0bcG3s512MGywSO19BOFoDVdiQbRYptnu
	 yLkBusmlHF7ssz3DRxsy7zIira5eUH+NO/AqgGPtGZighQ4B2nH/eFV0hSAWwKR8mo
	 Jd87TiFBwm/DJ8GU42MuW0EU1dAdGOV/7L5o+X78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.1 443/518] iommufd: Set upper bounds on cache invalidation entry_num and entry_len
Date: Thu, 16 Jul 2026 15:31:51 +0200
Message-ID: <20260716133057.532302041@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

commit 4d70986002f2f3eaaed89124fb2522bded38b016 upstream.

iommufd_hwpt_invalidate() takes a user-controlled entry_num and entry_len,
each bounded only by U32_MAX. An entry_len beyond the kernel's struct size
makes the copy helper verify the extra bytes are zero, scanning that excess
in one uninterruptible pass; a multi-gigabyte value over zeroed user memory
trips the soft-lockup watchdog.

A large entry_num is the other half, driving the backend invalidation loop
with no reschedule. The VT-d nested handler, for one, copies each entry and
flushes caches per iteration, pinning the CPU on a non-preemptible kernel.

Cap both in the ioctl. entry_len is held under PAGE_SIZE, above any request
struct, and entry_num under 1 << 19, the order of a hardware invalidation
queue and well beyond any real batch, bounding the per-call loop length.

Fixes: 8c6eabae3807 ("iommufd: Add IOMMU_HWPT_INVALIDATE")
Link: https://patch.msgid.link/r/447fa93663f7526eb361719e83fa8b649464483d.1780521606.git.nicolinc@nvidia.com
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/hw_pagetable.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -489,6 +489,9 @@ int iommufd_hwpt_get_dirty_bitmap(struct
 	return rc;
 }
 
+/* An arbitrary entry_num cap, far above any realistic invalidation batch */
+#define IOMMU_HWPT_INVALIDATE_ENTRY_NUM_MAX (1U << 19)
+
 int iommufd_hwpt_invalidate(struct iommufd_ucmd *ucmd)
 {
 	struct iommu_hwpt_invalidate *cmd = ucmd->cmd;
@@ -507,7 +510,13 @@ int iommufd_hwpt_invalidate(struct iommu
 		goto out;
 	}
 
-	if (cmd->entry_num && (!cmd->data_uptr || !cmd->entry_len)) {
+	/*
+	 * Bound entry_num and entry_len so a single call cannot pin the CPU;
+	 * entry_len also caps the copy_struct_from_user() trailing-zero scan.
+	 */
+	if (cmd->entry_num &&
+	    (!cmd->data_uptr || !cmd->entry_len || cmd->entry_len > PAGE_SIZE ||
+	     cmd->entry_num > IOMMU_HWPT_INVALIDATE_ENTRY_NUM_MAX)) {
 		rc = -EINVAL;
 		goto out;
 	}


