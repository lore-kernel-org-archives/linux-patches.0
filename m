Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062152;
	b=EcrlCNIpnBxJVXTy46Desc8jRpikg2FDTpbyLLknIl6tXYtSNMyxvbXwoaigzhQSCyxF
	 KIxA/rZ0iVEQ5npkKMOLSJ4kUKGBhU9mjNN4pvl2Vt0dPo0ZIqtXSaxDQPrroggsHHi3u
	 NvGvpO0Kiv7KrLwsCjEViGSHWp0Yv3g7Pwgez6mR9jibuVtZMacTcX1fpeOAUvQQfWwx3
	 aChQOaSo7BFFVmgDgaoFdSx3GClD/QIwKuEQB3I3e1mj+Ka21BYNxZGpOjlTjE54U7DFT
	 3TSG4lyIIY8N0Q5y43LNRa+ZPQB3uGPub5ps/mLZOTBp436ezGmWC8V78PvkyhLM+9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062152;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5XKGBxjKWMOaynxkQvqxjLF30tOEOJRWHDUi+eJEyQw=;
	b=kcBeO128II2ePyQf/70XMVYQBqbFi8fOzt3oIc/CFEQhWuwaoFxzTGm63X8IbQZwgjyf
	 0mqJNX2FEN4SeTi7EG2EH+zyfUR/BZvzfTM2draLHLOzwEQDJJGbe4twHk/t4WoJJFhSP
	 Vd/S5Ximz2SLjCPvQZgbK8tEy7qBlzgxpANPAaNONKP00swfzCrH7xIDUgBamo3tDholD
	 Ryvful0zJ+qkqs6szGXoxxnbSCf1YKKLddoBqHiKyWK04napRZYKPTMsPdP9I6bynG+Wi
	 JGfFs5QgNqrXRC21TsTckTkdvNGFkOOgMNVmsbjgI83zIoD8y3lrZvP55ozQ2DAAFew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ADvDICGz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3654E606A320;
	Thu, 19 Nov 2026 04:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ADvDICGz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 938771F000C4;
	Thu, 19 Nov 2026 04:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062152;
	bh=5XKGBxjKWMOaynxkQvqxjLF30tOEOJRWHDUi+eJEyQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ADvDICGzavFCLSGTEksxY8SdgpZ3NMKJkTLNCAbMENe6c6sPRUl5SEXY8oG9Uj3k7
	 6owKQYr0evOsUcZr6l52I3puqL6MWbpa+59Eu/DXp+z3IgK92RxN+a8bexfdqUR51+
	 qI4NDT8L+es2idkZ5/JlD3VK47M/SEDA+D35f4hs=
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
Subject: [PATCH 5.10 1807/1848] nvmet-rdma: fix double puts after a failed RDMA WRITE
Date: Wed, 18 Nov 2026 16:04:05 +0100
Message-ID: <20261118150034.959186650@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b1d447cf599b9..6f72d4fc9b87e 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -801,7 +801,10 @@ static void nvmet_rdma_write_data_done(struct ib_cq *cq, struct ib_wc *wc)
 
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



