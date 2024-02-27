Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E08613B7A0;
	Tue, 27 Feb 2024 13:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040661; cv=none; b=mlxwEZmsNv2TRW9SIyjV4nZoPlKuRzIt4JdVwJ20OIU896ByQMceuNR19D6XgDIRkcPR2VcZ4imbwxxq0LN12k3yMPslAaxyJc0cWIdtkh4hoOMMCE1mh7OHS5KHTN6B8qu82C+IyGI1iFRJC/l/XTAHlCn4c+6kWcYskLTAabI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040661; c=relaxed/simple;
	bh=VVABE2Dw5RiSZg1RGBLXw/Ysj5z1w+/hIa0YhqGszLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZR0+eyqAPczNMZotycKgFLHoU4WAuFpHTOmv6BDs3yi1HKFZJUzLF5mdtfr3jmgD0lf+9Z8goTNGrn6wCJjH/8rV90pEcyZMa2SfTh47gepCRxU39SL0tBU+Kc6S49RyfJ1+6NM/B64J2Xw5XxGFjzcQ7oJ5nirzTygAiiXLzl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O/N8FCO7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O/N8FCO7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940D8C433F1;
	Tue, 27 Feb 2024 13:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040660;
	bh=VVABE2Dw5RiSZg1RGBLXw/Ysj5z1w+/hIa0YhqGszLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O/N8FCO7ll9vRovSXh1QnMOfYieo84fNgj9yH8mIg/eFsXcmcR1cUXE+0fA2vPqAP
	 PO4VonauetsVBS4/K0GD6DjPTjohqGjm4ywvjeobNc5LarpRwSkH5Vq8His8HrWSTC
	 dMIilhnwVrT1ip7mhMrWEBo4LFLoYg8wrFr4cAnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Daniel Wagner <dwagner@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 065/334] nvmet-fc: release reference on target port
Date: Tue, 27 Feb 2024 14:18:43 +0100
Message-ID: <20240227131632.660162619@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index bd59990b52501..8cd1ef293769b 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -360,7 +360,7 @@ __nvmet_fc_finish_ls_req(struct nvmet_fc_ls_req_op *lsop)
 
 	if (!lsop->req_queued) {
 		spin_unlock_irqrestore(&tgtport->lock, flags);
-		return;
+		goto out_puttgtport;
 	}
 
 	list_del(&lsop->lsreq_list);
@@ -373,6 +373,7 @@ __nvmet_fc_finish_ls_req(struct nvmet_fc_ls_req_op *lsop)
 				  (lsreq->rqstlen + lsreq->rsplen),
 				  DMA_BIDIRECTIONAL);
 
+out_puttgtport:
 	nvmet_fc_tgtport_put(tgtport);
 }
 
-- 
2.43.0



