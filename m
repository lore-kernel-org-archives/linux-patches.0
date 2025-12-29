Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C862931B111;
	Mon, 29 Dec 2025 16:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025075; cv=none; b=Lh66qWtlk1H1svZeN2Z8p6+Orwoa+7azzatn4QySGmzZrHO4+PxG/1pvq7EXwwpREBxrXDIa47W2joDacunQlhf9HAmqT2EXsiAqWKXkND5lGrQM2UXhJ/0lNHwV3gjXbX/E9Nr/GUV4BmjaIl8HfdYDgJH89O2gvTavTDSJjkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025075; c=relaxed/simple;
	bh=pUfO1eznxEX+VNf++uDAsddTfwypkoT8US1Zt996uWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQa++EGGkk4EWo93uINpPGxl9gnnqHBdVt+P7hrrPBi7SqKKPPtdfHE18SEyY4GlgiLrAPZibOewlOlC86I9D3wXQwMPSPdSxRyh4fFWYXWnwjolfwWpK9gX5uUFRtF8Ue1shq4SpG1IPzJ6Bacb+w0JAgv0ZSJQorZkRSl/CRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pfNH8N0R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pfNH8N0R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E18EC4CEF7;
	Mon, 29 Dec 2025 16:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025075;
	bh=pUfO1eznxEX+VNf++uDAsddTfwypkoT8US1Zt996uWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pfNH8N0RgvVQ3IZeJGi0Aao9alCItuvG57QRJNrf/0F4EghPvFTql2VVfcgX5DbE1
	 2Q9AORdrlWe+C6DlPuqR2QM7VayoSDMl68v5JtqAcGuipHo7Sf8ZJyJT9zrAPU7sMP
	 Zbwv+6dOgdyMOC+Y/o3l+wBOsd0aGqjUw77u12is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 085/430] netfilter: nf_nat: remove bogus direction check
Date: Mon, 29 Dec 2025 17:08:07 +0100
Message-ID: <20251229160727.491260836@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 5ec8ca26fe93103577c904644b0957f069d0051a ]

Jakub reports spurious failures of the 'conntrack_reverse_clash.sh'
selftest.  A bogus test makes nat core resort to port rewrite even
though there is no need for this.

When the test is made, nf_nat_used_tuple() would already have caused us
to return if no other CPU had added a colliding entry.
Moreover, nf_nat_used_tuple() would have ignored the colliding entry if
their origin tuples had been the same.

All that is left to check is if the colliding entry in the hash table
is subject to NAT, and, if its not, if our entry matches in the reverse
direction, e.g. hash table has

addr1:1234 -> addr2:80, and we want to commit
addr2:80   -> addr1:1234.

Because we already checked that neither the new nor the committed entry is
subject to NAT we only have to check origin vs. reply tuple:
for non-nat entries, the reply tuple is always the inverted original.

Just in case there are more problems extend the error reporting
in the selftest while at it and dump conntrack table/stats on error.

Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://lore.kernel.org/netdev/20251206175135.4a56591b@kernel.org/
Fixes: d8f84a9bc7c4 ("netfilter: nf_nat: don't try nat source port reallocation for reverse dir clash")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_nat_core.c                        | 14 +-------------
 .../net/netfilter/conntrack_reverse_clash.c        | 13 +++++++++----
 .../net/netfilter/conntrack_reverse_clash.sh       |  2 ++
 3 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 78a61dac4ade8..e6b24586d2fed 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -294,25 +294,13 @@ nf_nat_used_tuple_new(const struct nf_conntrack_tuple *tuple,
 
 	ct = nf_ct_tuplehash_to_ctrack(thash);
 
-	/* NB: IP_CT_DIR_ORIGINAL should be impossible because
-	 * nf_nat_used_tuple() handles origin collisions.
-	 *
-	 * Handle remote chance other CPU confirmed its ct right after.
-	 */
-	if (thash->tuple.dst.dir != IP_CT_DIR_REPLY)
-		goto out;
-
 	/* clashing connection subject to NAT? Retry with new tuple. */
 	if (READ_ONCE(ct->status) & uses_nat)
 		goto out;
 
 	if (nf_ct_tuple_equal(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
-			      &ignored_ct->tuplehash[IP_CT_DIR_REPLY].tuple) &&
-	    nf_ct_tuple_equal(&ct->tuplehash[IP_CT_DIR_REPLY].tuple,
-			      &ignored_ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple)) {
+			      &ignored_ct->tuplehash[IP_CT_DIR_REPLY].tuple))
 		taken = false;
-		goto out;
-	}
 out:
 	nf_ct_put(ct);
 	return taken;
diff --git a/tools/testing/selftests/net/netfilter/conntrack_reverse_clash.c b/tools/testing/selftests/net/netfilter/conntrack_reverse_clash.c
index 507930cee8cb6..462d628cc3bdb 100644
--- a/tools/testing/selftests/net/netfilter/conntrack_reverse_clash.c
+++ b/tools/testing/selftests/net/netfilter/conntrack_reverse_clash.c
@@ -33,9 +33,14 @@ static void die(const char *e)
 	exit(111);
 }
 
-static void die_port(uint16_t got, uint16_t want)
+static void die_port(const struct sockaddr_in *sin, uint16_t want)
 {
-	fprintf(stderr, "Port number changed, wanted %d got %d\n", want, ntohs(got));
+	uint16_t got = ntohs(sin->sin_port);
+	char str[INET_ADDRSTRLEN];
+
+	inet_ntop(AF_INET, &sin->sin_addr, str, sizeof(str));
+
+	fprintf(stderr, "Port number changed, wanted %d got %d from %s\n", want, got, str);
 	exit(1);
 }
 
@@ -100,7 +105,7 @@ int main(int argc, char *argv[])
 				die("child recvfrom");
 
 			if (peer.sin_port != htons(PORT))
-				die_port(peer.sin_port, PORT);
+				die_port(&peer, PORT);
 		} else {
 			if (sendto(s2, buf, LEN, 0, (struct sockaddr *)&sa1, sizeof(sa1)) != LEN)
 				continue;
@@ -109,7 +114,7 @@ int main(int argc, char *argv[])
 				die("parent recvfrom");
 
 			if (peer.sin_port != htons((PORT + 1)))
-				die_port(peer.sin_port, PORT + 1);
+				die_port(&peer, PORT + 1);
 		}
 	}
 
diff --git a/tools/testing/selftests/net/netfilter/conntrack_reverse_clash.sh b/tools/testing/selftests/net/netfilter/conntrack_reverse_clash.sh
index a24c896347a88..dc7e9d6da0624 100755
--- a/tools/testing/selftests/net/netfilter/conntrack_reverse_clash.sh
+++ b/tools/testing/selftests/net/netfilter/conntrack_reverse_clash.sh
@@ -45,6 +45,8 @@ if ip netns exec "$ns0" ./conntrack_reverse_clash; then
 	echo "PASS: No SNAT performed for null bindings"
 else
 	echo "ERROR: SNAT performed without any matching snat rule"
+	ip netns exec "$ns0" conntrack -L
+	ip netns exec "$ns0" conntrack -S
 	exit 1
 fi
 
-- 
2.51.0



