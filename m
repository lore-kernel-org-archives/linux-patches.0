Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684C83DAAA4;
	Wed, 30 Sep 2026 19:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796044; cv=none; b=acLeV/wDLpLsxIkA56xnu97ibxmDjEGN9MjxXYJSqzwW9z3C6XfqJjBOkSbjyDrvLkdMep5MGqMDvxBlTR66tLvbrk+2w2LyVEOX0T4nMbSXy37Itrjg/1in/lh+f7aLXUpYDvLKYflxj0Xh/UUTViS2uWol/Mc9KDjv80bBXpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796044; c=relaxed/simple;
	bh=MXdXf5/OjSWrPJhdW2GtK6ASE9ivbym8qcCazl9HN5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b7CrsoxkCLYIe4WNmQRJQxIpYIK6hiZVELxDoYLM+GOKGJdq8G/MY6olqQiptHjSY3TEVi1Wi8sY8S/Vj27G9WeYIuwpVuueP1s6z4HlgN6d0eUQ1G+MFYZySW/ZFlbL6jjqbY1KnwmXavlZiLz1oUpLFxsJlH7wCOGP0pTyKts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ql8Vt2kT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ql8Vt2kT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41181F000FF;
	Wed, 30 Sep 2026 19:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796043;
	bh=A3vbCmx4mIz/fnxvtKew4Pn3Nlv7YPYKgIzuhvoSouk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ql8Vt2kTLKyCcWkGnZeayPfS/mctqKCGqgwrs9iPOJFy5hgHhSo4j2+jGa881tDCl
	 lxqcoxHxpNROV5QC7m4NkzHconvBieu9bICbt1ta1zulE9zShl504tRYmTlAots+Mx
	 tt6muW+zNLn/ieynhiXTZ9cQQCFGwVUp5+ysLUZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0775/1193] RDMA/siw: Bound fragmented header copies by the remaining length
Date: Wed, 30 Sep 2026 17:24:19 +0200
Message-ID: <20260930152451.472643937@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 9ff797e516dbc1ecb73701ec4c24055712d44411 ]

siw_get_hdr() can receive an extended DDP/RDMAP header across more than
one TCP callback. The first callback may receive most of the header,
while the next one still limits the copy to hdrlen - MIN_DDP_HDR instead
of the number of missing bytes. This makes the destination move past the
end of the header and overwrite the receive state, including
fpdu_part_rcvd. A later callback can then use a negative fpdu_part_rcvd
value as a copy offset, which creates an OOB write.

Use the number of header bytes already received when calculating the
next copy length.

Fixes: 754209850df8 ("RDMA/siw: Always consume all skbuf data in sk_data_ready() upcall.")
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Link: https://patch.msgid.link/20260908085520.1746329-1-Jeremy.Jean@oss.cyber.gouv.fr
Assisted-by: Codex:gpt-6
Acked-by: Bernard Metzler <bernard.metzler@linux.dev>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_qp_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_qp_rx.c b/drivers/infiniband/sw/siw/siw_qp_rx.c
index 96a8e23a8ce22..907fca0765d34 100644
--- a/drivers/infiniband/sw/siw/siw_qp_rx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_rx.c
@@ -1095,7 +1095,7 @@ static int siw_get_hdr(struct siw_rx_stream *srx)
 	if (iwarp_pktinfo[opcode].hdr_len > sizeof(struct iwarp_ctrl_tagged)) {
 		int hdrlen = iwarp_pktinfo[opcode].hdr_len;
 
-		bytes = min_t(int, hdrlen - MIN_DDP_HDR, srx->skb_new);
+		bytes = min_t(int, hdrlen - srx->fpdu_part_rcvd, srx->skb_new);
 
 		skb_copy_bits(skb, srx->skb_offset,
 			      (char *)c_hdr + srx->fpdu_part_rcvd, bytes);
-- 
2.53.0



