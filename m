Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1CD44AB61;
	Tue, 21 Jul 2026 21:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669099; cv=none; b=GosucPGMPPklO0oTfRkBINrfdzwnei0V+V2BTxbP+T0/lU/AmL4ajBUf4aOQrq5Ok3L/hxd8ejv/L/HHN9lhgdJLWy1/o0IPYZcwkCspsCmcHCQRrHW05uyRbFw3XJK/fXbBOOyO+gmXfj43qLQFoU4FSpRctn7D9NTTSdc9y2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669099; c=relaxed/simple;
	bh=NKA6BSRalp1ACASUbeefFH56ueZ74LARiVMAnbs0n2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ed9P54umWrN8Af0h+k7Ar33MqB/n95MAzWcjsFg6sG0gzcDKrb+YbpykS5Tpl2cDGlAX73P3wQNDH0vrdaZQ3nTLfYfLKZZRrAPh4p/M/KYwXxopobTOA+UMv36zDcpNxxnv1bOnwJq/3eTxGS34cPtfBfrOk4pi27jyFQeOYBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j7ILFXfD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j7ILFXfD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC2E1F000E9;
	Tue, 21 Jul 2026 21:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669097;
	bh=nxURP9lgKk8NxJFmBOnUAks9eGp30kjr64CvaQO8KN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j7ILFXfDEPKl+SW1kkWjiTvVR2mSZ+it+CEhqKxMGwAZbsUJnOzyXTLgu1DZYNcGN
	 j0tyvhozA5fNdN5XN9o6/pUN7G/RdHP1XRoAriMXhUMejUEsgw3Qqi8rmDpkQuzFB1
	 abTyNtIlbSGi1mRqLhQpnWCGfunzaRARzw0zPgnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0383/1067] netfilter: conntrack: call nf_ct_gre_keymap_destroy() if master helper is pptp
Date: Tue, 21 Jul 2026 17:16:24 +0200
Message-ID: <20260721152433.199069778@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 002d53ded404ec..f5c466ea1e7df7 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -576,9 +576,23 @@ static void destroy_gre_conntrack(struct nf_conn *ct)
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



