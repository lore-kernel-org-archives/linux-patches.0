Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831437;
	b=jmhyBjK/HXp2RiqHT+mNPgSWkAnbrORu0vqs4WASRu0JgnIGz8zS3Qx8UVkMX6ZMN7H4
	 jcvuvcLqtY7R4dvLOpZWWqubSChWz83bURauMpKFZkgGS5l8IzybCvNRdd85yM45iVpgZ
	 3vVmoDdZ0/MecJCqT6tJqHi0Y8EzyJeqEICeZR7e1OAM1aSA6t2im0UQPlUVUpay8i5Rs
	 os0ZefXpKmuA8Jp77l1F5N+e8+LSgSPCJpjaYqydNbNQb6txstLDeBw9UGsUc6+b/Bcun
	 i0x7Yfe87D78KRl7o/2x1TOkrFxuF8lM5rzI1JFvn3xAxNpGXBcaQKLhyicf9eFkAvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831437;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nTypuvJESHejxbxSOTHRvvcsU9H4xbBpQ9jQeDTwAXE=;
	b=5ULlzHqb+3yWMFNpDiL86QnU/udLC7GxiT3GRf2OhkA8+XHfj+62phFNiJArh6ncO8to
	 prPtfrhE3rlzy8kVLsZN8hzjDJW1gX+GtfWnV59iOs4i+yLibT6euOfq6KV8ok2TnEj7p
	 DoJ7+uKqCRn0lfPPIFKNbT9AC/3bHULzz1oRc67zW2GCLXTtdIqqsHwh24dWCVLga0YeJ
	 kfJY/HBA4j54HOEptRxunJ7dgeCcI/oBnubXkQwyOvShz0vVi7Ol3SIfEpjURE2IgFtHb
	 t9LfEd+TvxNqnVC+9GIFJPzyvVg0ctEGuQnWwD1nTqcUcKXS+e+xCGZXa2IJ37+T6nA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=og5uPJpK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB154606B385;
	Wed,  4 Nov 2026 22:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=og5uPJpK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683B41F000C1;
	Wed,  4 Nov 2026 22:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831436;
	bh=nTypuvJESHejxbxSOTHRvvcsU9H4xbBpQ9jQeDTwAXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=og5uPJpK6ohCrYgTNDolXTCqNov8qWbOI604EmjbNs0JAVzwajhxMIIj0NP6/ZmjP
	 DjERnHAcUp6eYvFdEjOv0GH0cHDxWM3aMYjSy1Q6NANdblKH2dX3ZT9LUqyZhw4zlC
	 EHqg4kivjXSXYe+LNjwc/yVGdCdSngOR/BFFu1y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 0674/1005] media: au0828: fix use-after-free in bulk_timeout timer on disconnect
Date: Wed,  4 Nov 2026 16:06:47 -0500
Message-ID: <20261104211102.521993943@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


