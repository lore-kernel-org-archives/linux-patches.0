Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065249;
	b=vlG3ed+sGFbjqMrYVQrh0RcqB9O2M6DrXS+7pECew++UgR/QtjOCUo2ENkznxd5fhuUf
	 Ih+8e+b9Xvw2CU+oKcQhE6/agIaj0mB9RldqRIh3J+/Y/55fvM68OeT7ixMerkpCBkOAE
	 cjX5hRFpKU17gpLHkbVIswzr+YAoCzpbNTTyGZWc3fQzI7DopqqgQJW0I7F8PpIobFE5+
	 Wz60n5l3zsCPug/w479OdsUHsjINHM4JvMyhjtWo5/ViyuT2dnN+X864g5RgRilmcNaQt
	 DlSdjxm6l1Iu+Lc/zGNDz0K1YYfOKTZtexNuZxJl0YZQx8l4BzlqsM6NTSZxh2dFNAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065249;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UtehgBNqz5ydSc+Z9SLT/cME+GLJZiVdV7QT+F4MLDE=;
	b=WEzYTkmptROUylCaMB48QgCPetaBYnbhg+BfgfRB3Ai629sWS5nHrLq4gVyMcXLDiWLC
	 xZ5hdm6zY2CZwA5cZkin3yEMBdEmXQlnm8FGf6Y6zqEawZr3wlyQUqlkth2HgoCW9krW/
	 5PTkvj86SZDEw4z0xJlJ1rsOUk29VYMnBHNGKUru4d3vlv1z983AjAfM8uSMLk7dCWf5G
	 oC8vRjwxqFkDZokGpYv0U20V9+NntX/s9qhHXnM3NMoBwSGOsLb8mHGxkkAQwvGyUb7NY
	 0bn+1avhjs/xbwPY3Ts+wxVL6YUn6YMWtsOnMAJYbrpNyYf9AhUIcjgQRViEb8BjrsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ifY5d2iR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D329606A326;
	Sat,  7 Nov 2026 15:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ifY5d2iR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73711F0089F;
	Sat,  7 Nov 2026 15:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065249;
	bh=UtehgBNqz5ydSc+Z9SLT/cME+GLJZiVdV7QT+F4MLDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ifY5d2iRpmCRP62DUBUWIv5fIslyIa8OPJdfD1QY9xfETTF6wjmqtvVv/ccapub6C
	 9sv1NBXeMnN/VQqZUKgzuZo3EhxEPeEPN65vuXgqpKZr45ws87jdjHcLPY4JFlKHJi
	 n8vpY9dpPPHWHZ90AKfGDMOWaGWtAUrdCkc2swIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	shaos <shawnq1@163.com>,
	Jeff Layton <jlayton@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1023/1257] listns: dont wrap around with a U64_MAX cursor
Date: Sat,  7 Nov 2026 08:55:19 -0500
Message-ID: <20261107135007.581343913@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 2a1887000e2d4adc8cb3933b53431dea6d5e310b ]

do_listns() and do_listns_userns() take the last namespace id the caller
saw and look up the first namespace after it by searching the rbtree for
last_ns_id + 1. With U64_MAX that wraps around to zero and the search
returns the namespace with the smallest id. So a cursor at the largest
possible id restarts the listing from the beginning instead of failing
with ENOENT like a cursor of U64_MAX - 1 does. That's the case for the
unified tree, the type-specific trees and the owner tree alike.

No namespace will ever have that id. They come from a counter and a
caller that only feeds back ids it got from us can't hit this. It's
still wrong.

Instead of adding one to the cursor and searching for the smallest id
that's greater or equal make the lookup helpers search for the smallest
id that's strictly greater than the cursor. That's what both callers
want anyway and there's nothing left to overflow.

Reproducer, unprivileged:

    #define _GNU_SOURCE
    #include <errno.h>
    #include <stdint.h>
    #include <stdio.h>
    #include <sys/syscall.h>
    #include <unistd.h>
    #ifndef __NR_listns
    #define __NR_listns 470
    #endif
    #define CLONE_NEWUSER		0x10000000U
    #define LISTNS_CURRENT_USER	0xffffffffffffffffULL
    struct ns_id_req {
    	uint32_t size, spare;
    	uint64_t ns_id;
    	uint32_t ns_type, spare2;
    	uint64_t user_ns_id;
    };
    static void list(const char *tree, uint32_t type, uint64_t owner,
    		 uint64_t cursor)
    {
    	struct ns_id_req req = {
    		.size = sizeof(req), .ns_id = cursor, .ns_type = type,
    		.user_ns_id = owner,
    	};
    	uint64_t ids[8];
    	long ret;
    	errno = 0;
    	ret = syscall(__NR_listns, &req, ids, 8, 0);
    	printf("%s cursor %llu: ret %ld errno %d", tree,
    	       (unsigned long long)cursor, ret, errno);
    	for (long i = 0; i < ret && i < 3; i++)
    		printf("%s%llu", i ? "," : " ids ", (unsigned long long)ids[i]);
    	printf("%s\n", ret > 3 ? ",..." : "");
    }
    int main(void)
    {
    	static const uint64_t cursors[] = { 0, UINT64_MAX - 1, UINT64_MAX };
    	for (int i = 0; i < 3; i++)
    		list("unified", 0, 0, cursors[i]);
    	for (int i = 0; i < 3; i++)
    		list("userns", CLONE_NEWUSER, 0, cursors[i]);
    	for (int i = 0; i < 3; i++)
    		list("owner", 0, LISTNS_CURRENT_USER, cursors[i]);
    	return 0;
    }

