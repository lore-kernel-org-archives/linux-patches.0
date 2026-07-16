Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7036442D76E;
	Thu, 16 Jul 2026 14:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212414; cv=none; b=CVCmjUhxzsyJLqmMEp8gVL+Qqhh+vBZ6mhDYF3dTYXnFIicOv9ew8m4lzN8MAR+a294xQGS5LY96RuB18SRjlWlYsShpfhd9gdOiPrdq9DTHUrPiSllQ/EfX9SGQziYBoZgZaUhSmmaiKQFIZcSEhWfjlqKwA7xqdZ2S+er7jjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212414; c=relaxed/simple;
	bh=NzLcOAvBuB11J7+L+GLhrXuJBOarz6uiBO0KvPhCxgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JpAMNKAs6Bwm+VKM751662gQWcgA29uExEbN/mMQaS2ePuq8ewRu41DvnQW90fALYFeiOL0E/lpHLgioHgKf9s0cZ4R6CMyUzS4D1vAuHsPU1k6EKPdk3akXAvKzEtN5V2J/CpLB1XveSHS6OeSDn2FHoufwDa6k2YdkAdSyxjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cE5CA2ZF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cE5CA2ZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7AA71F000E9;
	Thu, 16 Jul 2026 14:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212413;
	bh=9Tc+Qx58r3tlG/c0GV5LEIMAo5P02PSfmBTA0CwY3K0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cE5CA2ZFDEnofXlDvNIfHxEWpwt6kASsBH33JBU2DpIUvlWUcdoP3adcKgJ7N9S3C
	 5J9w4cFvinsvy2LvyREXnawcRvmj2+l0U4HMVDD7y8FECfV7lbernCY06zz/XXLmG4
	 Q8bC9PDYUnUiqMzrKG90JOUTD/fLVoTIoZQ5qpNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.12 317/349] iommufd: Set upper bounds on cache invalidation entry_num and entry_len
Date: Thu, 16 Jul 2026 15:34:11 +0200
Message-ID: <20260716133040.410756490@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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
@@ -406,6 +406,9 @@ int iommufd_hwpt_get_dirty_bitmap(struct
 	return rc;
 }
 
+/* An arbitrary entry_num cap, far above any realistic invalidation batch */
+#define IOMMU_HWPT_INVALIDATE_ENTRY_NUM_MAX (1U << 19)
+
 int iommufd_hwpt_invalidate(struct iommufd_ucmd *ucmd)
 {
 	struct iommu_hwpt_invalidate *cmd = ucmd->cmd;
@@ -424,7 +427,13 @@ int iommufd_hwpt_invalidate(struct iommu
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


