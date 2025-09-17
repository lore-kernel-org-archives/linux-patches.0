Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C24830BBBC;
	Wed, 17 Sep 2025 12:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113066; cv=none; b=XvWHanDSUViA7aohQKZeV0sR6xT/uax/cgbMGfOzMpMOoFIFz4pCHbDTXZ2TXwwjB5UxZ9XvKhwltuiLvOxiKv0NctYIdimOCxaght01JQJ4QYQnAhFznx/Az5Yw6DD8hAzE7l1hAUfkxrYIq19TcwXdR+tTMYjRw5GWE4jopPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113066; c=relaxed/simple;
	bh=LzWsL4lhw2x4s7BVlgHC/uizME4Ep8kIL/S4k/qnZUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5PtNti3WCiQ6hvitgIBgurXADDOuPJQuT/LJg/43gXHrMo6QWxrpBv+Z2vyaDp0hWdRVEnqViNYjkVR6P7gr4HEw4eH57OHAGeEtmwR12ETkkQZPM2hNzabJl8498InbiiY7zR+BV2vB+GcW4uGjngdd8odH5AAyHl94jj49SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mI0KElAF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mI0KElAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6771EC4CEF0;
	Wed, 17 Sep 2025 12:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113065;
	bh=LzWsL4lhw2x4s7BVlgHC/uizME4Ep8kIL/S4k/qnZUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mI0KElAFoeXNIh0ozaRXSEMFjgOUTmzvXHi9VRh4zYZqYJ4rHJCrXnuw9ODVlx7OM
	 L8GOLre9C+PeflM/UQUrXjJEicYMgSnIWGpHEckuucBNfD90pqk6F9bvzgAf2C87GI
	 /prjsqi1mHx+o175SWUXAbyFU/WGk49vwsZALMEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 162/189] netfilter: nf_tables: restart set lookup on base_seq change
Date: Wed, 17 Sep 2025 14:34:32 +0200
Message-ID: <20250917123355.832077150@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit b2f742c846cab9afc5953a5d8f17b54922dcc723 ]

The hash, hash_fast, rhash and bitwise sets may indicate no result even
though a matching element exists during a short time window while other
cpu is finalizing the transaction.

This happens when the hash lookup/bitwise lookup function has picked up
the old genbit, right before it was toggled by nf_tables_commit(), but
then the same cpu managed to unlink the matching old element from the
hash table:

cpu0					cpu1
  has added new elements to clone
  has marked elements as being
  inactive in new generation
					perform lookup in the set
  enters commit phase:
					A) observes old genbit
   increments base_seq
I) increments the genbit
II) removes old element from the set
					B) finds matching element
					C) returns no match: found
					element is not valid in old
					generation

					Next lookup observes new genbit and
					finds matching e2.

Consider a packet matching element e1, e2.

cpu0 processes following transaction:
1. remove e1
2. adds e2, which has same key as e1.

P matches both e1 and e2.  Therefore, cpu1 should always find a match
for P. Due to above race, this is not the case:

cpu1 observed the old genbit.  e2 will not be considered once it is found.
The element e1 is not found anymore if cpu0 managed to unlink it from the
hlist before cpu1 found it during list traversal.

The situation only occurs for a brief time period, lookups happening
after I) observe new genbit and return e2.

This problem exists in all set types except nft_set_pipapo, so fix it once
in nft_lookup rather than each set ops individually.

Sample the base sequence counter, which gets incremented right before the
genbit is changed.

Then, if no match is found, retry the lookup if the base sequence was
altered in between.

If the base sequence hasn't changed:
 - No update took place: no-match result is expected.
   This is the common case.  or:
 - nf_tables_commit() hasn't progressed to genbit update yet.
   Old elements were still visible and nomatch result is expected, or:
 - nf_tables_commit updated the genbit:
   We picked up the new base_seq, so the lookup function also picked
   up the new genbit, no-match result is expected.

If the old genbit was observed, then nft_lookup also picked up the old
base_seq: nft_lookup_should_retry() returns true and relookup is performed
in the new generation.

This problem was added when the unconditional synchronize_rcu() call
that followed the current/next generation bit toggle was removed.

Thanks to Pablo Neira Ayuso for reviewing an earlier version of this
patchset, for suggesting re-use of existing base_seq and placement of
the restart loop in nft_set_do_lookup().

Fixes: 0cbc06b3faba ("netfilter: nf_tables: remove synchronize_rcu in commit phase")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c |  3 ++-
 net/netfilter/nft_lookup.c    | 31 ++++++++++++++++++++++++++++++-
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5ea7a015504bb..cde63e5f18d8f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10971,7 +10971,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	while (++base_seq == 0)
 		;
 
-	WRITE_ONCE(net->nft.base_seq, base_seq);
+	/* pairs with smp_load_acquire in nft_lookup_eval */
+	smp_store_release(&net->nft.base_seq, base_seq);
 
 	gc_seq = nft_gc_seq_begin(nft_net);
 
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 2c6909bf1b407..58c5b14889c47 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -55,11 +55,40 @@ __nft_set_do_lookup(const struct net *net, const struct nft_set *set,
 	return set->ops->lookup(net, set, key);
 }
 
+static unsigned int nft_base_seq(const struct net *net)
+{
+	/* pairs with smp_store_release() in nf_tables_commit() */
+	return smp_load_acquire(&net->nft.base_seq);
+}
+
+static bool nft_lookup_should_retry(const struct net *net, unsigned int seq)
+{
+	return unlikely(seq != nft_base_seq(net));
+}
+
 const struct nft_set_ext *
 nft_set_do_lookup(const struct net *net, const struct nft_set *set,
 		  const u32 *key)
 {
-	return __nft_set_do_lookup(net, set, key);
+	const struct nft_set_ext *ext;
+	unsigned int base_seq;
+
+	do {
+		base_seq = nft_base_seq(net);
+
+		ext = __nft_set_do_lookup(net, set, key);
+		if (ext)
+			break;
+		/* No match?  There is a small chance that lookup was
+		 * performed in the old generation, but nf_tables_commit()
+		 * already unlinked a (matching) element.
+		 *
+		 * We need to repeat the lookup to make sure that we didn't
+		 * miss a matching element in the new generation.
+		 */
+	} while (nft_lookup_should_retry(net, base_seq));
+
+	return ext;
 }
 EXPORT_SYMBOL_GPL(nft_set_do_lookup);
 
-- 
2.51.0



