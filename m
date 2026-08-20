Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FA53793CE;
	Thu, 20 Aug 2026 16:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244609; cv=none; b=GTKbqP5iYsAQ+wYvem9rPNVhxARdrnvJCDGZP8xt5qGZiU/8ZYt0ytpXo8L8Fud0CxCuq2YM+4RfpaxmxI9C3r1SGql92WFMp8cp88Ve6BMc2OHLuczWstrQHP/zFyFhNqfxF3D5RJ0vYPmHhrdhgolozFmruUIcpwYG8+c3s+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244609; c=relaxed/simple;
	bh=or4QRUVhGvcWOusxQyrK53II+RVZreLBFhBkzRWEUXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hh6aGnt9P9v/wsZuVOd0T9YUGdVtvs3qIDc4al1UjVci9SIkbTKPdqdYoWMH8ppchlHZwksc65YV/P2lpYEhFp8xwF0LNHKUPsGygDPrRiGfMzdLdA0wj8jLi8Ua3nI8xLYPKgeOTC/0gaFCjX0xFGrwYsnrWdlVve3dpFxJduc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b1EsBTBN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b1EsBTBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255CD1F000E9;
	Thu, 20 Aug 2026 16:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244608;
	bh=+BD9kniz9kUtWb9nB58annVoxmWbCRT0H+F1WjKRn3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b1EsBTBNf/w8ZlChZLiKepF4JO3W4oxIRRF4Zx8KtARj0bBtRMQWu2ztiKy+tiko2
	 s8nAX6CDFsHMahSsHU96rOr9Y622Mu21bpBuyt58s9sbeGdQxt+vDHmSp21kQIsNSl
	 ZgQh1VrKOeBQAhtbJxLOYbNijMXP4GmCdaXmfNjU=
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
Subject: [PATCH 5.10 229/235] net/smc: rdma write inline if qp has sufficient inline space
Date: Thu, 20 Aug 2026 16:57:45 +0200
Message-ID: <20260820145223.562435671@linuxfoundation.org>
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
@@ -320,12 +320,20 @@ static int smcr_tx_rdma_writes(struct sm
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
 
@@ -339,8 +347,7 @@ static int smcr_tx_rdma_writes(struct sm
 			src_len = dst_len - src_len; /* remainder */
 			src_len_sum += src_len;
 		}
-		rc = smc_tx_rdma_write(conn, dst_off, num_sges,
-				       &wr_rdma_buf->wr_tx_rdma[dstchunk]);
+		rc = smc_tx_rdma_write(conn, dst_off, num_sges, wr);
 		if (rc)
 			return rc;
 		if (dst_len_sum == len)


