Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044345;
	b=NjpWOHeqtVoiafTWJe7M3M4bu5UPv0Z4ZT5ZySCjnuk7lXZYfaNYS3vFxQIPUfRFPo36
	 geMtPgQBajeMl9cdUSy9dQZKUesSWyu4IDOHvAf4aQBNDOG1yx6VGVmJDuMv8kzyirek8
	 nIDZCIK3ygm7dreOhnOZgdVLorB6+CgDtUakZgtRDxzv5NZvIh7uhegEjR38bp+f3qGE3
	 T1opscyAqWfqI6X46zGUszg5ddPytLzjG1el9jfl1fdKVGdn3OZ93R5Bp9g3WmnSg6gVY
	 oPgeZKZ3YPCLSyO2KlBhjBHS9SGf2ih2/4/+1rr0L94ztUoblOwfxSZkIsuQ7K744Ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044345;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6KXFOYvZu/R5q3i/DroaY+szDRGzXCYCIPrBpmnlhwI=;
	b=FxYPwZ4BKXD0u/jrsmFT9NpF8zflPSoPMsR9x2qexSwmnU0C4hHVjlZsKTWV6cnLMQhw
	 Nm1kovmOfHPevNZbVMmJynSybUrLMKXEvFySx3SyjTaWEa3ZknJ8UGdEpHvmc49lNMOXV
	 waiqT6OpQLyCKujmGXPzjeFVzKO63/k2YkZ+jp3kTWAQshgXQ2bSVN3x5WP0OP75Pwomh
	 gX0x9UlExr3qQbTuzmHv8O7y/7JYhFuNtVUPCSMYynNhN9YtCnz+QMPsFy2WzlWucplZg
	 FQiuJR643Y8uxqGyurpQVZzDSxdenKrwO+AxLWNEdqp2JB78KcDmSfLEBk84JxtjjcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kd5Q4Nl8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F913606A31C;
	Wed, 18 Nov 2026 23:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kd5Q4Nl8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C1F1F000C9;
	Wed, 18 Nov 2026 23:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044344;
	bh=6KXFOYvZu/R5q3i/DroaY+szDRGzXCYCIPrBpmnlhwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kd5Q4Nl8lzynRdpS9Ot9R6qPeXh9iT86VxS/mb8pTStmUSkaDiEIFYumrzxy4UQyD
	 RtLtohBLhyZmyXZZEC1y/iCUrw0yqQ/2CEKH0uq71gbkWq7pBb0t4a8hLDUQLy2eIk
	 JogUhqEALNzDnKcXy9FB8QQ9qAo8LmlabArOX+2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 0535/2857] media: au0828: fix use-after-free in bulk_timeout timer on disconnect
Date: Wed, 18 Nov 2026 15:26:09 +0100
Message-ID: <20261118150220.746367953@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit 521030837bee352515d5ea57cc6a29581db3506e upstream.

start_urb_transfer() arms dev->bulk_timeout, whose callback
au0828_bulk_timeout() queues dev->restart_streaming; that work in turn
calls start_urb_transfer() and re-arms the timer.

au0828_dvb_unregister() cancels restart_streaming on disconnect but does
not sync bulk_timeout. au0828_usb_release() then frees dev with kfree(),
so a timer still armed or pending at that point can fire after the free
and dereference dev through timer_container_of().

Sync the timer with timer_shutdown_sync() before cancel_work_sync().  The
timer callback queues the work, so the timer must be stopped first; the
shutdown variant is needed because the work re-arms the timer through
start_urb_transfer().  The dvb->frontend == NULL early return guards the
register-failure path where the timer was never set up.

This bug was found by static analysis.

Fixes: 53460c53b761 ("[media] au0828: Add timer to restart TS stream if no data arrives on bulk endpoint")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/au0828/au0828-dvb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/usb/au0828/au0828-dvb.c
+++ b/drivers/media/usb/au0828/au0828-dvb.c
@@ -537,6 +537,7 @@ void au0828_dvb_unregister(struct au0828
 	if (dvb->frontend == NULL)
 		return;
 
+	timer_shutdown_sync(&dev->bulk_timeout);
 	cancel_work_sync(&dev->restart_streaming);
 
 	dvb_net_release(&dvb->net);


