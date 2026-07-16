Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E015722301;
	Thu, 16 Jul 2026 13:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210097; cv=none; b=gT6hhA1QeZGIkHcvZ890JHS4DtkzABiu0fmJCyE9ogR1FUTU9z9WiyphDpqmMI8WGhkPHsjOvFWYDsOppYh29EHDuMjkwF4w9XpkjMf+tWmsEO8BUWhUTxMCwKw7QOpVZvNFXf6Ak1NY4Qv4QD4rtpLXYNr9nBAkJOzOyMMNXtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210097; c=relaxed/simple;
	bh=cohivxUsJYJqx2jKmiAUaRzhPIb61EFxHV/ZtoQ6U+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l67THLPsTk4dX8OrG5haRUwaq246c9QttzLlLPPLdLtsUX5zLsrwdgGDkB3RpVVehK/3Z3SVT+eTHJN5cg7p/JV0W3xannefFT8R6hvQTpN1xmyFXTMe8zHNP6rlH5zBjJrrDUOZtewwKB4otfA9ikGOO1QrmD+UtrpDWbE5Loc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QokDkOS+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QokDkOS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B5A1F00A3A;
	Thu, 16 Jul 2026 13:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210095;
	bh=Yd8TGmepduocHum/JqOvvYb1Sr7cTYvp38yMhaYwq2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QokDkOS+SnnfkFCI4YFoJOY8UWfXjOAv+q7xmzYEOFd3N+BToMx6IOssaaKY1nLQV
	 PjuddnnsQUkGj2NDkYAyUlg8M8jo1xeOAx4xsdhKWXwS3RGLlCsExQ9RranG/81kVq
	 wajrUqxHfZSz6TKiHNM9dnS5JvpRGxkGZVO43Vzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH 7.1 435/518] iommufd: Move vevent memory allocation outside spinlock
Date: Thu, 16 Jul 2026 15:31:43 +0200
Message-ID: <20260716133057.362649948@linuxfoundation.org>
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

commit 47443565d10c51366c9382dbc8597cd6c460b8a2 upstream.

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
 
-	vevent = kzalloc_flex(*vevent, event_data, data_len, GFP_ATOMIC);
-	if (!vevent) {
-		rc = -ENOMEM;
+	spin_lock(&veventq->common.lock);
+	if (veventq->num_events == veventq->depth) {
+		kfree(vevent);
 		vevent = &veventq->lost_events_header;
 		goto out_set_header;
 	}


