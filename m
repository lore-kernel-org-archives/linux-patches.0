Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B1E3B9D9D;
	Tue, 21 Jul 2026 22:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671594; cv=none; b=d181vI6D3gT7GAnqrnsAfrOB0rK472zIg+bgtwk4MGQdz5knUJ2F71/IkKC9bp7+ttUcWcIqUIpcZ24QeOC4T3pfjpcM7sLT5lmKta8JwU/v4YUuqaFB2sN+XLxBpunVOjGqNj1+WcVSv7Hv5egkDMRd5RCLXRrhrHo2BivgrZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671594; c=relaxed/simple;
	bh=zO7d0BIDmVRndaNKrZQz70tOT+TVBW3Roo+K64CyzmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEsdZwzjX1h0eS7VThkzMCEOhMkvKIcd62Um/HCLXxqv1lWiGY+s+aQyBrMVN/LO1OrQnS1Ui5pNXk4uQ9Eqo0jtg1v205RPhjUWoZVB/ctlg4n5rirt35rskDjy3ChrCtMtgqGr4WgxxKjpjzQYoLpL0GmX3hB8BMaZ/2gxjBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wMaNj54+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wMaNj54+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DBF41F000E9;
	Tue, 21 Jul 2026 22:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671592;
	bh=hd4YMFgGKO4P+Z4PnvLNRwLVhS+/uXFpg37RdSKr9wE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wMaNj54+j3AILZ9cRkiVTUvUqpcJQxSruQNJd1BhvafbO+9+kvj9Kzs/BOxJo+HIz
	 iXKGlfS9eHCmiOamFST1V0I73dYtPuyXtQl1pssxEdUOqZsJda7J8kj0M5OewkvL1z
	 3ODFVgJEBicDVJUCX792K5E9qjH9GGQf9avdHb1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 303/843] netfilter: conntrack: call nf_ct_gre_keymap_destroy() if master helper is pptp
Date: Tue, 21 Jul 2026 17:18:58 +0200
Message-ID: <20260721152412.844047865@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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
index 00a97743507deb..ea9aba75b38afd 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -622,9 +622,23 @@ static void destroy_gre_conntrack(struct nf_conn *ct)
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



