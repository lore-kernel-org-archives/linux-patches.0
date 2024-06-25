Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B6A146A67;
	Tue, 25 Jun 2024 09:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309139; cv=none; b=n/W9+TN9lPjWik1rKUaiI2zLA4PdWkI1Gloh8W43xwre+Ml4wb89kXdidgRr83G9JbKjs9vQHAhoeQZ/fEA4RO8Lh33+HGAerk1ikynwE2pPWG3ZSLK0oNN2etSJNbdPD3xKvgokPoL9YtBka/kVTD9s5CBYg8r8MFPlEqIzBiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309139; c=relaxed/simple;
	bh=Z6nRnq+0SbOf2KL96iP1AbITB+hAVGUXnOdvBcb46N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1KdMbFGWWgyvh5BjCxNXd+pR4KeCLKdq56xdYBGRnqG6vWHezuHDnUGKUvd0q9wpwTeyjFBF37Bg0KzwcZBktqrrskO8oX0r5Y2/MV0QazP6Dq8kafr38bm5C0Yyo5zcOHwsGK5zD/dc+6knNBv7e4tKbT1MBHSxpRSJ97bX84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=spEO/cz7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="spEO/cz7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3756C32781;
	Tue, 25 Jun 2024 09:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309139;
	bh=Z6nRnq+0SbOf2KL96iP1AbITB+hAVGUXnOdvBcb46N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=spEO/cz7/RBvikCLBEgcoJyFMAWWPPSZ8yRbjLSIfoOKiTRsq5osTYkrCw/AJfUye
	 6R8mE8YgVQ0VwXyaQLLRt3VZay4xJJByPMYcrRKhdOqrmb21LOnh/jeHqla18WlkB6
	 q/MywdAozqDqusqweHPUohqLSgHrMTtejfj3tGHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 108/192] dmaengine: idxd: Fix possible Use-After-Free in irq_process_work_list
Date: Tue, 25 Jun 2024 11:33:00 +0200
Message-ID: <20240625085541.319871506@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit e3215deca4520773cd2b155bed164c12365149a7 ]

Use list_for_each_entry_safe() to allow iterating through the list and
deleting the entry in the iteration process. The descriptor is freed via
idxd_desc_complete() and there's a slight chance may cause issue for
the list iterator when the descriptor is reused by another thread
without it being deleted from the list.

Fixes: 16e19e11228b ("dmaengine: idxd: Fix list corruption in description completion")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fenghua Yu <fenghua.yu@intel.com>
Link: https://lore.kernel.org/r/20240603012444.11902-1-lirongqing@baidu.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/irq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/irq.c b/drivers/dma/idxd/irq.c
index b2ca9c1f194c9..7efc85b5bad9e 100644
--- a/drivers/dma/idxd/irq.c
+++ b/drivers/dma/idxd/irq.c
@@ -611,11 +611,13 @@ static void irq_process_work_list(struct idxd_irq_entry *irq_entry)
 
 	spin_unlock(&irq_entry->list_lock);
 
-	list_for_each_entry(desc, &flist, list) {
+	list_for_each_entry_safe(desc, n, &flist, list) {
 		/*
 		 * Check against the original status as ABORT is software defined
 		 * and 0xff, which DSA_COMP_STATUS_MASK can mask out.
 		 */
+		list_del(&desc->list);
+
 		if (unlikely(desc->completion->status == IDXD_COMP_DESC_ABORT)) {
 			idxd_dma_complete_txd(desc, IDXD_COMPLETE_ABORT, true);
 			continue;
-- 
2.43.0



