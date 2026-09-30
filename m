Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D1D30D401;
	Wed, 30 Sep 2026 19:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796308; cv=none; b=h3R2loOGqIDcxP2JgDTf6UoVwG3togE8aARHWz2YJC9z0fS4ulAh6PpedgDUDl2xbVCivZI7irhv8p5E41fQZFmi+zovAaKJDKCRaaFaLToJBtJQKoguv/yXyC0di6xjJjEFrTftCkZQnYYmXud5NIJfHD5Alx0nXWZj1yZRdpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796308; c=relaxed/simple;
	bh=6re1x29g9J7aQpNVy89hqvch5yhjV1AGL80jTnXGU58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dL+YZ+vUQS546LgllTvz/9TSx2NXf6N9uzNvbr2uX7q2XKZG07bLRyrd2a5e74jRWmEQrwu45kEbaR9VFCFg+kqoEUndSuZADPYIH9lI0B8Ha7e2/GlLHCVhr/k3wLGQq77kPoq9DjBBup1euHSYkYiLeCzWA64hdNLBShEEAco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jtsQDuGx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jtsQDuGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C3B1F000FF;
	Wed, 30 Sep 2026 19:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796307;
	bh=riWhmajyCcSwSM4nna9H3exF9FUZ7mvtFJXDXwgcyR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jtsQDuGxO/+98yKN7Q+knKwVa5f9vt1VMD6RQwyhzFJOiMenH+mK1zUqhvHBS/Axv
	 M6JwFvgv/zCxPccslPxms44v5RruXfZWnJwVDCsB18ibEmVMOeOCtdLGmwvA8qQKSQ
	 Oy+FBBvuSBiRkvsL2PFL78hT1S2/4Nbi1pXuZUFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.6 0868/1193] xfrm: serialize state GC with device state flush
Date: Wed, 30 Sep 2026 17:25:52 +0200
Message-ID: <20260930152453.523493709@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
@@ -928,6 +931,7 @@ restart:
 out:
 	spin_unlock_bh(&net->xfrm.xfrm_state_lock);
 
+	mutex_lock(&xfrm_state_gc_mutex);
 	spin_lock_bh(&xfrm_state_dev_gc_lock);
 restart_gc:
 	hlist_for_each_entry_safe(x, tmp, &xfrm_state_dev_gc_list, dev_gclist) {
@@ -942,6 +946,7 @@ restart_gc:
 
 	}
 	spin_unlock_bh(&xfrm_state_dev_gc_lock);
+	mutex_unlock(&xfrm_state_gc_mutex);
 
 	xfrm_flush_gc();
 


