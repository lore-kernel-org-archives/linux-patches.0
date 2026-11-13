Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591063;
	b=IZVF5zafH8ewDZX7ZlFul0JCKZxVz44Z0R1V9rc/s66MJys9Gsk/NDZJ+B5UiqCkl5r+
	 aq7TvurPlUmXXaYnl5o9zLRIkjdciRSYnTcYeAKOVkPwAY/bHSvsdHmhAHaW0KC8c4+I4
	 jiJzW5bvqBHqck/wi72htTEUnuLfPrKg5OIScNdUIoGn26+DuurBxOl0VTuCtrwb97ZkZ
	 syyN3SFBAMCtqAJqR7URGI/Cfqxo+zzjfTCQI2Yc3YTco6U/wNuqBKB9ncC6rlODj+6J6
	 4vj3WplYy4XVu/C3iICyLZydmGEAwmhFkDuGcJ0ORKwLnr5a3+hYZN7ef9mYuoW4JjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591063;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k5AdnoBmclxbO2E/UjwjruXEgcu+6fsEWT+x4Cb2pRk=;
	b=JejUZJBgQjNqi5A4+6kcGgrpnmQUU2hr38Rqx7y9yi7LAdZlswl90hiFg3iqHiTru3Zl
	 Vu/VZVTQsZ4U/bbUnvFVVZZFqs0i3P0ud1Wz9kQhn+QuPRlvb+IzzOGL2trm6TaZexD63
	 WINNOyHvsV7vzHYx/kobAV1Is8kd+fCKo7koox2zZUwVB8AsQLRsWJjEVBKzWpQ2bqCId
	 a/m1DW8wT9d7DDh5kENh2qYk5bz11o8GaRvjJ1VlMzY77oO4YmqiDUQe4KsNlytjwiL2L
	 i9iXX1G2nlPK3XS91OB/Xm0gl2Qsjjk3FoZcwrxgJYKm2KueiZ2qDmZkQfCl+EMg7cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="q7RR/adr";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DBF606B354;
	Fri, 13 Nov 2026 17:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q7RR/adr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89251F000C4;
	Fri, 13 Nov 2026 17:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591062;
	bh=k5AdnoBmclxbO2E/UjwjruXEgcu+6fsEWT+x4Cb2pRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q7RR/adrqHiVWR6Uq4z49kElpgBKMgvTv1+SL99NbWKs9+gatfL449ugc+T8SB2wj
	 dUM1q8KY4XpflFgYQ7Ve+egxKR8K3eIFS10A7YyExunORo+PTlXdXVYXy2Yb4BugXQ
	 gdbJtTyI/meeb6YJG3Uy6/DZGJtEvnf862d72NZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Balbir Singh <balbirs@nvidia.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 222/670] mm/mempolicy: charge shared policy nodes
Date: Fri, 13 Nov 2026 10:46:26 -0500
Message-ID: <20261113153819.408889106@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

[ Upstream commit 68b2aa37afa390f08de13bc0bac61a9ded3318bc ]

Any local user can bypass memory.max with mbind() on a tmpfs file, and
allocate unbounded kernel memory.

mbind() sets a NUMA memory policy for a range of a mapping. If the
mapping is of a shmem and friends, the kernel also stores the policy on
the inode, in a tree with one entry per range of the file.

Each mbind() on a single page of a mapping can add one shared policy node
(struct sp_node) and one struct mempolicy to that tree. They outlive the
mapping and stay around until the inode is destroyed. The tree is not
bounded by the file size, so the file can be empty.

Memory that user space can allocate must be charged to a memory cgroup. A
slab cache does that for all of its objects if it is created with
SLAB_ACCOUNT. numa_policy_init() creates the slab caches for both
structs without SLAB_ACCOUNT, so they are not charged to any cgroup.

Reproduced with mbind() on single pages of an empty tmpfs file, from a
cgroup with memory.max=8M: the global OOM killer killed tasks owned by
root, and the machine panicked.

Fix this by creating both caches with SLAB_ACCOUNT. This change implies
that mbind() can now fail when running into memcg limits. Further,
the policy_cache also serves task and VMA policies, so they are
similarly accounted now.

Note that per-file limits are not really helpful, as the user could
simply use many files; having limits per user is tricky as well.

Fix generated by an LLM and submitted by Chris Mason in private.

Fixes: 5d097056c9a0 ("kmemcg: account certain kmem allocations to memcg")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
[ david: smaller description tweaks ]
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Link: https://patch.msgid.link/20261029-fixes_shmem-v4-1-392fc715d8f6@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mempolicy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 3853b6ff71177..6f29f764762b2 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -3099,11 +3099,11 @@ void __init numa_policy_init(void)
 
 	policy_cache = kmem_cache_create("numa_policy",
 					 sizeof(struct mempolicy),
-					 0, SLAB_PANIC, NULL);
+					 0, SLAB_PANIC | SLAB_ACCOUNT, NULL);
 
 	sn_cache = kmem_cache_create("shared_policy_node",
 				     sizeof(struct sp_node),
-				     0, SLAB_PANIC, NULL);
+				     0, SLAB_PANIC | SLAB_ACCOUNT, NULL);
 
 	for_each_node(nid) {
 		preferred_node_policy[nid] = (struct mempolicy) {
-- 
2.53.0



