Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047259;
	b=wD1xzk49O8ci9Gn+13G6BC4Z88yIESSW4dFXy9MnOEKJVdLdS9/R58PeB8ig1aGrymD5
	 TOWCbgX1T5bxaAVANJXZtAULeQBa0frLMriFgr0y+vEbPmV8ueg1eWMFmBJ/WLbfFdEZk
	 1BdByBveoZC4aW64885R0UgAiTouQR8jyx7s2YsZM0PFpSGpQYrwDLZzvBOmgXhbEnkx1
	 4ifIP3J85Pt005EM1zq5Uenm5R+XArnfbNfKQ/YYorAAIdsRnN1m0dG2y0oP6zSex6p+Q
	 BE3DEAu3ELkHqwiTK4BDCpNLOX3G3+nNxdEJ7NSNfWSN0/as5JPuOrlfqcLT/CLYKWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047259;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LDpKSie6bQzSqmy7FrF/xd9/1ISTxATCAhjDT8gkU2g=;
	b=jW6dJsdatvBQpjuoKWn7ox6cHkPTQMl89kMBjzSDXPamteHdlY8rYkVFEtLCUQGbIdFg
	 nTi+LLO6p6fEXpjGgtO4EXjdsThdprUEzoPGSCj3Io1caTAkEGW9VoPdXdbiMdAih+AXw
	 NDKqKSYMu7wCnkSK723csTs5yBUOak1f8Khudkd4tSG2sAwozaFEGtnqscMwf1MX01e4l
	 0GAqXO55rS4kZOwczPop5867YQOC3Mj9yYMx1QzZzWxnoS/KxGjHvHAq7qEV2xvGF533p
	 aR8pBSK/stt7dn6MTNAWHuthpJ+0BAXTFY6gl7db5pR5an2oL05a5utYzaaFC3woKJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=svCoiKgQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D522606A31C;
	Thu, 19 Nov 2026 00:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=svCoiKgQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565BB1F000C4;
	Thu, 19 Nov 2026 00:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047258;
	bh=LDpKSie6bQzSqmy7FrF/xd9/1ISTxATCAhjDT8gkU2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=svCoiKgQKaHaiu5tU3X+dN4g2k/b09QMULlU36VL4/8pPKJmhw9NsxDULJknmlfky
	 bWrdjYuAl96Gp4jeiI2WgVK5jDUCjkJWdHr2GDmRkt1YZXIgFIBboCTnJOeLF1lqep
	 44kRzhSwaLn7G/x2H+D+i/QmAadwBut08TsBaYHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	yanxia <yanxia@cmss.chinamobile.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1575/2857] veth: fix stale peer max_mtu on XDP program replacement
Date: Wed, 18 Nov 2026 15:43:29 +0100
Message-ID: <20261118150258.090645358@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context for the missing xdp_features_set_redirect_target(peer, true) call ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index e8064b9253720..b8a2b3be2767e 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1536,10 +1536,9 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 			}
 		}
 
-		if (!old_prog) {
+		if (!old_prog)
 			peer->hw_features &= ~NETIF_F_GSO_SOFTWARE;
-			peer->max_mtu = max_mtu;
-		}
+		peer->max_mtu = max_mtu;
 	}
 
 	if (old_prog) {
-- 
2.53.0



