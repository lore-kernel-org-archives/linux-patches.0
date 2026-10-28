Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210397;
	b=aS+/3SgArjuuaHUSiJek1wsTn9MeTGzgIFWEbn3FiEz4PaBeNU0dFm5Re/ziRDs0nvag
	 SGi4FBfBnaP9Aee+GbTetuhJve44WIz7NHhyu/fgwhwdEmoGDHn5n02WBCNFKWHZa+gWM
	 3BqSnk4sZreIavALcuQ9kIAcDUXa4DLnu+7ffcomnwZpfFQHvQRLQqZVHYtT9gmICAPTp
	 BZGGRBhp468IZcgr0OwI2Q49/y2WqiWB0EpiSLu6AnthsvcEpkHYfXGAhWWs1HPZcFSsa
	 ylOAaB92P6+CUAjohqwnIu5+XhZK/rYgUdoSosPaIRCtkOmAHrplWu7Un/R4TTedjgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210397;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AUiQ2B29Mm5KXvndtaXvzdLQRspRqn+2bHEmhWhJZwg=;
	b=plhzTQRls4ieZ2YddtNjstCsBIpPb5X/rAcYeGEDSYWOnEmoeOYTogC9/n0DMSOD9wfM
	 IqlFoxZXqAx5cdG4qF025OPX93LjOaVmQfZPNeqXdRB6FqvNK2+5zoZSwKvHuR+4r7+/y
	 vdyJwyMJf59caEDOAc9dnR+TfB05MUSb+5AfW1EcJWvnWxdjPnejvMlOG2RsNtsHTzWrm
	 9ZV625XA+5f3eSUtUWiYAWHdNTX1Og1035+KiKDMrfXsJoPZZZfnMPaGZwE0NFsbtjL0y
	 14ruMU0CACCYR/O4azRE/te5TfPm3phSswzINhRc109PdCPGBKrJSXGMsB6pUCbMaDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tKKWHqHk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95FD7606A31C;
	Wed, 28 Oct 2026 17:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tKKWHqHk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56ED1F01825;
	Wed, 28 Oct 2026 17:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210397;
	bh=AUiQ2B29Mm5KXvndtaXvzdLQRspRqn+2bHEmhWhJZwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tKKWHqHkZ0X44S1MTkouZQ7MpZZIhWMZvlw4iKY9WTyW7bzwTEhCvC/Y1G6PTZUr5
	 8ZEOqy7yL/K1H00l31i4wpIbbkCIeAZqdmQscDfG3UNTenEyFsysR2kio1OwKjeu/l
	 NlYfucaaQae27CWhYzD0p+OTzoadndUsWeE/4dbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 013/571] nvme-tcp: fix host memory disclosure on R2T for a read command
Date: Wed, 28 Oct 2026 17:52:40 +0100
Message-ID: <20261028170008.335241547@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

[ Upstream commit 6efbc52237facda35d2d874fe1765bb4839275d8 ]

nvme_tcp_handle_r2t() does not check the direction of the request the
R2T refers to. A malicious controller can send an R2T for a READ and
the host will answer it: nvme_tcp_setup_h2c_data_pdu() builds the
H2CData header and nvme_tcp_try_send_data() sends the request's data
buffer. That buffer is the READ destination, so its contents go to the
controller.

The command then completes normally and nothing is logged.

Against a test controller that answers every READ with an R2T, a 4096
byte buffered read returned all 4096 bytes, split over two R2Ts. The
pages contained stale kernel data, including an array of struct page
pointers.

Reject an R2T for a request that is not a write.

Fixes: 3f2304f8c6d6 ("nvme-tcp: add NVMe over TCP host driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index a832ccabb7b75..8ce4dc96313fc 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -690,6 +690,13 @@ static int nvme_tcp_handle_r2t(struct nvme_tcp_queue *queue,
 	}
 	req = blk_mq_rq_to_pdu(rq);
 
+	if (unlikely(rq_data_dir(rq) != WRITE)) {
+		dev_err(queue->ctrl->ctrl.device,
+			"req %d unexpected r2t for a non-write command\n",
+			rq->tag);
+		return -EPROTO;
+	}
+
 	if (unlikely(!r2t_length)) {
 		dev_err(queue->ctrl->ctrl.device,
 			"req %d r2t len is %u, probably a bug...\n",
-- 
2.53.0



