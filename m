Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C39486B8C;
	Wed, 23 Sep 2026 14:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174362; cv=none; b=Y3sdQRA6EkLTqL4U/QvH2yeOWRCTBzFMDuPrq5Dut3UqSYE8qydjSyisO3ync483xGb6UsiNxyrANZE3ArXuJOoIt3bjJBbb+4SUchNs+/LrQGhpz5hn2niVYdjQ0IhQuGlOS1ksPQwBaL1+hUzAOtj24yV5eD1iyYDOZWOzg+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174362; c=relaxed/simple;
	bh=K9ZCXEzB6U2Vxfwmb0C3/jlKJVStuV9b4uo6K3FM6pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UCCw/LYbpSYY2Gzz066CpGXptz/8+lyMO/5yB+5YUZHDIXD3ayH4n3gSV+3wegsFpOAyh+Lw5R+qLuJzvnnFp4Ka55cSqtCucnnHbSaF9SJmB3BXGLy0o7CaPoFwk3dPEN8vZA178ZtK2PfGL1ZVv55MQd1ZQD6AlIGvpF9tiWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YtZSbD9B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YtZSbD9B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DD81F00893;
	Wed, 23 Sep 2026 14:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174361;
	bh=pLYxObdy/SHGc0csBuY1bZ+yNc5+Sf0pSJgUbChzgtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YtZSbD9B9AuAgC0ymHuC22BsA4iuAv5bB40KWlNnZQGWkMLBMpMWE/TaHGNZ47nAc
	 UKBstJj8Uw0mzzIBs+8yv05r7jScdXnRL/UjjCQc6YSlyo17TTEkBB5Ly9D3rDKXKV
	 XWg+QpA8zJbVw2J2tCJEsq26Mywc1fV/Ph/oVaCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 089/398] RDMA/siw: Bound fragmented header copies by the remaining length
Date: Wed, 23 Sep 2026 16:02:43 +0200
Message-ID: <20260923140645.745341170@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



