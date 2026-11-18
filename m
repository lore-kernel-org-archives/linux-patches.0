Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028134;
	b=46NgZy/vfqvHeEki3CLIK5NTEemUwXJEb0NLdeOXt+M2d7qCuxg2tYItUL0JnE3ZOzdB
	 a4kWrpyvhv3+HK1+NmZMO3EyneXmnLNrNzoPXBVKrKH+ueMZd3aNrN+3sYb7R/5jaiPB/
	 oluQ9vCWCjtTLu16X//eA0V1e1LHjW8wg1AuaHCLWysYg5LgB0qtI8FO1nvcT0LXJmQwd
	 IsSTTyrxI74H0hcRnbR5kXQh73g+fSJYthrnt1OyFB1bzeIP3paz4CTbmkguW7LkyfMnU
	 FmLJLSQnk6uBU2LjX1U5DhR9ytBbCEeuH99TKPur16BvNN0TDlKezgpJta+DkFqOKog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028134;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q35FdxzYNWUFgCCQO+/TYDkwc+WC2DY2P2NhUwVGFzs=;
	b=gpWP0vyJdiuI0VTMrvN/iWyC374gn1crU9m7W3mNGnHWuxMxaISyK47lRc+xoaYpjaDe
	 w9cR3V335sD0ThMU7Uev1mzZu8df8vd+c28O4TD869jUX762QldYiHyMTHeXi0eTI4lBj
	 5/ZZDlX2R99DBxY5OKyLHsZe6GtpJ8tvaOG6lfzS8okeMAoI2rgRBwA2BYTstYJnrIZ3o
	 CMbKHcM80yvgQfjaUawGaU6CJM5ImvtLaNhz9VnXNbrXokK9Jt1AOGefHBhJkvb0K0upV
	 DoSKYvSeV+N0dGbc3ab6uvg/r1tQCJ1H1/j5F7E+rSuYiV+HkawkL9UjYP5Jd7jE0Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yn+LwKYt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCF0606A320;
	Wed, 18 Nov 2026 18:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yn+LwKYt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE411F000C4;
	Wed, 18 Nov 2026 18:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028133;
	bh=Q35FdxzYNWUFgCCQO+/TYDkwc+WC2DY2P2NhUwVGFzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yn+LwKYtXkIRhdddhksCvdytCJof3y47hjTpOwEbmKcjfte1pemnV5DEZOOx1Kphv
	 RlJrwVD2Bxi1dPpwkZ+ag7Jv5Ipj6hnL7sUpgEKaXdRzvE59PoYuXrZ8Fec8ExjAtr
	 eUhL4RzpyfZV+x4Z6gdiBjhlpULvnwlea+39lUFE=
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
Subject: [PATCH 6.18 2036/2151] nvmet-rdma: fix double puts after a failed RDMA WRITE
Date: Wed, 18 Nov 2026 16:02:51 +0100
Message-ID: <20261118150235.901988074@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index d1b47e6287581..20e574a4eac64 100644
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



