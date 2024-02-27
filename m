Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C824C54BD4;
	Tue, 27 Feb 2024 13:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041766; cv=none; b=PBQuJifh596CFywI1QYswdOluJS6WHIS8NoUXYuSDKM86COfqYKNNUcboR0oerk4quODfVz/K+Qmngs9CAb2jqd37NEQkGnT9vNXCCE9wlamRhhYAyR+Q49EZy3fnC/72s43go8crE+RvR6p1CJlxdn8YsnQmO8d27JW+m0Nf7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041766; c=relaxed/simple;
	bh=q1S+dxfZXzAL7imY4opuciaGp1J8YHe0EaHGXdk60nQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N6+B4zLkh4ocpa9/ItzY4Xh4Lvm0J7o5drbZQ9kJt4PxVDxBs+iPrBpzkAs/W+hrSkhB1/MCUhmhMucHIYldI/VtfEDxQwloqU8DkqS4quXsCTaVrHRToYyGXCHFoz15onNHqhPU3Hvct4PUQZp7hC13ax5Eojw3Y01fdTWj2j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CK+uK/qf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CK+uK/qf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 175E5C433C7;
	Tue, 27 Feb 2024 13:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041766;
	bh=q1S+dxfZXzAL7imY4opuciaGp1J8YHe0EaHGXdk60nQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CK+uK/qfCZcqixoPvyyKYgh7eZrkyWwT+N38wDyVv4rmfU07ps+cdd41oXooSh8Ov
	 33/DNKHltdg5osyHW8/DhY24TTmjqkFRCM5U1VpJeq3HRy+Bi7TP9tKy4oB0m8C8n0
	 zCHBZW/myprNy+J4Y40povC+bmwMaGC53dDUV1Lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Daniel Wagner <dwagner@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/299] nvmet-fc: release reference on target port
Date: Tue, 27 Feb 2024 14:22:51 +0100
Message-ID: <20240227131627.887784842@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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
index 1ab6601fdd5cf..0075d9636b065 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -359,7 +359,7 @@ __nvmet_fc_finish_ls_req(struct nvmet_fc_ls_req_op *lsop)
 
 	if (!lsop->req_queued) {
 		spin_unlock_irqrestore(&tgtport->lock, flags);
-		return;
+		goto out_puttgtport;
 	}
 
 	list_del(&lsop->lsreq_list);
@@ -372,6 +372,7 @@ __nvmet_fc_finish_ls_req(struct nvmet_fc_ls_req_op *lsop)
 				  (lsreq->rqstlen + lsreq->rsplen),
 				  DMA_BIDIRECTIONAL);
 
+out_puttgtport:
 	nvmet_fc_tgtport_put(tgtport);
 }
 
-- 
2.43.0



