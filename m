Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDD92E7165;
	Mon, 13 Apr 2026 16:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098038; cv=none; b=cswc7vWgnlWBT6Q4ikHN4Zr7vTGBwUfxT6ofjGKpvomw9as+vCTFqx1pYCoSuPCJmoCYYo+cfYIjGGnE3R9RrMhb2i/MYp1W/7EpxZZbvKydUx4I4ZJbKMzNG/ffchaL4HT2tOOyTRynVK0DUIofDxzd6rVucmN6DdTEEvdpTGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098038; c=relaxed/simple;
	bh=ya0iLdaOlUWonPyWTuQAlWSIOSoTJd43e4AV6qAROYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mOYEuLXnOEKzZe0/Kap/qGJttCfrLiQSe+vHRQdDTttLM4GErFdLuzCn8FxGK0q8KRx6hqJtHEGlH6nGK7d1LXJI6bn+CWGDfa89NSaGdArFkO2GIzgR2RhkPKr0t/06f69TiLsTQVfr6oyypJCZStJC6jFf70DWPgeKP55hzew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LinIVYAU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LinIVYAU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 853F2C2BCB0;
	Mon, 13 Apr 2026 16:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098037;
	bh=ya0iLdaOlUWonPyWTuQAlWSIOSoTJd43e4AV6qAROYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LinIVYAUcYeOOSQo+AxtCfIFiTn7DIy54097hVmRJqSq3fQgopTsF71hAFl3qJ+G7
	 6eINZFCKWrRLqVzUfM/x4ToYbs7bBNHJPqr/6l4Yl/ISVJvRD8xkxxEL/4tw2hCoar
	 166aDLiGyC/zgq2qb5xYNd4Cr02G1P8c84CZCcto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 336/570] netfilter: nf_conntrack_expect: skip expectations in other netns via proc
Date: Mon, 13 Apr 2026 17:57:47 +0200
Message-ID: <20260413155843.080326747@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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
index 6d056ebba57c6..10d4dfbdde226 100644
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



