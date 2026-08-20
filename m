Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D27382371;
	Thu, 20 Aug 2026 15:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239318; cv=none; b=ksREbh4/+GhrBmrOet1dh3Uz/PNdPANsqiib+i2yfaJiBYhMsEQtvk7Tt1r1le97JEBK+euN66h70EKJjYlXrPEwdAAMKP++dLMmfclQCC99lut4sohdbrQGIgLNfiKSFWjgdUNPOVXxKVo1NDn2tBTme5VCmyrI6mUojkf5niI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239318; c=relaxed/simple;
	bh=ohzW86/v8Pk9oz7sh79dI8BAxnjE7OR6KK5UKBPdhvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fduF427LHH8MDPCWg8c9MmKQ65Rv8z0E9Yeztmp8CUYHniwl+zG8cxKIa9uXYU3zAaShUOyQGWBx9Kb3DmeeMMS6hT8Rm8tfrqfN7x3XKw6LdQ3aF5q5EYPgYVCB81Z5AUMV5W7+i99oYYeJPQYKSxp9RQvZhyyTEpyPvrMyPPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vEiXqguV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vEiXqguV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D9101F000E9;
	Thu, 20 Aug 2026 15:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239317;
	bh=7/86BHe9GzwT1EFSVXZy/IY8fcNyrSEJpJvh9aUlzHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vEiXqguVF3BG8qO8Bhl59WQibRha45y/KstDzZMZ4CCXUeTOml4/yUUaPoeh2P0DK
	 7dZCkXk0geE2h2jJEz6O+D3nBzIrS9hndbTyfg6Y/kEYH4TXRn19Rpl+c/YS6AmK8w
	 CWMV7uQ59QArrr+AZ4jb/IO69Fq1TIm2XOWCk+kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Zhen <max.zhen@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 202/217] accel/amdxdna: Skip unmapped range in aie2_populate_range()
Date: Thu, 20 Aug 2026 16:56:10 +0200
Message-ID: <20260820145243.789077329@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 6c916e301fa10de9158b922474ade7b43d726cda ]

aie2_populate_range() incorrectly failed jobs for BOs with multiple
mmaps: if the unmapped entry appeared first in umap_list, the loop would
pick it up, call hmm_range_fault() on a gone VMA, and return -EFAULT
without ever trying the remaining valid mapps.

Fix it by skipping unmapped entries. After the loop, if the map list is
empty or all maps are valid, map_invalid can be cleared normally.

Fixes: e486147c912f ("accel/amdxdna: Add BO import and export")
Reviewed-by: Max Zhen <max.zhen@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260812205628.810816-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_ctx.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index 612ad6302622a..9ec3d90c2d200 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -794,6 +794,16 @@ static int aie2_populate_range(struct amdxdna_gem_obj *abo)
 	found = false;
 	down_write(&xdna->notifier_lock);
 	list_for_each_entry(mapp, &abo->mem.umap_list, node) {
+		/*
+		 * Skip entries that have already been unmapped.
+		 *
+		 * If userspace unmaps the address and later submits I/O using
+		 * it, the IOMMU will reject the access and report a fault.
+		 * Ignore such entries here.
+		 */
+		if (mapp->unmapped)
+			continue;
+
 		if (mapp->invalid && kref_get_unless_zero(&mapp->refcnt)) {
 			found = true;
 			break;
@@ -801,6 +811,12 @@ static int aie2_populate_range(struct amdxdna_gem_obj *abo)
 	}
 
 	if (!found) {
+		/*
+		 * This also covers the case where all mappings have been
+		 * removed. There are no invalid mappings left to process.
+		 * Any subsequent I/O using the unmapped address will be
+		 * rejected by the IOMMU.
+		 */
 		abo->mem.map_invalid = false;
 		up_write(&xdna->notifier_lock);
 		return 0;
-- 
2.53.0



