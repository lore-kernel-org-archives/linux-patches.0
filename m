Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042585;
	b=GIAVaHGHGmPx7GCZb1eq6Hv76+HE4GBk48hcvsDwmgHuOAM3bgFYLtbqPYB1PUMWqKzX
	 iljlG3M+ONEmhDMlPjzCtXwxsXBH/LWVx+TZ9Y7ime+eCny0E5ys1fmIJw44IFYvS0W8M
	 hOP2RoZnBBlrYPMNf/S0qp8W58xKtyeuzdR3bhNYX7AkFZp9agNgFwEE9pq6cED1orEC+
	 X+vHbZKJbHOeqgdsvRARp7JA9aATRlY+oNCgPwP3IvazVxWfffuvblppYGNqUbRgOfHFf
	 +NQCUdEX583uApuQ3jpXM9Iij5POndLwUDCvwr5RzgSibNZ5WEtm7HzElypvJrwp0Qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042585;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oaid6C8kxa74lkVia6DB7TlUre0uQxCHSMOShV5TA2U=;
	b=icRy15qzH3CYolF/CrcKZNrN1j1JuqTnSoHFGi4Q7K1FYBI704w+KSob2zvKxYHXlF3t
	 u0coS6Kas+9YOkl+ZN1lzj23fLbQlNoqkpKd3MdFwk6Bu/EmSoEDQACoAgGG0TOzz9Kpe
	 1G40TkJhbhi7DjiIdfrOHix0ffmn0COszW71hS92W0HvDwv1qS5iyMXwcrOHmu0Cv7knH
	 EOO2HCDgN9iIpBo2rJmfPgBPTVirw3ACPrq+9iljqxeldlaXfmYHF9fP1iwM1WCmVzGpv
	 gqSQUxF1cvXJpEMZCz4nYnpE79smjuA5WIC/Bibyg4Z/RUcY+7IMeUwMaZWjbYNcUDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QddP28zP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61744606A325;
	Wed, 18 Nov 2026 22:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QddP28zP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8D01F000C4;
	Wed, 18 Nov 2026 22:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042585;
	bh=oaid6C8kxa74lkVia6DB7TlUre0uQxCHSMOShV5TA2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QddP28zP3lhEGg4H+QxiMRZ2cMYUUR8+nybFeNwFOrrSCkYq2qvjFBZWtihtIfgHa
	 D+wDplve8RGWuOHKLLyZDVmsAM5SGGw2z3pQRKdhj+pG7332T0zhEaK7k8uKBHc212
	 zDFk+idJ9f8modv3E88+cePJVtHY9wHiZSxY/P8c=
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
Subject: [PATCH 6.6 3223/3318] nvmet-rdma: fix double puts after a failed RDMA WRITE
Date: Wed, 18 Nov 2026 16:04:05 +0100
Message-ID: <20261118150456.415503510@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 84ed94dbf9701..87f1a4b6f4b9e 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -804,7 +804,10 @@ static void nvmet_rdma_write_data_done(struct ib_cq *cq, struct ib_wc *wc)
 
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



