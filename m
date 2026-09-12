Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4420F367B65;
	Sat, 12 Sep 2026 19:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242075; cv=none; b=GzwF4AnPZ7rEsW9R+JQhypvVbHjvUtcGDQG9FIzFQYQlIecIrVYhY/H8RXomc3wjEKzjJjARLe7a3Tc2cOJs+4dHH3nWEyR12TPqVQkzgRW08pGyhYQjoy05wWfxScVZU8SVx0U5VwOf8RxdNs/a0g675svvnbhKeKOLz5IfKUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242075; c=relaxed/simple;
	bh=LsFlwpRwx8l7Aj6LVoQJGX5CwJ4MDXv4GaXpHpHOBVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a4i1KxK9y+ZpcAHGceWBYpeFhpBU7OM+hZEXQ+R9f7Y9uIGZEZKnljWg60dTiXvtcoGKe8kYg3TaIgMy8OmkxfQrYLYEevDHHX5nmy2omiZo+mbNkvJJ42eVAiPbc67OKrR41vFunDjVGdb6I3vrHyQkfOUt+oT2ZW1S86qWDgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XLK/6/mZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XLK/6/mZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656781F000FF;
	Sat, 12 Sep 2026 19:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242072;
	bh=ZvjAM38nIixku4zxwRoeSB2nNbNL8mvrq4FYbVOZJ/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XLK/6/mZOUDM3eK+xs6mc7Spwo+PY/yelAhDKjJZ2qyKU0eRGOgSGeiTItg6Aw5E5
	 YPGDb0S5RGpapr3M0D9OHJTPU8faqGakxhq24gnuXBf2nlZETdef3sW95sF2Y7bvQa
	 t1ZwA15PCf5/zf579cvdZqula+6G/W58Th00M9s4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 275/798] media: cx23885: cancel NetUP CI work before teardown
Date: Sat, 12 Sep 2026 08:58:23 +0200
Message-ID: <20260912065523.459811442@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit 4e143d662ca94888b494b2427fc9e34494eb933a upstream.

netup_ci_exit() frees a netup_ci_state while its work item,
netup_read_ci_status(), may still be pending or running on the system
workqueue. The worker obtains the state with container_of() and
dereferences it, so it must not outlive the state.

netup_ci_init() queues the initial status read, and CI GPIO interrupts
subsequently queue the same work from netup_ci_slot_status(). During
remove, cx23885_finidev() calls free_irq() before the CI device is
unregistered. free_irq() prevents further IRQ handlers from running,
but does not drain work queued previously, so the worker can run after
netup_ci_exit() frees the state.

Call cancel_work_sync() before dvb_ca_en50221_release() and kfree().

This issue was found by an in-house static analysis tool.

Fixes: c184dcd28233 ("V4L/DVB (10798): Add CIMax(R) SP2 Common Interface code for NetUP Dual DVB-S2 CI card")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/cx23885/cimax2.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/pci/cx23885/cimax2.c
+++ b/drivers/media/pci/cx23885/cimax2.c
@@ -528,6 +528,7 @@ void netup_ci_exit(struct cx23885_tsport
 	if (NULL == state->ca.data)
 		return;
 
+	cancel_work_sync(&state->work);
 	dvb_ca_en50221_release(&state->ca);
 	kfree(state);
 }


