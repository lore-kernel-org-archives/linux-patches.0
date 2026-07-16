Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF0C31ED7C;
	Thu, 16 Jul 2026 14:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211426; cv=none; b=ujrZSpE5HdsGMp3URUcak6hJxt5fp0cVWLkt9qu2+EPjNhtGn/SnEAqGeK/DpSOmpmDJ51+6/ek0QAJQls9xbsTfEFQWYM3V+t2A5mNf8I8kxKJ/iZpTlbpGx9/94fmvGbJABD2/LyeDnBQh7VXz5NqUeMnQIEJccp0hMavpOyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211426; c=relaxed/simple;
	bh=21/4BcNkK2vvpi6Er8FYClhEjGQM8m2gSqzd5cLxED8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gDF/yACVj+P4Hwps03czmSQS5SYeluYEKix5P1aV7k+G2xloFJdgV1m7ZRbB2SOm1xt8tF3dAINva134YRABL0wUl41CRZLTNZAVypM0tGuBTFxlEN9qQFwKEfODB9aQUSpygMLv7o40s5WQVfaJOLs2mLmckM3JMcDo3hxvHJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rmU/SI1l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rmU/SI1l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB351F000E9;
	Thu, 16 Jul 2026 14:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211424;
	bh=vSxwQA4OmwzAJNIfT1sRBSsSm+lu/mZNIcXZaTYPfzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rmU/SI1luf6ruwFKGw5nkkG/9kWcYTC5/tOH8yHwfkKkYyKyVX6NJRWRFUVZJGd5e
	 IrvuI2OltViGO/Moyrn+T8MHlR9feclCOUfoeoiuAXchoKu6JGfJ3GTzcme0mlTLUx
	 NTr3yGZW0QVAxTXQVyiMU0/ZFn2XIa0So5XRIfpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.18 416/480] iommufd: Set upper bounds on cache invalidation entry_num and entry_len
Date: Thu, 16 Jul 2026 15:32:43 +0200
Message-ID: <20260716133053.813787555@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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


