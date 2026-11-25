Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625697;
	b=3SzTSpluGHSpAje09we/VZTqUtfkA5lhm+wc57uDH1gHJLMMXFZAsqZaDd/ZbtMdwM1z
	 n+0DMcS8jqid9ddYbqgoBkZL2O/MRlNqPPrNMX7ig96g9OXV/PnDaAy85aYkukofhY2Ou
	 i4ixre47CVxrbaezngTl/nlYc7FGe3XR6V6Bef5uPmmXOOmpaKDiAosYs9MM7qd7nmVnk
	 NiisK16IFcrvvHItrqlYYWkaTh0pvwdeRkxklN4Y7LzFHyo3JIyDeusWAAuUHVAHc2PzD
	 T9DttRVFzAb6Vzt9eOzQWWm2KyAkK9eSoVgEro37MzhjXtZQNnGSYPFFaluKkveB8tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625697;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KZyJC/NeQJYHXp8jLec7sFh2YCkcsP/k2yIqudlasbQ=;
	b=OtM62oRseSkaze5HnBcewo9FVt2G1z5WBTXJqeBbQ+KvzBPjw3ot2ITuEQLH3KANf0LM
	 EvMeBlsueaMxEIC+7Ws2+5fewQRLLK+sHpVfcvxNwwYD3ZUd80EFN5mrNRF24jlP8NUCN
	 cbPAvrcZfHIbQ6lO++m5eSkJCo+yEyl23jAEOR9Yi7IYtk9vi+oCbBD7qI2Cy67ZZlauT
	 +rXXdMvTYFvHBTlKuqtZM6CebHar2Chwk5W//7hPcCdbHHtpoZHsnqc8IDljD98JSYy6P
	 /spvcKQTbFWfIZzXTxr6h+/S62Pco1pTllNUUBf0f/WJmlpvtIoiksNSXD4ovfFSuyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J4Bih2KL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E74C606A31E;
	Wed, 25 Nov 2026 16:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J4Bih2KL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0581F000C6;
	Wed, 25 Nov 2026 16:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625697;
	bh=KZyJC/NeQJYHXp8jLec7sFh2YCkcsP/k2yIqudlasbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J4Bih2KLgvu/O0iMs7oDmVXaW6VFINZy2+zvxVhg1K+hnT8UXH+cBoCnwvBZMnDrn
	 7Q4D85lqpOQwCg18AyVMEWKkxqTGkf6rIpWmY0GtsckeaKMmuirQJ+CTx9xcKoQ1Fk
	 cN7KclY1kBYKRNDwUVxMbHdXIZEfNTr9CpsnvQaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft)" <cenzhang@linux.microsoft.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.12 600/816] netfilter: xt_recent: do not call remove_proc_entry() under recent_lock
Date: Wed, 25 Nov 2026 15:35:48 +0100
Message-ID: <20261125143903.067076717@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>

commit 17c2e41736b62cfe444c64d67860b1fbc1e886ac upstream.

recent_proc_net_exit() removes the /proc/net/xt_recent/<name> entries of
a dying network namespace while holding spin_lock_bh(&recent_lock).
remove_proc_entry() may sleep: proc_entry_rundown() waits until every
task that is still inside the entry's file operations has left. A reader
of such an entry is counted in by proc_reg_read() before
recent_seq_start() takes recent_lock. So if a read is in flight when the
namespace is torn down, cleanup_net() sleeps in atomic context holding
the spinlock that the reader is spinning on, and neither side can ever
make progress.

An unprivileged user can trigger this from a user namespace by adding a
rule with the "recent" match and reading its proc file while the
namespace is being destroyed. As recent_lock is global, every later
attempt to take it spins forever too: the spinning can spread to all
CPUs, and network namespace teardown stops system-wide.

  BUG: sleeping function called from invalid context at
    kernel/sched/completion.c:116
   #3: (recent_lock){+...}-{3:3}, at: recent_net_exit+0x2b/0x140
  Workqueue: netns cleanup_net
  Call Trace:
   proc_entry_rundown+0x185/0x1b0
   remove_proc_entry+0x21a/0x520
   recent_net_exit+0x7f/0x140
   cleanup_net+0x414/0x8f0
  ...
  rcu: INFO: rcu_preempt self-detected stall on CPU
  Call Trace:
   queued_spin_lock_slowpath+0x313/0xc20
   recent_seq_start+0x87/0x1b0
   seq_read_iter+0x265/0x11e0
   proc_reg_read+0x1ab/0x270

Fix by taking recent_mutex instead of recent_lock. According to
commit a0e889bb1bdc ("[NETFILTER]: recent match: fix "sleeping function
called from invalid context""), recent_mutex is the lock to use here: it
protects recent_net->tables and was introduced so that proc entries are
created and removed without recent_lock held, because those calls may
sleep. hashlimit_proc_net_exit() does the same for xt_hashlimit.

Fixes: 665e205c16c1 ("netfilter: xt_recent: fix namespace destroy path")
Cc: stable@vger.kernel.org
Cc: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/xt_recent.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -649,14 +649,15 @@ static void __net_exit recent_proc_net_e
 
 	/* recent_net_exit() is called before recent_mt_destroy(). Make sure
 	 * that the parent xt_recent proc entry is empty before trying to
-	 * remove it.
+	 * remove it. Use recent_mutex instead of recent_lock since
+	 * remove_proc_entry() may sleep.
 	 */
-	spin_lock_bh(&recent_lock);
+	mutex_lock(&recent_mutex);
 	list_for_each_entry(t, &recent_net->tables, list)
 	        remove_proc_entry(t->name, recent_net->xt_recent);
 
 	recent_net->xt_recent = NULL;
-	spin_unlock_bh(&recent_lock);
+	mutex_unlock(&recent_mutex);
 
 	remove_proc_entry("xt_recent", net->proc_net);
 }


