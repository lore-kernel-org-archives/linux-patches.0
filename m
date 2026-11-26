Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704542;
	b=sqsyc0rds9yU0T820CK1a4X+lm7zIdQgvuWh0i+BPdfCbXGmZHkY5Cd+Au6apoclOkHD
	 A98FHQD/Ga8vbEKDQ29v+crUzBZrsH73uruvmhC3Dew/FLd0T5+sQTJMwlsvn81TcGYDU
	 lw7khaXDrQmGyGNgJcgqSohKsyn3rU1gGGYoWk8N/XI1VymIZGFOfWZJYLtzyaQtVRtvk
	 GQVJnSKuHg7f51Cf3k35ahJ+ZrLQuj4d9kGoMnyD3p2Fbwk8ZkCZimKAHTrD8RXcx56F9
	 rjWB9o05sr9i2hJ/ceXyGxNVVORD/msF7GVgPnBMk8HSv8XpvcQ8SIQ+ehKQyfK6k6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704542;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=oapEMry0T/E245m/chFmaxO+Mp2yl+BzRpx/xyvkAiE=;
	b=mNdoQcG2so1Lk8lO+u5ITUf1yHyRoVNoDxAzIkowPf/MDCooVsd9bJVmejOU/FW1ujrK
	 AGWHB9Hb74ARB3gSrg9zpTd9bZyy8Ks15wMd9bcAXdvWdka+eS9aREAOYiEim/S2q9kED
	 8nzLnKVERwYvodWcqpAeKP4cxjgEhDd3dcMMZRbiuJx/geetk4UT2dLj3A0DAhwXwPbpb
	 JE6Ai11A8sA71ljkZhY1gkoS6NFDbas3/W7y4c0vGm3q4KfmYt+cOyii2XknGv9kBEWkW
	 hFYJJHePEK/iaijW19QJG3kSBaQtsjXcBm6ZhKQPJlUSgSbwWg3Y15NToCgUXrBstKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=se+zAEQU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3D9606A31C;
	Thu, 26 Nov 2026 14:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=se+zAEQU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27DE91F000C4;
	Thu, 26 Nov 2026 14:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704541;
	bh=oapEMry0T/E245m/chFmaxO+Mp2yl+BzRpx/xyvkAiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=se+zAEQU60/gK7W6zP0pRZ7BVwnHinYXftdryoomypH55eWs2PKRC7lM02uero45N
	 BZ8qpNdZGhL6Pi5evMa0Lqh5WjM0LKSLbFangrUVxoYziKGG3uNMQVXTD8lYUw9SYs
	 GeUXtNcUHM3uypwNinhjNJlz2CnETtkRov8k6VvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	=?UTF-8?q?Dani=C3=ABl=20Trujillo?= <datrujillo@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 160/265] ipv4: fib_trie: prevent speculative out-of-bounds child access
Date: Thu, 26 Nov 2026 15:38:10 +0100
Message-ID: <20261126143616.325875451@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniël Trujillo <datrujillo@nvidia.com>

commit fd3d73286662950656f54616d0b3fea29e2dc99a upstream.

fib_table_lookup() checks the child index against the bounds before
passing it to get_child_rcu().

The index is derived from the lookup key, which in turn is derived from
flp->daddr. A userspace process can therefore influence the index by
triggering lookups for chosen destination IPv4 addresses.

If this bounds check is mispredicted as in-bounds, an out-of-bounds index
can be transiently passed to get_child_rcu(). The value loaded beyond the
child array is then treated as a node pointer. A later transient
dereference of that pointer can cause a data-dependent cache footprint.

This was found during Spectre-v1 research. Leakage was demonstrated with
instrumentation that delays branch resolution with a CLFLUSH before the
mispredicted branch and makes the leaked location deterministic for
reproducible measurement. In that setup, a userspace-controlled IPv4
lookup key was able to trigger a transient out-of-bounds child access.
The transient use of the loaded value as a pointer caused a
data-dependent cache footprint that was recoverable from userspace using
Prime+Probe. A real-world attacker would likely need to delay branch
resolution, which was not demonstrated end-to-end without the added
CLFLUSH.

Sanitize the index with array_index_nospec() before accessing the child
array. This removed the observed leakage in the described setup.

Apply the hardening before setting cindex in fib_table_lookup(), because
cindex can later be used by the backtrace path to load another child
pointer. fib_find_node() has the same pattern, with the checked index
derived from a user-provided key in fib_table_insert() and
fib_table_delete(). leaf_walk_rcu() has a similar checked cindex before
get_child_rcu(), and the traversed state can be influenced by userspace
actions. fib_find_node() runs under RTNL and leaf_walk_rcu() is not on
the packet lookup hot path, so harden those analogous accesses in the
same way. Also harden fib_trie_get_next(), where a mispredicted loop
condition could transiently read one child past the array.

I see a slowdown of roughly 10% in a microbenchmark where we call
fib_table_lookup() with 64 routes directly from inside the kernel. I
observed no slowdown in a loopback UDP sendto() microbenchmark.

Fixes: 9f9e636d4f89 ("fib_trie: Optimize fib_table_lookup to avoid wasting time on loops/variables")
Cc: stable@vger.kernel.org
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Signed-off-by: Daniël Trujillo <datrujillo@nvidia.com>
Link: https://patch.msgid.link/20261106-fib-trie-nospec-v3-1-53da6550dcf8@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_trie.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -60,6 +60,7 @@
 #include <linux/export.h>
 #include <linux/vmalloc.h>
 #include <linux/notifier.h>
+#include <linux/nospec.h>
 #include <net/net_namespace.h>
 #include <net/ip.h>
 #include <net/protocol.h>
@@ -965,6 +966,8 @@ static struct key_vector *fib_find_node(
 			break;
 		}
 
+		index = array_index_nospec(index, 1ul << n->bits);
+
 		/* keep searching until we find a perfect match leaf or NULL */
 	} while (IS_TNODE(n));
 
@@ -1423,6 +1426,8 @@ int fib_table_lookup(struct fib_table *t
 		if (IS_LEAF(n))
 			goto found;
 
+		index = array_index_nospec(index, 1ul << n->bits);
+
 		/* only record pn and cindex if we are going to be chopping
 		 * bits later.  Otherwise we are just wasting cycles.
 		 */
@@ -1720,6 +1725,8 @@ static struct key_vector *leaf_walk_rcu(
 		if (cindex >> pn->bits)
 			break;
 
+		cindex = array_index_nospec(cindex, 1ul << pn->bits);
+
 		/* descend into the next child */
 		n = get_child_rcu(pn, cindex++);
 		if (!n)
@@ -1741,6 +1748,8 @@ static struct key_vector *leaf_walk_rcu(
 			continue;
 		}
 
+		cindex = array_index_nospec(cindex, 1ul << pn->bits);
+
 		/* grab the next available node */
 		n = get_child_rcu(pn, cindex++);
 		if (!n)
@@ -2396,7 +2405,10 @@ static struct key_vector *fib_trie_get_n
 
 	while (!IS_TRIE(pn)) {
 		while (cindex < child_length(pn)) {
-			struct key_vector *n = get_child_rcu(pn, cindex++);
+			struct key_vector *n;
+
+			cindex = array_index_nospec(cindex, child_length(pn));
+			n = get_child_rcu(pn, cindex++);
 
 			if (!n)
 				continue;


