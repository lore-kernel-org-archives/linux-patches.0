Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEDE34FF40;
	Tue,  6 Jan 2026 17:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721468; cv=none; b=QE4R2aZTPM/yeiVSX11CNWZLxjeTLMwy8MeP+oIS3InGllAKcx/c5yMiB0+JPMgM7QeUa2j02bHrzFSwnwSAKTbuGwwpxYT4kx1oG0/V5qbUJAiuWL9wV0vs+G5j8kKw29+djZeegP2jvS5v6TfqRDCt6MNV41RnfAd7eDXTFes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721468; c=relaxed/simple;
	bh=Ir7i5+7IqPZ/Hi7aHzxI+YZOffxC5+nKC3Yse+bnG5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/ebNTS+7AWp7RPJQmsfOSFScuIaxJ4MnRWxRgjCEC+9jOvlhTnxJo9ZrNR/ApogkAKfMMmmWk8W9maFwNMNk3VJ+K8FDIKZBtYmjB+Aj5agpeQzqrAUM7RN8ZcetDNOR0L6bp9U2GyiUZg7S7WCaOLaNQS8pIplmjpfnfC56Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wRBNpBdZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wRBNpBdZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0F8C19423;
	Tue,  6 Jan 2026 17:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721467;
	bh=Ir7i5+7IqPZ/Hi7aHzxI+YZOffxC5+nKC3Yse+bnG5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wRBNpBdZCipA2JNte/0e4e8/5c9dwaKhw9+F67kKMbQc5qKUfLJN0jzkmgEMY/xRW
	 3UMipSNi9HgrewdAIoC5qgMG+tkOo+V4RF/mi0MkD3F+5KSCjrBGDEeZY4TDk/aPoY
	 QGrl4ziPYILqDnkQPT8eff2ljfJhvp39bC3QHWSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.12 545/567] hrtimers: Make hrtimer_update_function() less expensive
Date: Tue,  6 Jan 2026 18:05:27 +0100
Message-ID: <20260106170511.570743684@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

commit 2ea97b76d6712bfb0408e5b81ffd7bc4551d3153 upstream.

The sanity checks in hrtimer_update_function() are expensive for high
frequency usage like in the io/uring code due to locking.

Hide the sanity checks behind CONFIG_PROVE_LOCKING, which has a decent
chance to be enabled on a regular basis for testing.

Fixes: 8f02e3563bb5 ("hrtimers: Introduce hrtimer_update_function()")
Reported-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/87ikpllali.ffs@tglx
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hrtimer.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -348,6 +348,7 @@ static inline int hrtimer_callback_runni
 static inline void hrtimer_update_function(struct hrtimer *timer,
 					   enum hrtimer_restart (*function)(struct hrtimer *))
 {
+#ifdef CONFIG_PROVE_LOCKING
 	guard(raw_spinlock_irqsave)(&timer->base->cpu_base->lock);
 
 	if (WARN_ON_ONCE(hrtimer_is_queued(timer)))
@@ -355,7 +356,7 @@ static inline void hrtimer_update_functi
 
 	if (WARN_ON_ONCE(!function))
 		return;
-
+#endif
 	timer->function = function;
 }
 


