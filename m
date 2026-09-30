Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD1950B8DA;
	Wed, 30 Sep 2026 16:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785131; cv=none; b=H0j3Mvdu9Mt8rK31xfKc0Jx02UhdG8ZEfCx+2zcFaYMcxHZ49p8QdKG9VhHl2FSr1MUVC3Ub0NB/Zf78MpOL5bTfRXeT8WJ+2KYWVJf7dJKJZzHT9SLO3eU0h2HcCSWC6g3Q6BiPcuy+Ef2w+21pupE72LrZScrG/XA+Pfm3wTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785131; c=relaxed/simple;
	bh=9YEs5WSv3R6XuLpwgid81NkJFPY+rEcXoqYqWOT8+pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c3ReFrDkY5JOTFZdReHJ7hguL3a7R7v8ggkze7Rk0R9S50dz8tcR+tUQqRIKQmpNRfgXufQ5TG/0kJqc5lUdY7p9yUWTpMlrVKvrHkFtP3bGtaYWZH4OkkDJRFqhkuK7o/cmJ6igTGCLlTF/yPC744kGJGFa+INxfjt0plnUH1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kQgTwVIy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kQgTwVIy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0711F00899;
	Wed, 30 Sep 2026 16:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785127;
	bh=NmpOVyq++HUZSRLipcaNtOA4L+e6X8neMJBKtwyBJj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kQgTwVIyjt0NbXcP5mYgo9//SIzWCoaOD3H7f72ICsO3LFCQjm11Jc2EpDCJckBTR
	 1u3DslTkgUy1jBW48l0YTHvy9MMM1aZ3kwXj5Ka6fihRpV9aTI628QaK1K+JV5+RWw
	 YAnK3jjnzPsiaNW+RrcXJymkmofkwhk8Qq93nZfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8e808eb853386f575d86@syzkaller.appspotmail.com,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 354/982] ppp: ppp_async: simplify tty disc_data access
Date: Wed, 30 Sep 2026 17:18:10 +0200
Message-ID: <20260930152424.418127047@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index aba0744c0ab58..3f3c662550372 100644
--- a/drivers/net/ppp/ppp_async.c
+++ b/drivers/net/ppp/ppp_async.c
@@ -65,8 +65,6 @@ struct asyncppp {
 
 	struct tasklet_struct tsk;
 
-	refcount_t	refcnt;
-	struct completion dead;
 	struct ppp_channel chan;	/* interface to generic ppp layer */
 	unsigned char	obuf[OBUFSIZE];
 };
@@ -115,38 +113,6 @@ static const struct ppp_channel_ops async_ops = {
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
@@ -181,9 +147,6 @@ ppp_asynctty_open(struct tty_struct *tty)
 	skb_queue_head_init(&ap->rqueue);
 	tasklet_setup(&ap->tsk, ppp_async_process);
 
-	refcount_set(&ap->refcnt, 1);
-	init_completion(&ap->dead);
-
 	ap->chan.private = ap;
 	ap->chan.ops = &async_ops;
 	ap->chan.mtu = PPP_MRU;
@@ -204,34 +167,18 @@ ppp_asynctty_open(struct tty_struct *tty)
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
@@ -241,17 +188,6 @@ ppp_asynctty_close(struct tty_struct *tty)
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
@@ -283,7 +219,7 @@ ppp_asynctty_write(struct tty_struct *tty, struct file *file,
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
 
@@ -340,7 +275,7 @@ static void
 ppp_asynctty_receive(struct tty_struct *tty, const unsigned char *buf,
 		  const char *cflags, int count)
 {
-	struct asyncppp *ap = ap_get(tty);
+	struct asyncppp *ap = tty->disc_data;
 	unsigned long flags;
 
 	if (!ap)
@@ -350,21 +285,19 @@ ppp_asynctty_receive(struct tty_struct *tty, const unsigned char *buf,
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
 
 
@@ -374,7 +307,6 @@ static struct tty_ldisc_ops ppp_ldisc = {
 	.name	= "ppp",
 	.open	= ppp_asynctty_open,
 	.close	= ppp_asynctty_close,
-	.hangup	= ppp_asynctty_hangup,
 	.read	= ppp_asynctty_read,
 	.write	= ppp_asynctty_write,
 	.ioctl	= ppp_asynctty_ioctl,
-- 
2.53.0



