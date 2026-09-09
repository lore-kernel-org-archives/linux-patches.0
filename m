Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E99E572696;
	Wed,  9 Sep 2026 14:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964032; cv=none; b=iGrnjktMOH9zZhOM1O3QZO71PTQnJtRDl6cCLz7VNPqKT8KpaeJUvR5s0dEPRBrpVdlPL4aRnApjRviQfwlzfiHIcjVokn63Zmzd5XoQaahetbq9Jiw0+4GbzytoTekq4cTDG570qWmQHSZ5lrQKi7zujClfOEj4WaXVPQBonkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964032; c=relaxed/simple;
	bh=+iKcu/rZF2vCh78JgGyVfaeVsYXSP3c7XUPRABis53E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4w5ushSsjHew4z8Cmuf+OKkIGnXsiWOFGckAipcZMYWnmqAmta5njVFY8cS/4gw+Qkw0b122TQ/cW7JHBkm717cWKgavXJSmV86oA1YiWfk6Teh3Rj1MJ+obbzzy543TKQqDia6+V7Yz+p/4uuLPUhWxJZfT5b/EOo8/BK1y6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oGKlPcp7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oGKlPcp7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC851F00A3A;
	Wed,  9 Sep 2026 14:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964031;
	bh=cJ9dQs9UsS6lB33ZaHmEfGrvsFSQRXHbZjrWDnUWJ0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oGKlPcp7gzY+VSk4BkSAD3Pf8AlyVDIbpY5S7p9r0sU/PYzcgX410FZILtgaJZ63M
	 fw7+royzVGq4yeUQEw1k/v7OqN/2Xj+jCCSqi3WNmiijEgJ2xiSjxmbSJwP04FU4gg
	 lCBZCjBdivEUmmF4nLCLZCC0ywLNts9zf3NoF6oY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 284/583] media: cx23885: cancel NetUP CI work before teardown
Date: Wed,  9 Sep 2026 15:39:29 +0200
Message-ID: <20260909134247.882148607@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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


