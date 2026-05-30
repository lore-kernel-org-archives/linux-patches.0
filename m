Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C06261B9E;
	Sat, 30 May 2026 17:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163321; cv=none; b=h18Kg9qW3C+pAZC7x0uc8E2HyzLO5FLM9DxTbeaXJ1NYWvwoWmwWhblprfBK/sUX11JeIgWhvLLxa4qoJyNKvH5UgYuhgvBwHdKWE0VUEojcNGF6afODgrUPYByOho4gFtCtF2aqIwvi4g44WLhkrf93O9DgaaKwpK9lGq0Cdz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163321; c=relaxed/simple;
	bh=CGmpqGFInz495MT5Mxy5GVNWoMetXNzZ9t6ZQm53RXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQRXsBLeqWExW8ZW9FQR2VWXgb/bQfVe2lri3USoV7N/sz3xD3p3RlZvwV5IJ+0YTodJ9xJKlBCLr21zjo1gyl1o8cMsjtike+trYweEWKEJn1j9Zb3NLl2KjX3/z/BCOf5Gcnxo6Acc1q3wNuBwzZCNaZ405Z2L3ydM0A2N8wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DtcFVjBJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DtcFVjBJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C3871F00893;
	Sat, 30 May 2026 17:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163319;
	bh=JiZyOi2mXG7rSaQRmYR9Rgpa6WJbXAgg/gpdalIOs8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DtcFVjBJfeoQHMpzWbhMPtDQGGYDsQ3lRfSuDK4Ns3k16Ng1t1+bn0Scrc1qjTWPa
	 LU3OEuZmlTdE4Lv/hTIc51lS3gGSq89r4w1LpVJIUp79naw0BFdcuRrlFk2sHynJ90
	 vdKbj3T/VU5Rf77g/1d4RKPbunP8hHe1C0sbCn9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hkbinbin <hkbinbinbin@gmail.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.15 222/776] RDMA/rxe: Validate pad and ICRC before payload_size() in rxe_rcv
Date: Sat, 30 May 2026 17:58:56 +0200
Message-ID: <20260530160246.259737776@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: hkbinbin <hkbinbinbin@gmail.com>

commit 7244491dab347f648e661da96dc0febadd9daec3 upstream.

rxe_rcv() currently checks only that the incoming packet is at least
header_size(pkt) bytes long before payload_size() is used.

However, payload_size() subtracts both the attacker-controlled BTH pad
field and RXE_ICRC_SIZE from pkt->paylen:

  payload_size = pkt->paylen - offset[RXE_PAYLOAD] - bth_pad(pkt)
                 - RXE_ICRC_SIZE

This means a short packet can still make payload_size() underflow even
if it includes enough bytes for the fixed headers. Simply requiring
header_size(pkt) + RXE_ICRC_SIZE is not sufficient either, because a
packet with a forged non-zero BTH pad can still leave payload_size()
negative and pass an underflowed value to later receive-path users.

Fix this by validating pkt->paylen against the full minimum length
required by payload_size(): header_size(pkt) + bth_pad(pkt) +
RXE_ICRC_SIZE.

Cc: stable@vger.kernel.org
Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://patch.msgid.link/r/20260401121907.1468366-1-hkbinbinbin@gmail.com
Signed-off-by: hkbinbin <hkbinbinbin@gmail.com>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/sw/rxe/rxe_recv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/sw/rxe/rxe_recv.c
+++ b/drivers/infiniband/sw/rxe/rxe_recv.c
@@ -375,7 +375,8 @@ void rxe_rcv(struct sk_buff *skb)
 	pkt->qp = NULL;
 	pkt->mask |= rxe_opcode[pkt->opcode].mask;
 
-	if (unlikely(skb->len < header_size(pkt)))
+	if (unlikely(pkt->paylen < header_size(pkt) + bth_pad(pkt) +
+		       RXE_ICRC_SIZE))
 		goto drop;
 
 	err = hdr_check(pkt);