Before, on 7.3.0-rc7-00252-g4e3259b08c54 (vfs.fixes) in a VM:

    unified cursor 0: ret 8 errno 0 ids 1,2,3,...
    unified cursor 18446744073709551614: ret -1 errno 2
    unified cursor 18446744073709551615: ret 8 errno 0 ids 1,2,3,...
    userns cursor 0: ret 1 errno 0 ids 3
    userns cursor 18446744073709551614: ret -1 errno 2
    userns cursor 18446744073709551615: ret 1 errno 0 ids 3
    owner cursor 0: ret 8 errno 0 ids 1,2,4,...
    owner cursor 18446744073709551614: ret -1 errno 2
    owner cursor 18446744073709551615: ret 8 errno 0 ids 1,2,4,...

After:

    unified cursor 0: ret 8 errno 0 ids 1,2,3,...
    unified cursor 18446744073709551614: ret -1 errno 2
    unified cursor 18446744073709551615: ret -1 errno 2
    userns cursor 0: ret 1 errno 0 ids 3
    userns cursor 18446744073709551614: ret -1 errno 2
    userns cursor 18446744073709551615: ret -1 errno 2
    owner cursor 0: ret 8 errno 0 ids 1,2,4,...
    owner cursor 18446744073709551614: ret -1 errno 2
    owner cursor 18446744073709551615: ret -1 errno 2

Reported-by: shaos <shawnq1@163.com>
Link: https://lore.kernel.org/r/20261020110732.959552-1-shawnq1@163.com
Fixes: 76b6f5dfb3fd ("nstree: add listns()")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261021-work-mount-statmount_listns_fixes-v1-5-8917a4c1bd14@kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/nstree.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/kernel/nstree.c b/kernel/nstree.c
index 831f279d174a3..58b2b55fa8d26 100644
--- a/kernel/nstree.c
+++ b/kernel/nstree.c
@@ -459,10 +459,10 @@ static inline int prepare_klistns(struct klistns *kls, struct ns_id_req *kreq,
 }
 
 /*
- * Lookup a namespace owned by owner with id >= ns_id.
- * Returns the namespace with the smallest id that is >= ns_id.
+ * Lookup a namespace owned by owner with id > ns_id.
+ * Returns the namespace with the smallest id that is > ns_id.
  */
-static struct ns_common *lookup_ns_owner_at(u64 ns_id, struct ns_common *owner)
+static struct ns_common *lookup_ns_owner_after(u64 ns_id, struct ns_common *owner)
 {
 	struct ns_common *ret = NULL;
 	struct rb_node *node;
@@ -476,10 +476,8 @@ static struct ns_common *lookup_ns_owner_at(u64 ns_id, struct ns_common *owner)
 		struct ns_common *ns;
 
 		ns = node_to_ns_owner(node);
-		if (ns_id <= ns->ns_id) {
+		if (ns_id < ns->ns_id) {
 			ret = ns;
-			if (ns_id == ns->ns_id)
-				break;
 			node = node->rb_left;
 		} else {
 			node = node->rb_right;
@@ -565,7 +563,7 @@ static ssize_t do_listns_userns(struct klistns *kls)
 	 * then use it's list entry to iterate from there.
 	 */
 	if (kls->last_ns_id) {
-		kls->first_ns = lookup_ns_owner_at(kls->last_ns_id + 1, ns);
+		kls->first_ns = lookup_ns_owner_after(kls->last_ns_id, ns);
 		if (!kls->first_ns)
 			return -ENOENT;
 		first_ns = kls->first_ns;
@@ -613,10 +611,10 @@ static ssize_t do_listns_userns(struct klistns *kls)
 }
 
 /*
- * Lookup a namespace with id >= ns_id in either the unified tree or a type-specific tree.
- * Returns the namespace with the smallest id that is >= ns_id.
+ * Lookup a namespace with id > ns_id in either the unified tree or a type-specific tree.
+ * Returns the namespace with the smallest id that is > ns_id.
  */
-static struct ns_common *lookup_ns_id_at(u64 ns_id, int ns_type)
+static struct ns_common *lookup_ns_id_after(u64 ns_id, int ns_type)
 {
 	struct ns_common *ret = NULL;
 	struct ns_tree_root *ns_tree = NULL;
@@ -643,13 +641,8 @@ static struct ns_common *lookup_ns_id_at(u64 ns_id, int ns_type)
 		else
 			ns = node_to_ns_unified(node);
 
-		if (ns_id <= ns->ns_id) {
-			if (ns_type)
-				ret = node_to_ns(node);
-			else
-				ret = node_to_ns_unified(node);
-			if (ns_id == ns->ns_id)
-				break;
+		if (ns_id < ns->ns_id) {
+			ret = ns;
 			node = node->rb_left;
 		} else {
 			node = node->rb_right;
@@ -708,7 +701,7 @@ static ssize_t do_listns(struct klistns *kls)
 	}
 
 	if (kls->last_ns_id) {
-		kls->first_ns = lookup_ns_id_at(kls->last_ns_id + 1, ns_type);
+		kls->first_ns = lookup_ns_id_after(kls->last_ns_id, ns_type);
 		if (!kls->first_ns)
 			return -ENOENT;
 		first_ns = kls->first_ns;
-- 
2.53.0



