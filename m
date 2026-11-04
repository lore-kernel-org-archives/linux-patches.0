Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827039;
	b=p5yfAkaP4nksBtUcDXqYzHNOBOZiMiLIrGc4yjDM1PK1zZTNEEzPC0N7oSgcUTFfUBmP
	 uaPxi/vYt4QODTQR/TA9Pv2+Q66KidD5yGVCgI3xO1Ucz5vrpGy/+RcPsTSFIBqH4gXFn
	 5j9IY9W3goL/dU5+R5kve1ZdtTEHf8msvy77VNa18aY9cqAROs3dSS+C7JPu/O+H6NmoB
	 HL0spUzmwiKEwAN25UtDwl42HfpdD5Bsz28KZfxnjrWrU4vN+eKOXjzFlIqt5tuqpyiMR
	 laNZLNklE1d3q53TzKgs94+wL8/aA6TCXimmuRIgIc+AjYt3pgFByBFgOiBwOl4cftg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827039;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xyzz/88GpUqTT/nwP7162/KtMTbP2zx5JVkbweiTaS4=;
	b=sWqsYxh5O4M6e8/1lMzdxFv4wgOPBEpCIk1t/aUJmEhKT7ZYKT2p43eYldtoVfIapXLY
	 Zcy8Tt6hFhrcVc1jFO+6ux6b2bOOzy01RVObmd89PcPf9ZfN9sTuBaFfLdf5S/XNRc3Y2
	 d0lmUzL6dugeqNatwl9MxvSFJ8VBWArHMT/COkSgo6JkaPlfcrCvVnv7jAlvL9Ny+bz4H
	 WAoB10fy+KJKtBqyRRFuxQxyDWl2gnpi7PNeZcFIWKMuleeIj0HtfpdF0IpZglF1PLG1Q
	 TXJYbrwh2LmSHO8znuPU48JAwouQQB00Q7IPX7lR8GMjiGCngBaKnfdEGyD4pXLcRiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qFpCQy0d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FAA660877C4;
	Wed,  4 Nov 2026 21:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qFpCQy0d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 249CD1F000C1;
	Wed,  4 Nov 2026 21:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827039;
	bh=Xyzz/88GpUqTT/nwP7162/KtMTbP2zx5JVkbweiTaS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qFpCQy0dB4LbqsbywJfNpWca+b8wpnJar79EMRMCTkq5X5MWQNd84FThEtZi3eu9n
	 IyLCzKsJTEij307/Un8jA1/16XuyxSPRnYpEcPBzWhKI2IwABr41h/r71QxbxuYKr8
	 KpfAxRmvwQjbgo4Oa8V25BOpKr+ow67nh7vTqY50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.3 158/547] media: au0828: fix use-after-free in bulk_timeout timer on disconnect
Date: Wed,  4 Nov 2026 16:05:42 -0500
Message-ID: <20261104211042.647052622@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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


