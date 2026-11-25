Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625667;
	b=ayr51oxPHk+WALjY59Oy9MECMM64GjdWosSqPQyy1cge/x1A2438L7UMX+6F5JbLtkjV
	 Y0FJzApYmV0ephhSGJI7AWDa4cugF9Einb2ysvidX67x7M6ZJB4KhSq6asyzBc0y0jneR
	 GuQLlhTN3O80VdzjduWHoLigG84CZYzQveY4GjDfuwpkl0sV2vjnoBRCPMTA3T9ryYTlM
	 Vu1tbF+930hvb8mfT7//AvkSAS6bIofPbxPqKjlVSvU5ThfhDGrbK2b9++yDLnWhlUoj6
	 KvxrZ9KmXOss6LoQzH+sjNwru70DdlNZHRZBEtvLWbxXXShsYzsBLEZwdDajF6qXeYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625667;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=lfzpE4gg6KOEj9hvxe2gowuUXc+04BkiYeu+dm9klug=;
	b=J9tIcR+73rapPKM71AZJ6Nvlnk34HIVwkyjY/QFvqiwTpLCA42qCA6cUooR6uifEuulp
	 9tqjxzEmVJkv4p9tjCOXtl+73VwIJVwNGwPCMUraRXz5Lvh2SnhhHGwi0REFCs1TkXkgo
	 Vlz1Y3jLTgQlGeaesyS49eWENpx37q2mQLSe3Fy0fFGfS4a0LSFBR8pkN7qvPxrDZ/3DU
	 9oIlpWJReRqkT5N6goNcqJAuac2UKARiiviNlHIiogQBz+EOZwtYnsMKyRJYGudOjYJ6J
	 WsXNtMgGE6zwASi074ultJ17XMKSrvW4Rzil6wSka6qTxDTPLIiHmexpv4P/kvje+3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dk0XInwG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61909606A32A;
	Wed, 25 Nov 2026 16:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dk0XInwG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE171F000C0;
	Wed, 25 Nov 2026 16:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625667;
	bh=lfzpE4gg6KOEj9hvxe2gowuUXc+04BkiYeu+dm9klug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dk0XInwGpvYe8VoFcO6J4YvPi3iIUonShwuJ0WaRm9/6tI1cy4Eyr2matcTDrqtoz
	 3lGP6TJcu3AYC7mVw4LwJjO7U4tRNxGBIj/X+MSGcf+dEoP9He8Cg8Wbfl3/1PVXuQ
	 TFZHeOlShe2T+DO5Ysj+l+XT11z5qprEMdl63RuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	=?UTF-8?q?Dani=C3=ABl=20Trujillo?= <datrujillo@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 591/816] ipv4: fib_trie: prevent speculative out-of-bounds child access
Date: Wed, 25 Nov 2026 15:35:39 +0100
Message-ID: <20261125143902.857697664@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -61,6 +61,7 @@
 #include <linux/export.h>
 #include <linux/vmalloc.h>
 #include <linux/notifier.h>
+#include <linux/nospec.h>
 #include <net/net_namespace.h>
 #include <net/inet_dscp.h>
 #include <net/ip.h>
@@ -967,6 +968,8 @@ static struct key_vector *fib_find_node(
 			break;
 		}
 
+		index = array_index_nospec(index, 1ul << n->bits);
+
 		/* keep searching until we find a perfect match leaf or NULL */
 	} while (IS_TNODE(n));
 
@@ -1472,6 +1475,8 @@ int fib_table_lookup(struct fib_table *t
 		if (IS_LEAF(n))
 			goto found;
 
+		index = array_index_nospec(index, 1ul << n->bits);
+
 		/* only record pn and cindex if we are going to be chopping
 		 * bits later.  Otherwise we are just wasting cycles.
 		 */
@@ -1772,6 +1777,8 @@ static struct key_vector *leaf_walk_rcu(
 		if (cindex >> pn->bits)
 			break;
 
+		cindex = array_index_nospec(cindex, 1ul << pn->bits);
+
 		/* descend into the next child */
 		n = get_child_rcu(pn, cindex++);
 		if (!n)
@@ -1793,6 +1800,8 @@ static struct key_vector *leaf_walk_rcu(
 			continue;
 		}
 
+		cindex = array_index_nospec(cindex, 1ul << pn->bits);
+
 		/* grab the next available node */
 		n = get_child_rcu(pn, cindex++);
 		if (!n)
@@ -2444,7 +2453,10 @@ static struct key_vector *fib_trie_get_n
 
 	while (!IS_TRIE(pn)) {
 		while (cindex < child_length(pn)) {
-			struct key_vector *n = get_child_rcu(pn, cindex++);
+			struct key_vector *n;
+
+			cindex = array_index_nospec(cindex, child_length(pn));
+			n = get_child_rcu(pn, cindex++);
 
 			if (!n)
 				continue;


