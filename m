Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A6D35A3AD;
	Mon,  4 May 2026 14:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904583; cv=none; b=oHXJ24QfpcCKB6H/O6fQ/JCAx5aKTPy2L4ys5kqR+NmW5er1NxILbYBGGiXilcxdlmCqjg1Wp4n+K2gmguJKpLihXd5U6eAu4tLVgfTbEspTbMVo/aEh1pe22lwk9LGVCz6sGh0/M0CRP5RZXSB2QsVQxToNCigsVN5Bj86c5Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904583; c=relaxed/simple;
	bh=PERHti3HH/PvhGejy7hqvG9Cao3spVhIfdtkjaSPdMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCSR+XPj0B07huQZqDOjPhJ9JFo7nbz1wrDVyZb1h2YZCRKpYtsfuAVUZIFfRvJs3vNXtpKLRzF6QF3ezezYeFlRDF2Gj2Spttzsj5itSHzHLBQXqYXQ21tuX1bFpvST34rw911FmeacFFXDmHf0vFpwgpqdSNMX2rqv8TP3Byo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zcaubDdP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zcaubDdP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E561C2BCB8;
	Mon,  4 May 2026 14:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904583;
	bh=PERHti3HH/PvhGejy7hqvG9Cao3spVhIfdtkjaSPdMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zcaubDdPD2HaR0+tUP9bN7idFD/DWFCkyKTAbotY7C0grEqNVV9U6p+5Pe34Pe7N/
	 UH3coUXi+eyKjYtIrZNsUh7tpqapsXS10iBjH6cdsBiLMwu3H3KHdCEWtCxuQ+Xdcd
	 HWpZ9iqC4OohFraz4L3YsSqevXKQ2TTXXHLPF+o4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hkbinbin <hkbinbinbin@gmail.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.12 094/215] RDMA/rxe: Validate pad and ICRC before payload_size() in rxe_rcv
Date: Mon,  4 May 2026 15:51:53 +0200
Message-ID: <20260504135133.591459732@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


