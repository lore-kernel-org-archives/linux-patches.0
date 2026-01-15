Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFAC29C338;
	Thu, 15 Jan 2026 17:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496488; cv=none; b=TmNQDDkdaY4QSBvFercyzwhlTLC12YcpyD6d0lPWvX86JfTB2+GTaL+vOWegLqrg7dHyk8fChbIV9G1j8zBcKteXXLLcb3DQZaIUMorMDubRwsqPt2b/vDg0NEWKnzNqgj8P0fktx0CRrfS69JTIX4J/M9K+z7F2Dt110+HqvRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496488; c=relaxed/simple;
	bh=6/H2kcHugN7QQFe1ujESfDuNK70t4/5810PKwH0IpN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vbpi+UGuBeN9RVFBVrSFZP9MmdsS+BAf9HquTXx60ezfxYTNmizbwnzQ1/J4KQ6jQyMOPjgHfoQ6ABqceGKPMYqOcMS8FOZxNOkkEY/gkpW4mnkJ7sdgPa9fDMnD/s/YbO2rsHQog6tF2ZFRWImIj6Zr5TRqaeqpoufsWzDFYVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cSGZ1orq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cSGZ1orq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF4AC116D0;
	Thu, 15 Jan 2026 17:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496488;
	bh=6/H2kcHugN7QQFe1ujESfDuNK70t4/5810PKwH0IpN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cSGZ1orq7RYllroBh4e46vr0RBGzI+xbCHnpTavW+T0D6L4NU2MDLK/2vubMaEx+x
	 eDinclTe7NtKbywWtNBf+GgiWuzryl9V9qEbZstMQg7tM3FnMnKkXeOmRP7zKx5iE/
	 mSxY6IgTPRAT23MzVKn72Gy590U7rT/hXtnAcRiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6ee3b889bdeada0a6226@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 005/119] NFSD: net ref data still needs to be freed even if net hasnt startup
Date: Thu, 15 Jan 2026 17:47:00 +0100
Message-ID: <20260115164152.152252831@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

From: Edward Adam Davis <eadavis@qq.com>

commit 0b88bfa42e5468baff71909c2f324a495318532b upstream.

When the NFSD instance doesn't to startup, the net ref data memory is
not properly reclaimed, which triggers the memory leak issue reported
by syzbot [1].

To avoid the problem reported in [1], the net ref data memory reclamation
action is moved outside of nfsd_net_up when the net is shutdown.

[1]
unreferenced object 0xffff88812a39dfc0 (size 64):
  backtrace (crc a2262fc6):
    percpu_ref_init+0x94/0x1e0 lib/percpu-refcount.c:76
    nfsd_create_serv+0xbe/0x260 fs/nfsd/nfssvc.c:605
    nfsd_nl_listener_set_doit+0x62/0xb00 fs/nfsd/nfsctl.c:1882
    genl_family_rcv_msg_doit+0x11e/0x190 net/netlink/genetlink.c:1115
    genl_family_rcv_msg net/netlink/genetlink.c:1195 [inline]
    genl_rcv_msg+0x2fd/0x440 net/netlink/genetlink.c:1210

BUG: memory leak

Reported-by: syzbot+6ee3b889bdeada0a6226@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6ee3b889bdeada0a6226
Fixes: 39972494e318 ("nfsd: update percpu_ref to manage references on nfsd_net")
Cc: stable@vger.kernel.org
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfssvc.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -434,26 +434,26 @@ static void nfsd_shutdown_net(struct net
 {
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 
-	if (!nn->nfsd_net_up)
-		return;
-
-	percpu_ref_kill_and_confirm(&nn->nfsd_net_ref, nfsd_net_done);
-	wait_for_completion(&nn->nfsd_net_confirm_done);
-
-	nfsd_export_flush(net);
-	nfs4_state_shutdown_net(net);
-	nfsd_reply_cache_shutdown(nn);
-	nfsd_file_cache_shutdown_net(net);
-	if (nn->lockd_up) {
-		lockd_down(net);
-		nn->lockd_up = false;
+	if (nn->nfsd_net_up) {
+		percpu_ref_kill_and_confirm(&nn->nfsd_net_ref, nfsd_net_done);
+		wait_for_completion(&nn->nfsd_net_confirm_done);
+
+		nfsd_export_flush(net);
+		nfs4_state_shutdown_net(net);
+		nfsd_reply_cache_shutdown(nn);
+		nfsd_file_cache_shutdown_net(net);
+		if (nn->lockd_up) {
+			lockd_down(net);
+			nn->lockd_up = false;
+		}
+		wait_for_completion(&nn->nfsd_net_free_done);
 	}
 
-	wait_for_completion(&nn->nfsd_net_free_done);
 	percpu_ref_exit(&nn->nfsd_net_ref);
 
+	if (nn->nfsd_net_up)
+		nfsd_shutdown_generic();
 	nn->nfsd_net_up = false;
-	nfsd_shutdown_generic();
 }
 
 static DEFINE_SPINLOCK(nfsd_notifier_lock);


