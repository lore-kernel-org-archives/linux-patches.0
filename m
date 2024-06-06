Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D797E19ADB6;
	Thu,  6 Jun 2024 14:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683051; cv=none; b=FsyuhWlDwn/HEGahdQMq9W9R7pKod5xupzeOKXWdktEQ/HXNDSSfhLfx/XBi4euEvkCfvBNpRTRArRm5xsUO45k+ExWZhjM4NyfkZwNPnTtVAB5G+y3Z3uxuMwqZi0119Fn50O5xAYm05Ma6Vd7nEwJBkCGQZoNmEr4LLR3u1Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683051; c=relaxed/simple;
	bh=IP6aCR9TaEUIytwK3Hn89HLj8WLj1TrUjw5FNasiwxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/mGiTK6rh9TMHR347dvleUxRMQRMe4Shv4u3oMtWUc4/WASuTlanlSlx0GumWKo2x41lobNizQW0EM+WNvitWQtH68IvxmansshkpaZ/26/36XO4BB/xxnx1zrBjDzma3tLUOdpknj1XA8k9g+tSthZlWMePYTdTU7xuM604Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e+o0gY7C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e+o0gY7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84348C4AF16;
	Thu,  6 Jun 2024 14:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683051;
	bh=IP6aCR9TaEUIytwK3Hn89HLj8WLj1TrUjw5FNasiwxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e+o0gY7CpN73DOeGpC4AD1puV32nlWIqWpnlXjo40XGdSNby3Fx5JMj3rNsltNSB/
	 TzSWJ8023NCxO01/jka62ixW8L8IEtI/4XBiv7lgzdaez5AqK8ZSOHyWEpAQxKPCRJ
	 nKXOA5C73FUbl7kFyS2eZ8XKM6+IJP9pkH+Fa54c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 292/374] nvme-multipath: fix io accounting on failover
Date: Thu,  6 Jun 2024 16:04:31 +0200
Message-ID: <20240606131701.661940902@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit a2e4c5f5f68dbd206f132bc709b98dea64afc3b8 ]

There are io stats accounting that needs to be handled, so don't call
blk_mq_end_request() directly. Use the existing nvme_end_req() helper
that already handles everything.

Fixes: d4d957b53d91ee ("nvme-multipath: support io stats on the mpath device")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c      | 2 +-
 drivers/nvme/host/multipath.c | 3 ++-
 drivers/nvme/host/nvme.h      | 1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 5008964f3ebe8..d513fd27589df 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -422,7 +422,7 @@ static inline void __nvme_end_req(struct request *req)
 		nvme_mpath_end_request(req);
 }
 
-static inline void nvme_end_req(struct request *req)
+void nvme_end_req(struct request *req)
 {
 	blk_status_t status = nvme_error_status(nvme_req(req)->status);
 
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index d16e976ae1a47..a4e46eb20be63 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -118,7 +118,8 @@ void nvme_failover_req(struct request *req)
 	blk_steal_bios(&ns->head->requeue_list, req);
 	spin_unlock_irqrestore(&ns->head->requeue_lock, flags);
 
-	blk_mq_end_request(req, 0);
+	nvme_req(req)->status = 0;
+	nvme_end_req(req);
 	kblockd_schedule_work(&ns->head->requeue_work);
 }
 
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 05532c2811774..d7bcc6d51e84e 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -767,6 +767,7 @@ static inline bool nvme_state_terminal(struct nvme_ctrl *ctrl)
 	}
 }
 
+void nvme_end_req(struct request *req);
 void nvme_complete_rq(struct request *req);
 void nvme_complete_batch_req(struct request *req);
 
-- 
2.43.0



