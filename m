Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0111A3E3C5C;
	Tue, 31 Mar 2026 16:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975045; cv=none; b=XmuxGU83kg6AFTXO2RsU7kMrlg1/z7OTYKKV3Od/cLcV6d4ykOyx8vaod63tTh6gt1pCxdYS2cnjtJ925Ig6TGtqT2W06z2fO0x0nr+GBgUbncb3Lz1GtJvZcri+yX2vgbFOZCuen9TE7PQozhWdcxsEMizmhmt7olGeX8WeEkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975045; c=relaxed/simple;
	bh=aIuuk7zT7ciCHqCz0EjmiVN1ahk9sjNWH4pdwfifZWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OSBS38Kcwlev6EmST32Ski025aKdC3x2ehdBO+2SNDOptZsDLrQpnUD3uK1EgfJR9rdeW9Bks63gxh8L0/SMTk4mwaNst14dsLaYpmoC+kPIkj1WJ8YwiD/0eysE5lElD4c4rwWGO+jfBOjPe69c8Ai3MyfbI/2PEGep+RmmrRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z2sCwBvd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z2sCwBvd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AFFCC19423;
	Tue, 31 Mar 2026 16:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975044;
	bh=aIuuk7zT7ciCHqCz0EjmiVN1ahk9sjNWH4pdwfifZWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z2sCwBvdZwaielbig/z1oaYhRWtLV7fjAQQXC2rgldQhTFngOjPw7nWXD5PFufCIV
	 jq+jSUlOXuC1mbpJ4mYR/0NBRsmRj41ZD7k5HEqpaoxD/gXDqciaZRxRMZ8AuuAkse
	 DILyt+vZkwk0u/DNpiJBNJt2OdZS26PMICuPR+4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 143/342] netfilter: nf_conntrack_expect: skip expectations in other netns via proc
Date: Tue, 31 Mar 2026 18:19:36 +0200
Message-ID: <20260331161804.269936896@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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



