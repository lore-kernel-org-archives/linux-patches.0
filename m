Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D6DC128;
	Tue, 13 Feb 2024 17:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707846058; cv=none; b=E5H3UJEPvUtYN6H3DaZLfVvak89VRQnnHldwTEm7R5CfxalxRd1kxr1VnS7eKmXJpzqHV9j1MwnqJNx8rPXIpvSVqxLGu1ckm+qJCzIdbkDCQl5z8UD1t9o6gRHna4tzdbydzNkYfzITv5frrKQtX/l2kFwEZ1OOlO3BMlMrJZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707846058; c=relaxed/simple;
	bh=rtuZW5s2040YF9nbAki/Nd38+67IwkpGcG5LOBecIXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MA3gtvZamHDK88JhWhTC17SyJiCgzwrwleiDfU21P6JhlYS/LP6xoX4EaLGYZ0ZjzdrdBwQ18YZh0anKtm5QmG8sDxuA/tjeieOHDwPmeg1g6CyYpMY2F85veI/BmHb1PZQSMLq+LDqtJtEufmH7o2flU2I5A8UyTXN6icMONOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mW6SI1GX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mW6SI1GX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F2AC43390;
	Tue, 13 Feb 2024 17:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707846058;
	bh=rtuZW5s2040YF9nbAki/Nd38+67IwkpGcG5LOBecIXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mW6SI1GXfi/NVHdgd7H4x9BCDTU9SRNd4wDqpvAtbB/gHSOvCJJEJ2hL3VBaJFVK6
	 L3CsKFH7vgcv5rlXJsMzHpqx2D5tZIBUyNF6SIlD64RGtvF3Zh+E7O/F9RYei/VCVf
	 dvjK+FA64mW/CZ6dckuqOrxyDY1R+qnRYw7k6YUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6.7 115/124] bcachefs: bch2_kthread_io_clock_wait() no longer sleeps until full amount
Date: Tue, 13 Feb 2024 18:22:17 +0100
Message-ID: <20240213171857.089323870@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kent.overstreet@linux.dev>

commit d92b83f592d810aded2e5f90db5f560cc8cf577b upstream.

Drop t he loop in bch2_kthread_io_clock_wait(): this allows the code
that uses it to be woken up for other reasons, and fixes a bug where
rebalance wouldn't wake up when a scan was requested.

This raises the possibility of spurious wakeups, but callers should
always be able to handle that reasonably well.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/bcachefs/clock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/bcachefs/clock.c
+++ b/fs/bcachefs/clock.c
@@ -109,7 +109,7 @@ void bch2_kthread_io_clock_wait(struct i
 	if (cpu_timeout != MAX_SCHEDULE_TIMEOUT)
 		mod_timer(&wait.cpu_timer, cpu_timeout + jiffies);
 
-	while (1) {
+	do {
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (kthread && kthread_should_stop())
 			break;
@@ -119,7 +119,7 @@ void bch2_kthread_io_clock_wait(struct i
 
 		schedule();
 		try_to_freeze();
-	}
+	} while (0);
 
 	__set_current_state(TASK_RUNNING);
 	del_timer_sync(&wait.cpu_timer);


