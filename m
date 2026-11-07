Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065523;
	b=rj+7gzeaf4Nb8a+aBZzH171Namb1rRZboUz2/fC32P9w8QWrNE+gZoG+af5pkwfzprGh
	 yGGaLkfgF+qWFAPebn3i8ntqcq1SvYlG3SVOEOJ8OjAznZ+9JstP1vSUuXZtqV6wCY2eC
	 h6HXkHc8AvqORn6e1e5FtcP6Nez36uw4aKuPfnN/yapWIy+4EpnHzOPWcX4kdxbBqQnri
	 uoVK4MOJwBagTY78dkh4wLRkeBxT0eRKae/bacJ8DXxcrpU9IC5aAjkb0qaaQI8mgrCcU
	 AjsL3SOV1BTN5VFtKHt56eWSNAHp3IwzlnOpgrIt/kOgJyJ6YoXBwCEdmDtOMAUph4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065523;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=07mKt5yGOLMYWFh5xdT2UJs6blZtgWAuxZMSfwrbAdo=;
	b=5I3QF+kXg3+70aPuNXQRjygE1PhS2B/n592vF+/XVyztJtJ4l1XsFHFCIKexQFzTgUMY
	 DOb4L5x4oNTRS6q3biK04Un7W04FHbxfUiKACXGuo7AD6hxaxbXq0RumlOcp4LjdxiLIj
	 w/2SCcEhd3pYUa9RTGwNPYqpZAABqEUsvTjT5XiLqe89ilIss+4pIqweZJHHlWNqswt3x
	 GcHNgyCzNIQx4Q73VSLpJJExlJ86DpqfMjo+WC8HlQQCWNDRk1SEbOXO0L7kfy8mcNTFw
	 zvsmPEvvmPvMD67X8A3GzNIBwV98iufEJu/h24Ng68L9Ldr9n007O6LSm6DnWvY95uQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CfTR9vM6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7F9606A32C;
	Sat,  7 Nov 2026 15:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CfTR9vM6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31381F0089F;
	Sat,  7 Nov 2026 15:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065523;
	bh=07mKt5yGOLMYWFh5xdT2UJs6blZtgWAuxZMSfwrbAdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CfTR9vM63YWQVinvjxoaezHhPwtTXthp2pQqOZ+9txF+sh6pLTXirgeWTWayYjAkX
	 an63H9/gQUegBYGsZDGN2mg6rnqZ1cYRzB6VH3tc6VdWCjTnmcJNsS/SnwATiiBNqm
	 UkQ3BTuR+i+Oe/QxYTLQsg5hWmLmJiKYPc4P8+T4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Keith Busch <kbusch@kernel.org>,
	Andrew Stellman <astellman@stellman-greene.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1202/1257] nvmet-rdma: fix out-of-bounds write in nvmet_rdma_map_sgl_inline()
Date: Sat,  7 Nov 2026 08:58:18 -0500
Message-ID: <20261107135012.553340102@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 075ab58d8c884..ebf4a7bde524b 100644
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



