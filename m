Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49A53769F9;
	Wed, 23 Sep 2026 14:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172923; cv=none; b=c7xFnPZwxWXNOdZUbr3Za+EDmQq6C53OVBHPDpyxD81ze8vME7X0p4j1X//FMIpVTnM956MLl3bP9wDW8Ar/Pvvy30eEz4pq43GryL0iS7UFS2SZjdtrhiuglQGczQ022Pu7uYSCl24rgksbeUehNHJLzMLNvpgsBoawNCZglzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172923; c=relaxed/simple;
	bh=ONNmhMF62oM+BA6LWmuR8rUCABydZ0vKqOhkN3G1hjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FWdEQFd1h0zkQD2n5PNsJdFg2F+UzG4IiZhkMuJ28ld7k+bhr8Q0oQNFkvlTetoPiZo3531KlfQOHiAXnOMWw6toEP02nFAeEmDTgffHQQZkU1+fp3/eqK/AmhIznqMbjLcV0J4x8CNxNeEH2fboVNtvAYzesSJHnyabIdiPSbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JJSffDIB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JJSffDIB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB7F1F000FF;
	Wed, 23 Sep 2026 14:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172922;
	bh=+lFFAX9AbxiKhFTJDfzrtIpAnaSUQdeudH1YLvOq5pQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JJSffDIB9JVizfLuAoUxIdq2iC+YIa6Of2zLrQB4jREP5T8buLpST3mgkvb/Bowiy
	 JnkR+jvaksy+QfSl30vdiRzSVEKkxRFFjcbdtwZtosShbrHPN9yDUZ0OgfiLpeTcB1
	 31NPXLZBg6uAMBmvqa/EzYNh7FKFaihKsN9XMUkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 100/438] RDMA/siw: Bound fragmented header copies by the remaining length
Date: Wed, 23 Sep 2026 16:02:01 +0200
Message-ID: <20260923140647.369814247@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index b566d163c5aab..e5b641c8d694a 100644
--- a/drivers/infiniband/sw/siw/siw_qp_rx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_rx.c
@@ -1079,7 +1079,7 @@ static int siw_get_hdr(struct siw_rx_stream *srx)
 	if (iwarp_pktinfo[opcode].hdr_len > sizeof(struct iwarp_ctrl_tagged)) {
 		int hdrlen = iwarp_pktinfo[opcode].hdr_len;
 
-		bytes = min_t(int, hdrlen - MIN_DDP_HDR, srx->skb_new);
+		bytes = min_t(int, hdrlen - srx->fpdu_part_rcvd, srx->skb_new);
 
 		skb_copy_bits(skb, srx->skb_offset,
 			      (char *)c_hdr + srx->fpdu_part_rcvd, bytes);
-- 
2.53.0



