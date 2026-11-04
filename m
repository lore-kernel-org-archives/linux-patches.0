Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828884;
	b=2WCW70k9SCrrOqyBLNp/J1K10kDaKulstlNNIr4gk/YAwqhqBSREcfOJUckm00cuz/oU
	 kcwRxgWCW17Ik/IW1ByT//mIb8HQ/J6zCGJCOJTjwkvNrLr0Jo24W3Wx+lFZHTk4OMOfw
	 yBSxpZ3th93VfKBJlH6ZHlegbav4/5pp5KOK6WstQKdHGRxOhiQD6siY0PLX4qc0d6NbB
	 S0wU1r+XHYc+3DV7Ywg7vyu92zF6xzoHKbr/e1AbBVKLPFQMICrcfqoVRWD5cU7T/x0ZG
	 q6eHpezsZzNK//+pOj0u/tmYxzbFC374QmKNDugoTGdUE7CJsyVlQJt393wXRjTsbHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828884;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wz2rA6Mb9t7Z3Bfmg9PBc2KasB39JfiOed+/Ys9cxPc=;
	b=pEQU7UYax+V0OekIV2O5leaQnfjpg3Fi14lUQQXa8bqnjvgyA+KzswpEm8P6Ew+eG/D+
	 P8mjaJKY48DLahZjtHwPTSxuXz8SbOp4tFknn00FAGYcHHvTThhZUBJi+vzQ7Sdk5Tdpn
	 CLT8V6dlH8D6DqVVF8rlftuV0zSKGiF9u2hLl4N95WS7wdu74LSwNzIah4JsWgq5a4LLW
	 OuUHkCd4E/gCJlKEO6PNuI0+8KP3dzh8RAc6tC8ZgHeXGVcgPFcAzw6cFfC8opilhVnSv
	 aWzL+5XKmcGlCuOSjwK73rX13xdMlByETaE/BSmpoFb2ksTBmIfFtclu96/hYdvlX+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x3DDITzv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500C4607030F;
	Wed,  4 Nov 2026 21:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x3DDITzv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE441F0093A;
	Wed,  4 Nov 2026 21:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828884;
	bh=wz2rA6Mb9t7Z3Bfmg9PBc2KasB39JfiOed+/Ys9cxPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x3DDITzvBbbP4Xxk4p0jBuhQz+3k8Z7KHc9UYns87m8gwc6t22eJn+ZwQWPR77kKG
	 qU1B7EGG8rfBLrRIfJC0K/Q5dR2X4foO9BNE9lgR+YjVDWQSj/jsntSYtGb0D/JWiF
	 Ohsmv+fkBwbNZEsUsh0h3pJcUTh3S0qCDNV/wrbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.3 265/547] media: rc: Fix race between bpf(BPG_PROG_ATTACH) and device unregister
Date: Wed,  4 Nov 2026 16:07:29 -0500
Message-ID: <20261104211045.718582882@linuxfoundation.org>
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


