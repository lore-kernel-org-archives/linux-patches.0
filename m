Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C237DA9E;
	Thu, 15 Aug 2024 13:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729581; cv=none; b=SDYEqH0NgDh9EGmQEzYhsMeSnkzuJtKE2bMl31qw4gEmiBSxb/x5C4bcp8xyHLj9LnjQLirPtmOCFmgq5uDMcojfRhO+5vHmi96aLSkXRggwqRwv6DgRaNJNG3Zs/B6Poqa6i04K4XBKUV0V/5b/CMSNCV5F4IYZO3A3/+EueZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729581; c=relaxed/simple;
	bh=7Aas2ufuWNY6yohTvWpG3PyP9AJ+BiiOfVEdQctHnbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o7Z0zxWtTr+9jtlRDSd2xKBVjN5YDvnHcMTx353D8/7YTm+rJTmiFb3pGNilk/qXbhnUV1dZoksG7F1Q6a4QEyaC0BjkDL448C5rKj8CMrsc0d3W72oAaQXULVfOol60LmTuf0iz69jWc86a0ZbvNCl5zSXe16KCWfUap1Xyod8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ayv/Uynt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ayv/Uynt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2431FC32786;
	Thu, 15 Aug 2024 13:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729581;
	bh=7Aas2ufuWNY6yohTvWpG3PyP9AJ+BiiOfVEdQctHnbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ayv/UyntJJk0Pa33i1gNfnAm160DwMXmvM7oZbFhkLx3vJ8E2tFwavmGXMY7vaSBp
	 xRYUXnOku0dQ/OSxSMgC7P0cOy/gR+CijQjdEmrmfrHObfhIo3LatjpN3OYugekn3O
	 gevzqyCqbXNdbnXWubh+IpmLXmKe93z028omg4Q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zdi-disclosures@trendmicro.com,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 144/484] netfilter: ctnetlink: use helper function to calculate expect ID
Date: Thu, 15 Aug 2024 15:20:02 +0200
Message-ID: <20240815131946.979408876@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1466015bc56dc..b429ffde25b1a 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3426,7 +3426,8 @@ static int ctnetlink_del_expect(struct sk_buff *skb,
 
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



