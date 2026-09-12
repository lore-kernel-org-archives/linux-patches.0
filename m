Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153374746C4;
	Sat, 12 Sep 2026 11:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211683; cv=none; b=WK/rzu448vC+tZgb1MYg/RhGvPyz+Ghb9wYLCidPATNoHMxgbVvxbDkFq19Yyb7F1VTrAnhO+/66W4RZzBzI8t7tqUByf7c6g0H6CrSaT1XSD8zp9+gXiOPTNYyTd1RlMYtRtFXNsgNGHL3pi9eOZ7h26gdrR1mX6Wye5MupyXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211683; c=relaxed/simple;
	bh=oo3npqyyQvqY3PSqVIzba/GQ8Q7wiWLPJKOyi/ccIYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lveVjtdp+KJWgZAfhLg6yiwoCIhKONClKJrsXFbviZeehvMj8HGtbVMak6E8omO7y5Try4PSeHQ3A9aYHBItHx23KLwZb/AkmBzI5xq1oM0eK80dJrkFzo+ci4IoPQZZNkHXUXoVAIX2ToJlo81bcwOsH3ZDP26juprrCzexgIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DmOtNUae; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DmOtNUae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0DBB1F000FF;
	Sat, 12 Sep 2026 11:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211681;
	bh=CVBxau7kDFwo7mFU8psfkVYLvsPKfxizuMLBu4kUCDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DmOtNUaeoa6ZcH7Ui+iwHn6FFRYjnL/H5j7SJV0E0WDrJH/TQxYkXNnVDh3qpSdtg
	 2lfW8gEBTtPmeU+nwsG36p8bOAgwjISi/5s/8qF68Jy+xmP+4TLjSWkY8TjuyZV5FJ
	 c8KrQLZfK6xg3+dvHvNnWYmkewaPwDxJICAYf03c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baul Lee <baul.lee@xbow.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1279/1518] vxlan: mdb: Fix use-after-free in vxlan_mdb_flush()
Date: Sat, 12 Sep 2026 08:57:28 +0200
Message-ID: <20260912065652.446541772@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Baul Lee <baul.lee@xbow.com>

[ Upstream commit bc2dc66a6693a78f8c1e6ca2dbebd50f16e2c366 ]

vxlan_mdb_flush() iterates over the MDB entries using
hlist_for_each_entry_safe(), which only tolerates the removal of the
current entry. Contrary to the comment above the loop, the removal of an
entry can trigger the removal of another entry.

Flushing the remotes of a (*, G) entry also removes the (S, G) entries
that were created for its source list, once they are left without
remotes:

vxlan_mdb_remotes_flush()
-> vxlan_mdb_remote_del()
   -> vxlan_mdb_remote_srcs_del()
      -> vxlan_mdb_remote_src_del()
         -> vxlan_mdb_remote_src_fwd_del()
            -> __vxlan_mdb_del()
               -> vxlan_mdb_entry_put()

Such an entry can be located after the (*, G) entry in the list, as
vxlan_mdb_entry_get() returns an existing entry without moving it to the
head of the list. This order is obtained by adding the (S, G) entry
before the (*, G) entry, the latter with NLM_F_REPLACE, as the addition
of the source otherwise fails with -EEXIST. The (S, G) entry is then the
entry saved by hlist_for_each_entry_safe() and it is freed while the
(*, G) entry is processed. The next iteration calls hlist_del() on it
again, writing LIST_POISON1 to LIST_POISON2 [1].

Besides device deletion, the flush is also reachable from RTM_DELMDB
with NLM_F_BULK.

Fix by re-reading the next entry after the remotes were flushed. The
current entry cannot be removed by this flush, as source lists can only
be configured on (*, G) entries and the removed entries are (S, G)
entries. It is therefore still linked and its next pointer reflects the
removals.

[1]
BUG: KASAN: wild-memory-access in vxlan_mdb_entry_put.part.0+0x328/0x588
Write of size 8 at addr dead000000000122 by task ip/327

CPU: 3 UID: 1000 PID: 327 Comm: ip Not tainted 7.2.0-rc7 #2 PREEMPT
Call trace:
 vxlan_mdb_entry_put.part.0+0x328/0x588
 vxlan_mdb_flush+0x1d8/0x25c
 vxlan_mdb_fini+0x8c/0x100
 vxlan_uninit+0x1c/0x7c
 unregister_netdevice_many_notify+0x954/0xd4c
 rtnl_dellink+0x210/0x530
 rtnetlink_rcv_msg+0x434/0x4d0
 netlink_rcv_skb+0xc4/0x204
 rtnetlink_rcv+0x18/0x24
 netlink_unicast+0x4b8/0x548
 netlink_sendmsg+0x29c/0x560
 ____sys_sendmsg+0x390/0x3ec
 ___sys_sendmsg+0x114/0x188
 __sys_sendmsg+0xf0/0x178
 __arm64_sys_sendmsg+0x48/0x60
 invoke_syscall.constprop.0+0x58/0x180
 el0_svc_common.constprop.0+0x74/0x140
 do_el0_svc+0x30/0x40
 el0_svc+0x38/0x98
 el0t_64_sync_handler+0xa0/0xe4
 el0t_64_sync+0x198/0x19c

Fixes: a3a48de5eade ("vxlan: mdb: Add MDB control path support")
Signed-off-by: Baul Lee <baul.lee@xbow.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260814153547.29567-1-baul.lee@xbow.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_mdb.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_mdb.c b/drivers/net/vxlan/vxlan_mdb.c
index 2ddcbf102b894..70d2d180f6d23 100644
--- a/drivers/net/vxlan/vxlan_mdb.c
+++ b/drivers/net/vxlan/vxlan_mdb.c
@@ -1428,14 +1428,17 @@ static void vxlan_mdb_flush(struct vxlan_dev *vxlan,
 	struct vxlan_mdb_entry *mdb_entry;
 	struct hlist_node *tmp;
 
-	/* The removal of an entry cannot trigger the removal of another entry
-	 * since entries are always added to the head of the list.
-	 */
 	hlist_for_each_entry_safe(mdb_entry, tmp, &vxlan->mdb_list, mdb_node) {
 		if (desc->src_vni && desc->src_vni != mdb_entry->key.vni)
 			continue;
 
 		vxlan_mdb_remotes_flush(vxlan, mdb_entry, desc);
+		/* The flush can remove the (S, G) entries created for the
+		 * source list of this entry, including the one saved by
+		 * hlist_for_each_entry_safe(), so re-read it while this entry
+		 * is still linked.
+		 */
+		tmp = mdb_entry->mdb_node.next;
 		/* Entry will only be removed if its remotes list is empty. */
 		vxlan_mdb_entry_put(vxlan, mdb_entry);
 	}
-- 
2.53.0



