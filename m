Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50544E0B73;
	Thu, 17 Sep 2026 17:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665373; cv=none; b=eXtvVkqAU0twzXo256cbAuYkLnU0KnprPBmFVUpT4d36rk+DR7LESW02IVmxeyZNtM/PXn9y5Wqd1Ma10u0VtTJno2u/acplcPlDLUT9LtwwGyG7edXqetJg79K8MQtSeGJCe/LclvUhKJdLO/F5JGWGVnNI4Q1PWElc3NhleBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665373; c=relaxed/simple;
	bh=QNgKjfTX4qUeOcdIbeFpc0S2+SrKKEm9Cd//zs0NV/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTRRAmAGfnyId6QHIdLmKysXRaaTNf3ab3U3V/hG3oJ8zIw+0l6z45rvbfEmcGmeTMJCpA/Ez2BI6Ht6Gvds3GP/A0sUkdI5nW4cuQuLkbcpyjeYJACShD8pF1x5g6bghTZ/bn2jYTOb+TphBtUy8DhQQL3Mtz/DaMyxyE0Xy6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vOVmjkwS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vOVmjkwS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457BF1F000FF;
	Thu, 17 Sep 2026 17:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665371;
	bh=TADkjrzUDMXk3ZIY6zuItJxC9OuWwrM6m4/5jWE7Omg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vOVmjkwSBsWBNZ/clLOz9Y/+hlY56zHcff26xhrBH8LvjUslosnR+nwc2HM6qwg5o
	 Q354H18rD0IHlYl0lEEbzvOxMu0i5OHYzvXnk3/2dar0KlLJ0/8qiMv2WFYCiGSJZJ
	 twcnRUXmcBvmSOMi1V/cPHq13XoOy5fjRRo5u6L0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8e808eb853386f575d86@syzkaller.appspotmail.com,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0682/1250] ppp: ppp_async: simplify tty disc_data access
Date: Thu, 17 Sep 2026 16:07:57 +0100
Message-ID: <20260917151610.368997226@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Qingfang Deng <qingfang.deng@linux.dev>

[ Upstream commit 9feb069e5ed03582fbf6272539f1caa2a17dc6d5 ]

tty_ldisc_hangup() invokes the hangup callback while holding only a read
lock on tty->ldisc_sem, so it can run concurrently with other line
discipline callbacks. This currently forces async PPP to maintain
separate lifetime protection around tty->disc_data.

