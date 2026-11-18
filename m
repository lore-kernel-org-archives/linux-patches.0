Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036863;
	b=SMcntNU+3FKW8LM6wT+gWCboaX+QJdtQ1rlziO4PadObf4KbQn1NknUT40LmrcfBapPm
	 JHHUPDoXiAASAARr+LDeZzTeLymTmiar6DoX/uuahuqhx172lF3GTC1QMviH5m8Y7Rxo6
	 u/wo8N0T8KeoQBIaEB4RWrf6uBAvepek6fXzJ3x/ozkhblrAINDTcICwOEZF4vC0ngiv2
	 Kc2hgFY430zXVu/1vyDenH4l5LPWq621ARP8bfQRAp6cBMly9myfJKfnxx+5xxhIlMI04
	 EdcBtUHpoQFD+iWsJeEQfYD8Vubq4Ki8cbPTqQ18i//fWYr21Bz/ybdJJJ384y9P/SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036863;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YeMBGc2UTXkZszvLXlo4rWBPCDz6WCey6TVr3pAE8kk=;
	b=RJZMRsbpLoDbylNK/lyDAvGaTD8oMVaLHqKqHDkKTC+TFL55kHoc/j5n/lbATRiLxUiA
	 RFDNpz2cjsEt5Bw1u6/ue3szIH2yIudX2xtNn5zWHKpDbHxRAhJIghTlcsqsPeMPzL47O
	 iF6xjRiYfAXdBcjdr0VCLp19uTajbN/bFZf3I+wzYDM2Z89D/Z1cM2713q7f0kbo2fq5I
	 +C0uvZuFYbXd3nIFBgRaXETb24QaH51g1ArxAu0eCHd2Y9G+KH7ZM7p+KRmHsWvYgq43e
	 ce8kB0791se7O8amHVWioj8bRsMEu9cMEYvFnkjoQrKVrweZqzwKdS2kNCMUHYuuTEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LLn9ILXQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BB0606A31C;
	Wed, 18 Nov 2026 21:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LLn9ILXQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC641F000C4;
	Wed, 18 Nov 2026 21:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036862;
	bh=YeMBGc2UTXkZszvLXlo4rWBPCDz6WCey6TVr3pAE8kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LLn9ILXQ6giJgJg5KSqGJBvHR/KrjSWiZdktR05CGQrUaFAb/OeO19qHlgN7DyUFR
	 E3+Q/q9K+LO/BKCQSgRvgq6MlMtgtzaUqEeTl2wPN/QYOME4BGMfWp5YaZ8y+laeS+
	 HZpIaXEJwGruLEZi2dLuoBOWdLUAx24pynyK+MM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	yanxia <yanxia@cmss.chinamobile.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1211/3318] veth: fix stale peer max_mtu on XDP program replacement
Date: Wed, 18 Nov 2026 15:30:33 +0100
Message-ID: <20261118150356.501217127@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: yanxia <yanxia@cmss.chinamobile.com>

[ Upstream commit c955325db639e9503941227e14e1f1ccc99442a1 ]

veth_xdp_set() calculates the peer MTU limit from the incoming program's
XDP fragment capability, but only stores it when no program was attached.
Replacing a program with one having a different fragment capability
therefore leaves the peer's max_mtu stale.

Replacing a regular program with an xdp.frags program keeps rejecting
otherwise valid jumbo MTUs. The opposite replacement leaves a larger
limit in place and permits MTUs which a fresh attachment of the regular
program would reject.

Update peer->max_mtu after every successful attachment or replacement.
Keep the GSO feature update conditional on the first attachment.

Found during review of the XDP replacement path and confirmed with
native XDP on an isolated veth pair. Before the fix, direct replacement
rejects MTU 9000 after switching to xdp.frags, and accepts it after
switching back to a regular program. Detaching and attaching instead
produces the expected results in both directions.

UML tests on net reproduce the problem before this change and match the
detach/attach controls afterwards, with both devices up or down and
with either endpoint receiving XDP. Failed replacements preserve the
previous state; same-type replacements and detach also behave as
expected. Small-frame traffic passes in the devices-up cases.

Fixes: 7cda76d858a4 ("veth: Allow jumbo frames in xdp mode")
Cc: stable@vger.kernel.org
Signed-off-by: yanxia <yanxia@cmss.chinamobile.com>
Link: https://patch.msgid.link/20261020020147.790274-1-yanxia@cmss.chinamobile.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 334783a022194..06171a3deb9fe 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1643,10 +1643,9 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 			}
 		}
 
-		if (!old_prog) {
+		if (!old_prog)
 			peer->hw_features &= ~NETIF_F_GSO_SOFTWARE;
-			peer->max_mtu = max_mtu;
-		}
+		peer->max_mtu = max_mtu;
 
 		xdp_features_set_redirect_target(peer, true);
 	}
-- 
2.53.0



