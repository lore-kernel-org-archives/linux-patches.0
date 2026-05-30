Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EDB25B08A;
	Sat, 30 May 2026 18:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166651; cv=none; b=HrRvZ9wU9nterQOX4sUmDqRueD8+aDgkE08CcSE26jxKjHnYHuGCnun7iZ76uL5fnZHwQuLKH/wsc0WO/K4GkzXK51VanuwP25alHy0vtt3XUvue8noVyq3NRXyKfMtj/bYmiuXHSxp5CfKanb4e1y5bCJN3xn07WukMVUSxoVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166651; c=relaxed/simple;
	bh=axdpaXGXOPYLDFKfRWRufCjvm6USMtfW5Ya7LEFfUF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S2aPiKqXpmsqTJAF2x1JyNL5H+fioAvV2GNTnLouhfUPsx76qBRr9oeqDlbioPHhkh1VoS0OEKprmXePrht6XoZ+rfuma1SYLCh8LNARUEbhx6mLirW5TKr75Vz0wFxnj36dNS/dxxyITgfa/q/agAnniyRAbv4KcBJFUoZVo2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oVKrDwhu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oVKrDwhu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D811F00893;
	Sat, 30 May 2026 18:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166650;
	bh=WMJA8nA6s+gmDbN3WYEbeXOV27Y4J+pEhHMI/KnNV7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oVKrDwhui8kQKfoOCU4ymz3uKTKkIqVeu+OjAMUveoBvszad+ym+xvRXQo73mq6fO
	 CsLpqGU+Sp5QY6SZrAfTex0p5L42vqkTKM1qbppRt3GBE6FlQMPvh3DvEdsIa2bg8S
	 g8yNSU2LLb64b2I4uX/+Y7y1P4QO9N1HMpiIvI/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Sukholitko <boris.sukholitko@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 428/589] dissector: do not set invalid PPP protocol
Date: Sat, 30 May 2026 18:05:09 +0200
Message-ID: <20260530160235.972274166@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Sukholitko <boris.sukholitko@broadcom.com>

[ Upstream commit 2e861e5e97175dfa7b7bc055c45acdc06d2301d3 ]

The following flower filter fails to match non-PPP_IP{V6} packets
wrapped in PPP_SES protocol:

tc filter add dev eth0 ingress protocol ppp_ses flower \
        action simple sdata hi64

The reason is that proto local variable is being set even when
FLOW_DISSECT_RET_OUT_BAD status is returned.

The fix is to avoid setting proto variable if the PPP protocol is unknown.

Signed-off-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: cc1ff87bce1c ("pppoe: drop PFC frames")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/flow_dissector.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index cc9c63987dc36..8fe8b3afacd04 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1197,9 +1197,8 @@ bool __skb_flow_dissect(const struct net *net,
 			break;
 		}
 
-		proto = hdr->proto;
 		nhoff += PPPOE_SES_HLEN;
-		switch (proto) {
+		switch (hdr->proto) {
 		case htons(PPP_IP):
 			proto = htons(ETH_P_IP);
 			fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
-- 
2.53.0



