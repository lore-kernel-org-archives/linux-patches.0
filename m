Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C601373C1A;
	Thu, 30 Jul 2026 15:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425947; cv=none; b=UcdcybeWV0+UmfgwbTlhX1TqjJZDxNeevyJuY0UufNziFqnzXuwAUZ+RZhOUC3HLRxl4r/nauhyCrialLiarIS2EKsLly1kBaT9ofB9x8dwMepOELb96c9uAn14sYuzq5ntKLm1pa7hLGgwHQmW+p3/BoIszCk0ZAv5mbOOcrIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425947; c=relaxed/simple;
	bh=1v3z7tUcGuiyyy4ygIFlz+SIoJ09YlT1YjaY8EK9r2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+t4Eqa+y/2pL5j1PxsOJ6o6t4sevASMeriCqgz7xAM/6iqQLDwhw1/9ILUxIss2ZL7FRAuaVmXBmOq5NvGYg60eQz8Y6gwuagKNyytUe5ZOsK9zg07923E+HnjnHjjRGP/rPhF5ntISvC1gy/H+1uEmGFgWb/W6yhR28zKlOv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X+oqevD5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X+oqevD5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D69D41F000E9;
	Thu, 30 Jul 2026 15:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425946;
	bh=cz1PS4M4dvfeal4JEI/N6R71nZQT6AUWHDxa8G1YoeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X+oqevD5pU+Lnd206eSLaKnp8QC2tr/wyOfLXMVLj9ZgYyE3GKt08w0qNXlXk9h9V
	 U74VLQHUuT8MsdEaUAA+NnmVgaMIbeviDTP5/xjRFRkiyKuBSTdx/1EMJ3OTfvtlt8
	 AD5cyrnbY0jz5+ZtU3+1Hp2RHxYzbylQPe03Z50Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	Allison Henderson <achender@kernel.org>,
	"Cen Zhang (Microsoft)" <blbllhy@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 248/602] rds: tcp: unregister sysctl before tearing down listen socket
Date: Thu, 30 Jul 2026 16:10:40 +0200
Message-ID: <20260730141441.184355521@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang (Microsoft) <blbllhy@gmail.com>

[ Upstream commit 167e54c703ccd4fa028feb568b0d1002020cff86 ]

rds_tcp_exit_net() frees the per-netns RDS TCP listen socket via
rds_tcp_kill_sock() before unregistering the per-netns sysctl table.  Since
rds_tcp_skbuf_handler() derives the netns from
rtn->rds_tcp_listen_sock->sk, a concurrent sysctl write can race with
netns teardown and dereference the freed socket/sk.

KASAN reports the race as:

  BUG: KASAN: slab-use-after-free in rds_tcp_skbuf_handler+0x2aa/0x2e0
  rds_tcp_skbuf_handler              net/rds/tcp.c:721
  proc_sys_call_handler              fs/proc/proc_sysctl.c
  vfs_write                          fs/read_write.c
  __x64_sys_pwrite64                 fs/read_write.c

Fix this by unregistering the RDS TCP sysctl table before calling
rds_tcp_kill_sock().  unregister_net_sysctl_table() prevents new sysctl
handlers from starting and waits for in-flight handlers to finish, so
the listen socket can then be released safely. The fix was tested
against the linked reproducer.

Fixes: 7f5611cbc487 ("rds: sysctl: rds_tcp_{rcv,snd}buf: avoid using current->nsproxy")
Reported-by: AutonomousCodeSecurity@microsoft.com
Link: https://lore.kernel.org/all/20260719203718.9680-1-blbllhy@gmail.com
Reviewed-by: Allison Henderson <achender@kernel.org>
Signed-off-by: Cen Zhang (Microsoft) <blbllhy@gmail.com>
Link: https://patch.msgid.link/20260719210357.10179-1-blbllhy@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/tcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index b66dfcc3efaa0f..06a2d8d48bbacf 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -637,13 +637,13 @@ static void __net_exit rds_tcp_exit_net(struct net *net)
 {
 	struct rds_tcp_net *rtn = net_generic(net, rds_tcp_netid);
 
-	rds_tcp_kill_sock(net);
-
 	if (rtn->rds_tcp_sysctl)
 		unregister_net_sysctl_table(rtn->rds_tcp_sysctl);
 
 	if (net != &init_net)
 		kfree(rtn->ctl_table);
+
+	rds_tcp_kill_sock(net);
 }
 
 static struct pernet_operations rds_tcp_net_ops = {
-- 
2.53.0



