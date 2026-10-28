Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215711;
	b=aXbvSg47b/7Siol3HAAjCoJPrb0NiSDsxWUgAtdX1BRFJvZwGAR0+rufghZOYnF+75vD
	 tMZQDRZOJcC3ZDpqBMKJZZAJDGxyRiXZKzXAIKhUQGfiKN8rKKPDfgVnGsXvUi8cOwHLD
	 qJYilNn0L8QXAh5sc8D8mH5HAS5cO1eDbqLW0Tk/okcWbhdWTFoDyFqEP0vji9H2HHlI8
	 UtEVlZJLqd2UQwAQ3aXLlNeBjabN35coQKNmvJXgebpm2ZJit6Exj25EONcScp/AvmeLU
	 2jX7xgqTxYi8QySWqbk2+kzZtAssmLeMH+5GHlNkK71dSheesT9Wxetw6hyjtuev9yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215711;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y+c0Ai3sXTUjsUXRjcmD+KAzHkpB34Hcb15mVA6Vvjg=;
	b=v36vwh7tUvXOGyU3IWL8UBJ5cofeS9jbd5HP2356T3EghBsQ943qhcupCiaTcW9McWww
	 9nDG3xVLicn1ObnMUW2dwwtYloc5dVyGYWAc0irzNp91Ov796VOpmqOsN+RGt2FrPRuJo
	 AHfHxSTmNxo3Nojszp94mb/qsYX6etaSxVR1CG5x9EkVKrlF3IW7AIYpeDrxrThKDfNwn
	 tDRlD2137rh1S9lZsdYUUbnDarxl5bhKf9/CZ4WP+yBQjfIqSqTlaKblaEDwjjo8OHfA1
	 boKG82boLV6OerZ7HgYeuD6AROhcgKsFK6/UMLBhYOUCqH/csIXsg+8O3VhxBnNXUUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zOeTnuP4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDB5606A31E;
	Wed, 28 Oct 2026 19:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zOeTnuP4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D901F01828;
	Wed, 28 Oct 2026 19:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215711;
	bh=Y+c0Ai3sXTUjsUXRjcmD+KAzHkpB34Hcb15mVA6Vvjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zOeTnuP4GNbjWR2O5GR5fVcqYtNQurEjlS8SZrSwVuC9PLBZ299IEjh0Y7HEY08Ri
	 jxG4BTmQQ23ME0FbS19CuD2/VTljUTqNNs7rjnCnFsPd2bd0+umDqTzmrPNR5vpxKD
	 6hy1IEZmedke61q0hbAabyJnyPkKT/OIUKFGm3f0=
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
Subject: [PATCH 6.1 1305/1887] l2tp: fix tunnel and session refcount leak on seq_file release
Date: Wed, 28 Oct 2026 17:56:41 +0100
Message-ID: <20261028170529.126855556@linuxfoundation.org>
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



