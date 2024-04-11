Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6929E79FD;
	Thu, 11 Apr 2024 10:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831730; cv=none; b=Sidn0qSB1DmfMa5cn6w6/x5ORZUzAPWT36ivMUb9hx22A0Ze+tbjIdn0w5LZDYuO5bhdSqgkhhhZHErTvazpV8yP95VjlBSQUrHhZk528CAJAC+XhHF2kvy+YbWj0xWY1e1k4B4BCrxHQD0EyOheQ9uthF/dxkdwpU0LfzZ4e6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831730; c=relaxed/simple;
	bh=O0xZDDHidy2d8SaZa3NKFu0a6/cNwf/Y0EzkoIY3Gfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=imVZh0Yt0nSnI9c0g5ocSgGJar0Byy8oT6KPnFajws2S71FA0xiKnW5wOjO4zCrTVnAqx47unD0Y4vf4OEPnA0gd4O1zcxFxw6/CSCq/0DflWtJoR/krLFyAkicjt+NdqkKJTwHY2lmbnYeUK7qTfRTIX+oE6m1dwlAN5SuG18I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zGCrefe5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zGCrefe5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D7CC433C7;
	Thu, 11 Apr 2024 10:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831730;
	bh=O0xZDDHidy2d8SaZa3NKFu0a6/cNwf/Y0EzkoIY3Gfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zGCrefe5tOHLcuM9JXEDfgMXhI0BodE26iZB6ybzvz5DgvrXPL81JBpVhWzgDu7kQ
	 7joZv8ZCdY3wvpIGQlyUHzV+X1UaHq5tc8DK7NF99OjcXpL9Xh1ePQsxbRTFuP61oV
	 S6lEYo7jJHeznWhny62MHhbsY1NyWpy7mzi6B59M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Alexander Aring <aahringo@redhat.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 069/294] mac802154: fix llsec key resources release in mac802154_llsec_key_del
Date: Thu, 11 Apr 2024 11:53:52 +0200
Message-ID: <20240411095437.764917760@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit e8a1e58345cf40b7b272e08ac7b32328b2543e40 ]

mac802154_llsec_key_del() can free resources of a key directly without
following the RCU rules for waiting before the end of a grace period. This
may lead to use-after-free in case llsec_lookup_key() is traversing the
list of keys in parallel with a key deletion:

refcount_t: addition on 0; use-after-free.
WARNING: CPU: 4 PID: 16000 at lib/refcount.c:25 refcount_warn_saturate+0x162/0x2a0
Modules linked in:
CPU: 4 PID: 16000 Comm: wpan-ping Not tainted 6.7.0 #19
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:refcount_warn_saturate+0x162/0x2a0
Call Trace:
 <TASK>
 llsec_lookup_key.isra.0+0x890/0x9e0
 mac802154_llsec_encrypt+0x30c/0x9c0
 ieee802154_subif_start_xmit+0x24/0x1e0
 dev_hard_start_xmit+0x13e/0x690
 sch_direct_xmit+0x2ae/0xbc0
 __dev_queue_xmit+0x11dd/0x3c20
 dgram_sendmsg+0x90b/0xd60
 __sys_sendto+0x466/0x4c0
 __x64_sys_sendto+0xe0/0x1c0
 do_syscall_64+0x45/0xf0
 entry_SYSCALL_64_after_hwframe+0x6e/0x76

Also, ieee802154_llsec_key_entry structures are not freed by
mac802154_llsec_key_del():

