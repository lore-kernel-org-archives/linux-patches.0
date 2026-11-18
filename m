Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032423;
	b=gKLcRV877U10/NFGiw9QpNDcORvLmrsCRApOEqnXfWAVF3Y9L/oH+ElgYjruayx3D01P
	 ztQ19E6PLocvgqZx3DiYUO3hlVBSq6jAx+ITZtyk2lEeXQ9bqu0yqiBTWaxfX9vo79AjI
	 yBrDzFpar3UFftZ05ArTKyuJ7185VeRalQtN0lauX+8Lh4GkG+U41u5YhbgOm//eBA88z
	 spcWXKgnkCyriF6ysL1XZJ7bf5sN7x/88zN3jM0Wox44l7VMGvbnf8bgXkRwWL/0EUPn5
	 FutsUwvgXimHuAYHWkm9+3RtoMFipl7hdtnSZgev33QWU7L77NNy+27zkgtBQaE0OXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032423;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lqiajxenWsRM4GXVrzmv3XgRliyasy8ASJCnfGAFlqg=;
	b=BjeR8oD7POrAYeh32F5aeM1jWhHZdjzv5qrEPlpCD5cBAuifCCqiLiCazNA1i1kcBxTt
	 NB8nMnaCXu/wt2jZkME1HFKZYwIXSyothZfhQqgT9ltOl5BU2Yk7qdHA8KO9p4trvduj+
	 L75H26TNpME3pYPDgvomwbcMoMJJN2ibIPzHTnayyen5ofXxtPhGVcaOeyRKXhcgJShCW
	 RCgLdHRRm9c6mv0GEnNOqw4i7pf+iVKX0KcvSvDthEkUWMEBZUaiuUDug6faUm0rFuMrQ
	 1Yc/lmweQRYsaSAGrGXWM8JCoG9KpI0uOKXl7vvGAnXn0yX+bhIdHlHz5y76YBR53uA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=azUbN5VB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70512606B2FF;
	Wed, 18 Nov 2026 20:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=azUbN5VB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B181F000CD;
	Wed, 18 Nov 2026 20:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032423;
	bh=lqiajxenWsRM4GXVrzmv3XgRliyasy8ASJCnfGAFlqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=azUbN5VBywUdlhRIXAaIgmDd5GeS5YJL6X2qWs832MODIdkubiauCNQeyEbJ9WpzF
	 FxbhLCtF9V11BM/uE2hMBT8xFtbqV8TD2aLeRSysF3n1gveGYJs6X1t43pqEvIAYpF
	 +ABKItxfe5eP87zRuaVs0Bsml8m4DUdrTmtJLX7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Sunil Goutham <sgoutham@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1406/1756] octeontx2-af: Fix CQ enable state tracking after AQ writes
Date: Wed, 18 Nov 2026 15:58:53 +0100
Message-ID: <20261118150105.163406443@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 07bd391eb9572e74f073c49acef327611234f9bb ]

Use the CQ context's ena field when updating the CQ enable bitmap.
The current code reads rq.ena, which overlaps bit 0 of the CQ base address
and can leave the bitmap out of sync with the hardware context. This can
cause enabled CQs to be skipped during teardown.

Use sq.ena for the SQ bitmap update as well, so each queue type reads
its own context.

Fixes: 557dd485eaeb ("octeontx2-af: Support for disabling NIX RQ/SQ/CQ contexts")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Ratheesh Kannoth <rkannoth@marvell.com>
Reviewed-by: Sunil Goutham <sgoutham@marvell.com>
Link: https://patch.msgid.link/20261011125508.534618-1-alok.a.tiwari@oracle.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index e9bcfc730f450..56e637000a0f9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -1170,7 +1170,7 @@ static int rvu_nix_blk_aq_enq_inst(struct rvu *rvu, struct nix_hw *nix_hw,
 				__clear_bit(req->qidx, pfvf->rq_bmap);
 		}
 		if (req->ctype == NIX_AQ_CTYPE_SQ) {
-			ena = (req->rq.ena & req->sq_mask.ena) |
+			ena = (req->sq.ena & req->sq_mask.ena) |
 				(test_bit(req->qidx, pfvf->sq_bmap) &
 				~req->sq_mask.ena);
 			if (ena)
@@ -1179,7 +1179,7 @@ static int rvu_nix_blk_aq_enq_inst(struct rvu *rvu, struct nix_hw *nix_hw,
 				__clear_bit(req->qidx, pfvf->sq_bmap);
 		}
 		if (req->ctype == NIX_AQ_CTYPE_CQ) {
-			ena = (req->rq.ena & req->cq_mask.ena) |
+			ena = (req->cq.ena & req->cq_mask.ena) |
 				(test_bit(req->qidx, pfvf->cq_bmap) &
 				~req->cq_mask.ena);
 			if (ena)
-- 
2.53.0



