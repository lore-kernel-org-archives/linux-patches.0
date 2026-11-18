Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022219;
	b=RK4DEx4PClB3pSbk4oQBzSShmTTdOxAZ+Kk1iXxt0Kwg5hwA4rwb60p+rYDqjaNiNyRX
	 RMSBhbxM3Kj3FFI7+3OuuFIyfy8xNaD+uw8ypdiDU5caKJwAFeKuBxxNqzFFmML6/FY0p
	 Ek8e8y50+zrxY8Z5UmNexUoipfhlIuJlSG2dt6JZegnXPYWpYq7gXxK/XD2AaeO/wk1MU
	 XBiXl+I35dAkagme0XwQp9m49goFDXGGn9TYZmLXXDpwtwNnX9ZWvCKD8rbkimapdagXM
	 7exmT11zebH7ZztctOIGhsWyCHp3/glhr/yNVgnJeP04xUEnqwXfwT7PkD1RVTedAnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022219;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xKiWgtWegBcosKwZoLHjEKwAgAOFOitYr3pea1arfOY=;
	b=IuPlWqJ6DCv42NcSRViztxHsF6//u2A5I7gumMy86pVaHmQ+ii8mXA5aAy19U1AZ2i3W
	 ybOrfuuTI1Y1IkVp7Tb7LA42Z7yQycEhjpWoy8mzoEyVq5y/n5Ho9H1zlFN4M2/rUmf6M
	 zqnR37kTSTy9+YmW4iIsOe0f+JSSCRgB70Wm7A2QtfUSHyGw1KI0vrY7pCr5EB6wVspOF
	 Wl499pIG+jKGge9MgfflzEYrR3Sxqb8l35RNl0P4OAFDJC2jqwuE4lJ2chj9+CZBazQJ2
	 Vz4m3rZOoMWtjfbOKkNO+iLc+cGeJxBslT4pej0zyEmp07spxUtLZqPHEFSi85PUevg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JANB+fdS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CD6606A31C;
	Wed, 18 Nov 2026 17:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JANB+fdS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2BA81F000C4;
	Wed, 18 Nov 2026 17:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022219;
	bh=xKiWgtWegBcosKwZoLHjEKwAgAOFOitYr3pea1arfOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JANB+fdSDK+JiFa/JBaZizJeuUnH8ZfsRBrXqOt6fkKTZYNQ89G8x/cGK01m2yYML
	 iIolxPHfmH5ZonsBoZqGTQ02s039JfxfO00O9XDcWevlG8tRMTV9S/JasCr3WEhk6F
	 03t7hqiD9PY8bXg45s9E4PoicxKD1xkH29ZJ8G9E=
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
Subject: [PATCH 7.3 2543/2651] nvmet-rdma: fix double puts after a failed RDMA WRITE
Date: Wed, 18 Nov 2026 16:03:03 +0100
Message-ID: <20261118150416.093050901@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 279d0d097b55f..b9e39d1657d29 100644
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



