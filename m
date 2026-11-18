Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056925;
	b=pnbmGl+inLD9vfUx4+gAVduOtvguyhVRTAql6o9mqztqF9tuwOt4dZ9p/z5hEgcFLAIc
	 OakAIhZe6y3h6jAUpKQ3fxJV+nEXvz61tkU57g1JVFcKH00D1vHXo56EX7aLfyCYdZ+8M
	 v/ZjV36O8XAtotRfyuFHu9i628F/c20lpjX/jsQMopKVaBi2l4RcmNDN0rXjSefFcYT1p
	 9J0si/1oyt0xAQfeIuhIJ5dbcvOosaCbh04WVqx304MNS9RSbf/2jP03MHDIHpyaVE5iO
	 H23aith1ioL9OjJO+HSCZ642Huj+Vri1f0UysFttNCZtr5jB/gVGXY8CiVvhYk4qgRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056925;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ljMPo/AIum35PpHglcR/AVwpQRr/37ecd4o+O0EGX9k=;
	b=dChPG6bITzJwGrrr1+Ph77Z6Wd+Ee4rS6542pHOZSofVxHflgG5AR6V1oRTiAlMhJMcw
	 klD9bzOW6KJEHBeh0q6OuFI9rwNvGKnM7BAZIBU8FG83mLUTT1vSF6R34qb8Z/U0zpLGc
	 CPZm9qSMFr25mfBveUkcwWQ/TGLNujfBRYKaLxesdgHI/LCiUvVBAiS65vPj43a3xJTss
	 zCp2EfUXu6d9CCMzyWam3M+QLZJYhtcUXDi/Kc3qqhpLXHmHjp2ueIAmWihXMLzWCu+jU
	 4i/0lYW28dF8BP7KtdaQhQBKWZXeYTbc42WuYt8FD5DpOA06bsKmXSBA2aUNZ3OlRxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K9jmBdIl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE62A606A325;
	Thu, 19 Nov 2026 02:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K9jmBdIl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F5311F000C4;
	Thu, 19 Nov 2026 02:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056924;
	bh=ljMPo/AIum35PpHglcR/AVwpQRr/37ecd4o+O0EGX9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K9jmBdIlrKDrhU6lIUm7GEybbL5ZmJauD2uwudsG9945Kp2r65m8meczoJ92soJ/i
	 71cfHCnDtQAWgBenbrkx8+lZqsMrvTCf0b2pmxhog5sIE8DWxznbGkNH7dOFKTYBWw
	 gVsNPSi2fZFxnPrehcRm3e1/jo5ijxXeeMYHtUpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2160/2214] nvmet-rdma: fix double puts after a failed RDMA WRITE
Date: Wed, 18 Nov 2026 16:03:56 +0100
Message-ID: <20261118150136.856720004@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

[ Upstream commit f1dac2a2e75260d1466d9f03ccf0944d6d0449a4 ]

For a read with T10-PI the RDMA WRITE is posted alone and
nvmet_rdma_write_data_done() posts the SEND once the metadata check
result is known. By then the request has been completed and its
references put: __nvmet_req_complete() put ns->ref and the pc_ref, and
nvmet_req_complete() sq->ref, right after queuing the response. The
error branch of nvmet_rdma_write_data_done() copies the one from
nvmet_rdma_read_data_done() and calls nvmet_req_uninit(), which puts
all three again. A WRITE fails whenever the connection ends with reads
in flight, which is up to the host. Depending on timing the sq->ref
count goes to zero early and the queue is freed under the remaining
completions, or never reaches zero and nvmet_sq_destroy() sleeps
forever, or percpu_ref_put() dereferences NULL after percpu_ref_exit().
ns->ref stays too low for good, so disabling the namespace hangs too.
Reproduced with KASAN over rxe with a test patch forcing the PI path.

Drop the nvmet_req_uninit(). The branch still releases the RDMA context
and the response, which is all the request owns at that point.

Fixes: b09160c3996c ("nvmet-rdma: add metadata/T10-PI support")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/rdma.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index b911b33bb15c0..f4819e2976a81 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -803,7 +803,10 @@ static void nvmet_rdma_write_data_done(struct ib_cq *cq, struct ib_wc *wc)
 
 	if (unlikely(wc->status != IB_WC_SUCCESS)) {
 		nvmet_rdma_rw_ctx_destroy(rsp);
-		nvmet_req_uninit(&rsp->req);
+		/*
+		 * Unlike in nvmet_rdma_read_data_done(), the request has been
+		 * completed and its references are put: no nvmet_req_uninit().
+		 */
 		nvmet_rdma_release_rsp(rsp);
 		if (wc->status != IB_WC_WR_FLUSH_ERR) {
 			pr_info("RDMA WRITE for CQE failed with status %s (%d).\n",
-- 
2.53.0



