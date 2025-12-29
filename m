Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475F83314C5;
	Mon, 29 Dec 2025 16:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025567; cv=none; b=MR62LufCYvQWkSB/iZZzDaIP4bQk7F22jue23PEHm92kLYLvmToXBW4C7uxBX2gewZhxKpci+Rtz3EcVpuVrjWWBwAeHG60W85+L84N3zNvomIVFuZKk4EYxIAKWJxk99WRm+8X2wlCXeesfGK9rvVkIYmLfV5lfP5RyBdQXOoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025567; c=relaxed/simple;
	bh=prxHzD6TedeN+GyKMEzx2HWrOgOe2tahJ43vBf74Dok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WbIH2sxvRNgwZb8PyFBfV4PD/kiK5GRmorbGhK5SNpRL63JdYw0jm3GEBgq/8SGwF7VJneIl2ZTwLwBVfq0C6mAhqnoccxu5YJsLrxnmIwld3S0NWnKFZhPZPbt5YDbDhHeg/GdPs7fnbhqYtZWjfK/Ohblaoc3UDCMsfouPJFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S21hHu5m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S21hHu5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A48C4CEF7;
	Mon, 29 Dec 2025 16:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025565;
	bh=prxHzD6TedeN+GyKMEzx2HWrOgOe2tahJ43vBf74Dok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S21hHu5mr+WXHs5eCDudV9j5IN3/d/NQg7Zf+6zooLy+xoeBbSWdQdf7KfTkppUUq
	 Mf/mci1H3NODdrAz9Uv+X2tWeIcSG7k264LqDx1szR/JAX51CUDo9fAxAurnkX4YXm
	 8zdS9HJSJU+A/OGUU8fJOFSzOwxrkl4UykGUM008=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 6.18 258/430] printk: Avoid irq_work for printk_deferred() on suspend
Date: Mon, 29 Dec 2025 17:11:00 +0100
Message-ID: <20251229160733.850770512@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: John Ogness <john.ogness@linutronix.de>

commit 66e7c1e0ee08cfb6db64f8f3f6e5a3cc930145c8 upstream.

With commit ("printk: Avoid scheduling irq_work on suspend") the
implementation of printk_get_console_flush_type() was modified to
avoid offloading when irq_work should be blocked during suspend.
Since printk uses the returned flush type to determine what
flushing methods are used, this was thought to be sufficient for
avoiding irq_work usage during the suspend phase.

However, vprintk_emit() implements a hack to support
printk_deferred(). In this hack, the returned flush type is
adjusted to make sure no legacy direct printing occurs when
printk_deferred() was used.

Because of this hack, the legacy offloading flushing method can
still be used, causing irq_work to be queued when it should not
be.

Adjust the vprintk_emit() hack to also consider
@console_irqwork_blocked so that legacy offloading will not be
chosen when irq_work should be blocked.

Link: https://lore.kernel.org/lkml/87fra90xv4.fsf@jogness.linutronix.de
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Fixes: 26873e3e7f0c ("printk: Avoid scheduling irq_work on suspend")
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/printk/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2393,7 +2393,7 @@ asmlinkage int vprintk_emit(int facility
 	/* If called from the scheduler, we can not call up(). */
 	if (level == LOGLEVEL_SCHED) {
 		level = LOGLEVEL_DEFAULT;
-		ft.legacy_offload |= ft.legacy_direct;
+		ft.legacy_offload |= ft.legacy_direct && !console_irqwork_blocked;
 		ft.legacy_direct = false;
 	}
 


