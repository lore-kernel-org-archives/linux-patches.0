Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9604225788;
	Mon, 13 Apr 2026 16:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096552; cv=none; b=Vlc36nZrp221sAA9eRpTY0tTJ5BGNuplSTz0h+YCN8cyAZlWQ9wBVjnFGA/Fdz1rK1eg3MJf+x9qWv4kNH6F71rfL6uT97eXA92YoSVpA1nqceyUSJCu6Nj892inf5oy88Oc7wV28hIpPQwBFKBHGx30o35VpbnxOvJGBr1qQmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096552; c=relaxed/simple;
	bh=KbIURFkiDfyrD6JCIGNTzqCt6N5ShVcUJANT6D5jvgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJ+on4twrlsbtERI9hm2onpjz58D9uyaoO1KECS8fN0s1Fr/og0urOBSF7X1c5X3BiyHIrLOHsGpSlTD2pv9KtZP6SjjTpf+ZDZO4NOVZfhcRp1ab8fIW5HCco4K9v3xI0kiIrPb6p/R+C8WLnCunqjCuPX2DKup4/D91d+xg/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d1n17Ord; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d1n17Ord"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E79C2BCB0;
	Mon, 13 Apr 2026 16:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096552;
	bh=KbIURFkiDfyrD6JCIGNTzqCt6N5ShVcUJANT6D5jvgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d1n17OrdibHB7aKTj9heLuvxn459CzJtrL/7VTfQssRfPkx0KzHfNCl7fCz3Po9MO
	 hWVCYVJcDFb96TVgSsEAtMNobuWNNJbtwqUMof9LhxxJS5w+/A5rj054sEP8lPhbIo
	 nDmf3hTDS/wyaEi6GHc+qH7Ff0wokyt0CN4cUAn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Ray Zhang <sgzhang@google.com>,
	Emil Tantilov <emil.s.tantilov@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.18 56/83] idpf: fix PREEMPT_RT raw/bh spinlock nesting for async VC handling
Date: Mon, 13 Apr 2026 18:00:24 +0200
Message-ID: <20260413155733.106702960@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
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

From: Emil Tantilov <emil.s.tantilov@intel.com>

commit 591478118293c1bd628de330a99eb1eb2ef8d76b upstream.

Switch from using the completion's raw spinlock to a local lock in the
idpf_vc_xn struct. The conversion is safe because complete/_all() are
called outside the lock and there is no reason to share the completion
lock in the current logic. This avoids invalid wait context reported by
the kernel due to the async handler taking BH spinlock:

[  805.726977] =============================
[  805.726991] [ BUG: Invalid wait context ]
[  805.727006] 7.0.0-rc2-net-devq-031026+ #28 Tainted: G S         OE
[  805.727026] -----------------------------
[  805.727038] kworker/u261:0/572 is trying to lock:
[  805.727051] ff190da6a8dbb6a0 (&vport_config->mac_filter_list_lock){+...}-{3:3}, at: idpf_mac_filter_async_handler+0xe9/0x260 [idpf]
[  805.727099] other info that might help us debug this:
[  805.727111] context-{5:5}
[  805.727119] 3 locks held by kworker/u261:0/572:
[  805.727132]  #0: ff190da6db3e6148 ((wq_completion)idpf-0000:83:00.0-mbx){+.+.}-{0:0}, at: process_one_work+0x4b5/0x730
[  805.727163]  #1: ff3c6f0a6131fe50 ((work_completion)(&(&adapter->mbx_task)->work)){+.+.}-{0:0}, at: process_one_work+0x1e5/0x730
[  805.727191]  #2: ff190da765190020 (&x->wait#34){+.+.}-{2:2}, at: idpf_recv_mb_msg+0xc8/0x710 [idpf]
[  805.727218] stack backtrace:
...
[  805.727238] Workqueue: idpf-0000:83:00.0-mbx idpf_mbx_task [idpf]
[  805.727247] Call Trace:
[  805.727249]  <TASK>
[  805.727251]  dump_stack_lvl+0x77/0xb0
[  805.727259]  __lock_acquire+0xb3b/0x2290
[  805.727268]  ? __irq_work_queue_local+0x59/0x130
[  805.727275]  lock_acquire+0xc6/0x2f0
[  805.727277]  ? idpf_mac_filter_async_handler+0xe9/0x260 [idpf]
[  805.727284]  ? _printk+0x5b/0x80
[  805.727290]  _raw_spin_lock_bh+0x38/0x50
[  805.727298]  ? idpf_mac_filter_async_handler+0xe9/0x260 [idpf]
[  805.727303]  idpf_mac_filter_async_handler+0xe9/0x260 [idpf]
[  805.727310]  idpf_recv_mb_msg+0x1c8/0x710 [idpf]
[  805.727317]  process_one_work+0x226/0x730
[  805.727322]  worker_thread+0x19e/0x340
[  805.727325]  ? __pfx_worker_thread+0x10/0x10
[  805.727328]  kthread+0xf4/0x130
[  805.727333]  ? __pfx_kthread+0x10/0x10
[  805.727336]  ret_from_fork+0x32c/0x410
[  805.727345]  ? __pfx_kthread+0x10/0x10
[  805.727347]  ret_from_fork_asm+0x1a/0x30
[  805.727354]  </TASK>

