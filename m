Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D252517B50B;
	Sun,  1 Sep 2024 16:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209550; cv=none; b=YUfoD3IUOfFA1EWqZVmwY2hVevHoClXhiTJr+/G0TyrEKJvkH70rOm6ICjufC4NDF/fzQXc+Hhz9N1Sjb+W9hYcxBN90qttNdMDJEpCMqH/6CinAjT6R1XxITx3kvlH5kJFgOUicfZeEiymeyXw5zJJA1bY1Mq/9mMbpWYclZLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209550; c=relaxed/simple;
	bh=g+SsTHGXFwafjm/1GekxbHOwWnaFRV6Sw3y0UO4n2KM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XtDL7TCv4la+yhoFnKLfbE814LikWzVEl+kl0is6+LWAfbAQAOt82+ssubedy8xhqJ+uHGr4mQjEaQEIxJhL9PtRtTzgepuVCyiQXBMTdwermQyRDUXvJvVvYl9ojxfErFiEHUBJZL6sgTXZWVA8fEjVNhWmM+Y0nqWCvT1q6jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRJB/lTc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRJB/lTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58ECAC4CEC3;
	Sun,  1 Sep 2024 16:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209550;
	bh=g+SsTHGXFwafjm/1GekxbHOwWnaFRV6Sw3y0UO4n2KM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XRJB/lTcDLbZjc+Vl5cW5iSiXK/T+loi5mLlP4kfvhdHMW9nr1C7Lq/S/eXqj19XX
	 /U1pxl50IoydnJVu7WCxYURX8RSo+Mj7iyMUPzqxZBlMmrQpCd1ALWJz/NW14VYBWO
	 WOpm1ig7sI8tPpOAN5fosjD0oZaCsWk2UD4qVqpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 072/151] nvmet-tcp: do not continue for invalid icreq
Date: Sun,  1 Sep 2024 18:17:12 +0200
Message-ID: <20240901160816.823770705@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 0889d13b9e1cbef49e802ae09f3b516911ad82a1 ]

When the length check for an icreq sqe fails we should not
continue processing but rather return immediately as all
other contents of that sqe cannot be relied on.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index d70a2fa4ba45f..e493fc709065a 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -846,6 +846,7 @@ static int nvmet_tcp_handle_icreq(struct nvmet_tcp_queue *queue)
 		pr_err("bad nvme-tcp pdu length (%d)\n",
 			le32_to_cpu(icreq->hdr.plen));
 		nvmet_tcp_fatal_error(queue);
+		return -EPROTO;
 	}
 
 	if (icreq->pfv != NVME_TCP_PFV_1_0) {
-- 
2.43.0



