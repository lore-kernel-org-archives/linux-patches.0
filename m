Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC7746EF6C;
	Tue, 21 Jul 2026 19:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661914; cv=none; b=jegDVmvIXk2nZcOHNVz9I/FEymKejD6fNJm8ADdXELYN5UBU0DsZGqHnfQQZzpoD0+K9J28WH6DPVsih8xDHL8lLK6AhTq/iyri2mX49z0a3Zedh9E2WhjjOBZ7BH2Jlcbr5kPQTPm0SOhlendh/3IHMNQZQ+p57MoJ9SD8LgHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661914; c=relaxed/simple;
	bh=xetT50aBK6VKr4Ddf3x463sQfLmPMnksvQ/b6HvCbU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmogYCB3bLiZQhZLlX1YLW4yG7PZ7u7R63W11fwr/KdAVU80MRi0O3DGWDndkIwdj7Tmah2xJPJHaaVyg+wm9M942ZQ+pQpaOSmoLoT978RymdKIeLKa/KPSN7p+aQSu9KmfnrxhV5EC1btZS2Fl79lBQR+OYsAMuwsjzErRNrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d5FvpYr7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d5FvpYr7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F111F000E9;
	Tue, 21 Jul 2026 19:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661913;
	bh=5B2914HCmfEo6XoQw5PVNoXY3HtCOn6zEvfz4QNoRQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d5FvpYr7+KAdvIRIalTw8bUJh/P6HihkQqtFgF1znrwkMmiXQf5poRZEJXSVCqGbc
	 OFLk9P2cuKSZra1NRQt0XLwcrY0XnEUPkbEhZBaTShVLILnlIOiqT1ZZGNQLyAAYVr
	 QuG/0HryzL214RYOkoYyvmpqdDAYjvSd+NhdMtuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0247/1276] netfilter: conntrack: call nf_ct_gre_keymap_destroy() if master helper is pptp
Date: Tue, 21 Jul 2026 17:11:30 +0200
Message-ID: <20260721152451.617813223@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 82bc581e3df40a..423080cf86a4f2 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -565,9 +565,23 @@ static void destroy_gre_conntrack(struct nf_conn *ct)
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



