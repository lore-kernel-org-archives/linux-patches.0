Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065572;
	b=Ikyfux7WRI8Q3y+BTh7J7SaDhQiMSHvH7bIb57xW+nQMGr1ExKW89tYsby86ELIxE22/
	 uOfoaEt0xRxcOl4gKqlxR5PqYOwla781UNva5Y+7zOgLl1NsDnluI2aDir87HwfW1u7cK
	 5tWNdN2tVO0eyRXrFOKLtn5sg2pVyjAdEgrDM1pH/UH4t2CninGXIsmH9fbc/wi6lTiTJ
	 Yk9f8K5s6xFhMsZalV/azuwcBHjOg33HPVYZCSAz7zQ1OP+5698YZz4SP/5iFnksoMGUL
	 mUcDU4lJwfOeC6mhdoPJt34DuY9/VEt/3t583oI8R40N0hl8/E4ICjQQckGgTlEcQyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065572;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8Z4//GOV0IElKG9A5Dz2HNi7wRw2hpfmNID2E0AwiRw=;
	b=HmruMct6YGy7ZqEqwJvJoMw2TsQ5yqFOS+fn17So6GpPWCIXy/lYNS58H7MdZeW0Iep6
	 8FZ2aBudgo7se4v49CUniKiiwd08MXow5qUaMZir15DP8DjsN/VXXiqA/NYNCweHPWWur
	 9uhiCL5dQGPjVS4C0Yhx37JjMLieRkYgg67bGu9d+5D3nafboxrlV7JsJs+C4nMenhYyi
	 Ug3HGyuQ4OLdG0L6enZcQkWVOAXJ89T+FXoF18/t1GuHxli5HDNzlrR0GnlC6n9O2j/xT
	 h5ZeGtGR/46Ov2d1biIqEQVBoMszWrtqVBaeMQ3HOwunWn0MKfnU5Kr9vKDpjti1x0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VLNg0Gz1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D2B606A335;
	Sat,  7 Nov 2026 15:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VLNg0Gz1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E3C1F0089F;
	Sat,  7 Nov 2026 15:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065572;
	bh=8Z4//GOV0IElKG9A5Dz2HNi7wRw2hpfmNID2E0AwiRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VLNg0Gz10XH/tN4tCCrZrSCPWD65+ymiqogKo0EDVLufos7RtIzGAHI4AGYc4NAbJ
	 6XwByf3KFpg1PSPC62TnHyGxrqfQuCcmdY7c7GH0R9YexSwlTcT5h35hfRWfXpRPlu
	 2Vh1Nz+aropo6fY0OdwMj1duEGjXNaUd9zn6KTUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	shaos <shawnq1@163.com>,
	Josef Bacik <josef@toxicpanda.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1234/1257] nstree: dont end listns() at an inactive namespace
Date: Sat,  7 Nov 2026 08:58:50 -0500
Message-ID: <20261107135013.423148810@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit da29ac46d34a19e8cc328ad17cb88713fd4563fa ]

listns() resumes after the last returned id by looking up the first
namespace with a larger id with lookup_ns_id_after(), or with
lookup_ns_owner_after() when filtering by owner. Both also take a
reference with ns_get_unless_inactive(). If that namespace is inactive,
e.g. a network namespace that is only pinned by a socket or a user
namespace that is only pinned by a file's credentials, or if it is being
torn down, the lookup returns NULL and listns() fails with -ENOENT.
Userspace takes that as the end of the list, so every namespace after
it is silently missed:

  ids 10 (active), 11 (inactive), 12 (active)
  listns(ns_id = 0,  nr = 1)  -> 10
  listns(ns_id = 10, nr = 1)  -> lookup_ns_id_after(10) -> NULL, -ENOENT
  12 is never listed

A call without a cursor doesn't have this problem because the loop just
skips the namespaces that legitimize_ns() rejects.

The reference only kept the starting point valid until the RCU walk
began. Look it up under rcu_read_lock() instead, without taking a
reference. The namespace can't be freed before the RCU read-side section
ends, and if it is unlinked in the meantime its ->next still leads back
into the list, which the walk already relies on for every other entry.
The starting namespace then goes through legitimize_ns() like every
other one, and kls->first_ns isn't needed anymore.

Reported-by: shaos <shawnq1@163.com>
Link: https://lore.kernel.org/r/20261020110746.959806-1-shawnq1@163.com
Fixes: 76b6f5dfb3fd ("nstree: add listns()")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/nstree.c | 55 +++++++++++++++++++++++++------------------------
 1 file changed, 28 insertions(+), 27 deletions(-)

