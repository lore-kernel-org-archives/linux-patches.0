Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74D1318B9C;
	Thu, 17 Sep 2026 15:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660427; cv=none; b=uhcp2jhSBQcz/wVRJvuglVnK39bT+Dr93rvvN6VQ1SDh5uGCmqm+LOzJl/ljVrDIJAHghDB4SQqjlJ0ZdR7fASuNYtVeNy1uELjaXUX0oZOj+cZPm0t4ux6oi/YEG8qF1hIkO4VooJ2w3l7tTeXFlZfnDmAY77GiF2EyonN8274=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660427; c=relaxed/simple;
	bh=/xmXYAcuNAr95IKROiQPWV01/V791kz9eZxN3gck8Ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpXz40Nz2Vwb6zY5/jYOtU0qsf7Im99kW191qqBspasMZORh26kIjhY9dO0MqG8PEujHl1H8sK+QN53ozDurMDfWPBXPb14PorUlWQegbVg+fj6mm6UoyEAlNkgDrdbHY+bOdh3ubi9yQoLxEAvZO4PHHcz0GYKeb+rvM3ddG4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u0SEa65F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u0SEa65F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D0E1F000FF;
	Thu, 17 Sep 2026 15:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660425;
	bh=vLW8eeE0olxV8fDthJcxn06d+l1mJ4kSJIGtpjWFDic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u0SEa65F580MLbFESzcmSpNn34Kn8sy904NaH7bHXf3HN9fo5ju5OtbpDOHAV8SCB
	 DCQ0vIVQcUvcYTHr8XgSL7MSjFg4DQ9+S39RM7hTyGv1yAW98uYYbFDS+dbcP0SIbA
	 WZ2Ccq7GnP+vHMEkoLec18xFBi8FKcIQImfHEsc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Qi Zhang <marsy12010123@gmail.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 589/733] afs: Clear stale peer app data after address list changes
Date: Thu, 17 Sep 2026 16:14:57 +0100
Message-ID: <20260917151407.103832568@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <nicoyip.dev@gmail.com>

commit ba0623fc19a424f4745394c499f9f28a8d88d397 upstream.

afs_fs_probe_fileserver() fetches the current endpoint state under
server->fs_lock, but leaves old_alist as NULL.  Consequently,
afs_set_peer_appdata() treats every address list replacement as initial
setup and only binds the new peers; it never unbinds peers removed from
the old list.

An address refresh can therefore proceed as follows.  CPU 0 replaces
server S's list and drops Pold without clearing Pold->app_data.  The
server destroyer then clears only S's current peers and lets S reach its
RCU callback.  After the callback frees S, CPU 1 handles a callback
through an RxRPC connection that still pins Pold, reads Pold->app_data,
and calls afs_use_server() on the freed object.

KASAN reported:

  BUG: KASAN: slab-use-after-free in afs_find_server+0x3c/0xa0
  Read of size 4 at addr ffff8881013e1af0 by task krxrpcio/7001/74
  Call Trace:
   afs_find_server+0x3c/0xa0
   afs_rx_new_call+0x15c/0x390
   rxrpc_new_incoming_call+0x97c/0x1730
   rxrpc_input_packet.constprop.0+0xd03/0xec0
   rxrpc_io_thread+0x967/0x1640
  Allocated by task 93:
   afs_lookup_server+0x1a7/0x14c0
   afs_alloc_server_list+0x43f/0xb60
   afs_create_volume+0x923/0x1490
   afs_get_tree+0x1c6/0x10a0
  Freed by task 0:
   kfree+0x131/0x3c0
   rcu_core+0x50a/0x1850
  Last potentially related work creation:
   __call_rcu_common.constprop.0+0x71/0xa10
   afs_put_server+0x213/0x2b0

Preserve old->addresses for the peer app-data update so that removed
peers are cleared before the endpoint state is replaced.  Also advance
both cursors when the old and new lists share a peer; activating the
old/new comparison without this would otherwise loop forever on the
shared entry.

Fixes: 40e8b52fe8c8 ("afs: Use the per-peer app data provided by rxrpc")
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Signed-off-by: Qi Zhang <marsy12010123@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260902121024.3328255-5-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: linux-fsdevel@vger.kernel.org
cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/addr_list.c |    5 ++++-
 fs/afs/fs_probe.c  |    1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/fs/afs/addr_list.c
+++ b/fs/afs/addr_list.c
@@ -394,8 +394,11 @@ void afs_set_peer_appdata(struct afs_ser
 		struct rxrpc_peer *pn = new_alist->addrs[n].peer;
 		struct rxrpc_peer *po = old_alist->addrs[o].peer;
 
-		if (pn == po)
+		if (pn == po) {
+			n++;
+			o++;
 			continue;
+		}
 		if (pn < po) {
 			rxrpc_kernel_set_peer_data(pn, data);
 			n++;
--- a/fs/afs/fs_probe.c
+++ b/fs/afs/fs_probe.c
@@ -258,6 +258,7 @@ int afs_fs_probe_fileserver(struct afs_n
 					lockdep_is_held(&server->fs_lock));
 	if (old) {
 		estate->responsive_set = old->responsive_set;
+		old_alist = old->addresses;
 		if (!new_alist)
 			new_alist = old->addresses;
 	}


