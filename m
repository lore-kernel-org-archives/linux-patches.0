Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7366514389C;
	Wed, 19 Jun 2024 13:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802789; cv=none; b=rEb3UBZOXVZVK3EehKg3FmmSRtXT+4lHKm4X1GvsnxZC5bLyg6pWQbXd9wBucnRMa5Q6Uq0QrBlXYqdAyKzsrG34Gm8aEhOgv/BNQdUrwQP91ROKkkQi2TPTyCeij+180/DoyI1ICgtkSlTGFo034+W0gczDJeBBewWg6s7nTRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802789; c=relaxed/simple;
	bh=LM7TGkAYxc4HJCgHVFlX2/ZT1DEIyi0faIhACmj9SD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGvj30dd1OBodovRUxHlk+Tf9z2ise0barCNvHzd3KQhoio5JHS7YtTNBYvPErUNVAMqSsutP8lYuN7sEJmnH5oxwWf29cXxHVJwNUVzeW5odUo3yGjvCBYPFrh1rcanA7IEVBzhBMnYBK7oCPhRpC19c9WteC7GjOa65oR6n2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ULWNp7+h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ULWNp7+h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED505C2BBFC;
	Wed, 19 Jun 2024 13:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802789;
	bh=LM7TGkAYxc4HJCgHVFlX2/ZT1DEIyi0faIhACmj9SD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ULWNp7+h2k/1F/3bukl7B20Me2xwqzu/W4srj8YPUw0xiZgtxe2aSBkRGgJoozq/Y
	 M4jW7YQ8rwuZzGdFnYK7OKC1zhA1YjGiqIw1VveVxRicMa7fLJazoRN8j2gZkwCKP/
	 n4JGUnu36wwW3rabATNLKjAt3ZFYvwGy0jlqUy/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Escande <nico.escande@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 006/281] wifi: mac80211: mesh: Fix leak of mesh_preq_queue objects
Date: Wed, 19 Jun 2024 14:52:45 +0200
Message-ID: <20240619125610.089298705@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Escande <nico.escande@gmail.com>

[ Upstream commit b7d7f11a291830fdf69d3301075dd0fb347ced84 ]

The hwmp code use objects of type mesh_preq_queue, added to a list in
ieee80211_if_mesh, to keep track of mpath we need to resolve. If the mpath
gets deleted, ex mesh interface is removed, the entries in that list will
never get cleaned. Fix this by flushing all corresponding items of the
preq_queue in mesh_path_flush_pending().

This should take care of KASAN reports like this:

unreferenced object 0xffff00000668d800 (size 128):
  comm "kworker/u8:4", pid 67, jiffies 4295419552 (age 1836.444s)
  hex dump (first 32 bytes):
    00 1f 05 09 00 00 ff ff 00 d5 68 06 00 00 ff ff  ..........h.....
    8e 97 ea eb 3e b8 01 00 00 00 00 00 00 00 00 00  ....>...........
  backtrace:
    [<000000007302a0b6>] __kmem_cache_alloc_node+0x1e0/0x35c
    [<00000000049bd418>] kmalloc_trace+0x34/0x80
    [<0000000000d792bb>] mesh_queue_preq+0x44/0x2a8
    [<00000000c99c3696>] mesh_nexthop_resolve+0x198/0x19c
    [<00000000926bf598>] ieee80211_xmit+0x1d0/0x1f4
    [<00000000fc8c2284>] __ieee80211_subif_start_xmit+0x30c/0x764
    [<000000005926ee38>] ieee80211_subif_start_xmit+0x9c/0x7a4
    [<000000004c86e916>] dev_hard_start_xmit+0x174/0x440
    [<0000000023495647>] __dev_queue_xmit+0xe24/0x111c
    [<00000000cfe9ca78>] batadv_send_skb_packet+0x180/0x1e4
    [<000000007bacc5d5>] batadv_v_elp_periodic_work+0x2f4/0x508
    [<00000000adc3cd94>] process_one_work+0x4b8/0xa1c
    [<00000000b36425d1>] worker_thread+0x9c/0x634
    [<0000000005852dd5>] kthread+0x1bc/0x1c4
    [<000000005fccd770>] ret_from_fork+0x10/0x20
unreferenced object 0xffff000009051f00 (size 128):
  comm "kworker/u8:4", pid 67, jiffies 4295419553 (age 1836.440s)
  hex dump (first 32 bytes):
    90 d6 92 0d 00 00 ff ff 00 d8 68 06 00 00 ff ff  ..........h.....
    36 27 92 e4 02 e0 01 00 00 58 79 06 00 00 ff ff  6'.......Xy.....
  backtrace:
    [<000000007302a0b6>] __kmem_cache_alloc_node+0x1e0/0x35c
    [<00000000049bd418>] kmalloc_trace+0x34/0x80
    [<0000000000d792bb>] mesh_queue_preq+0x44/0x2a8
    [<00000000c99c3696>] mesh_nexthop_resolve+0x198/0x19c
    [<00000000926bf598>] ieee80211_xmit+0x1d0/0x1f4
    [<00000000fc8c2284>] __ieee80211_subif_start_xmit+0x30c/0x764
    [<000000005926ee38>] ieee80211_subif_start_xmit+0x9c/0x7a4
    [<000000004c86e916>] dev_hard_start_xmit+0x174/0x440
    [<0000000023495647>] __dev_queue_xmit+0xe24/0x111c
    [<00000000cfe9ca78>] batadv_send_skb_packet+0x180/0x1e4
    [<000000007bacc5d5>] batadv_v_elp_periodic_work+0x2f4/0x508
    [<00000000adc3cd94>] process_one_work+0x4b8/0xa1c
    [<00000000b36425d1>] worker_thread+0x9c/0x634
    [<0000000005852dd5>] kthread+0x1bc/0x1c4
    [<000000005fccd770>] ret_from_fork+0x10/0x20

Fixes: 050ac52cbe1f ("mac80211: code for on-demand Hybrid Wireless Mesh Protocol")
Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
Link: https://msgid.link/20240528142605.1060566-1-nico.escande@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh_pathtbl.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index a6b62169f0848..c0a5c75cddcb9 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -1017,10 +1017,23 @@ void mesh_path_discard_frame(struct ieee80211_sub_if_data *sdata,
  */
 void mesh_path_flush_pending(struct mesh_path *mpath)
 {
+	struct ieee80211_sub_if_data *sdata = mpath->sdata;
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct mesh_preq_queue *preq, *tmp;
 	struct sk_buff *skb;
 
 	while ((skb = skb_dequeue(&mpath->frame_queue)) != NULL)
 		mesh_path_discard_frame(mpath->sdata, skb);
+
+	spin_lock_bh(&ifmsh->mesh_preq_queue_lock);
+	list_for_each_entry_safe(preq, tmp, &ifmsh->preq_queue.list, list) {
+		if (ether_addr_equal(mpath->dst, preq->dst)) {
+			list_del(&preq->list);
+			kfree(preq);
+			--ifmsh->preq_queue_len;
+		}
+	}
+	spin_unlock_bh(&ifmsh->mesh_preq_queue_lock);
 }
 
 /**
-- 
2.43.0



