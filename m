Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063387;
	b=ddFDPQWBpUE7lxS+/kTH16f3G20ZaZOExFSkfGuOIgTmlDlYjKUCLEkGug6HtGfJtyGx
	 sryBYH8AxAQyKfxADIGmwZWd5awJYHGJELkHt+xj/CBHskRZDpkl/d3Iqg2zcf44Ymf0m
	 aZKuMJsX8cw8+JZJZehgIaBBgjRcXi5/CetlgS6vMtvweDszvieaBPKPhtD0rLVZi6rQ2
	 dxUb1suGUJ5PszFdCvjZ8oWJjewO2FkI7qaQ7D1a+SfoP4woMobiCJxaXZVzxVOJXeR5M
	 PCbmHGobp9Oi9LyC5U4kOF8y6kXXZlhl3n690VP8KHDjgDSk5ck4WxBPdB6grGOI/uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063387;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1SFuLUiFKjXNreExHLsRDvP27dlTlSRVCYrQvEcDTbw=;
	b=p7zbWEABm08dLr1/Y4skPppSxTnWMxy+eymuB9XKOUohzrKGst4ahp954N8mD2tCM7UU
	 j1nmUQe8YjwQfVppkCM9loxTiHsdFTLzK+7qMFXr7CAEkZjPC1B0t19BZJES8E0cizSNm
	 3Fk4fFGUwaU90gLjn0Hhmz6pij9J8nRXbqiZ1tcT9fYAvBAWTF6GZEtqtDNY6W2Rt6M5E
	 5IdQAhqWoFvIi+Iwrm4qnIITopqveIV8VcraGstlwyOWZ1MFD2YKb4u+1xYU8V64ubD2K
	 2K8mWNck2J1QBivKSNkWSfrpHgXbfhp3tb+sidmB6j3kCTiBcjyu4s0TzplyazKYVFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f+3Gy+hx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5182606D816;
	Sat,  7 Nov 2026 14:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f+3Gy+hx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6062E1F0089F;
	Sat,  7 Nov 2026 14:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063386;
	bh=1SFuLUiFKjXNreExHLsRDvP27dlTlSRVCYrQvEcDTbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f+3Gy+hxaBHmg0cVrE6PZHbeEtUjeWqOLkj5QcnDmCuxVCstDpxNJyCDSiniMVjKh
	 jaAuJvPpWnEtFbxMqDI45cnn3rU7iAhBz2qgi6VCezRc+UP0PMonpDhXxwKb4IVoLB
	 xUMBKvtFsRc53G6SpYpU0C6BDLWbgzc1onYk4uiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Andrea Parri <parri.andrea@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 521/869] nvmet: zns: dont leak stale memory in zone management receive
Date: Sat,  7 Nov 2026 08:53:23 -0500
Message-ID: <20261107134911.181195215@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Andrea Parri <parri.andrea@gmail.com>

[ Upstream commit 31b8a6af19b73e6167c4b655cd5e86681bac1c41 ]

A Zone Management Receive report returns the full buffer the host asked
for, but nvmet_bdev_zone_zmgmt_recv_work() writes only the 8-byte
Number of Zones field and one 64-byte descriptor for each matching zone
that fits. The 56 reserved header bytes and every descriptor slot past
the last match keep whatever the buffer held before. A 4096-byte report
covering a single zone leaves 4024 bytes unwritten.

The tcp, rdma and fc transports allocate that buffer with sgl_alloc()
and pci-epf with kmalloc(), none with __GFP_ZERO, and on success each
sends the whole buffer to the host (nvmet_setup_c2h_data_pdu() for
tcp), so the host receives old kernel memory from the target.

nvmet_bdev_execute_zone_mgmt_recv() also never checks the transport
data length against NUMD, so on transports where the host sets that
length, the buffer sent back can be much larger than the report NUMD
describes. pci-epf derives its data length from NUMD, so the length
check below does not apply there, but the zeroing still covers the
report.

Reject a data length that does not match NUMD with
nvmet_check_transfer_len(), as nvmet_bdev_execute_zone_append() does,
and zero the report with nvmet_zero_sgl() before filling it. Zeroing
NUMD bytes is only enough because of the length check, so the two go
together.

Allocating with __GFP_ZERO in the transports would also close the leak,
but it adds a memset to every read command to fix one handler, so the
transports are left alone.

Tested over the loop, tcp, rdma and fc transports with a zoned
null_blk namespace: before this patch, zone reports carried stale bytes
and a data length larger than NUMD was accepted; with it, reports are
fully initialized and such a length fails with Data SGL Length Invalid.

Fixes: aaf2e048af27 ("nvmet: add ZBD over ZNS backend support")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/zns.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
index 95af4b67108c7..00f694ac3986c 100644
--- a/drivers/nvme/target/zns.c
+++ b/drivers/nvme/target/zns.c
@@ -286,6 +286,11 @@ static void nvmet_bdev_zone_zmgmt_recv_work(struct work_struct *w)
 	if (status)
 		goto out;
 
+	/* Only the zone count and matching descriptors are written below. */
+	status = nvmet_zero_sgl(req, 0, out_bufsize);
+	if (status)
+		goto out;
+
 	if (!req_slba_nr_zones) {
 		status = NVME_SC_SUCCESS;
 		goto out;
@@ -314,6 +319,11 @@ static void nvmet_bdev_zone_zmgmt_recv_work(struct work_struct *w)
 
 void nvmet_bdev_execute_zone_mgmt_recv(struct nvmet_req *req)
 {
+	u32 out_bufsize = (le32_to_cpu(req->cmd->zmr.numd) + 1) << 2;
+
+	if (!nvmet_check_transfer_len(req, out_bufsize))
+		return;
+
 	INIT_WORK(&req->z.zmgmt_work, nvmet_bdev_zone_zmgmt_recv_work);
 	queue_work(zbd_wq, &req->z.zmgmt_work);
 }
-- 
2.53.0



