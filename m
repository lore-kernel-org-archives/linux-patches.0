Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A86D1487E9;
	Tue, 25 Jun 2024 10:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309624; cv=none; b=FMnSKEt3Q1L7Goe29vX5+WTwx2kzsE26sPkcc1OY1KXKqzcEimUYEkVrTw8XWqfF5k/eyx8C5aERddlWgPAVHNhH2gR5st8PBW9q5HQCf0UqV9BQ2gpjnVzuIF2JObdM2g92QHcpSFH2Q3sI5vWTIgK3AoyrXyXCWVnX0G35Du8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309624; c=relaxed/simple;
	bh=Ye8FhaUbjwgeQEItj39QQAvOMWpQtd8/CqOZ20bYjSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ARS/qCCNvYMSc+0UvwGC+zuYc0TGmsEQyZX6eR8JnqDywnF+Oohj5ptT1ssfFtIF9xC9Kae1bKWlD+CloocyFxvSSZMXwP3y3wWZYx+HNGUlomH3iRrPQ6RLQgaxSiMZ+BnH+WJwAS+8qO4b5wGkqyAnPJzEPEo29ehMZLZjp4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y0NgxEIj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y0NgxEIj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E37FC32781;
	Tue, 25 Jun 2024 10:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309623;
	bh=Ye8FhaUbjwgeQEItj39QQAvOMWpQtd8/CqOZ20bYjSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y0NgxEIjKC+pp0zTEMdBKMKJej6ktntBG6byQ+0MvqTPI3F5dnJGnxAx/wGzyNQF6
	 wrQgFEqJD6rvWgWbnwkDPu6ziGbPDjQMM8VPp7SlBj7yaGBOsufW05IEzKNRQCT0wz
	 Lw74GKZ3UFGYG8ImiTlgQFNSBFzaf+N5NNE9YXpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/131] dmaengine: idxd: Fix possible Use-After-Free in irq_process_work_list
Date: Tue, 25 Jun 2024 11:33:54 +0200
Message-ID: <20240625085528.944454768@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index aa314ebec5878..4a3eb96b8199a 100644
--- a/drivers/dma/idxd/irq.c
+++ b/drivers/dma/idxd/irq.c
@@ -454,11 +454,13 @@ static void irq_process_work_list(struct idxd_irq_entry *irq_entry)
 
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



