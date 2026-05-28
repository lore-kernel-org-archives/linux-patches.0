Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB54318B96;
	Thu, 28 May 2026 20:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001316; cv=none; b=TXQ90+t8KmgT7p9WLZiGCl616oQULrjHTI8Vxj2YksOOcKFVsuBbkqLDvQgVkkuv9+gXQIVtZxzDSdPrWXKHxvWiBAVIdys6ntPnrUiRjr0ENgi8xdC3Q/wBZQltxH291vxAoDgBhbAeKxaY5VHXj6p30+EhHCNunSabM5LjOoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001316; c=relaxed/simple;
	bh=ZBY5X6V499nwsSTfb4m9Lx5yKhTkrlcnNQah3QO/GsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tLgxnU3c7IowTxvebuZptOOBWB6hBV71pL2kep15n9GU3qPY+TFw0gG06TFGlEea7r9K8Be5zXaTybvd8R4iXRodATHoAeBhr84kXsYdbDp3hn7GxeeDMdATC/x7TIM49MpKe5nnnnlgoRn5e4oDiNbJc1M99ADfey1GxJbOnFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d1T2fGw9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d1T2fGw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65A31F000E9;
	Thu, 28 May 2026 20:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001315;
	bh=WhtShlvFR3EZ5OkA7KFqfX06I6jFM1KOuD6vO01jhyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d1T2fGw97SqwuEo5AiwPV2TZcA4kcUiOVlKmrOodOoAtLIyMfcg5BunkzxwGbWUih
	 W+RnSuBVFZdclfd3JviJALAThrpOWNKr2L2waUSLpP2ZMtcE6h7WO5YdgOvet1nGK5
	 NQDR4hwPnv9jv03DpKDf6Xb+aANalyIOtLPeJ0Rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.6 067/186] RDMA/siw: Reject MPA FPDU length underflow before signed receive math
Date: Thu, 28 May 2026 21:49:07 +0200
Message-ID: <20260528194930.759695646@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 0ce1bc9e46ecabe84772bb561e373c0d9876d6f2 upstream.

A malicious connected siw peer can send an iWARP FPDU whose MPA length
field (c_hdr->mpa_len, 16 bit big-endian, peer-controlled) is smaller
than the fixed DDP/RDMAP header for the announced opcode. Soft-iWARP
parses the full header in siw_get_hdr() based on iwarp_pktinfo[opcode]
.hdr_len, but never compares mpa_len against that header length.

siw_tcp_rx_data() then derives

    srx->fpdu_part_rem = be16_to_cpu(mpa_len) - fpdu_part_rcvd
                         + MPA_HDR_SIZE;

where fpdu_part_rcvd equals iwarp_pktinfo[opcode].hdr_len at this
point. For a tagged WRITE (hdr_len 16, MPA_HDR_SIZE 2) the smallest
on-wire mpa_len of 0 yields fpdu_part_rem = -14, and any mpa_len below
hdr_len - MPA_HDR_SIZE underflows to a negative int.

The signed value then flows into siw_proc_write()/siw_proc_rresp() as

    bytes = min(srx->fpdu_part_rem, srx->skb_new);

is handed to siw_check_mem() as an int len (whose interval check
addr + len > mem->va + mem->len is satisfied for a valid base when
len is negative), and reaches siw_rx_data() -> siw_rx_kva() /
siw_rx_umem() -> skb_copy_bits() as a signed copy length. The header
copy branch in skb_copy_bits() promotes that to size_t, producing a
multi-gigabyte read.

KASAN under a KUnit harness that drives the real kernel TCP receive
path -- a loopback AF_INET socketpair, the malformed FPDU written via
kernel_sendmsg, sk_data_ready firing in softirq, tcp_read_sock
dispatching to siw_tcp_rx_data -- reports:

    BUG: KASAN: use-after-free in skb_copy_bits+0x284/0x480
    Read of size 4294967295 at addr ffff888...
    Call Trace:
     skb_copy_bits
     siw_rx_kva
     siw_rx_data
     siw_check_mem
     siw_proc_write
     siw_tcp_rx_data
     __tcp_read_sock
     siw_qp_llp_data_ready
     tcp_data_ready
     tcp_data_queue

Add the missing invariant at the earliest point where the peer header
is fully assembled. iwarp_pktinfo[*].hdr_len - MPA_HDR_SIZE is exactly
the value the siw transmitter uses as the minimum mpa_len for each
opcode (drivers/infiniband/sw/siw/siw_qp.c:33), so this matches the
protocol contract. Out-of-range FPDUs terminate the connection with
TERM_ERROR_LAYER_LLP / LLP_ETYPE_MPA / LLP_ECODE_FPDU_START -- which
is RFC 5044 Section 8 error code 3 ("Marker and ULPDU Length fields
do not agree on the start of an FPDU"), the correct framing-error
class for this inconsistency.

Fixes: 8b6a361b8c48 ("rdma/siw: receive path")
Link: https://patch.msgid.link/r/20260513175325.2042630-2-michael.bommarito@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Assisted-by: Claude:claude-opus-4-7
Acked-by: Bernard Metzler <bernard.metzler@linux.dev>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/sw/siw/siw_qp_rx.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/infiniband/sw/siw/siw_qp_rx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_rx.c
@@ -1102,6 +1102,21 @@ static int siw_get_hdr(struct siw_rx_str
 	}
 
 	/*
+	 * Peer-controlled mpa_len must not underflow srx->fpdu_part_rem
+	 * in siw_tcp_rx_data(); a negative value flows as a signed copy
+	 * length into siw_check_mem() and skb_copy_bits().
+	 */
+	if (unlikely(be16_to_cpu(c_hdr->mpa_len) + MPA_HDR_SIZE <
+		     iwarp_pktinfo[opcode].hdr_len)) {
+		pr_warn_ratelimited("siw: short mpa_len %u for opcode %u (hdr_len %u)\n",
+				    be16_to_cpu(c_hdr->mpa_len), opcode,
+				    iwarp_pktinfo[opcode].hdr_len);
+		siw_init_terminate(rx_qp(srx), TERM_ERROR_LAYER_LLP,
+				   LLP_ETYPE_MPA, LLP_ECODE_FPDU_START, 0);
+		return -EINVAL;
+	}
+
+	/*
 	 * DDP/RDMAP header receive completed. Check if the current
 	 * DDP segment starts a new RDMAP message or continues a previously
 	 * started RDMAP message.


