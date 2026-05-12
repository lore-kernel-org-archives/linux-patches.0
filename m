Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB7A366831;
	Tue, 12 May 2026 18:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609561; cv=none; b=YaSbBzdNfuP53DyVeivBTQXmwtaACNGMzqVYNypcPF/QLKh0fdcoOlqFicfOAiVhhFwnxZjsEXkmT5lg5xny1qLOVxNX12Sl5eo2bl0VXc15Jx07PKHcyAfSsfhLVnDAe7qfTuKw6cugbnh9Sl2xHnSE3wifKOpJzyBsS9IqFJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609561; c=relaxed/simple;
	bh=xW99KDvb5QRbxxlemKWG3y91w1xLUF6aYKQA1HAD6Cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HoU1MXmm7Tl3aiIwBoHGWAokmeZ6N3n5Rpj0Je44iclwvThIjKYkDryivXbfq+8PgkneeUY8tDevlawCqQkHVLOB/vsjjx/r1PdCM0Lzc+ThUYluZMhNTG5dYvNzY2qdeNZEPlLhP86SsObxlkD7YUXaA6FEbsR0sZ59I8d+LIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sS1hslPE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sS1hslPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB25EC2BCC7;
	Tue, 12 May 2026 18:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609561;
	bh=xW99KDvb5QRbxxlemKWG3y91w1xLUF6aYKQA1HAD6Cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sS1hslPEfRLL5hT3pdgCWq9wjm/L5ScohH+1Rqn+z1aApxqg2j2wxOII6YcvZ3sf2
	 K57dUiJ2rS6Hbe1gH5FziT+8rDTkDJZ75uLoYy08P+AjLUquD8ST7sCsA4Q6kW791z
	 RteQ31GWRJSbX68WYMyIS0VFluZYMGoC1OXrXwAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.0 241/307] RDMA/rxe: Reject non-8-byte ATOMIC_WRITE payloads
Date: Tue, 12 May 2026 19:40:36 +0200
Message-ID: <20260512173945.209204121@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

commit 1114c87aa6f195cf07da55a27b2122ae26557b26 upstream.

atomic_write_reply() at drivers/infiniband/sw/rxe/rxe_resp.c
unconditionally dereferences 8 bytes at payload_addr(pkt):

    value = *(u64 *)payload_addr(pkt);

check_rkey() previously accepted an ATOMIC_WRITE request with pktlen ==
resid == 0 because the length validation only compared pktlen against
resid. A remote initiator that sets the RETH length to 0 therefore reaches
atomic_write_reply() with a zero-byte logical payload, and the responder
reads sizeof(u64) bytes from past the logical end of the packet into
skb->head tailroom, then writes those 8 bytes into the attacker's MR via
rxe_mr_do_atomic_write(). That is a remote disclosure of 4 bytes of kernel
tailroom per probe (the other 4 bytes are the packet's own trailing ICRC).

IBA oA19-28 defines ATOMIC_WRITE as exactly 8 bytes. Anything else is
protocol-invalid. Hoist a strict length check into check_rkey() so the
responder never reaches the unchecked dereference, and keep the existing
WRITE-family length logic for the normal RDMA WRITE path.

Reproduced on mainline with an unmodified rxe driver: a sustained
zero-length ATOMIC_WRITE probe repeatedly leaks adjacent skb head-buffer
bytes into the attacker's MR, including recognisable kernel strings and
partial kernel-direct-map pointer words.  With this patch applied the
responder rejects the PDU and the MR stays all-zero.

Cc: stable@vger.kernel.org
Fixes: 034e285f8b99 ("RDMA/rxe: Make responder support atomic write on RC service")
Link: https://patch.msgid.link/r/20260418162141.3610201-1-michael.bommarito@gmail.com
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/sw/rxe/rxe_resp.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -526,7 +526,19 @@ static enum resp_states check_rkey(struc
 	}
 
 skip_check_range:
-	if (pkt->mask & (RXE_WRITE_MASK | RXE_ATOMIC_WRITE_MASK)) {
+	if (pkt->mask & RXE_ATOMIC_WRITE_MASK) {
+		/* IBA oA19-28: ATOMIC_WRITE payload is exactly 8 bytes.
+		 * Reject any other length before the responder reads
+		 * sizeof(u64) bytes from payload_addr(pkt); a shorter
+		 * payload would read past the logical end of the packet
+		 * into skb->head tailroom.
+		 */
+		if (resid != sizeof(u64) || pktlen != sizeof(u64) ||
+		    bth_pad(pkt)) {
+			state = RESPST_ERR_LENGTH;
+			goto err;
+		}
+	} else if (pkt->mask & RXE_WRITE_MASK) {
 		if (resid > mtu) {
 			if (pktlen != mtu || bth_pad(pkt)) {
 				state = RESPST_ERR_LENGTH;


