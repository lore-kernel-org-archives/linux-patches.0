Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9260312EBEA;
	Tue, 25 Jun 2024 09:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308527; cv=none; b=n7mRNMLzLm/3ykPDyu+1GsZ9pu+P0PBoMYb4s3fX6llf4K3EAvQqWVj++Gu7Vt8qMneAHXAEGsfv/wI4ogR4gHwvEQR1FXRneD+D5RZ7FUyM6v5p0hjL82iNwjxC0tUzVCEB5fFStcSsi+EgvvZNU+qHMtacC0Ll8WJzoqGvZJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308527; c=relaxed/simple;
	bh=Zte8kET2RcX3RDIrgekR/JoOFT4AvhiB1TzgdyFO0hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aahjRfVn3ytN41d1hokmJtULx79DwGIWABzvbcW81x5pEG1aci46TKLnIO4lIF9FSwOrkiRLEc25PpGiJ1/MHwpuPV7qsZnZHkZw6sPuOZqFqgst6IVWO3/hV+PRjR+6/1C3+faQdJ8Gr6VGTOw/Od1R1Jn9HieZkQaozQ3UsCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjw1kL4v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjw1kL4v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1897BC32781;
	Tue, 25 Jun 2024 09:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308527;
	bh=Zte8kET2RcX3RDIrgekR/JoOFT4AvhiB1TzgdyFO0hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kjw1kL4v1Z13WG1EYPPKYHUB/ZM59BRaMuNg++ZWJRP7DuiBOy6+deL88lgfzLJMu
	 /3tgMMYHM6hQGvP2CJ0JqtkzYFpPztBG3it2t1bOo3E423e6znZ22VeV41Ej2nJ0R2
	 X9sMZu4mQfJXMoZl4lBQYezDmsTyOQHVZVb3zS2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 151/250] dmaengine: idxd: Fix possible Use-After-Free in irq_process_work_list
Date: Tue, 25 Jun 2024 11:31:49 +0200
Message-ID: <20240625085553.855841120@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 8dc029c865515..fc049c9c9892e 100644
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
 			idxd_desc_complete(desc, IDXD_COMPLETE_ABORT, true);
 			continue;
-- 
2.43.0



