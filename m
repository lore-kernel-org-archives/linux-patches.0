Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CDE38DC7;
	Tue, 27 Aug 2024 14:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770342; cv=none; b=nvCWe4nEewKJ5iamkvqAlLTpL3IoSH5saUKtJW4gRO4hBcmZCnXNxlZTnHT1JBMcDPWHQlZa3yaeBV4Ji2E41g7J/ytRIZAEf6AEplzVSyg6txA7nkO1faS5PF4EqGMhXM0TINSvL1mD3NFvdV4bWsl6gEgZN+/xDiI3In75EjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770342; c=relaxed/simple;
	bh=guwWlVP/n5ERVAbIWm2Lt3CLjYf3REe2p7fGLBHB1Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mtioqxPOY9Y8VmpweCW7argqL4uERhxGosPW8OdcwlVETgTcH4+STZS1qgvwe6EZlsUh5hg4muiKphjFErZyk4dqy/hGFfamBEj4DGKzwamf73sWQPsYMshlr/jZWm08sytyJrWHoDIlVEV5V9LteW8B9+Heqnc0VlE1sJ5f2vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VfEmVVal; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VfEmVVal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372FEC4E673;
	Tue, 27 Aug 2024 14:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770342;
	bh=guwWlVP/n5ERVAbIWm2Lt3CLjYf3REe2p7fGLBHB1Co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VfEmVValWTHlsl7MpDQPGpRScncHpT8+5mLk6imMI2n67W+bShFck1mr/SHuQSRIC
	 5onzC5tx/3jhEOheOG9H4pjckjdcboCpH2JtyKY30vteQ/hxsGel9UYgv+C7MsTsNJ
	 Tfy9eOoQfctKhfx28KD4alnl2oOW+sG+X0CIvdFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 201/341] nvmet-tcp: do not continue for invalid icreq
Date: Tue, 27 Aug 2024 16:37:12 +0200
Message-ID: <20240827143851.064679520@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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
index 3d302815c6f36..c65a1f4421f60 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -875,6 +875,7 @@ static int nvmet_tcp_handle_icreq(struct nvmet_tcp_queue *queue)
 		pr_err("bad nvme-tcp pdu length (%d)\n",
 			le32_to_cpu(icreq->hdr.plen));
 		nvmet_tcp_fatal_error(queue);
+		return -EPROTO;
 	}
 
 	if (icreq->pfv != NVME_TCP_PFV_1_0) {
-- 
2.43.0



