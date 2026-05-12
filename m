Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D353EDE55;
	Tue, 12 May 2026 17:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608757; cv=none; b=jat3Q5uN1G0D1X7F8YjMVzoEg5FpmIOI6vX7USR3Vgu32KWWHxqwcRfloEB9RvbPT7osVDLS3U6I9XP9PP0FsYQEeoeS4uoMKszW+ierC+axCwYFKYzC7et0uU09AFDHxDYO99olJAP83+WMac8Jb4M2v++sonjjW2qacBYRFuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608757; c=relaxed/simple;
	bh=1xt2X73AzorLk7iPkuqDS1jK30ppd0/K1efai6kjlp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XOE0SYCV8PIrz5ewcZuprghP5OCCWv3zU9xUaomUwyVF74LnspGeFeKInNWaTPQ95aa/FdUHOFSYpHSEhVfRMoqRtLfhw2IFdtBeN610U5Ok3kuWx3bw6dOUpRbopc34MdUU/tIV0iHGEA0s4ghnXP9O1jhcz7HcImPSZ9pPn8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TYOyH3RI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TYOyH3RI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF09C2BCB0;
	Tue, 12 May 2026 17:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608757;
	bh=1xt2X73AzorLk7iPkuqDS1jK30ppd0/K1efai6kjlp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TYOyH3RIBpFQR/5Ltk7nRcJNXQ5mJd9T6j+i6obK0EKkWnjAjdg1UnMDw8IENSZ5p
	 bcAnkObcpKT0IXvDJQVOv2rba62X8dSqiiqjsl6+r6FKmMRJlpNuYqk8fPQDCHXK8Y
	 pxEhPLn2NJBmQTjx2jMg+vxrPPoF8Phy3Ovptvjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.18 202/270] RDMA/rxe: Reject non-8-byte ATOMIC_WRITE payloads
Date: Tue, 12 May 2026 19:40:03 +0200
Message-ID: <20260512173942.703581946@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


