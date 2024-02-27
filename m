Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C3713B7AB;
	Tue, 27 Feb 2024 14:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044018; cv=none; b=bvshJUTE+6e8iej1gNHm/VbSoEKSFKLvwbL1S1Q6NwPjLcjuornMmI+wT0jXecCqONp8huQGesO1EVEWPFITufGQsG4/RmauTxNklCZaR3Mo+FBmDWeLyjOqYZemX+K1XGMN3ev3X54n67815hC8L4/R9do2g78dDrfQjvn781M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044018; c=relaxed/simple;
	bh=Mgv/2TGkrj/qzLhQnDidfpwFvHjmhA2HsgL7Y2vmmic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nCmJEC2uIQgH/5LCNjYOWaQNShGlXxY+rAji1RBLvwoGdqexj8KrGu/HkGsU94doSCTJfrwQAi2wJF1o855l8L2bSdJklBcKsMRSH0Aq/rYdMgOQ7BXJFwDOrpI7W4TRAh0qcTj5PD4yr5lVNz/AMe9zDYQf1DbqxMgj85qGhxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kmhLd+1d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kmhLd+1d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E8EC433C7;
	Tue, 27 Feb 2024 14:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044017;
	bh=Mgv/2TGkrj/qzLhQnDidfpwFvHjmhA2HsgL7Y2vmmic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kmhLd+1dIC589e/PmorlVH9dFL5PCdoNdYo9xBTtcQQeBfnbU+mKEV4LSfFgltf4N
	 lnG2uJeSBLgO8DbultudRVyNUa+SB2sgNswV0IW5CRg5TofZHGSPrHVDJmRRkVZ041
	 xq5ioM5fQeSMFGnUtFHJzwKZaHpvqYZkJBd+5jF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Daniel Wagner <dwagner@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/122] nvmet-fc: release reference on target port
Date: Tue, 27 Feb 2024 14:26:33 +0100
Message-ID: <20240227131559.758711564@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit c691e6d7e13dab81ac8c7489c83b5dea972522a5 ]

In case we return early out of __nvmet_fc_finish_ls_req() we still have
to release the reference on the target port.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index 46fc44ce86712..18a64a4fd8da9 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -357,7 +357,7 @@ __nvmet_fc_finish_ls_req(struct nvmet_fc_ls_req_op *lsop)
 
 	if (!lsop->req_queued) {
 		spin_unlock_irqrestore(&tgtport->lock, flags);
-		return;
+		goto out_puttgtport;
 	}
 
 	list_del(&lsop->lsreq_list);
@@ -370,6 +370,7 @@ __nvmet_fc_finish_ls_req(struct nvmet_fc_ls_req_op *lsop)
 				  (lsreq->rqstlen + lsreq->rsplen),
 				  DMA_BIDIRECTIONAL);
 
+out_puttgtport:
 	nvmet_fc_tgtport_put(tgtport);
 }
 
-- 
2.43.0



