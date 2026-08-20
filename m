Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBAA42AF95;
	Thu, 20 Aug 2026 16:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244103; cv=none; b=TdhwASpF5bzR5l22/hIwYy7Nx5X/OJrWnOA80wRwJjp/18F+293z4zKL6CkvZ2Z+zBS8OkNHly8rdRDkW7UQMKiUTcrBT7Xgdqjh5cnEkrkfxE56861kD2sg9SEmDCqQNv4Dt72Yut4bfuDsEZtg7GknN1dAoykIdHM3QZYglxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244103; c=relaxed/simple;
	bh=g/loZuFHnIhFO9gb2LVmoWdY0OFtgr87yv2TQRfUgAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vivn3zvDoYx/lLfqmij7sR2J5FopFTc4czlbEzOytvCINhBqhGQKU7qeml775vsxNCSFgNm8nydNJo3+pcb4a3iUuWyt7AbOs8jO+quXmh2Doq0s4Fk2Yy0ckfekyo1Wkn6t6A+KvZu+DwpQg+2W7MIthpf7Lsmq2ROGowkZ/KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZaG1YiN0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZaG1YiN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71221F000E9;
	Thu, 20 Aug 2026 16:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244102;
	bh=nuJvabHIGC8R8ndU5FiBYXkqmWprRQcDiq/sI3hEdIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZaG1YiN0rPe6AdqiqzBSOQdpHXblcjXyQ1KS2mcwJHYrPrQlOiohCNmal0/ekn5OH
	 p/9TECnaXqnqKZgjPJeoESHPs++Ebwi4arog7X8TkEk8i07GA4cbAiYxSRdJxNWM6N
	 IiQtjh1mp5IzNEimpQew8avoXlHZff7o+H/k2IkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Zhenhao Wan <whi4ed0g@gmail.com>,
	Md Haris Iqbal <haris.iqbal@ionos.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 050/235] RDMA/rtrs-srv: Bound RDMA-Write length to chunk size in rdma_write_sg
Date: Thu, 20 Aug 2026 16:54:46 +0200
Message-ID: <20260820145217.951881175@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhenhao Wan <whi4ed0g@gmail.com>

[ Upstream commit 963af8d97a8c6a117134a8d0db1415e0489200b1 ]

When the server answers an RTRS READ, rdma_write_sg() builds the source
scatter/gather entry for the IB_WR_RDMA_WRITE that returns data to the
peer. Its length is taken directly from the wire descriptor:

  plist->length = le32_to_cpu(id->rd_msg->desc[0].len);

rd_msg points into the chunk buffer that the remote peer filled via
RDMA-WRITE-WITH-IMM (rtrs_srv_rdma_done() -> process_io_req() ->
process_read()), so desc[0].len is attacker-controlled and, before this
change, was only rejected when zero. The source address is the fixed
chunk start (dma_addr[msg_id]) and the source lkey is the PD-wide
local_dma_lkey, which is not tied to the chunk's MR mapping, so the verbs
layer does not constrain the transfer length to max_chunk_size. msg_id
and off are bounded against queue_depth and max_chunk_size in
rtrs_srv_rdma_done(), but desc[0].len is a separate field that was not
checked against the chunk size.

A peer that advertises desc[0].len larger than max_chunk_size can make
the posted RDMA write read past the chunk's mapped region. The resulting
behaviour depends on the IOMMU configuration: with no IOMMU or in
passthrough mode the read may extend into memory adjacent to the chunk
and be returned to the peer, which can disclose host memory; with a
translating IOMMU the out-of-range access is expected to fault and abort
the connection. In either case the transfer exceeds what the protocol
permits and is driven by a remote peer.

Reject a descriptor length above max_chunk_size, mirroring the existing
off >= max_chunk_size bound in rtrs_srv_rdma_done(). Legitimate clients
do not exceed it: the client sets desc[0].len to its MR length, which is
capped at the negotiated max_io_size (max_chunk_size - MAX_HDR_SIZE).

Fixes: 9cb837480424 ("RDMA/rtrs: server: main functionality")
Link: https://patch.msgid.link/r/20260612-master-v1-1-70cde5c6fdc9@gmail.com
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Zhenhao Wan <whi4ed0g@gmail.com>
Reviewed-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -258,8 +258,9 @@ static int rdma_write_sg(struct rtrs_srv
 	/* WR will fail with length error
 	 * if this is 0
 	 */
-	if (unlikely(plist->length == 0)) {
-		rtrs_err(s, "Invalid RDMA-Write sg list length 0\n");
+	if (unlikely(plist->length == 0 || plist->length > max_chunk_size)) {
+		rtrs_err(s, "Invalid RDMA-Write sg list length %u\n",
+			 plist->length);
 		return -EINVAL;
 	}
 


