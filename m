Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A218531714F;
	Mon, 13 Apr 2026 16:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099253; cv=none; b=jJCh5PSpLhgg3gssTouoehtTP9M6mm/qH+As61L/0ZgjQSQ3pXH2DkOY4O5BWqnAVr667XdN4tHmXbwB8knBaROtxI60yq4pgB+Ak1rdhU+kJnVTUxN9+cKthyB7x1bX8tcYE7WCzt2ymkLwx7vopw9Klj51s/7zv1XsS2InM7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099253; c=relaxed/simple;
	bh=+rpgd452iUSBFpF/4TEVnH5qXNfJJiIDI6n+dPRh3mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CV9Yj/VxjBQt5PPpby1qqyBgtpWwLQSMJ3fBDsyt1WN/zZ/UfHuvSUsQgMZ2mCaQOj8Oxrw7byzUedSQf36/Tu7mRqRyYLRJYcWMf8FNLDDNYTKUFEJJqXJSe2yprWA1j4zRGtKn41HZSWo1YhgTwnSz/6fsVZuh7L/OfFqvo00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zU8VGpG4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zU8VGpG4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 376D8C2BCAF;
	Mon, 13 Apr 2026 16:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099253;
	bh=+rpgd452iUSBFpF/4TEVnH5qXNfJJiIDI6n+dPRh3mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zU8VGpG4v2jC2AUGFgOz22HiZKb4924F3bpI/8QfKFuX4rxd3pbQo12L71hYXNw00
	 4kIcEIBAUfiG8QLwF1OXcxUHXEJQKmlPnjmNJyrZWB8OWkIrBWcLYvuQ9TlQbug9I6
	 h4ZYAn5XMr/RJwEbkQp2Y9FZCLSs1LjyZGgLFAes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 269/491] netfilter: nf_conntrack_expect: skip expectations in other netns via proc
Date: Mon, 13 Apr 2026 17:58:34 +0200
Message-ID: <20260413155829.120948440@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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
index 516a9f05a87a7..e53e225d9489f 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -607,11 +607,15 @@ static int exp_seq_show(struct seq_file *s, void *v)
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



