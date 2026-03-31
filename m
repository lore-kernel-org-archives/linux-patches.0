Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76A72FC89C;
	Tue, 31 Mar 2026 17:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976551; cv=none; b=k+DAFsUf/aEKuQhjeVguwkEOJkWwpjkHJ1tR4NFIcNuN3qHy6Y/sTvdOTWPa1cURQAMvPIkzF+meayFmBjM25ac6q0ghEJLddhN/4WEDTszubHsB8ETvdFN/6jap1vH5+u69VYOoAdUaPRSkQ/GSxo5B9MW5/K3ORBJXSKCTspY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976551; c=relaxed/simple;
	bh=g0lRBsQhL+dYv7OXG7wEPJQf0TtfP9MknrihQ5A/kMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EY46NeAf/D/z9T84qC36vZG6M2+hWfbs8/1v7hF/Yys6nrBroyBctv826vTPbF1i/bbYCbtkppYAyTxZaBpGUdpWRv9N2h8DOheWMYHUMbbTPSGsm5W9iSIIkcNkp7BG788Rb8ico6SAGI2llue/bKO/BOU608o7fw+YzSKTyGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2u6+VKAh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2u6+VKAh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD7CC19423;
	Tue, 31 Mar 2026 17:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976551;
	bh=g0lRBsQhL+dYv7OXG7wEPJQf0TtfP9MknrihQ5A/kMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2u6+VKAhmf8cAzigqWoqgRCHTp76R0dny0DeupOGKmYfQdBGmhWo5zYfPVw+sSALV
	 S6wdkBXnwyQczOcH3JLj4rVvqFOqeBkuNgTfWwHkHEfOKocZmAfujdF2uJrTFXx+4C
	 FqPeI8OKt5S18pGpRBfeIOt9DZMCJOrRzrbO+JDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 129/309] netfilter: nf_conntrack_expect: skip expectations in other netns via proc
Date: Tue, 31 Mar 2026 18:20:32 +0200
Message-ID: <20260331161758.227129070@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 3db5647984de03d9cae0dcddb509b058351f0ee4 ]

Skip expectations that do not reside in this netns.

Similar to e77e6ff502ea ("netfilter: conntrack: do not dump other netns's
conntrack entries via proc").

Fixes: 9b03f38d0487 ("netfilter: netns nf_conntrack: per-netns expectations")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_expect.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index cfc2daa3fc7f3..227fb5dc39e27 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -627,11 +627,15 @@ static int exp_seq_show(struct seq_file *s, void *v)
 {
 	struct nf_conntrack_expect *expect;
 	struct nf_conntrack_helper *helper;
+	struct net *net = seq_file_net(s);
 	struct hlist_node *n = v;
 	char *delim = "";
 
 	expect = hlist_entry(n, struct nf_conntrack_expect, hnode);
 
+	if (!net_eq(nf_ct_exp_net(expect), net))
+		return 0;
+
 	if (expect->timeout.function)
 		seq_printf(s, "%ld ", timer_pending(&expect->timeout)
 			   ? (long)(expect->timeout.expires - jiffies)/HZ : 0);
-- 
2.51.0



