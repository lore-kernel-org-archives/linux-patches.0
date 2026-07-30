Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2A143E48C;
	Thu, 30 Jul 2026 14:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422167; cv=none; b=njO978i/Xmqn+jIzVoL2lrqcQUMxmPZ1Eqdc9CwPDjWYKqixh7JtspE9dXPp5QYCvqpFQ4rcqwZKowfSroZYVgSg0RbEZ28cq6A9AVGPS36tkfuPjJOPSxkIi5jr82c1f884QWa1xgNqJsP8SjI5JznS4da7n7lWRPDTxZn91M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422167; c=relaxed/simple;
	bh=9S3JepozFM35o1q/EknWcuziliEH2SdSMtgys3dKU4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTpOzrxNamGjaQVYnqQcUqxSmexX6eu5bc1nQZS9eisdmzxto+MOYxYdjyrxDrifeuxKSMzh7ME1qt+oG8eqr9UljUjqXccc8Erhe7oVKI5o0jl9fHKaunOBV40MQ2LbjWMe3Cy4Iu4EdkVgZ7xtnhn/UvElYSQ3o03DwKqIUWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=06T9WXke; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="06T9WXke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D457C1F000E9;
	Thu, 30 Jul 2026 14:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422166;
	bh=hgO3agm/WlRwhSSuEJ2bJiqiCz3Of3VITPnreGgNwY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=06T9WXkerD4MiDc0tagVBtclhTFcXAqXE1/0maI7yZHBFwxeA+bQwG6BfoHOLXoqm
	 niWUCo2LvMhC2oo3huGHfn/ElP5Q/4qPiY2kXRFqGVi/V/5hLXyyXrfYi0vEl+s8M7
	 2mDh7kWopsSRZb0mD+v9HrgkaumaplFf0/Usinrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	Allison Henderson <achender@kernel.org>,
	"Cen Zhang (Microsoft)" <blbllhy@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 346/744] rds: tcp: unregister sysctl before tearing down listen socket
Date: Thu, 30 Jul 2026 16:10:19 +0200
Message-ID: <20260730141451.639662204@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index d3acad60315ab0..76f441cbf50e64 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -638,13 +638,13 @@ static void __net_exit rds_tcp_exit_net(struct net *net)
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



