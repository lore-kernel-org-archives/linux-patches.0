Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52BE28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:13:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D236C433D2;
	Mon, 30 Jan 2023 14:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087992;
	bh=N3KoFhrFOX+6JxZC8kJ+87kqt95pSiwVEUzZnKKgNio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OccsKKsiQ81PiLnPsMp1zTn/d570EtcQBZPt4kgKa2FNGskwdri6BqMmoeVXujgnp
	 XXtT7zQS0e2VXMckYm941/gTgyyusMgRwH0Hdm5lRir6+yGF4cpTD1KTi1N9WWJt/l
	 n4My69L9aOqD3KLDDQYMB87D0Shjc3fq89WGVoIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 079/204] nvme-pci: fix timeout request state check
Date: Mon, 30 Jan 2023 14:50:44 +0100
Message-Id: <20230130134319.810028168@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 1c5842085851f786eba24a39ecd02650ad892064 ]

Polling the completion can progress the request state to IDLE, either
inline with the completion, or through softirq. Either way, the state
may not be COMPLETED, so don't check for that. We only care if the state
isn't IN_FLIGHT.

This is fixing an issue where the driver aborts an IO that we just
completed. Seeing the "aborting" message instead of "polled" is very
misleading as to where the timeout problem resides.

Fixes: bf392a5dc02a9b ("nvme-pci: Remove tag from process cq")
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 0165e65cf548..00552cd02d73 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1280,7 +1280,7 @@ static enum blk_eh_timer_return nvme_timeout(struct request *req, bool reserved)
 	else
 		nvme_poll_irqdisable(nvmeq);
 
-	if (blk_mq_request_completed(req)) {
+	if (blk_mq_rq_state(req) != MQ_RQ_IN_FLIGHT) {
 		dev_warn(dev->ctrl.device,
 			 "I/O %d QID %d timeout, completion polled\n",
 			 req->tag, nvmeq->qid);
-- 
2.39.0



