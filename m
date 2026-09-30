Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376E04ABBA5;
	Wed, 30 Sep 2026 18:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791946; cv=none; b=Sgc/0F3fBl+uIHaG0OGbgVmeEHIm2rAqVEIn8x5xoy1mIyQ0qWkMX31LU74Ab8el8gsrUGGOk20En1defXuqYj0IwAtzujsKUAEQa92bkwJCfJzJxLEO2je/UQnx5AXZyQkqP+0UTR5iIrJhmS/vpRmtg74qJnls05F4w0cMdsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791946; c=relaxed/simple;
	bh=ntFwMeujQpV25aXFyV0H+BJPvj7fzWzQxpKjIqXwP2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fcc65LbgP2RiOXl+idNMJJYt4OjV+fzIMRREVJP+3fcuZm6ivDDi9qh/QQgGMXIxCnbD0RSSaS6cK8K9Vo/a7EHEUALcx0+nqT4cTGy2W9gKqDiqAnZ6Zc2G6CjHrGZ8qHcyOPwmbhOVruYgBgZOQv9Ny5od3Ke7JEVQIrRieuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vTTnKCrW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vTTnKCrW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 887041F000FF;
	Wed, 30 Sep 2026 18:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791945;
	bh=PmJMN0tvFujtXtrSOc5+NeroKrV/8oxwbVk9tkty0J0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vTTnKCrWr2IUwg0pqL9LBaJP0SC0TWH0e4ln9DM+dqUOq+0x6RqxdQJM5edHfmE32
	 544doCGKBPf26ufYBDbI7kQS9KZRIobOJPtfnvQPnhslBxw3EjZp7zZAcxIdwU/oHV
	 b1d+IqzKA3n4dBtJgUmHOSSpR9IdCyOBV+1Uceuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 481/752] RDMA/siw: Bound fragmented header copies by the remaining length
Date: Wed, 30 Sep 2026 17:25:51 +0200
Message-ID: <20260930152408.678641331@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 743ffb3754e80..d608ecc67dd9d 100644
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



