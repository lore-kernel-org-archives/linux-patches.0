Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCFA46F48E;
	Tue, 21 Jul 2026 18:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659703; cv=none; b=Q/cvmowr0y05L/uMa9a6vWE8ZuiioFtCGOKrCScR5sl9Ga9UXib4LOxUNvi+Eo9WaYODR2HsiP+4MqlXbDnPDkumi+isXTYgKO5/qNDhNyEUhQ0Ay1oXjxIKMfR5iLkgrIGSz33fFO2nPHsEgcGKEt5ad2AC2qU82WDTcNGEBTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659703; c=relaxed/simple;
	bh=27rma2oVrr3biyyTpYb9F7EtmY34vUugFLfh9ut9JhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VRR5iCkRT4IDpTd5UQTiJA7KLqJLIAV2bB4SUPnubK/1J9vRv2pkSMJ4u7bs7S1/y6hm4/09OqakSTg7RSu7tmH64/q434ugOkOpAbv7qTz9FL7gEmDcYdfe27YJ//aTxt7aeHJc7bJD/ho2uQkralPv+uIuGY8jkZjFRXiMI0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x1+awWZ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x1+awWZ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49CD1F000E9;
	Tue, 21 Jul 2026 18:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659693;
	bh=tqCL9wqZl3+LGmGRJR4B/MnysWe5Mf6zR8hTPdsCewc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x1+awWZ7fk2sEjSpl2UzdJaYIhjk0EwxBLXfddO9Z72NSi8fwlX4yAh1/zyv2uykU
	 9BNhWzPfhpMv7piGo4EcugSTJ7TSaDQsPAhBxlIivNl93+ViQSiVz9zMfd1bBxtV44
	 ZRoyp2wODUlGoyiCqIJtdxC+uDDJajE0evDm4uJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Wu <wusamuel@google.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1582/1611] functionfs: use spinlock for FFS_DEACTIVATED/FFS_CLOSING transitions
Date: Tue, 21 Jul 2026 17:28:18 +0200
Message-ID: <20260721152551.055232135@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 2005aabe94eaab8608879d98afb901bc99bc3a31 ]

When all files are closed, functionfs needs ffs_data_reset() to be
done before any further opens are allowed.

During that time we have ffs->state set to FFS_CLOSING; that makes
->open() fail with -EBUSY.  Once ffs_data_reset() is done, it
switches state (to FFS_READ_DESCRIPTORS) indicating that opening
that thing is allowed again.  There's a couple of additional twists:
	* mounting with -o no_disconnect delays ffs_data_reset()
from doing that at the final ->release() to the first subsequent
open().  That's indicated by ffs->state set to FFS_DEACTIVATED;
if open() sees that, it immediately switches to FFS_CLOSING and
proceeds with doing ffs_data_reset() before returning to userland.
	* a couple of usb callbacks need to force the delayed
transition; unfortunately, they are done in locking environment
that does not allow blocking and ffs_data_reset() can block.
As the result, if these callbacks see FFS_DEACTIVATED, they change
state to FFS_CLOSING and use schedule_work() to get ffs_data_reset()
executed asynchronously.

Unfortunately, the locking is rather insufficient.  A fix attempted
in e5bf5ee26663 ("functionfs: fix the open/removal races") had closed
a bunch of UAF, but it didn't do anything to the callbacks, lacked
barriers in transition from FFS_CLOSING to FFS_READ_DESCRIPTORS
_and_ it had been too heavy-handed in open()/open() serialization -
I've used ffs->mutex for that, and it's being held over actual IO on
ep0, complete with copy_from_user(), etc.

Even more unfortunately, the userland side is apparently racy enough
to have the resulting timing changes (no failures, just a delayed
return of open(2)) disrupt the things quite badly.  Userland bugs
or not, it's a clear regression that needs to be dealt with.

Solution is to use a spinlock for serializing these state checks and
transitions - unlike ffs->mutex it can be taken in these callbacks
and it doesn't disrupt the timings in open().

We could introduce a new spinlock, but it's easier to use the one
that is already there (ffs->eps_lock) instead - the locking
environment is safe for it in all affected places.

Since now it is held over all places that alter or check the
open count (ffs->opened), there's no need to keep that atomic_t -
int would serve just fine and it's simpler that way.

Fixes: e5bf5ee26663 ("functionfs: fix the open/removal races")
Fixes: 18d6b32fca38 ("usb: gadget: f_fs: add "no_disconnect" mode") # v4.0
Tested-by: Samuel Wu <wusamuel@google.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: 3137b243c939 ("usb: gadget: f_fs: initialize reset_work at allocation time")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -3736,6 +3736,7 @@ static int ffs_func_set_alt(struct usb_f
 {
 	struct ffs_function *func = ffs_func_from_usb(f);
 	struct ffs_data *ffs = func->ffs;
+	unsigned long flags;
 	int ret = 0, intf;
 
 	if (alt > MAX_ALT_SETTINGS)
@@ -3748,12 +3749,15 @@ static int ffs_func_set_alt(struct usb_f
 	if (ffs->func)
 		ffs_func_eps_disable(ffs->func);
 
+	spin_lock_irqsave(&ffs->eps_lock, flags);
 	if (ffs->state == FFS_DEACTIVATED) {
 		ffs->state = FFS_CLOSING;
+		spin_unlock_irqrestore(&ffs->eps_lock, flags);
 		INIT_WORK(&ffs->reset_work, ffs_reset_work);
 		schedule_work(&ffs->reset_work);
 		return -ENODEV;
 	}
+	spin_unlock_irqrestore(&ffs->eps_lock, flags);
 
 	if (ffs->state != FFS_ACTIVE)
 		return -ENODEV;
@@ -3771,16 +3775,20 @@ static void ffs_func_disable(struct usb_
 {
 	struct ffs_function *func = ffs_func_from_usb(f);
 	struct ffs_data *ffs = func->ffs;
+	unsigned long flags;
 
 	if (ffs->func)
 		ffs_func_eps_disable(ffs->func);
 
+	spin_lock_irqsave(&ffs->eps_lock, flags);
 	if (ffs->state == FFS_DEACTIVATED) {
 		ffs->state = FFS_CLOSING;
+		spin_unlock_irqrestore(&ffs->eps_lock, flags);
 		INIT_WORK(&ffs->reset_work, ffs_reset_work);
 		schedule_work(&ffs->reset_work);
 		return;
 	}
+	spin_unlock_irqrestore(&ffs->eps_lock, flags);
 
 	if (ffs->state == FFS_ACTIVE) {
 		ffs->func = NULL;


