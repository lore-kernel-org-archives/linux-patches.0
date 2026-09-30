Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3270B3A784F;
	Wed, 30 Sep 2026 17:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788661; cv=none; b=AgdCdBJefZZKkFG9LBvdy4HMb4HrFIBig3LB2SAUkctf1cs9eyvgDnhI+DSsy2w/zdVD5zAPK8eGyfw9UlrtCJVv/EpaMbuvu+U2qvCAGbqG+XA0XJ+5iJe62poylDcvYh3Xj25l3TB3X8YONNbG0C/cWYzrHpzPtVZ2H/vuAPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788661; c=relaxed/simple;
	bh=+WxXLthTPIRYAiSvc+Jira1cNKDqFXnBGa7ceOvb3gM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAubjvgXSWgnD5/q7E/2s4ROld9OtpVyh31KvThl5j/pTo6sglS4CGhUMhDTxYL1nT6HYlzMSB3yiODT1VLL2DWY8e6JEo/7/7jupPqOVO63mfOyqGz8ys9z21w00IOHL7mGttdeHSHCDI87xhHzGLKZclO+OxxCUVAzupJL46Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2O0VcWvQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2O0VcWvQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839681F00898;
	Wed, 30 Sep 2026 17:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788660;
	bh=cexiRFvxgboM1huHqqPtCJXqqoG9FK4ay1WvRRr6FIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2O0VcWvQNMCKaOMwo2T6cCbXHD++t0VuFtmjH3LgM09c51ErlAYfTGuupJZSBl2Hl
	 NyDB+SYW8SHYK8JRGZZz6QThtD7g6tvmba1V9gVweAVbfkJJpFEiW2Rqy+SVMjMpiK
	 d+HeIRYPqZp1KtHUPSMi7L3JFf5hhNkvhCjdJFrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.12 201/877] xfrm: serialize state GC with device state flush
Date: Wed, 30 Sep 2026 17:18:32 +0200
Message-ID: <20260930152419.062147720@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Chengfeng Ye <nicoyip.dev@gmail.com>

commit 89fefad9f971bc637fb22373078144f2563c4be9 upstream.

The deferred-device pass in xfrm_dev_state_flush() finds states under
xfrm_state_dev_gc_lock, but drops the lock before calling
xfrm_dev_state_free() because the driver callback may sleep.  The device
GC list does not hold an xfrm_state reference, so the state GC worker can
destroy the same state concurrently.

The race can proceed as follows:

  CPU 0                               CPU 1
  find x on the device GC list
  drop xfrm_state_dev_gc_lock
  read x->xso.dev
                                      xfrm_state_gc_destroy(x)
                                      xfrm_dev_state_free(x)
                                      xfrm_state_free(x)
  continue xfrm_dev_state_free(x)

Both paths can invoke the driver callback and drop the device reference.
CPU 0 can also access the xfrm_state after CPU 1 has freed it.

KASAN reported:

  BUG: KASAN: slab-use-after-free in xfrm_dev_state_free+0x24c/0x2a0
  Read of size 8 at addr ffff88810bbaa960 by task poc/102

  Call Trace:
   xfrm_dev_state_free+0x24c/0x2a0
   xfrm_dev_state_flush+0x353/0x400
   xfrm_dev_event+0x26d/0x3a0
   notifier_call_chain+0xc0/0x280
   __dev_notify_flags+0x169/0x250
   netif_change_flags+0xe7/0x160
   dev_change_flags+0x96/0x220
   devinet_ioctl+0x7f4/0x1880

  Allocated by task 87:
   xfrm_state_alloc+0x1e/0x5c0
   xfrm_add_sa+0xe7f/0x5820
   xfrm_user_rcv_msg+0x4f3/0x940

  Freed by task 57:
   kmem_cache_free+0xcb/0x3d0
   xfrm_state_gc_task+0x4a8/0x650
   process_one_work+0x63a/0x1070

Serialize xfrm_state destruction against the deferred-device pass with a
mutex.  Keep xfrm_state_dev_gc_lock limited to list operations and retain
the existing callback and device-reference release ordering.

Fixes: 07b87f9eea0c ("xfrm: Fix unregister netdevice hang on hardware offload.")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_state.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -226,6 +226,7 @@ static struct xfrm_state_afinfo __rcu *x
 
 static DEFINE_SPINLOCK(xfrm_state_gc_lock);
 static DEFINE_SPINLOCK(xfrm_state_dev_gc_lock);
+static DEFINE_MUTEX(xfrm_state_gc_mutex);
 
 int __xfrm_state_delete(struct xfrm_state *x);
 
@@ -570,8 +571,10 @@ static void xfrm_state_gc_task(struct wo
 
 	synchronize_rcu();
 
+	mutex_lock(&xfrm_state_gc_mutex);
 	hlist_for_each_entry_safe(x, tmp, &gc_list, gclist)
 		xfrm_state_gc_destroy(x);
+	mutex_unlock(&xfrm_state_gc_mutex);
 }
 
 static enum hrtimer_restart xfrm_timer_handler(struct hrtimer *me)
@@ -937,6 +940,7 @@ restart:
 out:
 	spin_unlock_bh(&net->xfrm.xfrm_state_lock);
 
+	mutex_lock(&xfrm_state_gc_mutex);
 	spin_lock_bh(&xfrm_state_dev_gc_lock);
 restart_gc:
 	hlist_for_each_entry_safe(x, tmp, &xfrm_state_dev_gc_list, dev_gclist) {
@@ -951,6 +955,7 @@ restart_gc:
 
 	}
 	spin_unlock_bh(&xfrm_state_dev_gc_lock);
+	mutex_unlock(&xfrm_state_gc_mutex);
 
 	xfrm_flush_gc();
 


