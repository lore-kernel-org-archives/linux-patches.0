Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C3E367B9F;
	Thu, 20 Aug 2026 15:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238635; cv=none; b=PO6VlOHHjnOB28PJHWrpn4aeFyIIyhjsQ1zigRoiVRVWuCHmEc9g05V45ozg8obJ+iA9RsRqIzpxyfLS2sGiYarU7hWPrXyCyFwnnCrnhGYlgkmiNvax7shj456r5Z6pFFMJie5WY+ey1lM0QMhoV9Wuf23XsNwLUbLJ66/72O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238635; c=relaxed/simple;
	bh=eohanP1cJC+oUja91FB/LswdfJtqFJy1iYIS9pF0zZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtVbmt6JjPuhBSfQ2thtTOMdyZszCBTJhC2dcMN4jLgmk+ZRnCwJKX/Jb1/tbE3tSCtTsWh3WJad9AXVIwzsVL89rFwjVcLks8xBhTADogxA4Cb0GBT/0GD1IziIGLITD1r7nQMuv2UXokbWlFke+kCinpcueHAi6djnDgJHwTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g/jziWfC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g/jziWfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210E01F000E9;
	Thu, 20 Aug 2026 15:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238634;
	bh=2efmjmviK0Pu6QEPsYCOhIkHEn7FYlEqcYytl0dEbH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g/jziWfCM4pclH8+8HiuxaRXdgGtwMmtPzKIB6+Rs4OTOLkZ7Ohk5cJkbSXcHS2SU
	 tYxsHEe59uZ5JH0nd40VkKn39SpYqOz667nll7OeBhJkYe0e1X9JT9/ACjXxuRUryd
	 9b09xhTCezp4K+0brDXctAb8nWLaKiDAivE/RecA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Zhen <max.zhen@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 215/228] accel/amdxdna: Skip unmapped range in aie2_populate_range()
Date: Thu, 20 Aug 2026 16:55:57 +0200
Message-ID: <20260820145251.582129905@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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
index a417b7d9ffac3..1ac084afd9467 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -963,6 +963,16 @@ static int aie2_populate_range(struct amdxdna_gem_obj *abo)
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
@@ -970,6 +980,12 @@ static int aie2_populate_range(struct amdxdna_gem_obj *abo)
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



