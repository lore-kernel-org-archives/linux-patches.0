Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7B426B973;
	Thu, 28 May 2026 19:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998392; cv=none; b=eT/sEr348hOa/jChKpX4v7gAU+xMo1sG+8tOxuseN9g47WR3C+ueG1UVoDEQep6HVvNkSvfG919tycQTCi6suk0AUhwFRxzht0fcLK/WcRmywPNnq13Aswl3zPBv+RDgi+2cKJyNv/t7lko8aR5DNT3PeyYvhcw3y3K2+YPRTm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998392; c=relaxed/simple;
	bh=yHgOuMohB+r3T3SgzUDyGmi37S7IIVV+GaMQf4Y0iqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HAGYWXjKnKfj+NPznIEVTPVUGWLPKb1KqgkOQ4FFPzlBOsBP2C3krjkDz1LuZaQmqxItFpefaSsEnv+OtMz0PNXBhMjN7t503FgBV/MOeGI2lORgVxMLHt0++Cb3ilKcxa8a7Q6MUOPWsSx9uumzDgIpzgKF4nrC6XgaypsAZrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cC40tIuH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cC40tIuH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4FE1F000E9;
	Thu, 28 May 2026 19:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998391;
	bh=fYU/n5v7D6TKtgBG2uN8JcxBSN3oE3JHnhEzbdDgaF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cC40tIuHO78h6Aoqnds1csv8molTnZqngMejD+9vvTvDtYbyvhchTKJO+Fyu6zntg
	 v69RL98Shk2w4upC90KoWHOY2562JpijdxBakTrS5s8VS33313Sctjwj9jRvOgkba7
	 TlRy9ooDh3ODURbCrQdRjiZxgIPxMYxxd2FOOgNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.0 120/461] RDMA/siw: Reject MPA FPDU length underflow before signed receive math
Date: Thu, 28 May 2026 21:44:09 +0200
Message-ID: <20260528194650.452977245@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1082,6 +1082,21 @@ static int siw_get_hdr(struct siw_rx_str
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


