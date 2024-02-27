Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F57213B79F;
	Tue, 27 Feb 2024 14:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042575; cv=none; b=ItexUG6RJKKsUGzpZOT+pehr2zv/VDzTc/uJ0rZw/oa/rNWoZZQPqBTSHDPOUbD/jGHF3iSlv5K1gker3eOIzL/NwVrAdBKBn92B8IWwfiWc22OnHzgFbmS5LUt7Am5sXrXbH2iWFiC9Bv05nFuC7rjGaqAMVaycZPSS6UJ5H20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042575; c=relaxed/simple;
	bh=QvMt1v2mjQ506Mt4mf8IgIVXFSYDwC87goowara3Xe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cLu6WaDhBLUB7//yfsqTnh7K2rOw2+HHlk00Gve3r80ZmBmrLAOtMN2vq9x89TOx+dnyUGSNRIKqooHlVwl4Y5dVx5rMPrUS3nh3wn4dgk2i4ix1Id3kfLQ9OG8/hJv3EatQ9sISGYePmo0a0tWOZpYy6jbi0FUVbNYLs2SlKzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VC76HlHb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VC76HlHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4160C433C7;
	Tue, 27 Feb 2024 14:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042575;
	bh=QvMt1v2mjQ506Mt4mf8IgIVXFSYDwC87goowara3Xe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VC76HlHbYL3VL7XVyJcMxl8C6xGvBbXp1gadrXXMVty0w8uU+XUumKSnBsP8B61bm
	 h0Bpmi+qv99xn+q8fioDUT66iZzttFvsniuGUfHDtzuwnES7UsHj13sAJ4+gTRxVxI
	 6tahmaZxZbAuqceDem3JEMLCTib3sT+/N/8d+FeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Daniel Wagner <dwagner@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/245] nvmet-fc: release reference on target port
Date: Tue, 27 Feb 2024 14:23:52 +0100
Message-ID: <20240227131616.556367660@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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
index 00a2a591f5c1f..80df50ed7e3aa 100644
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



