Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8201FBE8
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:25:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D53C433EF;
	Thu,  1 Jun 2023 13:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685625928;
	bh=+qXVVh2fuhKJxTZT+NiSQWJUiN6sZmK/agtwVahpkAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dmCYh0soYcWfE1TzQH8GslC8iJT3imQH7/dVyqPIc0n1aHY6JcpJsETmQfhjCLLwf
	 ePPpJF1MeJ8kKU1+OjmGEGNLWAcMCY++KSsFFlTn+XKCHfGXLkbenvkvqA9b12xrSo
	 vZl3kzJkNdPf9U/ZMdvD+PhiuRKg12w2VKAcXAbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Blakey <paulb@nvidia.com>,
	Simon Horman <simon.horman@corigine.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Demi Marie Obenour <demi@invisiblethingslab.com>
Subject: [PATCH 5.15 42/42] netfilter: ctnetlink: Support offloaded conntrack entry deletion
Date: Thu,  1 Jun 2023 14:21:29 +0100
Message-Id: <20230601131938.591978622@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131936.699199833@linuxfoundation.org>
References: <20230601131936.699199833@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paul Blakey <paulb@nvidia.com>

commit 9b7c68b3911aef84afa4cbfc31bce20f10570d51 upstream.

Currently, offloaded conntrack entries (flows) can only be deleted
after they are removed from offload, which is either by timeout,
tcp state change or tc ct rule deletion. This can cause issues for
users wishing to manually delete or flush existing entries.

Support deletion of offloaded conntrack entries.

Example usage:
 # Delete all offloaded (and non offloaded) conntrack entries
 # whose source address is 1.2.3.4
 $ conntrack -D -s 1.2.3.4
 # Delete all entries
 $ conntrack -F

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Cc: Demi Marie Obenour <demi@invisiblethingslab.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_conntrack_netlink.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1546,9 +1546,6 @@ static const struct nla_policy ct_nla_po
 
 static int ctnetlink_flush_iterate(struct nf_conn *ct, void *data)
 {
-	if (test_bit(IPS_OFFLOAD_BIT, &ct->status))
-		return 0;
-
 	return ctnetlink_filter_match(ct, data);
 }
 
@@ -1612,11 +1609,6 @@ static int ctnetlink_del_conntrack(struc
 
 	ct = nf_ct_tuplehash_to_ctrack(h);
 
-	if (test_bit(IPS_OFFLOAD_BIT, &ct->status)) {
-		nf_ct_put(ct);
-		return -EBUSY;
-	}
-
 	if (cda[CTA_ID]) {
 		__be32 id = nla_get_be32(cda[CTA_ID]);
 


