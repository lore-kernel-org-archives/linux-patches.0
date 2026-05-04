Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6833AA4F8;
	Mon,  4 May 2026 14:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904049; cv=none; b=Nw6lDawCRjYVyCp5MQhQJsGr5HcXGcCzCKU/CF01sHOKhr+mg6J57ZoCdMkLCIQL2omaZsWEe/R83ZJ3zoFzCiLe8GN2wAKUks5jsFWsETOHRt1mExeK+rG07K0Jf8Z/IsApsoRJ33QzlThZSwzEImpBODBcm9m8b0Dr/l+Y0Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904049; c=relaxed/simple;
	bh=WpZZD7JardDsPE8bNcHsHkeny9yjHL6ICzXy1HgNb8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jF4iBPlgApPn/dMkmNvjBPDD204UZUvjWS/cbk8/BK+qvtbHA6YH7xdmfIzDwIaSGCLWb8LprEl3JnmDm/zLlAYikb75OIbIMkmc+u0K9yO3F0NEHjbKSdOD6S6/Ebr2PLRSNMU6xe3MRDP4L7qnGntVOK9mqfWSOqDKMfZ2XQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vkCCEPuR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vkCCEPuR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5367C2BCB8;
	Mon,  4 May 2026 14:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904049;
	bh=WpZZD7JardDsPE8bNcHsHkeny9yjHL6ICzXy1HgNb8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vkCCEPuRRq81LfFuRo+xaih/01tRBftTI+PkX8jbcsUyMSksvkgp+GJ+IOPuVx1Uk
	 DcM1LQLOnn8G+VQfDXjMgtWK1hPBchkicbfVDIQCW2wtI0PV1tjb/xWN5nKVcylSDG
	 eXSRQH1JFlpxKkiCN8Ebe1em6oIBi++1VTiF8S+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hkbinbin <hkbinbinbin@gmail.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.18 131/275] RDMA/rxe: Validate pad and ICRC before payload_size() in rxe_rcv
Date: Mon,  4 May 2026 15:51:11 +0200
Message-ID: <20260504135147.767594422@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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
@@ -330,7 +330,8 @@ void rxe_rcv(struct sk_buff *skb)
 	pkt->qp = NULL;
 	pkt->mask |= rxe_opcode[pkt->opcode].mask;
 
-	if (unlikely(skb->len < header_size(pkt)))
+	if (unlikely(pkt->paylen < header_size(pkt) + bth_pad(pkt) +
+		       RXE_ICRC_SIZE))
 		goto drop;
 
 	err = hdr_check(pkt);


