Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEE956B68;
	Tue, 23 Jan 2024 00:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970046; cv=none; b=h23vm0mSzdQv0+QFFg0v97dEGf6ZmfqnJcXcdlFzfwqWBpJsECBA+vpxbRAn9myY4uHlBb/GYjz1JrM4bwTqFOXqs+Q9zf4xamN+uAs2L2awoW6RaM3mgwBsCb46C2p6EMAaRuo3AgPxWIbCp7yOXyCF6I57410KV784mQ1yDdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970046; c=relaxed/simple;
	bh=yIvZ9jDMQgW46pcV1/MPEHhIDlvawumthv4vFU/BFJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQiLN0YHPig2z+0mYgls9IMnZY9lGcB8CxfFDkrTpEtOtnPeUwHaYWpKuH+b7dgUlSeU+ThFiCy9LhyyhNWY28ypDV0OmkFt79HLv651CiuuPFXpuAks3i4rkNwAyxkPUMgVCw8Pv1AliN0PT1KqbRTUAJF9oaYlGz06lqLLkHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UJL+Sn/G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UJL+Sn/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DD7C433F1;
	Tue, 23 Jan 2024 00:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970046;
	bh=yIvZ9jDMQgW46pcV1/MPEHhIDlvawumthv4vFU/BFJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UJL+Sn/GE5GKgn16/1keFa9yIuXBwJWW64LeZbgKUCyHZiPOUF8ito5/mTd89a2I+
	 zmsqo7eVZRzgc9oA2QnG7NloKLX4L6a2c/3Y/F5ilKDXPeEF4cCbzSZUVe9MhMKxKR
	 Alp7MA5qBWUdeyFRaOISD0s8jNQ9Jc4ZtFsENIAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 555/641] nvmet-tcp: fix a missing endianess conversion in nvmet_tcp_try_peek_pdu
Date: Mon, 22 Jan 2024 15:57:39 -0800
Message-ID: <20240122235835.513620220@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 3a96bff229d6e3016805fd6c3dba0655ccba01eb ]

No, a __le32 cast doesn't magically byteswap on big-endian systems..

Fixes: 70525e5d82f6 ("nvmet-tcp: peek icreq before starting TLS")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index b4b6a8ac8089..e5a2cd9e8c13 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1778,7 +1778,7 @@ static int nvmet_tcp_try_peek_pdu(struct nvmet_tcp_queue *queue)
 		 (int)sizeof(struct nvme_tcp_icreq_pdu));
 	if (hdr->type == nvme_tcp_icreq &&
 	    hdr->hlen == sizeof(struct nvme_tcp_icreq_pdu) &&
-	    hdr->plen == (__le32)sizeof(struct nvme_tcp_icreq_pdu)) {
+	    hdr->plen == cpu_to_le32(sizeof(struct nvme_tcp_icreq_pdu))) {
 		pr_debug("queue %d: icreq detected\n",
 			 queue->idx);
 		return len;
-- 
2.43.0



