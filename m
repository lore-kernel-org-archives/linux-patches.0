Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043311891D3;
	Wed,  3 Jul 2024 11:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005823; cv=none; b=VF2gcmoCPnCqhBOuSnHmT0ZrIDntJI1fuYtaB3FfM4D5LI2/L1/emfBrVfxHAy3N3fOzUyAEgoWjPBhRbkhYs8ufet74kdu0h6joXl6YK1suoivA3S4/2mK9r9Nh8h17nfbBJsgb0dcjSWu281CcNmZi+ZgnmAnz63P6QHvsKaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005823; c=relaxed/simple;
	bh=W0y8OERDwmS9OgRN5IrQ+imlLhanqAiqeuP+7bsMdr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=haMqVQg7otElDFltX58LeMSNpDpGHbHNtTFSoTnufcOoF3/tJ/8nr+5E3+CMN3xBsY7XgxJlKLHozXaKJCYuwu3CYCFClB/S07CESNGnnuE5cAEnUY89yrYiN8N9PMX73vzkCza+qGsj95TUA1yHMJmxDYXtjxeTjHbyHrQj1bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wqCGYd3C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wqCGYd3C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C90EC2BD10;
	Wed,  3 Jul 2024 11:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005822;
	bh=W0y8OERDwmS9OgRN5IrQ+imlLhanqAiqeuP+7bsMdr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wqCGYd3C/xUOGtSh30WxjgJs/alGLayu57xpv8hLoqW4zJnVNhIBFtQigKCOa0Ch4
	 YE0edetm5GBcfrEZp7uhrzD5g3MZZ3rFAuaxvZbiU+Z0Fk2Q/tLpt2flHsrInwwHa/
	 etYHAMNVXgVbAVn95NvX3vskBK+wjmMviGMaUTUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 207/356] dmaengine: idxd: Fix possible Use-After-Free in irq_process_work_list
Date: Wed,  3 Jul 2024 12:39:03 +0200
Message-ID: <20240703102920.938413001@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6d6af0dc3c0ec..1296076ea217c 100644
--- a/drivers/dma/idxd/irq.c
+++ b/drivers/dma/idxd/irq.c
@@ -233,11 +233,13 @@ static void irq_process_work_list(struct idxd_irq_entry *irq_entry)
 
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
 			complete_desc(desc, IDXD_COMPLETE_ABORT);
 			continue;
-- 
2.43.0



