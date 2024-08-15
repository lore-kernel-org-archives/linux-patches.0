Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D598F7DA78;
	Thu, 15 Aug 2024 13:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728610; cv=none; b=DQi73eimPmPnq84Y3t6ahjdZYZ8ASgbEvf3EB4HmEiKuHhRjGoEJ3RRpBWWWTnn5pGY35HNQGkWc676wvsywd5Jz8YhVj95rvA0L3oSJEjbfvMA9THH8TYMYSYfwrlO08KxwV04qEU0m91aqZextMGzcGViBB+Y9qt1RLdBixKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728610; c=relaxed/simple;
	bh=xfqK6ctOyojTSXPZ8LCLPLIr/JzNhSFX5oEVtoOU87k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nuns3h+BY+Ps7Fy1bzUWOGx9p5RewF1l+OTlepKXWZDb2kOCX66SzqU+Rbh/5SKTftnf3rmH5YctYS3Gt6cGSWopeg00cqhtm0RKEWdgkCeTsywC8wMFrEcpnF2vnjB2xsOg7ZhMppBvjkvVFrkcqnxkIoKogG2daFE2EqwAyKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hh6/y76G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hh6/y76G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02FDEC32786;
	Thu, 15 Aug 2024 13:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728609;
	bh=xfqK6ctOyojTSXPZ8LCLPLIr/JzNhSFX5oEVtoOU87k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hh6/y76GFa215g9IsBr4J6jWUqEDJWS589Brxw3wdnDNmsX9TKJ85X2iYQkrFgdWl
	 Oxz3Xz4PO5Rsfiq2cFeAIvce4cRcjGqE0tMufQ/+Iwfb2FeXjdsZRxVrFzCJ1+aQPn
	 ml3Onf7z7XSIqpJ1zV8BfKICc1rAI+izzfnsje5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zdi-disclosures@trendmicro.com,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 054/196] netfilter: ctnetlink: use helper function to calculate expect ID
Date: Thu, 15 Aug 2024 15:22:51 +0200
Message-ID: <20240815131854.146808322@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 782161895eb4ac45cf7cfa8db375bd4766cb8299 ]

Delete expectation path is missing a call to the nf_expect_get_id()
helper function to calculate the expectation ID, otherwise LSB of the
expectation object address is leaked to userspace.

Fixes: 3c79107631db ("netfilter: ctnetlink: don't use conntrack/expect object addresses as id")
Reported-by: zdi-disclosures@trendmicro.com
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 83e8566ec3f05..bcb72ad2c1786 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3106,7 +3106,8 @@ static int ctnetlink_del_expect(struct net *net, struct sock *ctnl,
 
 		if (cda[CTA_EXPECT_ID]) {
 			__be32 id = nla_get_be32(cda[CTA_EXPECT_ID]);
-			if (ntohl(id) != (u32)(unsigned long)exp) {
+
+			if (id != nf_expect_get_id(exp)) {
 				nf_ct_expect_put(exp);
 				return -ENOENT;
 			}
-- 
2.43.0



