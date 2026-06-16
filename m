Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B9335292A;
	Tue, 16 Jun 2026 18:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634028; cv=none; b=AX1sO0Y021gEO111+97TxvIQCw+CeswIERfRXQ2v94Cm15mgW7PMwRJG5uCbMhgyI5NBoSR/yeA6bJkx7q1xgM57nLT1q+0SpaYdHmMAt8J1sxpntx/OEEcguw1jqvpfVZTejOOV9s/1p0l1NmPAyTKv/fXqpMFJWJCFhkRWfsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634028; c=relaxed/simple;
	bh=HQQiq4bwnsQdH4LgvmSJBlE2dmAhHHA08JeQjb+aIA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MrKmcAZgHsP974pEfnB3DLTLCOAiVvM32ny9eEq6L8t5oGriJOrO8QeRHY5BNJiejiZaNiL6mgb1PGAcLgP4Ih9lorGsLVStxHYP8wGwv0XlYzx4BPIaVeLGwM+35rqjWTXrMYDMQtwjTZuMbbcaVZvbDp8Mq5MsWxwHyh5GuFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V0Ugk/RH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V0Ugk/RH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893D81F000E9;
	Tue, 16 Jun 2026 18:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634027;
	bh=FA8hjwr8nnsTBDZ7p55XYXVGqAFGnULOTy5QpPqbjkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V0Ugk/RHwTAP0lENwL3jGPnnclEgzXYLC8VYn0FRr4/HGuNBNLpNJgJTBRnfI2+MS
	 5VLC23dH/bhD+cGcXWvmyW+JIk40iaXdtHO2eY7OIDnNQ/7cBEWsT0OL+aeLhwVYDU
	 Cj594hW+NHaeHRqe4RgCQ6pfVLInX+schQWe15tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 187/411] sctp: fix uninit-value in __sctp_rcv_asconf_lookup()
Date: Tue, 16 Jun 2026 20:27:05 +0530
Message-ID: <20260616145110.633561305@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit f8373d7090b745728de66308deeecc67e8d319ce ]

__sctp_rcv_asconf_lookup() in net/sctp/input.c only checks that the ASCONF
chunk can hold the ADDIP header and a parameter header, then calls
af->from_addr_param(), which reads the full address (16 bytes for IPv6)
trusting the parameter's declared length.

An unauthenticated peer can send a truncated trailing ASCONF chunk that
declares an IPv6 address parameter but stops after the 4-byte parameter
header; reached from the no-association lookup path, from_addr_param() then
reads uninitialized bytes past the parameter.

Impact: an unauthenticated SCTP peer makes the receive path read up to 16
bytes of uninitialized memory past a truncated ASCONF address parameter.

The sibling __sctp_rcv_init_lookup() bounds parameters with
sctp_walk_params(); this path open-codes the fetch and omits the bound.
Verify the whole address parameter lies within the chunk before
from_addr_param() reads it, the same class of fix as commit 51e5ad549c43
("net: sctp: fix KMSAN uninit-value in sctp_inq_pop").

Fixes: df2185771439 ("[SCTP]: Update association lookup to look at ASCONF chunks as well")
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20260608122234.459098-1-michael.bommarito@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/input.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index 182898cb754a52..70530cbe57d0a7 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -1197,6 +1197,14 @@ static struct sctp_association *__sctp_rcv_asconf_lookup(
 	/* Skip over the ADDIP header and find the Address parameter */
 	param = (union sctp_addr_param *)(asconf + 1);
 
+	/* The whole address parameter must lie within the chunk before
+	 * af->from_addr_param() reads the variable-length address; otherwise a
+	 * truncated trailing ASCONF chunk lets it read uninitialized bytes past
+	 * the parameter.
+	 */
+	if (sizeof(*asconf) + ntohs(param->p.length) > ntohs(ch->length))
+		return NULL;
+
 	af = sctp_get_af_specific(param_type2af(param->p.type));
 	if (unlikely(!af))
 		return NULL;
-- 
2.53.0



