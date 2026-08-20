Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CA146D0BD;
	Thu, 20 Aug 2026 16:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243898; cv=none; b=az+eqbY1WzwJNsVF+X2txMIeKfaBaKvxjDKxPnrc58S4vDRQfH3RPM8h3kSl9c5Gf4ehaG5HRrWHViWeraberqdb/2neXGjzXKnICIbYLj9WQaZkj8e3kotOBCz+ULC1dmxc941Mf3mvIPsOF0yUtqMFIJninb31EcLVo22WzE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243898; c=relaxed/simple;
	bh=N5Fb+FIyb9/MNNLoZFL9b1+x+mWd0Ca+7kGDBTF2aGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KuL08Y50yTXopG/QSKJcsRv0CdmhSZJijKSvHqcooKgY9FKDMvnQAR9xLw8bLU3KT4RahVgB66hh8WuU4EZM8CL9AzaYpGOAkKAnEBVb2Z1kJp8vXs866bINRaZOqPWPE1YJKWtTkZGvMz6NzPZlChkcUC5+6VWL2tyvjZEzrto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k3WvRwPp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k3WvRwPp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95A01F000E9;
	Thu, 20 Aug 2026 16:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243897;
	bh=2quLk4xLRvGWKgB44PVq1mt1dNzhiX/GTZgB9QOm5OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k3WvRwPpfL0esqKlNQ2hWG/LlBo7p+nUeK05Se+AV6F23BJaicitlqJ0/fzrAkCNW
	 9XSAFOSaJL70Vhg/9pNP5zC4gegX57Zv2aKBNedPywr+QQ6k0LPzKYmJeteDi7YWs/
	 OJEW3b9pix0QIcPEM1JS7xPtx1NXRQQhtOk0nxro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangguan Wang <guangguan.wang@linux.alibaba.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	kernel test robot <lkp@intel.com>,
	Karsten Graul <kgraul@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 255/272] net/smc: rdma write inline if qp has sufficient inline space
Date: Thu, 20 Aug 2026 16:57:19 +0200
Message-ID: <20260820145239.280391823@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangguan Wang <guangguan.wang@linux.alibaba.com>

commit 793a7df63071eb09e5b88addf2a569d7bfd3c973 upstream.

Rdma write with inline flag when sending small packages,
whose length is shorter than the qp's max_inline_data, can
help reducing latency.

In my test environment, which are 2 VMs running on the same
physical host and whose NICs(ConnectX-4Lx) are working on
SR-IOV mode, qperf shows 0.5us-0.7us improvement in latency.

Test command:
server: smc_run taskset -c 1 qperf
client: smc_run taskset -c 1 qperf <server ip> -oo \
		msg_size:1:2K:*2 -t 30 -vu tcp_lat

The results shown below:
msgsize     before       after
1B          11.2 us      10.6 us (-0.6 us)
2B          11.2 us      10.7 us (-0.5 us)
4B          11.3 us      10.7 us (-0.6 us)
8B          11.2 us      10.6 us (-0.6 us)
16B         11.3 us      10.7 us (-0.6 us)
32B         11.3 us      10.6 us (-0.7 us)
64B         11.2 us      11.2 us (0 us)
128B        11.2 us      11.2 us (0 us)
256B        11.2 us      11.2 us (0 us)
512B        11.4 us      11.3 us (-0.1 us)
1KB         11.4 us      11.5 us (0.1 us)
2KB         11.5 us      11.5 us (0 us)

Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
Tested-by: kernel test robot <lkp@intel.com>
Acked-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 5d9686af2976 ("net: smc: fix splice entry lifetime imbalance in smc_rx_splice")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/smc_tx.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -333,12 +333,20 @@ static int smcr_tx_rdma_writes(struct sm
 	int rc;
 
 	for (dstchunk = 0; dstchunk < 2; dstchunk++) {
-		struct ib_sge *sge =
-			wr_rdma_buf->wr_tx_rdma[dstchunk].wr.sg_list;
+		struct ib_rdma_wr *wr = &wr_rdma_buf->wr_tx_rdma[dstchunk];
+		struct ib_sge *sge = wr->wr.sg_list;
+		u64 base_addr = dma_addr;
+
+		if (dst_len < link->qp_attr.cap.max_inline_data) {
+			base_addr = (uintptr_t)conn->sndbuf_desc->cpu_addr;
+			wr->wr.send_flags |= IB_SEND_INLINE;
+		} else {
+			wr->wr.send_flags &= ~IB_SEND_INLINE;
+		}
 
 		num_sges = 0;
 		for (srcchunk = 0; srcchunk < 2; srcchunk++) {
-			sge[srcchunk].addr = dma_addr + src_off;
+			sge[srcchunk].addr = base_addr + src_off;
 			sge[srcchunk].length = src_len;
 			num_sges++;
 
@@ -352,8 +360,7 @@ static int smcr_tx_rdma_writes(struct sm
 			src_len = dst_len - src_len; /* remainder */
 			src_len_sum += src_len;
 		}
-		rc = smc_tx_rdma_write(conn, dst_off, num_sges,
-				       &wr_rdma_buf->wr_tx_rdma[dstchunk]);
+		rc = smc_tx_rdma_write(conn, dst_off, num_sges, wr);
 		if (rc)
 			return rc;
 		if (dst_len_sum == len)


