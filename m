Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051685;
	b=n9HHXW5hW1k29xSxVZiddxFuLZx1tAcSIf2IBRpMwtDGxoOOW0CHERaN5FD63YQTSHOL
	 gnnw88YI9/8qrEF+iCbbbe/kSTfA0GTIdpZAoXhgDnKuA/rHhGZaVdVHjyVUWNbWEx+dc
	 Mkh/l41+LrCHuLY5HyogLPSrKdK34xS2ajUgRfObCrbS5RCq/lW14lNvCAo/oflf0odhP
	 spbJxWIcNSvAaooZIU8E+OvtYflksqfBrbB283f6hT3qRPUBA5azHWiaUs4chGw45UQC2
	 RiLYS992kURXlHjhjj5hCgNMMUa0RMYWWljrk8NS+kzUHBFf0P9lqDo1xxDHjtnO6lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051685;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qNE9A7BLbrtK0e6Ufi+oFZUsio9pTnqaM9LTpO06skQ=;
	b=yPVb81ZW4DOXG3D6IH4spLCgfqZCrxef7BLltamGTw4+I1guRIVx/58heXEeHe8M4ZEm
	 EsjfpSLtj8gF5EBUi0OYAcgyIZtqt51zY2uY4860FuODV0gR45A4PKKkQaH7a5gCRcgwK
	 QK/FJko8BXIbPloblz4NX54ufnSitfmeUNxT/AtvIlgpucPt0y53m5Y09q4REODpV++9U
	 B3W+LdOFSd07f1C2Z8hwDenQqqIKFxTOZSj72l0qcvXYMwX3WaBn6/WPaYgxroEhojDYB
	 +wK/2rgcZKNG67XgkLNek0Phr+S1HKyMNqNowSklMrQpWp5tbdYysefXwwdqNv+HmvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=etNQ6rpX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D7C606A32C;
	Thu, 19 Nov 2026 01:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=etNQ6rpX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ADCB1F000C4;
	Thu, 19 Nov 2026 01:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051685;
	bh=qNE9A7BLbrtK0e6Ufi+oFZUsio9pTnqaM9LTpO06skQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=etNQ6rpXaMIZml0KBK3Uy84pj96Vw45qpiLNoaPSf1g76TNJ6muRTioo0pqaNIw4j
	 q6ummynpstnPwZDem1BxVlE0XHbpc7jhQGDIBjCDNEpbRVt3Pwb5satDPz3ubaFHJr
	 adgMZ4FQUjDZj1bN2qd1TYA+nxuxPbaarzYCgEY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 0295/2214] media: au0828: fix use-after-free in bulk_timeout timer on disconnect
Date: Wed, 18 Nov 2026 15:32:51 +0100
Message-ID: <20261118150021.897265112@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