unreferenced object 0xffff8880613b6980 (size 64):
  comm "iwpan", pid 2176, jiffies 4294761134 (age 60.475s)
  hex dump (first 32 bytes):
    78 0d 8f 18 80 88 ff ff 22 01 00 00 00 00 ad de  x.......".......
    00 00 00 00 00 00 00 00 03 00 cd ab 00 00 00 00  ................
  backtrace:
    [<ffffffff81dcfa62>] __kmem_cache_alloc_node+0x1e2/0x2d0
    [<ffffffff81c43865>] kmalloc_trace+0x25/0xc0
    [<ffffffff88968b09>] mac802154_llsec_key_add+0xac9/0xcf0
    [<ffffffff8896e41a>] ieee802154_add_llsec_key+0x5a/0x80
    [<ffffffff8892adc6>] nl802154_add_llsec_key+0x426/0x5b0
    [<ffffffff86ff293e>] genl_family_rcv_msg_doit+0x1fe/0x2f0
    [<ffffffff86ff46d1>] genl_rcv_msg+0x531/0x7d0
    [<ffffffff86fee7a9>] netlink_rcv_skb+0x169/0x440
    [<ffffffff86ff1d88>] genl_rcv+0x28/0x40
    [<ffffffff86fec15c>] netlink_unicast+0x53c/0x820
    [<ffffffff86fecd8b>] netlink_sendmsg+0x93b/0xe60
    [<ffffffff86b91b35>] ____sys_sendmsg+0xac5/0xca0
    [<ffffffff86b9c3dd>] ___sys_sendmsg+0x11d/0x1c0
    [<ffffffff86b9c65a>] __sys_sendmsg+0xfa/0x1d0
    [<ffffffff88eadbf5>] do_syscall_64+0x45/0xf0
    [<ffffffff890000ea>] entry_SYSCALL_64_after_hwframe+0x6e/0x76

Handle the proper resource release in the RCU callback function
mac802154_llsec_key_del_rcu().

Note that if llsec_lookup_key() finds a key, it gets a refcount via
llsec_key_get() and locally copies key id from key_entry (which is a
list element). So it's safe to call llsec_key_put() and free the list
entry after the RCU grace period elapses.

Found by Linux Verification Center (linuxtesting.org).

Fixes: 5d637d5aabd8 ("mac802154: add llsec structures and mutators")
Cc: stable@vger.kernel.org
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Acked-by: Alexander Aring <aahringo@redhat.com>
Message-ID: <20240228163840.6667-1-pchelkin@ispras.ru>
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/cfg802154.h |  1 +
 net/mac802154/llsec.c   | 18 +++++++++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 6ed07844eb244..5290781abba3d 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -257,6 +257,7 @@ struct ieee802154_llsec_key {
 
 struct ieee802154_llsec_key_entry {
 	struct list_head list;
+	struct rcu_head rcu;
 
 	struct ieee802154_llsec_key_id id;
 	struct ieee802154_llsec_key *key;
diff --git a/net/mac802154/llsec.c b/net/mac802154/llsec.c
index 55550ead2ced8..a4cc9d077c59c 100644
--- a/net/mac802154/llsec.c
+++ b/net/mac802154/llsec.c
@@ -265,19 +265,27 @@ int mac802154_llsec_key_add(struct mac802154_llsec *sec,
 	return -ENOMEM;
 }
 
+static void mac802154_llsec_key_del_rcu(struct rcu_head *rcu)
+{
+	struct ieee802154_llsec_key_entry *pos;
+	struct mac802154_llsec_key *mkey;
+
+	pos = container_of(rcu, struct ieee802154_llsec_key_entry, rcu);
+	mkey = container_of(pos->key, struct mac802154_llsec_key, key);
+
+	llsec_key_put(mkey);
+	kfree_sensitive(pos);
+}
+
 int mac802154_llsec_key_del(struct mac802154_llsec *sec,
 			    const struct ieee802154_llsec_key_id *key)
 {
 	struct ieee802154_llsec_key_entry *pos;
 
 	list_for_each_entry(pos, &sec->table.keys, list) {
-		struct mac802154_llsec_key *mkey;
-
-		mkey = container_of(pos->key, struct mac802154_llsec_key, key);
-
 		if (llsec_key_id_equal(&pos->id, key)) {
 			list_del_rcu(&pos->list);
-			llsec_key_put(mkey);
+			call_rcu(&pos->rcu, mac802154_llsec_key_del_rcu);
 			return 0;
 		}
 	}
-- 
2.43.0



