Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE7A3C4169;
	Sat, 17 Oct 2026 17:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259423; cv=none; b=bDMvej9iM3oQMeZOrZORFxozgnaOcRk8FiaFuch0SuwuDgDW/ycpLCUq4vdT0fXQZdM31KdsoDdQHdV3+YX9lW9Bu+LSkes1YHu0wcIaRPss/AETjCkDjCkiZzrTa0jsRw3hZRPx7RZ0YdI6BC5JGF4xp+H1za5wg+EJ1F1Nt7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259423; c=relaxed/simple;
	bh=vJWgNh02jei+5Hf3RqUiuoJkoeWcdjqC1rRiueOE92o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hp4m19gbbN3u7KhNWvAKhzUBNimfudst+bcpH6A/D6jVhTZo5P59e3LPn+GUtuq8VLMBs/Bnd8xHApyT2qRwZv3SeMouqQYSTBQE7alFWIn81oIyke+sNeLQBrFKutF3AqBf6awQY2/3KinLzfIc4ay2J0/gHEkul5MMc1Y5R70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cmPm7C6d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cmPm7C6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 453AA1F000C4;
	Sat, 17 Oct 2026 17:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259419;
	bh=+7iGPEEf60QTWbUmC21TjGuIXNYZ1KM4wwwqyz8R3x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cmPm7C6dPDtmg8LWRWd+qpqZV3B30rag+09+RgiQ0ad+iUvSn7YcNPVQhWAqZvkKf
	 eKSPKkslo2x8szw4cTm1ee0o+k99JOEfRg6HGSXg7Duwr7+Q+Imn7mfKkm+7Y2nGRZ
	 Sem85gE/amXoJ+j2f/55P5p88452glBX96U4sGak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d6fa74e3f19d6ee01e3a@syzkaller.appspotmail.com,
	James Chapman <jchapman@katalix.com>,
	Guillaume Nault <gnault@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1208/1674] l2tp: fix tunnel and session refcount leak on seq_file release
Date: Sat, 17 Oct 2026 17:58:00 +0200
Message-ID: <20261017160502.146784966@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9006c116dd111d457bf5d074990210f70a4ad2c8 ]

In pppol2tp_proc_open() and l2tp_dfs_seq_open(), iteration state
(pd->tunnel and pd->session) is kept in seq_file private data to allow
iteration across multiple read() system calls.

However, if userspace closes /proc/net/pppol2tp or /sys/kernel/debug/l2tp/tunnels
before reading to end-of-file (EOF), any tunnel or session reference stored in
pd->tunnel / pd->session is left un-dropped when seq_file private data is freed.

Fix this by dropping any remaining pd->tunnel and pd->session references in
pppol2tp_proc_release() and l2tp_dfs_seq_release() when closing the file.

Fixes: 0e0c3fee3a59 ("l2tp: hold reference on tunnels printed in pppol2tp proc file")
Fixes: f726214d9b23 ("l2tp: hold reference on tunnels printed in l2tp/tunnels debugfs file")
Reported-by: syzbot+d6fa74e3f19d6ee01e3a@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6a760f32.01d0871a.3a0d52.004f.GAE@google.com/T/#u
Assisted-by: Jetski:Gemini-3.1-Pro
Cc: James Chapman <jchapman@katalix.com>
Cc: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260811144651.2733424-1-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/l2tp/l2tp_debugfs.c |  4 +++
 net/l2tp/l2tp_ppp.c     | 56 ++++++++++++++++++++++++++++++++++++++---
 2 files changed, 57 insertions(+), 3 deletions(-)

diff --git a/net/l2tp/l2tp_debugfs.c b/net/l2tp/l2tp_debugfs.c
index 4595b56d175d9..fe56dbae43bea 100644
--- a/net/l2tp/l2tp_debugfs.c
+++ b/net/l2tp/l2tp_debugfs.c
@@ -307,6 +307,10 @@ static int l2tp_dfs_seq_release(struct inode *inode, struct file *file)
 
 	seq = file->private_data;
 	pd = seq->private;
+	if (pd->session)
+		l2tp_session_dec_refcount(pd->session);
+	if (pd->tunnel)
+		l2tp_tunnel_dec_refcount(pd->tunnel);
 	if (pd->net)
 		put_net_track(pd->net, &pd->ns_tracker);
 	kfree(pd);
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 230b1b156465a..21b1016020f3a 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -1620,7 +1620,53 @@ static const struct seq_operations pppol2tp_seq_ops = {
 	.stop		= pppol2tp_seq_stop,
 	.show		= pppol2tp_seq_show,
 };
-#endif /* CONFIG_PROC_FS */
+
+static int pppol2tp_proc_open(struct inode *inode, struct file *file)
+{
+	struct net *net = pde_data(inode);
+	struct pppol2tp_seq_data *pd;
+
+	net = maybe_get_net(net);
+	if (!net)
+		return -ENXIO;
+
+	pd = __seq_open_private(file, &pppol2tp_seq_ops, sizeof(*pd));
+	if (!pd) {
+		put_net(net);
+		return -ENOMEM;
+	}
+
+#ifdef CONFIG_NET_NS
+	pd->p.net = net;
+	netns_tracker_alloc(net, &pd->p.ns_tracker, GFP_KERNEL);
+#endif
+	return 0;
+}
+
+static int pppol2tp_proc_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *seq = file->private_data;
+	struct pppol2tp_seq_data *pd = seq->private;
+
+	if (pd->session)
+		l2tp_session_dec_refcount(pd->session);
+	if (pd->tunnel)
+		l2tp_tunnel_dec_refcount(pd->tunnel);
+
+#ifdef CONFIG_NET_NS
+	put_net_track(pd->p.net, &pd->p.ns_tracker);
+#else
+	put_net(&init_net);
+#endif
+	return seq_release_private(inode, file);
+}
+
+static const struct proc_ops pppol2tp_proc_ops = {
+	.proc_open	= pppol2tp_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= pppol2tp_proc_release,
+};
 
 /*****************************************************************************
  * Network namespace
@@ -1631,8 +1677,8 @@ static __net_init int pppol2tp_init_net(struct net *net)
 	struct proc_dir_entry *pde;
 	int err = 0;
 
-	pde = proc_create_net("pppol2tp", 0444, net->proc_net,
-			      &pppol2tp_seq_ops, sizeof(struct pppol2tp_seq_data));
+	pde = proc_create_data("pppol2tp", 0444, net->proc_net,
+			       &pppol2tp_proc_ops, net);
 	if (!pde) {
 		err = -ENOMEM;
 		goto out;
@@ -1647,9 +1693,13 @@ static __net_exit void pppol2tp_exit_net(struct net *net)
 	remove_proc_entry("pppol2tp", net->proc_net);
 }
 
+#endif /* CONFIG_PROC_FS */
+
 static struct pernet_operations pppol2tp_net_ops = {
+#ifdef CONFIG_PROC_FS
 	.init = pppol2tp_init_net,
 	.exit = pppol2tp_exit_net,
+#endif
 	.id   = &pppol2tp_net_id,
 };
 
-- 
2.53.0



