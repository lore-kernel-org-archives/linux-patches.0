Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B712171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:41:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D001BC433EF;
	Mon, 22 May 2023 19:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784463;
	bh=aO9wLY9VkyrPWwoLZCy0KVRPNB4O8b8O/bzkxxfOAvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0fBl3ekkx1A98X7SecNxDEFgIlv88SbsB37Cm8wow5BiJ8ZojeRBW6qMtkfVm4EE8
	 HLRSqT93z6I3gxPNVjJ8X2Ok2NTQ2HRUo+3M4eDnPhWwzwiCqsAc3Avz625ijk/n8A
	 HlqEllNtjsC39jMGfG7iMhkRj4P5aTBAZWYldDUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin KaFai Lau <martin.lau@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 091/364] bpf: Annotate data races in bpf_local_storage
Date: Mon, 22 May 2023 20:06:36 +0100
Message-Id: <20230522190415.026980734@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 0a09a2f933c73dc76ab0b72da6855f44342a8903 ]

There are a few cases where hlist_node is checked to be unhashed without
holding the lock protecting its modification. In this case, one must use
hlist_unhashed_lockless to avoid load tearing and KCSAN reports. Fix
this by using lockless variant in places not protected by the lock.

Since this is not prompted by any actual KCSAN reports but only from
code review, I have not included a fixes tag.

Cc: Martin KaFai Lau <martin.lau@kernel.org>
Cc: KP Singh <kpsingh@kernel.org>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20230221200646.2500777-4-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_local_storage.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
index 35f4138a54dc1..58da17ae51241 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -51,11 +51,21 @@ owner_storage(struct bpf_local_storage_map *smap, void *owner)
 	return map->ops->map_owner_storage_ptr(owner);
 }
 
+static bool selem_linked_to_storage_lockless(const struct bpf_local_storage_elem *selem)
+{
+	return !hlist_unhashed_lockless(&selem->snode);
+}
+
 static bool selem_linked_to_storage(const struct bpf_local_storage_elem *selem)
 {
 	return !hlist_unhashed(&selem->snode);
 }
 
+static bool selem_linked_to_map_lockless(const struct bpf_local_storage_elem *selem)
+{
+	return !hlist_unhashed_lockless(&selem->map_node);
+}
+
 static bool selem_linked_to_map(const struct bpf_local_storage_elem *selem)
 {
 	return !hlist_unhashed(&selem->map_node);
@@ -174,7 +184,7 @@ static void __bpf_selem_unlink_storage(struct bpf_local_storage_elem *selem,
 	bool free_local_storage = false;
 	unsigned long flags;
 
-	if (unlikely(!selem_linked_to_storage(selem)))
+	if (unlikely(!selem_linked_to_storage_lockless(selem)))
 		/* selem has already been unlinked from sk */
 		return;
 
@@ -208,7 +218,7 @@ void bpf_selem_unlink_map(struct bpf_local_storage_elem *selem)
 	struct bpf_local_storage_map_bucket *b;
 	unsigned long flags;
 
-	if (unlikely(!selem_linked_to_map(selem)))
+	if (unlikely(!selem_linked_to_map_lockless(selem)))
 		/* selem has already be unlinked from smap */
 		return;
 
@@ -420,7 +430,7 @@ bpf_local_storage_update(void *owner, struct bpf_local_storage_map *smap,
 		err = check_flags(old_sdata, map_flags);
 		if (err)
 			return ERR_PTR(err);
-		if (old_sdata && selem_linked_to_storage(SELEM(old_sdata))) {
+		if (old_sdata && selem_linked_to_storage_lockless(SELEM(old_sdata))) {
 			copy_map_value_locked(&smap->map, old_sdata->data,
 					      value, false);
 			return old_sdata;
-- 
2.39.2



