Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59B13B1EFC;
	Tue, 21 Jul 2026 20:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666521; cv=none; b=rXGb6RG9VK08fmzusdgV1vFlM5Bv/MM2GrOc7VkUAj6RWpDII0LyG0AyqIVEaHTvO1y0BjFZTP5bTgnUerMwQQCu+3pnSf2acidzzSdal7y6lmcWQevz4eKp4MuAjUMhwp5ZNmNiYI2HxYTL8IItUpdf68NlclT/1gDPFlrPRAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666521; c=relaxed/simple;
	bh=2H13zIZXRk+iAix6mWXISzrPihNZzyX9P5C7YwRRZao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPjJtMbcql0nSGro4lhCPYagcgHLyu//8rGG4fQAjTfZqdzzesHBeE3haoGpbHBrcNq2JIcN6r0n+zPyQrDbFEUt9EIAyVTctejr7mKWrbTdCwBkU5fKYTyGTLr7odiO8njwwqqA5s+SGyw6qd3GrQ1zNJ1zBIRIgbN61Hr4Zog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ef9Em1EH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ef9Em1EH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577F71F000E9;
	Tue, 21 Jul 2026 20:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666519;
	bh=wgRodg2BzJqwQxv3Nma1uFfYRC717QVBN7J2OOl0ItU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ef9Em1EHYAuyI17QKiQpNvf5AB48ijcZLBcog/HwzNGXfPp1e3hE0hAvQMqTPWpmR
	 xAoxqYYRxVDCsiQqh2E5+ZFLQVKZBatEtB+MtoTWPae4mLFZM5fQtEtpTr5qJDsN22
	 vjKguiPmh4t5kvMCITN0l0hvtr7wMOinPE9OogrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Yu <yumike@google.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0714/1266] xfrm: Support crypto offload for inbound IPv6 ESP packets not in GRO path
Date: Tue, 21 Jul 2026 17:19:11 +0200
Message-ID: <20260721152457.842937781@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Yu <yumike@google.com>

[ Upstream commit f7e8542d71e908706855a9f3e9e7844fea1feea0 ]

IPsec crypt offload supports outbound IPv6 ESP packets, but it doesn't
support inbound IPv6 ESP packets.

This change enables the crypto offload for inbound IPv6 ESP packets
that are not handled through GRO code path. If HW drivers add the
offload information to the skb, the packet will be handled in the
crypto offload rx code path.

Apart from the change in crypto offload rx code path, the change
in xfrm_policy_check is also needed.

Exampe of RX data path:

  +-----------+   +-------+
  | HW Driver |-->| wlan0 |--------+
  +-----------+   +-------+        |
                                   v
                             +---------------+   +------+
                     +------>| Network Stack |-->| Apps |
                     |       +---------------+   +------+
                     |             |
                     |             v
                 +--------+   +------------+
                 | ipsec1 |<--| XFRM Stack |
                 +--------+   +------------+

Test: Enabled both in/out IPsec crypto offload, and verified IPv6
      ESP packets on Android device on both wifi/cellular network
Signed-off-by: Mike Yu <yumike@google.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Stable-dep-of: 68de007d5ac9 ("xfrm: annotate data-races around xfrm_policy_count[] and xfrm_policy_default[]")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_input.c  | 2 +-
 net/xfrm/xfrm_policy.c | 5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 1d20f2a0a7386b..1483770f845642 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -470,7 +470,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 	struct xfrm_offload *xo = xfrm_offload(skb);
 	struct sec_path *sp;
 
-	if (encap_type < 0 || (xo && xo->flags & XFRM_GRO)) {
+	if (encap_type < 0 || (xo && (xo->flags & XFRM_GRO || encap_type == 0))) {
 		x = xfrm_input_state(skb);
 
 		if (unlikely(x->km.state != XFRM_STATE_VALID)) {
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 2110941c8e9a75..ef07c9872b8d14 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3683,12 +3683,15 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 	}
 
 	if (!pol) {
+		const bool is_crypto_offload = sp &&
+			(xfrm_input_state(skb)->xso.type == XFRM_DEV_OFFLOAD_CRYPTO);
+
 		if (net->xfrm.policy_default[dir] == XFRM_USERPOLICY_BLOCK) {
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMINNOPOLS);
 			return 0;
 		}
 
-		if (sp && secpath_has_nontransport(sp, 0, &xerr_idx)) {
+		if (sp && secpath_has_nontransport(sp, 0, &xerr_idx) && !is_crypto_offload) {
 			xfrm_secpath_reject(xerr_idx, skb, &fl);
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMINNOPOLS);
 			return 0;
-- 
2.53.0



