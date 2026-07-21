Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FF246EF81;
	Tue, 21 Jul 2026 18:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659649; cv=none; b=rVq+V5v+bDLpRISOrXXeQpMRx15ujEg7H5ziYxPIU0Wk4tGrEm8ss6rHBR7FC+3fMDwZPcK8oM+635s9j6jm/8AhEWz24U5qAvetMq6+lZMuDoT4PwSm45LCcqVmXw/Pb1/2Zqy0LgceAzEmb/l2BK6klh9sty8limGZ2tGA2UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659649; c=relaxed/simple;
	bh=TWUnUZT8+uoUaHg3Soj9VD5m/FZhUOIVsDKp2Emfic8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UxBbQduPw0BfySDBMflb2+ioGAoy1FHh1ung6ascQhFcm2HN5ypDLiRhv5aR6Wz+xsLWpT3KxLm8+pIgrfpehMXSe5liHbK6pxOj2kbkOJlJdr7zVHlmJvKJKbjnmgHXF9hW8fDws+omD6P2nrAPlynp9EF8MoQlAzQf6HMs11E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nk6A08Sx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nk6A08Sx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7CAB1F000E9;
	Tue, 21 Jul 2026 18:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659648;
	bh=x9zo9jbmvCIig6sIx77K2I3hiY5FfTHmxHJJd00Y9jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nk6A08SxiHsFRaf8Ab8S9liK0g5VjKiufs5i6tLl8fI1XXConM72lh/6vu2wknOCx
	 ZH9dEQTtMw8om8iNY2p+nNmGQ39Usvw327kjybfjftWYgdZ4YM1O7ZnAK8a/wDhXrj
	 QL/Zfaea4qNs/zY9H6nWrVNU5R1pxnpmvkF7kef8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1600/1611] iommufd: Move vevent memory allocation outside spinlock
Date: Tue, 21 Jul 2026 17:28:36 +0200
Message-ID: <20260721152551.463790322@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

[ Upstream commit 47443565d10c51366c9382dbc8597cd6c460b8a2 ]

The veventq memory allocation happens inside the spinlock. Given its depth
is decided by the user space, this leaves a vulnerability, where userspace
can allocate large queues to exhaust atomic memory reserves.

Move the allocation outside the spinlock and use GFP_NOWAIT, which can fail
fast under memory pressure without dipping into the GFP_ATOMIC reserves or
direct-reclaiming from the threaded IRQ handler. On allocation failure,
queue the lost_events_header (so userspace learns of the drop) and return
-ENOMEM so the caller learns of the kernel-side memory pressure.

This is intentionally distinct from the queue-overflow path, which also
queues the lost_events_header but returns 0: a full queue is an expected
userspace-pacing condition rather than a kernel error.

A subsequent change will cap the upper bound of the veventq_depth.

Fixes: e36ba5ab808e ("iommufd: Add IOMMUFD_OBJ_VEVENTQ and IOMMUFD_CMD_VEVENTQ_ALLOC")
Link: https://patch.msgid.link/r/5ff36b5d80f7f6299f851be532a5195c1d2f1dae.1779408671.git.nicolinc@nvidia.com
Cc: stable@vger.kernel.org
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/driver.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/iommu/iommufd/driver.c
+++ b/drivers/iommu/iommufd/driver.c
@@ -149,15 +149,18 @@ int iommufd_viommu_report_event(struct i
 		goto out_unlock_veventqs;
 	}
 
-	spin_lock(&veventq->common.lock);
-	if (veventq->num_events == veventq->depth) {
+	/* Pre-allocate to avoid GFP_ATOMIC; use GFP_NOWAIT to avoid sleeping */
+	vevent = kzalloc_flex(*vevent, event_data, data_len, GFP_NOWAIT);
+	if (!vevent) {
+		spin_lock(&veventq->common.lock);
 		vevent = &veventq->lost_events_header;
+		rc = -ENOMEM;
 		goto out_set_header;
 	}
 
-	vevent = kzalloc(struct_size(vevent, event_data, data_len), GFP_ATOMIC);
-	if (!vevent) {
-		rc = -ENOMEM;
+	spin_lock(&veventq->common.lock);
+	if (veventq->num_events == veventq->depth) {
+		kfree(vevent);
 		vevent = &veventq->lost_events_header;
 		goto out_set_header;
 	}