Line discipline close is called under the write lock during hangup
processing. Remove the hangup callback and rely on close for teardown,
as done for SLIP by commit 23c53269f2ba ("slip: remove slip_hangup() to
fix use-after-free in slip_receive_buf()"). This serializes teardown
with all other line discipline operations.

disc_data_lock, refcount and completion are redundant with that
serialization. Remove them and access tty->disc_data directly.

This also eliminates a lockdep warning reported by syzbot. The warning
does not indicate a real deadlock because the write side runs only in
process context with hardirqs disabled.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+8e808eb853386f575d86@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/0000000000002fbad30611e25849@google.com/
Signed-off-by: Qingfang Deng <qingfang.deng@linux.dev>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260828073245.126804-1-qingfang.deng@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/ppp_async.c | 82 ++++---------------------------------
 1 file changed, 7 insertions(+), 75 deletions(-)

diff --git a/drivers/net/ppp/ppp_async.c b/drivers/net/ppp/ppp_async.c
index ab602a0228d38..cde8bd78c70be 100644
--- a/drivers/net/ppp/ppp_async.c
+++ b/drivers/net/ppp/ppp_async.c
@@ -65,8 +65,6 @@ struct asyncppp {
 
 	struct tasklet_struct tsk;
 
-	refcount_t	refcnt;
-	struct completion dead;
 	struct ppp_channel chan;	/* interface to generic ppp layer */
 	unsigned char	obuf[OBUFSIZE];
 };
@@ -116,38 +114,6 @@ static const struct ppp_channel_ops async_ops = {
  * Routines implementing the PPP line discipline.
  */
 
-/*
- * We have a potential race on dereferencing tty->disc_data,
- * because the tty layer provides no locking at all - thus one
- * cpu could be running ppp_asynctty_receive while another
- * calls ppp_asynctty_close, which zeroes tty->disc_data and
- * frees the memory that ppp_asynctty_receive is using.  The best
- * way to fix this is to use a rwlock in the tty struct, but for now
- * we use a single global rwlock for all ttys in ppp line discipline.
- *
- * FIXME: this is no longer true. The _close path for the ldisc is
- * now guaranteed to be sane.
- */
-static DEFINE_RWLOCK(disc_data_lock);
-
-static struct asyncppp *ap_get(struct tty_struct *tty)
-{
-	struct asyncppp *ap;
-
-	read_lock(&disc_data_lock);
-	ap = tty->disc_data;
-	if (ap != NULL)
-		refcount_inc(&ap->refcnt);
-	read_unlock(&disc_data_lock);
-	return ap;
-}
-
-static void ap_put(struct asyncppp *ap)
-{
-	if (refcount_dec_and_test(&ap->refcnt))
-		complete(&ap->dead);
-}
-
 /*
  * Called when a tty is put into PPP line discipline. Called in process
  * context.
@@ -182,9 +148,6 @@ ppp_asynctty_open(struct tty_struct *tty)
 	skb_queue_head_init(&ap->rqueue);
 	tasklet_setup(&ap->tsk, ppp_async_process);
 
-	refcount_set(&ap->refcnt, 1);
-	init_completion(&ap->dead);
-
 	ap->chan.private = ap;
 	ap->chan.ops = &async_ops;
 	ap->chan.mtu = PPP_MRU;
@@ -205,34 +168,18 @@ ppp_asynctty_open(struct tty_struct *tty)
 }
 
 /*
- * Called when the tty is put into another line discipline
- * or it hangs up.  We have to wait for any cpu currently
- * executing in any of the other ppp_asynctty_* routines to
- * finish before we can call ppp_unregister_channel and free
- * the asyncppp struct.  This routine must be called from
- * process context, not interrupt or softirq context.
+ * Called when the tty is put into another line discipline or it hangs up.
+ * This call is serialized against other ldisc functions.
  */
 static void
 ppp_asynctty_close(struct tty_struct *tty)
 {
-	struct asyncppp *ap;
+	struct asyncppp *ap = tty->disc_data;
 
-	write_lock_irq(&disc_data_lock);
-	ap = tty->disc_data;
-	tty->disc_data = NULL;
-	write_unlock_irq(&disc_data_lock);
 	if (!ap)
 		return;
 
-	/*
-	 * We have now ensured that nobody can start using ap from now
-	 * on, but we have to wait for all existing users to finish.
-	 * Note that ppp_unregister_channel ensures that no calls to
-	 * our channel ops (i.e. ppp_async_send/ioctl) are in progress
-	 * by the time it returns.
-	 */
-	if (!refcount_dec_and_test(&ap->refcnt))
-		wait_for_completion(&ap->dead);
+	tty->disc_data = NULL;
 	tasklet_kill(&ap->tsk);
 
 	ppp_unregister_channel(&ap->chan);
@@ -242,17 +189,6 @@ ppp_asynctty_close(struct tty_struct *tty)
 	kfree(ap);
 }
 
-/*
- * Called on tty hangup in process context.
- *
- * Wait for I/O to driver to complete and unregister PPP channel.
- * This is already done by the close routine, so just call that.
- */
-static void ppp_asynctty_hangup(struct tty_struct *tty)
-{
-	ppp_asynctty_close(tty);
-}
-
 /*
  * Read does nothing - no data is ever available this way.
  * Pppd reads and writes packets via /dev/ppp instead.
@@ -283,7 +219,7 @@ ppp_asynctty_write(struct tty_struct *tty, struct file *file, const u8 *buf,
 static int
 ppp_asynctty_ioctl(struct tty_struct *tty, unsigned int cmd, unsigned long arg)
 {
-	struct asyncppp *ap = ap_get(tty);
+	struct asyncppp *ap = tty->disc_data;
 	int err, val;
 	int __user *p = (int __user *)arg;
 
@@ -324,7 +260,6 @@ ppp_asynctty_ioctl(struct tty_struct *tty, unsigned int cmd, unsigned long arg)
 		err = tty_mode_ioctl(tty, cmd, arg);
 	}
 
-	ap_put(ap);
 	return err;
 }
 
@@ -333,7 +268,7 @@ static void
 ppp_asynctty_receive(struct tty_struct *tty, const u8 *buf, const u8 *cflags,
 		     size_t count)
 {
-	struct asyncppp *ap = ap_get(tty);
+	struct asyncppp *ap = tty->disc_data;
 	unsigned long flags;
 
 	if (!ap)
@@ -343,21 +278,19 @@ ppp_asynctty_receive(struct tty_struct *tty, const u8 *buf, const u8 *cflags,
 	spin_unlock_irqrestore(&ap->recv_lock, flags);
 	if (!skb_queue_empty(&ap->rqueue))
 		tasklet_schedule(&ap->tsk);
-	ap_put(ap);
 	tty_unthrottle(tty);
 }
 
 static void
 ppp_asynctty_wakeup(struct tty_struct *tty)
 {
-	struct asyncppp *ap = ap_get(tty);
+	struct asyncppp *ap = tty->disc_data;
 
 	clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
 	if (!ap)
 		return;
 	set_bit(XMIT_WAKEUP, &ap->xmit_flags);
 	tasklet_schedule(&ap->tsk);
-	ap_put(ap);
 }
 
 
@@ -367,7 +300,6 @@ static struct tty_ldisc_ops ppp_ldisc = {
 	.name	= "ppp",
 	.open	= ppp_asynctty_open,
 	.close	= ppp_asynctty_close,
-	.hangup	= ppp_asynctty_hangup,
 	.read	= ppp_asynctty_read,
 	.write	= ppp_asynctty_write,
 	.ioctl	= ppp_asynctty_ioctl,
-- 
2.53.0



