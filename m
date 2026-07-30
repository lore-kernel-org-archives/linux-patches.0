Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E694457AF;
	Thu, 30 Jul 2026 15:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424080; cv=none; b=rw75j+5PXhe50jRSP10lMFlkeH0jdtOJGOWKBnP9I/9yAroB4Z2cKH6Hk3LscDK+k5EugHapxj+p9gKQHpdKWoLH5hlfxgV0YH2nvLIF9WWn7MjC/C2E3nFRw8oaZ9lzBUSCDiSLJDIrL3pwyaT5S2UTalCiffH5JYUpSaKc8yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424080; c=relaxed/simple;
	bh=Dw7NJEOaZIwmLed2rLCiklSHu7991eYYbwakIXxeN5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=InqZgfk3hNlhQAD/tuAcWTQQCTOg5Vt8PX8Ia9dM9OeGktITK6akBRev7E6JjcEolPCbbJiWBn0SpZSejDMDLhWFauuPJbRaKctEZZMriBeTG+vP/1/exBjDEw6+SKC3KfubOPz5X45dDfwuE7wrk0Ox9anLMA5cS6/fsWL+AnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KoWU0M4w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KoWU0M4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EFA11F000E9;
	Thu, 30 Jul 2026 15:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424078;
	bh=o42Gy62IVzX75L1D5w11hz/Dp+wT7RGL0tarSrQiMhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KoWU0M4wqMLOrURNvaD4CA8z/1n53OsB0MXwGyiO6jLIgdAZ65fcUyRH/hSJWf7EH
	 0cXzbqjgEqsHsVHZx0QXg2JDBA8Yltf3VRgkb6Es+3ZSIwFqsd3DJh2/Gbz71fov2Q
	 oCaa8S7iZTw9uej25kSPDDX1ml2afmaVgtF4guHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 224/675] wifi: mac80211: tear down new links on vif update error path
Date: Thu, 30 Jul 2026 16:09:14 +0200
Message-ID: <20260730141449.902439394@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 952c02b33f56207a160421bcd61e7ac53c9c59ae ]

When ieee80211_vif_update_links() adds new links it allocates a link
container for each and calls ieee80211_link_init() (which registers the
per-link debugfs files with file->private_data pointing into the container)
and ieee80211_link_setup(). If the subsequent drv_change_vif_links() fails,
the error path restores the old pointers and jumps to 'free', which frees
the new containers but never removes their debugfs entries or stops the
links. The debugfs files survive with file->private_data dangling at the
freed container, so a later open()+read() (e.g. link-1/txpower)
dereferences freed memory in ieee80211_if_read_link(), a use-after-free.

The removal path already dismantles links correctly via
ieee80211_tear_down_links(), which removes each link's keys and debugfs
entries and calls ieee80211_link_stop(); the add path on the error branch
does not. Commit be1ba9ed221f ("wifi: mac80211: avoid weird state in error
path") hardened this same error path for the link-removal case
(new_links == 0) but left the newly-added links' teardown unaddressed.

drv_change_vif_links() can fail at runtime on MLO drivers (internal
allocation / queue / firmware command failures).

Remove the new links' debugfs entries and stop them before freeing.

  BUG: KASAN: slab-use-after-free in ieee80211_if_read_link (net/mac80211/debugfs_netdev.c:127)
  Read of size 8 at addr ffff888011290000 by task exploit/145
  Call Trace:
   ...
   ieee80211_if_read_link (net/mac80211/debugfs_netdev.c:127)
   short_proxy_read (fs/debugfs/file.c:373)
   vfs_read (fs/read_write.c:572)
   ksys_read (fs/read_write.c:716)
   do_syscall_64 (arch/x86/entry/syscall_64.c:94)
   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
  ...
  Oops: general protection fault, probably for non-canonical address 0xdffffc000000000a
  RIP: 0010:ieee80211_if_read_link (net/mac80211/debugfs_netdev.c:127)
  Kernel panic - not syncing: Fatal exception

Fixes: 170cd6a66d9a ("wifi: mac80211: add netdev per-link debugfs data and driver hook")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Link: https://patch.msgid.link/20260711210302.2098404-1-xmei5@asu.edu
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/link.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/link.c b/net/mac80211/link.c
index 05b0472bda40ed..235e370c2b59eb 100644
--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -382,6 +382,10 @@ static int ieee80211_vif_update_links(struct ieee80211_sub_if_data *sdata,
 		memcpy(sdata->link, old_data, sizeof(old_data));
 		memcpy(sdata->vif.link_conf, old, sizeof(old));
 		ieee80211_set_vif_links_bitmaps(sdata, old_links, dormant_links);
+		for_each_set_bit(link_id, &add, IEEE80211_MLD_MAX_NUM_LINKS) {
+			ieee80211_link_debugfs_remove(&links[link_id]->data);
+			ieee80211_link_stop(&links[link_id]->data);
+		}
 		/* and free (only) the newly allocated links */
 		memset(to_free, 0, sizeof(links));
 		goto free;
-- 
2.53.0