diff --git a/kernel/nstree.c b/kernel/nstree.c
index 58b2b55fa8d26..a756ae2e7881a 100644
--- a/kernel/nstree.c
+++ b/kernel/nstree.c
@@ -408,15 +408,12 @@ struct klistns {
 	u32 ns_type;
 	struct user_namespace *user_ns;
 	bool userns_capable;
-	struct ns_common *first_ns;
 };
 
 static void __free_klistns_free(const struct klistns *kls)
 {
 	if (kls->user_ns_id != LISTNS_CURRENT_USER)
 		put_user_ns(kls->user_ns);
-	if (kls->first_ns && kls->first_ns->ops)
-		kls->first_ns->ops->put(kls->first_ns);
 }
 
 #define NS_ALL (PID_NS | USER_NS | MNT_NS | UTS_NS | IPC_NS | NET_NS | CGROUP_NS | TIME_NS)
@@ -461,6 +458,9 @@ static inline int prepare_klistns(struct klistns *kls, struct ns_id_req *kreq,
 /*
  * Lookup a namespace owned by owner with id > ns_id.
  * Returns the namespace with the smallest id that is > ns_id.
+ *
+ * No reference is taken. The caller must hold rcu_read_lock() and may only
+ * use the result as the starting point of an RCU list walk.
  */
 static struct ns_common *lookup_ns_owner_after(u64 ns_id, struct ns_common *owner)
 {
@@ -484,8 +484,6 @@ static struct ns_common *lookup_ns_owner_after(u64 ns_id, struct ns_common *owne
 		}
 	}
 
-	if (ret)
-		ret = ns_get_unless_inactive(ret);
 	return ret;
 }
 
@@ -558,25 +556,27 @@ static ssize_t do_listns_userns(struct klistns *kls)
 		return -EINVAL;
 	kls->user_ns = to_user_ns(ns);
 
-	/*
-	 * Use the rbtree to find the first namespace we care about and
-	 * then use it's list entry to iterate from there.
-	 */
-	if (kls->last_ns_id) {
-		kls->first_ns = lookup_ns_owner_after(kls->last_ns_id, ns);
-		if (!kls->first_ns)
-			return -ENOENT;
-		first_ns = kls->first_ns;
-	}
-
 	ret = 0;
 	head = &to_ns_common(kls->user_ns)->ns_owner_root.ns_list_head;
 	kls->userns_capable = may_see_all_namespaces();
 
 	rcu_read_lock();
 
-	if (!first_ns)
+	/*
+	 * Use the rbtree to find the first namespace we care about and
+	 * then use it's list entry to iterate from there. That namespace
+	 * is filtered like any other, so the walk doesn't end early just
+	 * because it is inactive or already dying.
+	 */
+	if (kls->last_ns_id) {
+		first_ns = lookup_ns_owner_after(kls->last_ns_id, ns);
+		if (!first_ns) {
+			rcu_read_unlock();
+			return -ENOENT;
+		}
+	} else {
 		first_ns = list_entry_rcu(head->next, typeof(*first_ns), ns_owner_node.ns_list_entry);
+	}
 
 	ns = first_ns;
 	list_for_each_entry_from_rcu(ns, head, ns_owner_node.ns_list_entry) {
@@ -613,6 +613,9 @@ static ssize_t do_listns_userns(struct klistns *kls)
 /*
  * Lookup a namespace with id > ns_id in either the unified tree or a type-specific tree.
  * Returns the namespace with the smallest id that is > ns_id.
+ *
+ * No reference is taken. The caller must hold rcu_read_lock() and may only
+ * use the result as the starting point of an RCU list walk.
  */
 static struct ns_common *lookup_ns_id_after(u64 ns_id, int ns_type)
 {
@@ -649,8 +652,6 @@ static struct ns_common *lookup_ns_id_after(u64 ns_id, int ns_type)
 		}
 	}
 
-	if (ret)
-		ret = ns_get_unless_inactive(ret);
 	return ret;
 }
 
@@ -700,13 +701,6 @@ static ssize_t do_listns(struct klistns *kls)
 			return -EINVAL;
 	}
 
-	if (kls->last_ns_id) {
-		kls->first_ns = lookup_ns_id_after(kls->last_ns_id, ns_type);
-		if (!kls->first_ns)
-			return -ENOENT;
-		first_ns = kls->first_ns;
-	}
-
 	ret = 0;
 	if (ns_tree)
 		head = &ns_tree->ns_list_head;
@@ -715,8 +709,15 @@ static ssize_t do_listns(struct klistns *kls)
 
 	rcu_read_lock();
 
-	if (!first_ns)
+	if (kls->last_ns_id) {
+		first_ns = lookup_ns_id_after(kls->last_ns_id, ns_type);
+		if (!first_ns) {
+			rcu_read_unlock();
+			return -ENOENT;
+		}
+	} else {
 		first_ns = first_ns_common(head, ns_tree);
+	}
 
 	for (ns = first_ns; !ns_common_is_head(ns, head, ns_tree) && nr_ns_ids;
 	     ns = next_ns_common(ns, ns_tree)) {
-- 
2.53.0