Fixes: 34c21fa894a1 ("idpf: implement virtchnl transaction manager")
Cc: stable@vger.kernel.org
Suggested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reported-by: Ray Zhang <sgzhang@google.com>
Signed-off-by: Emil Tantilov <emil.s.tantilov@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c |   14 +++++---------
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.h |    5 +++--
 2 files changed, 8 insertions(+), 11 deletions(-)

--- a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
@@ -284,26 +284,21 @@ dma_mem_error:
 	return err;
 }
 
-/* API for virtchnl "transaction" support ("xn" for short).
- *
- * We are reusing the completion lock to serialize the accesses to the
- * transaction state for simplicity, but it could be its own separate synchro
- * as well. For now, this API is only used from within a workqueue context;
- * raw_spin_lock() is enough.
- */
+/* API for virtchnl "transaction" support ("xn" for short). */
+
 /**
  * idpf_vc_xn_lock - Request exclusive access to vc transaction
  * @xn: struct idpf_vc_xn* to access
  */
 #define idpf_vc_xn_lock(xn)			\
-	raw_spin_lock(&(xn)->completed.wait.lock)
+	spin_lock(&(xn)->lock)
 
 /**
  * idpf_vc_xn_unlock - Release exclusive access to vc transaction
  * @xn: struct idpf_vc_xn* to access
  */
 #define idpf_vc_xn_unlock(xn)		\
-	raw_spin_unlock(&(xn)->completed.wait.lock)
+	spin_unlock(&(xn)->lock)
 
 /**
  * idpf_vc_xn_release_bufs - Release reference to reply buffer(s) and
@@ -335,6 +330,7 @@ static void idpf_vc_xn_init(struct idpf_
 		xn->state = IDPF_VC_XN_IDLE;
 		xn->idx = i;
 		idpf_vc_xn_release_bufs(xn);
+		spin_lock_init(&xn->lock);
 		init_completion(&xn->completed);
 	}
 
--- a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.h
+++ b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.h
@@ -42,8 +42,8 @@ typedef int (*async_vc_cb) (struct idpf_
  * struct idpf_vc_xn - Data structure representing virtchnl transactions
  * @completed: virtchnl event loop uses that to signal when a reply is
  *	       available, uses kernel completion API
- * @state: virtchnl event loop stores the data below, protected by the
- *	   completion's lock.
+ * @lock: protects the transaction state fields below
+ * @state: virtchnl event loop stores the data below, protected by @lock
  * @reply_sz: Original size of reply, may be > reply_buf.iov_len; it will be
  *	      truncated on its way to the receiver thread according to
  *	      reply_buf.iov_len.
@@ -58,6 +58,7 @@ typedef int (*async_vc_cb) (struct idpf_
  */
 struct idpf_vc_xn {
 	struct completion completed;
+	spinlock_t lock;
 	enum idpf_vc_xn_state state;
 	size_t reply_sz;
 	struct kvec reply;


