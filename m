Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036536;
	b=ZV6nsm1pCRJd9lIARNWURSX4jZwoeXoRirUEjgE9g77HaJomVk9oEdrfZA+094TYDdvf
	 9AjISHl4QXd9rcXowqgRjwI0eDpHzikxJawjwHgoIIw1KZPbUHCW9RcNBq8aYy/p29FIs
	 3ndW4BZKDU06z28b2z0tJT4ckyIqLYLnV8wsLWfZ0HVXMoRl1tg4VmcOANR+Zmp7Q2iyZ
	 /tkFqTIXXwGXIRbioH1WQDcpu4NzRrLUkza8NHflYX6wo2PtUhuLD5ao9x9LJJUwogUSD
	 FcFlO/wtXkBIptcmyDVjWK8aa40GNdCsDyyNwBWcjr5C77iyk35FzOZf7IDVWA6mZ1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036536;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DoKwsL4K7L8vxMfLihhapDier1o2+Cgk9cWPp9o7azk=;
	b=QkpP94q3P7E1WddM6I5NgoSCuxrUWFEPv6LScZU6z0tcDHSbvqu/Ygagz55DUucmppk9
	 jros/yfiYc2GMx9CDO0/9+XPQES45Pb5403GRC9MH7SOtfQtidMC6mL0sZn+dtW6y7aIx
	 fHPBByrZY04pHglWhX25HzBiLOIbksqgSWe7boxVhyMq5O9PSw/CYhN6IZW6ANkq48xDL
	 adRHVxU6tLoi0Oq4ZEHv4YiA8d09eVdtAlXgW/71cUgXdOaFEtAfE2DXplSKm+ekbR0qb
	 jBuGl9Pgx2+0P6J1GYGzSpXw38D52Kru2Vyv8RsXtk4YNO8FUyh/57UuYULfVuLGCsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gRT1ug7s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25A8606A320;
	Wed, 18 Nov 2026 21:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gRT1ug7s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1EA1F000CA;
	Wed, 18 Nov 2026 21:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036536;
	bh=DoKwsL4K7L8vxMfLihhapDier1o2+Cgk9cWPp9o7azk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gRT1ug7snDQ/zhXeUThB5fDQxgbZRUe2qWr2FfAj6W+AqYHApFm5pztMR0kDBvdxV
	 lZbMBfhlEKordFT2SfJaYHyLe8kMlBCv5rh6SGydaEzLbb77md88PdYmRlxRuGTgw4
	 cIRvEnBNSFDA6tMspbldqMxJsN79SWDkqO4QzwCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Andrea Parri <parri.andrea@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1094/3318] nvmet: zns: dont leak stale memory in zone management receive
Date: Wed, 18 Nov 2026 15:28:36 +0100
Message-ID: <20261118150352.797897363@linuxfoundation.org>
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
index b7f48a24cc6bc..34b30ec859c99 100644
--- a/drivers/nvme/target/zns.c
+++ b/drivers/nvme/target/zns.c
@@ -290,6 +290,11 @@ static void nvmet_bdev_zone_zmgmt_recv_work(struct work_struct *w)
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
@@ -318,6 +323,11 @@ static void nvmet_bdev_zone_zmgmt_recv_work(struct work_struct *w)
 
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



