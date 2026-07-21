Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F50367B92;
	Tue, 21 Jul 2026 22:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673626; cv=none; b=WCVopqniZPeT2r3cLg7x7vdcXE3oNA88RsQbN0W4g8DLHuS8unUZ4+PLscEzzo5HpwiEtuzq1eeJpkVor6Pxvg3wIvQtH2BpgzCyhupr1+Y2rCiowjF8k/VwZ9dHKheXQ5wdCw3rZGVH96zLsaoB1a9x0F7zY725ZIxOezFGF2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673626; c=relaxed/simple;
	bh=MyplwfVCTx6CjUZRpvLZVUQMnEjlmdmSuMJQKRuxIYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZYF+O0rK2vHS8NXWJjwDeE0CmlF9be5JL8VRHHPOuy/Hl9TSRiOUcQaMtmMGFMbhpZ2JZMm9HFDdqHm/5argCtx5YE8XBBGpbhqkTBaziqllvjQK/RDot7v+v/EN/sf4AxiWVt/rF8W+jxApNCI/jU625cKYpOqhvjs3A/teJec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cWCR/w3w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cWCR/w3w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6B51F000E9;
	Tue, 21 Jul 2026 22:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673624;
	bh=sqTAS5gwKd3W968ED1xrlEpRJ3jHpY1r8Euz+xguDNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cWCR/w3wvO4l0x/fPApf8F7hsPUU9d7coIPhj5hBSezHwrDD57vhQrfSwyNcSOmY9
	 B7TSB3rDA3H25x7uaNdGeUBV4rM4sXkPIsQFG4UJQ7+btUSwWARXieGWJXTzWxM6FD
	 y0Ug+i3UAS0kf8UbvUDKZQr8PCFSbEePNW7lCVF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 234/699] netfilter: conntrack: call nf_ct_gre_keymap_destroy() if master helper is pptp
Date: Tue, 21 Jul 2026 17:19:53 +0200
Message-ID: <20260721152400.977823251@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit b0f02608fbcd607b5131cceb91fc0a035264e61c ]

For GRE flows, validate that the ct master helper (if any) is pptp
before calling nf_ct_gre_keymap_destroy(), so the helper data area
can be accessed safely. Note that only the pptp helper provides a
.destroy callback.

Fixes: e56894356f60 ("netfilter: conntrack: remove l4proto destroy hook")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_core.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index aea25823fbc14b..e2330c3456b039 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -585,9 +585,23 @@ static void destroy_gre_conntrack(struct nf_conn *ct)
 {
 #ifdef CONFIG_NF_CT_PROTO_GRE
 	struct nf_conn *master = ct->master;
+	struct nf_conn_help *help;
+
+	if (!master)
+		return;
+
+	help = nfct_help(master);
+	if (help) {
+		struct nf_conntrack_helper *helper;
 
-	if (master)
-		nf_ct_gre_keymap_destroy(master);
+		rcu_read_lock();
+		helper = rcu_dereference(help->helper);
+		/* Only pptp helper has a destroy callback. */
+		if (helper && helper->destroy)
+			nf_ct_gre_keymap_destroy(master);
+
+		rcu_read_unlock();
+	}
 #endif
 }
 
-- 
2.53.0



