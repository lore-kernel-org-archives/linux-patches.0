Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585256;
	b=XxIgONDUH25AWWgSktxHeL+XzE+JZfJ0QCrzdG7Cstw9gzDelbXAu3I9HjYhFjrmPje1
	 S4l0UhQBVxS8h5Zrq//tm48R1r8XoPwZNoucpayeEIQxkzJQq1q+3yv2Y1wgrEFaF1WgI
	 5SurZ9SjYTM0QFhFb7fEgXahnafSKRiR3KVaYdxu0a59nUb7wqE+zHKpmi1+MI2d7Gk3X
	 H8mC3NAYdGuGgFjQTSRGR05vNNlNFlM8qkMWUxtreB+70V/tMnMEKkPdBpK6P43aFxvcu
	 AfvOAD/oYVKmylkDMQyi6lPt+TMbwrEjtFVDK7leyM/RvgckNlcnLvJ70acDwvC1aOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585256;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YKCoKJsIZyuzOnNcNqOXjKQ++zSblsWucwHPwzZrm9o=;
	b=PxI2OnBt+e0tczI1aI8D2lRQbD7FUwM1nmlC+l/RsJemBCfVBKWdxYt/zRgB+462LAW7
	 0F/3M8ZizCILLZr1vOXXbHeKvqA/2ykRViU5EJFP4Vc42SMRk3HP7q0Tawe4hjTgAifqs
	 lNmvBhDk1PoyMPyF66sNyDjzzEpfMSCYHCsePIebH5qv8NP1BGX6X8Vaf38r9mZpIeC33
	 pNu/4UVEp1y/JmyUiJcsFUZ34pcOQRR89V80Y5665j2Gep+3giYmQEgnLmIdEt+C6dWES
	 6J/5xV3vRF2wUeeN5cjKQI6/42rtgOA7/IYCS9arEbka4AO6Fv6T7VKTc7paFyOTb5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QDzvKWDS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E84606A330;
	Fri, 13 Nov 2026 15:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QDzvKWDS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D14C1F000C4;
	Fri, 13 Nov 2026 15:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585256;
	bh=YKCoKJsIZyuzOnNcNqOXjKQ++zSblsWucwHPwzZrm9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QDzvKWDSioKoCDOicQRXNKpwujKXju/6jIhCRHdPuGYvvRdEgwXhKQRsolTsS+UBi
	 mXO4OGGXbFQG0of9mDq77gq+dK4ciwfa9cq6h8M9YYUuIf4WuZcMLT8nqYm+VOGjhq
	 8XxTBhI/IToWSDr3VaW1CWMIplOguCWD1ZLONM5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Keith Busch <kbusch@kernel.org>,
	Andrew Stellman <astellman@stellman-greene.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 005/686] nvmet-rdma: fix out-of-bounds write in nvmet_rdma_map_sgl_inline()
Date: Fri, 13 Nov 2026 10:42:18 -0500
Message-ID: <20261113153821.115586329@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Stellman <astellman@stellman-greene.com>

[ Upstream commit d1512773a0d539669440bd9f6d050b8e12923b5f ]

nvmet_rdma_map_sgl_inline() bounds the host-supplied in-capsule SGL
offset with "off + len > inline_data_size", evaluated in 64-bit
arithmetic. off is taken straight from the host SGL descriptor
(le64_to_cpu(sgl->addr)) and len is promoted to 64-bit, so the sum
wraps: an off within len of 2^64 makes it small and the check passes.
off is then used as page_idx = off / PAGE_SIZE to index the fixed-size
rsp->cmd->inline_sg[] array (NVMET_RDMA_MAX_INLINE_SGE entries), so a
crafted offset yields an out-of-bounds scatterlist index that is written
through in nvmet_rdma_use_inline_sg().

The mapping runs while handling a received capsule, before the command
executes, so a remote RDMA peer can reach it (the Connect capsule is a
write and takes this path on a queue that has no controller yet). The
host controls only the low bits of the resulting displacement, so the
expected impact is an out-of-bounds write that faults the target
(remote denial of service).

This wrap was reported, with a KASAN reproduction, on linux-nvme in May,
and the check below was suggested in that thread. The fix that was
applied, 48c0162f647b, reworked how the offset is mapped but kept the
original check, and its page index turns a wrapped offset into an
out-of-bounds index into inline_sg[].

Reject the offset before it can wrap.

Found independently by static analysis with AI assistance, not
reproduced at runtime.

Fixes: 0d5ee2b2ab4f ("nvmet-rdma: support max(16KB, PAGE_SIZE) inline data")
Fixes: 48c0162f647b ("nvmet-rdma: handle inline data with a nonzero offset")
Reported-by: Bryam Vargas <hexlabsecurity@proton.me>
Closes: https://lore.kernel.org/all/LM21QIR-1-qJb7PViyJKCnGBnUzizeiNJVWQ3wb7ZwGezodjgKg3f-iobqOyequ-sT1jFCKJImfqNO_BKU3KO80xFITnaI5GTV_GxLUNDDc=@proton.me/
Suggested-by: Keith Busch <kbusch@kernel.org>
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/rdma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index a0ba6641c7ffb..ae44a0ff34d74 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -864,7 +864,8 @@ static u16 nvmet_rdma_map_sgl_inline(struct nvmet_rdma_rsp *rsp)
 		return NVME_SC_INVALID_FIELD | NVME_STATUS_DNR;
 	}
 
-	if (off + len > rsp->queue->dev->inline_data_size) {
+	if (off > (u64)rsp->queue->dev->inline_data_size ||
+	    len > (u64)rsp->queue->dev->inline_data_size - off) {
 		pr_err("invalid inline data offset!\n");
 		return NVME_SC_SGL_INVALID_OFFSET | NVME_STATUS_DNR;
 	}
-- 
2.53.0



