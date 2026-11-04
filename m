Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831510;
	b=oHf5e2RVRgU98j6HQOLkkaIeexa3Ltov60y4ttB8fqSA/H41gswW3tvDmsu6170ln0Q8
	 3PsOyG2z5NLpr/KUVcdtUAlcnL7dRH8Koed/mAOiiwDw3eFyOa+qHGRV4UJI5xapcKSPx
	 IpdxUSuHqNwJIikawe33HFvsWOrlD/2ji7IMjA869DjnANywzmSsSbk9MbfxiljK2QDFc
	 Xj4w/xH6Yuw44ORqr55V81QfTUGUAYIRdoLWzIy9J8BJBTJ9WKgLyER1sQKXpJR3cCtot
	 lwlCo1DBq5CfppAWU0L5e32BqrRN6D92xXalCF/oWxphA/LsBWelABAU6bUCTVcAi3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831510;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wlbkXZg8ilbwzJu23nPNra8CU0T/P71CUCe283mr4w8=;
	b=A+8fqYKY0ayfOpFla4l79PD6k3qu4wtEJRjNl7SohuWd51tE/qTpBMw8MsI49oyWr2KY
	 c5HK2tiHRyBlMtlQKxDkV/Et7uts5dyrpJ7jcfXObM8pCj65BtpgJqSL7fUNk0kfG+A2Q
	 EAed4HaSEOLPWAZESsl3MZ0Hm12zGEUbYK8fALDh27sa0e1eUTo+hbuaDfJ3a+JFw/NR7
	 MW87PACOmCig3lLKbnHbDAc6SC4IRGSjDMWhGnPELLrqepcr0mutw3y8+iQZ6t4PiDefH
	 nvODH3WfvL0yJWhFDX9KPV2JEcQXmyGZejEOdii9w/SqOFGeE94tJGCY0FMhWvacfnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ty6vedfa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5AB606A33A;
	Wed,  4 Nov 2026 22:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ty6vedfa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1C81F00919;
	Wed,  4 Nov 2026 22:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831509;
	bh=wlbkXZg8ilbwzJu23nPNra8CU0T/P71CUCe283mr4w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ty6vedfarOtIKerMo04rgkBu784AF/gGIiCmfoxN2cSxZiPxlVQrJ/5ATwvdJ1BbK
	 Lf5JLZ+EL2p5WCW2dTMq/lJoXfxgDTKrbCv9IVkopezB/fHKLheTYOgOINq7uduHwc
	 IJ2ZWIo3a3ta5pcbglsnLcEV6gvwS73lSZrusfCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 0746/1005] media: rc: Fix race between bpf(BPG_PROG_ATTACH) and device unregister
Date: Wed,  4 Nov 2026 16:07:59 -0500
Message-ID: <20261104211104.361991605@linuxfoundation.org>
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

From: Sean Young <sean@mess.org>

commit b3f5daf3222999d3f92f606a4eb5e35ab90fd0e4 upstream.

Mark the device as unregistered before tearing down raw IR/bpf
state, so that racing bpf(BPF_PROG_{ATTACH,DETACH,QUERY}) calls
cannot slip in between ir_raw_event_unregister() completing and
dev->registered being cleared.

Fixes: dccc0c3ddf8f ("media: rc: fix race between unregister and urb/irq callbacks")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/rc-main.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -2026,18 +2026,18 @@ void rc_unregister_device(struct rc_dev
 	if (!dev)
 		return;
 
+	mutex_lock(&dev->lock);
+	dev->registered = false;
+	if (dev->users && dev->close)
+		dev->close(dev);
+	mutex_unlock(&dev->lock);
+
 	if (dev->driver_type == RC_DRIVER_IR_RAW)
 		ir_raw_event_unregister(dev);
 
 	timer_delete_sync(&dev->timer_keyup);
 	timer_delete_sync(&dev->timer_repeat);
 
-	mutex_lock(&dev->lock);
-	if (dev->users && dev->close)
-		dev->close(dev);
-	dev->registered = false;
-	mutex_unlock(&dev->lock);
-
 	rc_free_rx_device(dev);
 
 	/*


