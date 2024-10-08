Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271161C2420;
	Tue,  8 Oct 2024 12:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391707; cv=none; b=cQqU0V/6vZAtUH3qXaaYNkd7KTSJQhZQD4DdwDC/UuYL99tYF0jg5EG0aaM9D1lGdWy930+KikHqR4wnEiwFF3yOOEt6OYU8NYzQUbaOf8hj6RF8n85yBIVIi4fKK3eL42pSOpI6p7tQIvNtjF+Vg9y0Ai931J2KDESZTgHti7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391707; c=relaxed/simple;
	bh=Gyn27OIs7CmfXO8pJY713SGVXBQIB2vnSVPxuFY3pdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HMUtGLLM41Kxbukv8YuRy2ZJ/5iOQDUHsb5YWXQnvCbhffJzLRfP7KfoCzc313Fc48o8yIvwmsrbcUYwNFPvq4L/RiYyiUwze2vdgnFHtsMRPdTYofRjq4lYi75wyUv9FUgr8YvahNYRxK6oQVdn2FQ41krTKwAjzOvkKOubS4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uoLtZHVO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uoLtZHVO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A10C4CEC7;
	Tue,  8 Oct 2024 12:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391707;
	bh=Gyn27OIs7CmfXO8pJY713SGVXBQIB2vnSVPxuFY3pdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uoLtZHVOq2cEiSOt0cyc4zfFIFUpzmoLFmKEkzJ1aOTguyywYrCKSh/Tn8Je24CC3
	 52YAklmGyYWa2KZoBDsqxT1xVu3kuEDwqlBqwkZyoCytN+8C459v5HeT4M+voftDeH
	 IPH5VMTV6OVciSPlbH1yW4DvqkrJAyE6WE3ly7wg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanjay K Kumar <sanjay.k.kumar@intel.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 198/558] iommu/vt-d: Fix potential lockup if qi_submit_sync called with 0 count
Date: Tue,  8 Oct 2024 14:03:48 +0200
Message-ID: <20241008115710.141133397@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanjay K Kumar <sanjay.k.kumar@intel.com>

[ Upstream commit 3cf74230c139f208b7fb313ae0054386eee31a81 ]

If qi_submit_sync() is invoked with 0 invalidation descriptors (for
instance, for DMA draining purposes), we can run into a bug where a
submitting thread fails to detect the completion of invalidation_wait.
Subsequently, this led to a soft lockup. Currently, there is no impact
by this bug on the existing users because no callers are submitting
invalidations with 0 descriptors. This fix will enable future users
(such as DMA drain) calling qi_submit_sync() with 0 count.

Suppose thread T1 invokes qi_submit_sync() with non-zero descriptors, while
concurrently, thread T2 calls qi_submit_sync() with zero descriptors. Both
threads then enter a while loop, waiting for their respective descriptors
to complete. T1 detects its completion (i.e., T1's invalidation_wait status
changes to QI_DONE by HW) and proceeds to call reclaim_free_desc() to
reclaim all descriptors, potentially including adjacent ones of other
threads that are also marked as QI_DONE.

During this time, while T2 is waiting to acquire the qi->q_lock, the IOMMU
hardware may complete the invalidation for T2, setting its status to
QI_DONE. However, if T1's execution of reclaim_free_desc() frees T2's
invalidation_wait descriptor and changes its status to QI_FREE, T2 will
not observe the QI_DONE status for its invalidation_wait and will
indefinitely remain stuck.

This soft lockup does not occur when only non-zero descriptors are
submitted.In such cases, invalidation descriptors are interspersed among
wait descriptors with the status QI_IN_USE, acting as barriers. These
barriers prevent the reclaim code from mistakenly freeing descriptors
belonging to other submitters.

Considered the following example timeline:
	T1			T2
========================================
	ID1
	WD1
	while(WD1!=QI_DONE)
	unlock
				lock
	WD1=QI_DONE*		WD2
				while(WD2!=QI_DONE)
				unlock
	lock
	WD1==QI_DONE?
	ID1=QI_DONE		WD2=DONE*
	reclaim()
	ID1=FREE
	WD1=FREE
	WD2=FREE
	unlock
				soft lockup! T2 never sees QI_DONE in WD2

Where:
ID = invalidation descriptor
WD = wait descriptor
* Written by hardware

The root of the problem is that the descriptor status QI_DONE flag is used
for two conflicting purposes:
1. signal a descriptor is ready for reclaim (to be freed)
2. signal by the hardware that a wait descriptor is complete

The solution (in this patch) is state separation by using QI_FREE flag
for #1.

Once a thread's invalidation descriptors are complete, their status would
be set to QI_FREE. The reclaim_free_desc() function would then only
free descriptors marked as QI_FREE instead of those marked as
QI_DONE. This change ensures that T2 (from the previous example) will
correctly observe the completion of its invalidation_wait (marked as
QI_DONE).

Signed-off-by: Sanjay K Kumar <sanjay.k.kumar@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20240728210059.1964602-1-jacob.jun.pan@linux.intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/dmar.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
index 1c8d3141cb55c..01e157d89a163 100644
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -1204,9 +1204,7 @@ static void free_iommu(struct intel_iommu *iommu)
  */
 static inline void reclaim_free_desc(struct q_inval *qi)
 {
-	while (qi->desc_status[qi->free_tail] == QI_DONE ||
-	       qi->desc_status[qi->free_tail] == QI_ABORT) {
-		qi->desc_status[qi->free_tail] = QI_FREE;
+	while (qi->desc_status[qi->free_tail] == QI_FREE && qi->free_tail != qi->free_head) {
 		qi->free_tail = (qi->free_tail + 1) % QI_LENGTH;
 		qi->free_cnt++;
 	}
@@ -1463,8 +1461,16 @@ int qi_submit_sync(struct intel_iommu *iommu, struct qi_desc *desc,
 		raw_spin_lock(&qi->q_lock);
 	}
 
-	for (i = 0; i < count; i++)
-		qi->desc_status[(index + i) % QI_LENGTH] = QI_DONE;
+	/*
+	 * The reclaim code can free descriptors from multiple submissions
+	 * starting from the tail of the queue. When count == 0, the
+	 * status of the standalone wait descriptor at the tail of the queue
+	 * must be set to QI_FREE to allow the reclaim code to proceed.
+	 * It is also possible that descriptors from one of the previous
+	 * submissions has to be reclaimed by a subsequent submission.
+	 */
+	for (i = 0; i <= count; i++)
+		qi->desc_status[(index + i) % QI_LENGTH] = QI_FREE;
 
 	reclaim_free_desc(qi);
 	raw_spin_unlock_irqrestore(&qi->q_lock, flags);
-- 
2.43.0



