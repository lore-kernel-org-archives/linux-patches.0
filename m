Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217051;
	b=xHN8NXHSgFvE86/Jb0TJngSwUzLBBZQ3v+/lA4QSaZXBgwj3TOf0Fx47f3ngZEZOH0ef
	 Gna/i7hz+GaNQZ0tVRIb/tJlUEc9vCDOprBBySRoByDighmqA5pwAKBTR1wgJtlh7DxVc
	 mijrx3cT5LDT/vSWYYh3WekbZsjtY4jYq6/CSxGeheYcYpcaH0haZGlV9CGhE1SucWvIJ
	 NAKK6LFsrUHTbH85fjt97SlHFS2gDc9i0cQ7WDT31qN7pYbVeGUr/L36aE+pZoq/qWM/M
	 kyxvr++KerjNAM0CSsdxw6TRVjhYlHd4UOk8p/RQcvmtrsrMYIiHiIagvmIr+7/XZfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217051;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7A/jHczpgxifNgk7op33HtMhelo4HHFrgmhQ69b0wcU=;
	b=dYs25j437Yfa5k+Koxd13CRM7Z4m06THZRsH7h49lBlDyo8+3UiWjQdZoDO0bNdncPhE
	 mqBG7+HLQ2ph6ACPmnShK6V8+ME5ZfXV68Zu2YRopEVArofpQmcDqZhMBzmG0AqTjb8UL
	 hKdxRSGToe9g6tNM3eGz5EZiCLKWEv3TcJNoIz46fgjuaYQBbKErZGDDxOQhC3X7OwFf6
	 LC/jJZ5AgNs9QYJuAi+uqN8/MpuDAl5O8kxYbSEExFQttV8WIghQ5qcwYjnDSdmx7VqdI
	 v7ERwMv8M5ThYAis5OQCHzEM6Ub5JT6rfBEFA3IBxfibtOhsBkg7vlRrNzye3l61UYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="N/3FPyYh";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5389A606A320;
	Wed, 28 Oct 2026 19:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N/3FPyYh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE8461F01825;
	Wed, 28 Oct 2026 19:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217051;
	bh=7A/jHczpgxifNgk7op33HtMhelo4HHFrgmhQ69b0wcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N/3FPyYhoN2UayuAbJzKdVLTLogFXeZbh4hvfOX7eexp8908GL9WtmecO8nOX8jjW
	 wcknrgDdCukEGrWQsGSeb60lIwWO4LgpfTzidMkL18L6mHIvOGf5w0j2P/wPn2e9m7
	 fu9trBLKdbe118cs2E02bUHAPcC53sB3sLyivzbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	TencentOS Corvus AI <corvus@tencent.com>,
	Jun Yang <junvyyang@tencent.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 1770/1887] net: bridge: mcast: dont truncate the port group walk on teardown
Date: Wed, 28 Oct 2026 18:04:26 +0100
Message-ID: <20261028170539.732590514@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jun Yang <littleddfu@gmail.com>

commit 5a3f7a683aee56e1f15c9d53041f3236767eaae7 upstream.

__br_multicast_disable_port_ctx() and br_multicast_del_port() walk
port->mglist with hlist_for_each_entry_safe(). However,
br_multicast_find_del_pg() can also delete other entries from the same
list through br_multicast_fwd_src_remove() or __fwd_del_star_excl().

If such an entry is the iterator's saved next node, hlist_del_init()
clears its ->next and terminates the walk early. The reproducer triggers
this in both teardown walks, leaving port groups in the bridge mdb with
a dangling ->key.port after del_nbp() frees the port:

  BUG: KASAN: slab-use-after-free in __mdb_fill_info+0x1191/0x1320
   __mdb_fill_info+0x1191/0x1320
   br_mdb_dump+0x594/0xe40
   rtnl_mdb_dump+0x1cf/0x5d0

Use hlist_del_init_rcu() to unlink the group while preserving ->next.
br_multicast_del_pg() and the teardown walks run under
br->multicast_lock. The GC worker must acquire the same lock before
detaching the group for destruction, so the node remains alive while
the walk uses the preserved pointer.

Preserving ->next means a walk can now reach a group that an earlier
iteration already deleted as a side effect. That group is off mp->ports,
so br_multicast_find_del_pg() would fall through its port scan and hit
the trailing WARN_ON(1). Skip such groups at the top of that helper: a
port group is put on port->mglist when it is created and only unlinked
when it is deleted, so hlist_unhashed() identifies exactly this case.

Fixes: b08123684bd5 ("net: bridge: mcast: install S,G entries automatically based on reports")
Cc: stable@vger.kernel.org
Suggested-by: Nikolay Aleksandrov <razor@blackwall.org>
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Signed-off-by: Jun Yang <junvyyang@tencent.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20260831111330.199543-1-junvyyang@tencent.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_multicast.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -689,7 +689,11 @@ static void __br_multicast_del_pg(struct
 	struct hlist_node *tmp;
 
 	rcu_assign_pointer(*pp, pg->next);
-	hlist_del_init(&pg->mglist);
+	/* Keep ->next (held under multicast_lock, freed later by the GC work):
+	 * a port->mglist teardown walk may have latched this node as its next,
+	 * and deleting other groups of the same port must not truncate it.
+	 */
+	hlist_del_init_rcu(&pg->mglist);
 	br_multicast_eht_clean_sets(pg);
 	hlist_for_each_entry_safe(ent, tmp, &pg->src_list, node)
 		br_multicast_del_group_src(ent, false);
@@ -723,6 +727,13 @@ static void br_multicast_find_del_pg(str
 	struct net_bridge_mdb_entry *mp;
 	struct net_bridge_port_group *p;
 
+	/* A teardown walk over port->mglist can reach a group that an earlier
+	 * iteration already deleted as a side effect. It is off mp->ports by
+	 * now, so skip it instead of falling through to the WARN_ON() below.
+	 */
+	if (hlist_unhashed(&pg->mglist))
+		return;
+
 	mp = br_mdb_ip_get(br, &pg->key.addr);
 	if (WARN_ON(!mp))
 		return;


