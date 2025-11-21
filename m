Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2362347FF8;
	Fri, 21 Nov 2025 14:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733601; cv=none; b=kU5iCBCc1iDG4rbZn3qzByLFIFOzS+SqqKmPdkER1qN+C1S6l/9YrXD4VM5ZFgLn0N3waahoq5uGTYuTIyWRCgzU1GwlqBzUG/SczomOg8bGNyM+Z79LPXteT0CVK4+jgmtGLiKLKx5jxKZMmUl4/yjnNLV6f1R/xQmuUjTrCUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733601; c=relaxed/simple;
	bh=ZYxK78o6vI3DIPflXWuZQVW3U0CHrNMjN8lwwR1tZKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPumWd5zunStpu9bJVATCYXP5d1v/teIWMBiQltdhfDk+A3EKuYxEu2a5cEjggWL0Ypqla2ZBIV8qGVCjiCXYLkPR1pLSftf3P4BCH2A53dF1wUkumlp4+i4Fgql8NR7po6ShyTOonRGoLjckGYpTBZ5D6NhgR4bAyo8GLIlrSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KOPUSsM5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KOPUSsM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06043C4CEF1;
	Fri, 21 Nov 2025 14:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733601;
	bh=ZYxK78o6vI3DIPflXWuZQVW3U0CHrNMjN8lwwR1tZKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KOPUSsM5bPJUHiNX7FF6GPYQj/+74VXViqAAZV656ZV3XhdAwwpCIERRogrFqvcDC
	 XLK4h/xNyTcj/cGsiTxkClTX/ZTrcw7cnf0okA16xRdYxL4Mml2qmBlMqTdvSPXvg3
	 nKPxBe7lPPHWSR3Jyckm5TQONU15ZSbfKkprwkvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Sperbeck <jsperbeck@google.com>,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 523/529] net: netpoll: ensure skb_pool list is always initialized
Date: Fri, 21 Nov 2025 14:13:42 +0100
Message-ID: <20251121130249.655089129@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: John Sperbeck <jsperbeck@google.com>

commit f0d0277796db613c124206544b6dbe95b520ab6c upstream.

When __netpoll_setup() is called directly, instead of through
netpoll_setup(), the np->skb_pool list head isn't initialized.
If skb_pool_flush() is later called, then we hit a NULL pointer
in skb_queue_purge_reason().  This can be seen with this repro,
when CONFIG_NETCONSOLE is enabled as a module:

    ip tuntap add mode tap tap0
    ip link add name br0 type bridge
    ip link set dev tap0 master br0
    modprobe netconsole netconsole=4444@10.0.0.1/br0,9353@10.0.0.2/
    rmmod netconsole

The backtrace is:

    BUG: kernel NULL pointer dereference, address: 0000000000000008
    #PF: supervisor write access in kernel mode
    #PF: error_code(0x0002) - not-present page
    ... ... ...
    Call Trace:
     <TASK>
     __netpoll_free+0xa5/0xf0
     br_netpoll_cleanup+0x43/0x50 [bridge]
     do_netpoll_cleanup+0x43/0xc0
     netconsole_netdev_event+0x1e3/0x300 [netconsole]
     unregister_netdevice_notifier+0xd9/0x150
     cleanup_module+0x45/0x920 [netconsole]
     __se_sys_delete_module+0x205/0x290
     do_syscall_64+0x70/0x150
     entry_SYSCALL_64_after_hwframe+0x76/0x7e

Move the skb_pool list setup and initial skb fill into __netpoll_setup().

Fixes: 221a9c1df790 ("net: netpoll: Individualize the skb pool")
Signed-off-by: John Sperbeck <jsperbeck@google.com>
Reviewed-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20250114011354.2096812-1-jsperbeck@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/netpoll.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -634,6 +634,8 @@ int __netpoll_setup(struct netpoll *np,
 	const struct net_device_ops *ops;
 	int err;
 
+	skb_queue_head_init(&np->skb_pool);
+
 	if (ndev->priv_flags & IFF_DISABLE_NETPOLL) {
 		np_err(np, "%s doesn't support polling, aborting\n",
 		       ndev->name);
@@ -669,6 +671,9 @@ int __netpoll_setup(struct netpoll *np,
 	strscpy(np->dev_name, ndev->name, IFNAMSIZ);
 	npinfo->netpoll = np;
 
+	/* fill up the skb queue */
+	refill_skbs(np);
+
 	/* last thing to do is link it to the net device structure */
 	rcu_assign_pointer(ndev->npinfo, npinfo);
 
@@ -688,8 +693,6 @@ int netpoll_setup(struct netpoll *np)
 	struct in_device *in_dev;
 	int err;
 
-	skb_queue_head_init(&np->skb_pool);
-
 	rtnl_lock();
 	if (np->dev_name[0]) {
 		struct net *net = current->nsproxy->net_ns;
@@ -789,9 +792,6 @@ put_noaddr:
 		}
 	}
 
-	/* fill up the skb queue */
-	refill_skbs(np);
-
 	err = __netpoll_setup(np, ndev);
 	if (err)
 		goto flush;


