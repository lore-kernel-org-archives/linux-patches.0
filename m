Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD2E2F2346;
	Tue, 17 Jun 2025 16:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176305; cv=none; b=K6MM70dWB4B6IRTXCPhODVNlKyUidpHP07nJeHQrPTrEZZgs4+/gMVIqluQ+h+9h9y3lp6qXIPhmdw/R9BOx+d8TIa3zE/m9EKhjK+sAv9PQfSSXaGCRjLzlXNRVtoLnFo3NV1TIIZ2scNY3xE40pEXvS5oWSnd3XVau3+LxQH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176305; c=relaxed/simple;
	bh=htO05rXnm3XXqL8jUF9QjEBLdH/2DjL3qLibkSRsLnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4mozw4MfFHD+ci4/h8Fzvi9dS5ez9VSUBg5bCeoZMuAO2+Khlg6U1SQjfKn7MSLwn1cHQk/7nqwhbVHyemXenvLnY2Jorf/rOjJ8ivo/HvW/noSSPYPAwGw6pDLjXEDYhVsI9Le7tlqNxS8vUx32orqmOoc9/J0y87zHZN6ky8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MC27yYeK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MC27yYeK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB1C8C4CEE3;
	Tue, 17 Jun 2025 16:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176305;
	bh=htO05rXnm3XXqL8jUF9QjEBLdH/2DjL3qLibkSRsLnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MC27yYeK/2zwiuiUTVYBjkVtrMUNds3Qt2XGRfnTmqQWoS4hSY5HyhtPWVe57Udby
	 BluQCtGTAEbAjKC/xobOlyXCS8Ij2MeTIp4M3BxB93o9lj7EubjQvxPzyvJnO6m+nQ
	 XjEQmR2RW8U8d1vfsF3J0+DbBlwO15QasRmbGSqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yafang Shao <laoar.shao@gmail.com>,
	Shaun Brady <brady.1345@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 264/356] netfilter: nf_nat: also check reverse tuple to obtain clashing entry
Date: Tue, 17 Jun 2025 17:26:19 +0200
Message-ID: <20250617152348.831287944@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 50d9ce9679dd50df2dc51ada717fa875bc248fad ]

The logic added in the blamed commit was supposed to only omit nat source
port allocation if neither the existing nor the new entry are subject to
NAT.

However, its not enough to lookup the conntrack based on the proposed
tuple, we must also check the reverse direction.

Otherwise there are esoteric cases where the collision is in the reverse
direction because that colliding connection has a port rewrite, but the
new entry doesn't.  In this case, we only check the new entry and then
erronously conclude that no clash exists anymore.

 The existing (udp) tuple is:
  a:p -> b:P, with nat translation to s:P, i.e. pure daddr rewrite,
  reverse tuple in conntrack table is s:P -> a:p.

When another UDP packet is sent directly to s, i.e. a:p->s:P, this is
correctly detected as a colliding entry: tuple is taken by existing reply
tuple in reverse direction.

But the colliding conntrack is only searched for with unreversed
direction, and we can't find such entry matching a:p->s:P.

The incorrect conclusion is that the clashing entry has timed out and
that no port address translation is required.

Such conntrack will then be discarded at nf_confirm time because the
proposed reverse direction clashes with an existing mapping in the
conntrack table.

Search for the reverse tuple too, this will then check the NAT bits of
the colliding entry and triggers port reallocation.

Followp patch extends nft_nat.sh selftest to cover this scenario.

The IPS_SEQ_ADJUST change is also a bug fix:
Instead of checking for SEQ_ADJ this tested for SEEN_REPLY and ASSURED
by accident -- _BIT is only for use with the test_bit() API.

This bug has little consequence in practice, because the sequence number
adjustments are only useful for TCP which doesn't support clash resolution.

The existing test case (conntrack_reverse_clash.sh) exercise a race
condition path (parallel conntrack creation on different CPUs), so
the colliding entries have neither SEEN_REPLY nor ASSURED set.

Thanks to Yafang Shao and Shaun Brady for an initial investigation
of this bug.

Fixes: d8f84a9bc7c4 ("netfilter: nf_nat: don't try nat source port reallocation for reverse dir clash")
Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1795
Reported-by: Yafang Shao <laoar.shao@gmail.com>
Reported-by: Shaun Brady <brady.1345@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Tested-by: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_nat_core.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index ccca6e3848bcc..9df883d79acc9 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -248,7 +248,7 @@ static noinline bool
 nf_nat_used_tuple_new(const struct nf_conntrack_tuple *tuple,
 		      const struct nf_conn *ignored_ct)
 {
-	static const unsigned long uses_nat = IPS_NAT_MASK | IPS_SEQ_ADJUST_BIT;
+	static const unsigned long uses_nat = IPS_NAT_MASK | IPS_SEQ_ADJUST;
 	const struct nf_conntrack_tuple_hash *thash;
 	const struct nf_conntrack_zone *zone;
 	struct nf_conn *ct;
@@ -287,8 +287,14 @@ nf_nat_used_tuple_new(const struct nf_conntrack_tuple *tuple,
 	zone = nf_ct_zone(ignored_ct);
 
 	thash = nf_conntrack_find_get(net, zone, tuple);
-	if (unlikely(!thash)) /* clashing entry went away */
-		return false;
+	if (unlikely(!thash)) {
+		struct nf_conntrack_tuple reply;
+
+		nf_ct_invert_tuple(&reply, tuple);
+		thash = nf_conntrack_find_get(net, zone, &reply);
+		if (!thash) /* clashing entry went away */
+			return false;
+	}
 
 	ct = nf_ct_tuplehash_to_ctrack(thash);
 
-- 
2.39.5



