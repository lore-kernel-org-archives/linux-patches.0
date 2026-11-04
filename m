Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828893;
	b=NWLJV0ydWRKxv7z5/nQiUs9/FQpsLBrUTWoAOW6Sr24sw8SiU7VZe2/3ev6Uk5LGlBPt
	 Qlii170uWkH6sr4i/IlS4KTcb2bv2jXEqb7ovaLYZ/t/QGvbHDe+P/MPfVe6HtCpEONza
	 S2QKXlQLaeILHkX7FIYF2onOJt/VdURJVMSLMU7k9SE7LwV7MMQ457A8QsCSaPceevtl6
	 BtFYNAQa8Q2BxSxeER+5gbtAsltG+g8AlWj7hiI9xDmXPDbeBpIHzwasAu+UrsboRFxv+
	 gKQpkm3JANYT0eZyeD2Pui17eDzISjCvZ2X6uj5v2AJXji+nVKR5Nh4vBfkQreihcjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828893;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P4nBjwwRtTP1KAxzyUl+bD8CazVVc5QwVMWOpkQ4Kss=;
	b=fzZ1B5PRE/KwVE/ZeXOv1uyxdOwHwAEUaNNEZtnfPt0ix4yiBkAAw1NLgdzrkC9+Hrvt
	 pXVHdcQFN9Y9moaXt2TxClO0Cs5/YQZD/IqNeJLhxceOahyTIa+F5bt5XTuQHUceDl2Aw
	 3GHFL7qoH6+C4fy5IgeSMt2hN9CGfaBntgB1eEfoDsm28ubIlTMwLGDns47d/iJ0uYbVC
	 SZzDAqRx/IXEmfaqqYwgGjOn2jBrgSyxtBUCZqK3JvOz1YtaJ3dz57wSk5JT5U0hihefS
	 pBD3FR8m8QhI90+G3lBCA4tralgMSCOTCBEIifX7CbqReXj4yndq4mi/CXfiR1FWCtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yO6qPO4Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4151B606A33A;
	Wed,  4 Nov 2026 21:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yO6qPO4Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4FBF1F000C1;
	Wed,  4 Nov 2026 21:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828893;
	bh=P4nBjwwRtTP1KAxzyUl+bD8CazVVc5QwVMWOpkQ4Kss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yO6qPO4ZhZEFK46W5rCyNTMGRPhlf9VtQbNil/JgtKg/GBi7qjXTLTXO1+O6dY1+c
	 0fp2XTRBEVfjNO1Km6ahmSxXsqjAJ6DffS3fbAoOFGGizrB8TMZ29rJ0ulH6lbAAnt
	 5bbdvXYPQJERHFrwoL0gEEc7NJ5eC7Gagr+DKLDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.3 269/547] media: rc: After rc_unregister_device() timers can be re-armed
Date: Wed,  4 Nov 2026 16:07:33 -0500
Message-ID: <20261104211045.832828874@linuxfoundation.org>
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

commit ef41a67979aed4d7d4f393c56c1e25b6754e2b78 upstream.

If rc_keydown() is called after rc_register_device(), then the timers
can be re-armed. Delete them again for a final time.

Fixes: dccc0c3ddf8f ("media: rc: fix race between unregister and urb/irq callbacks")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/rc-main.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1753,6 +1753,11 @@ void rc_free_device(struct rc_dev *dev)
 	if (!dev)
 		return;
 
+	if (dev->input_dev) {
+		timer_delete_sync(&dev->timer_keyup);
+		timer_delete_sync(&dev->timer_repeat);
+	}
+
 	input_put_device(dev->input_dev);
 
 	put_device(&dev->dev);


