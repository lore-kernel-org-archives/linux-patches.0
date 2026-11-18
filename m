Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035804;
	b=HaQC19d+DgBrhjRTr5CE2SFI+cBPcIg+cRWjyrpyD+aV8z3AZ0Ks+AB1ruH86b64E2yR
	 sR8f91c3fY/SARUd0EIzCr+VwYM8qgvqGvaUHqBt5LdlYepiTbPuwkVJkCw6wlOCtR5Ys
	 JKa3qMJraHuhQ4xu8izIwMO61te/FG5UOhBMXv5TIsFkRLnpY5rXlAI+4Pg+OrBUmS6Ho
	 vR0BQuGg5X4u2lcbteTazLMCV5STpl8G8aHATt5J1cI8/H9zmcYWkOihopTNGkrwE60RQ
	 5Q6L2mrXjtK/xd6rINOXobw3dVjTiWQRtei5OxfuW3yuIrn7Z9uJc/mwTo2L7lfVGWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035804;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/kUju+pTtziJuqZ278G34pqbJqbM8K8P3mdctFRsGnc=;
	b=r2b0FKTScEtonrr29hYQhgbxe1Q87UYVHEmCInOYejT7QQmyapv2m/Y92sQ2v2DdYhJQ
	 7TcFkYYdfDXaOX5PLnO77pa7XgXuXE1PkG1LaU9j45fcw4QUOyU6XrUXDaxVWurpfpmCy
	 BskLScdYgCUw29hz+hFnlc15xXn4O2/hWuu+TY2o1ysSWgEFasBqOmlK2o1D/mycJsEUs
	 l+3K7UHtw33074ygAPcvpjxR2Olu4uhnHcZ/vreUZD6BwXIyR1Cfaq5Xzfv0kLVpMBktw
	 b2wO+cdoUnXOzzceKoRZ7d6Pad7r0k6dWSdlrRGa6zBygFK4Jss1xMyk1ZTu5F69BCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hno7vat1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E1D606A320;
	Wed, 18 Nov 2026 21:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hno7vat1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26911F000C4;
	Wed, 18 Nov 2026 21:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035804;
	bh=/kUju+pTtziJuqZ278G34pqbJqbM8K8P3mdctFRsGnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hno7vat16pbrjRNIIfDimT/gqe0qLsMfXo+c/1U1osLeLJkTcs/HfKUQQ5Uzhu2Xp
	 /nNv9k60w2hXiO+VZH3MD3XoYt9SBdy4qA83nbInFstgEkzEtE82B21kuZvZn2yC45
	 Pf53jesMYdVXTP6QF89I/mEs7wiR8SpzPJReICrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0791/3318] media: rc: Fix race between bpf(BPG_PROG_ATTACH) and device unregister
Date: Wed, 18 Nov 2026 15:23:33 +0100
Message-ID: <20261118150342.611130895@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit b3f5daf3222999d3f92f606a4eb5e35ab90fd0e4 ]

Mark the device as unregistered before tearing down raw IR/bpf
state, so that racing bpf(BPF_PROG_{ATTACH,DETACH,QUERY}) calls
cannot slip in between ir_raw_event_unregister() completing and
dev->registered being cleared.

Fixes: dccc0c3ddf8f ("media: rc: fix race between unregister and urb/irq callbacks")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/rc-main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 2eaacfa1e29eb..9ee1ea13550bd 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -2030,18 +2030,18 @@ void rc_unregister_device(struct rc_dev *dev)
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
 
 	del_timer_sync(&dev->timer_keyup);
 	del_timer_sync(&dev->timer_repeat);
 
-	mutex_lock(&dev->lock);
-	if (dev->users && dev->close)
-		dev->close(dev);
-	dev->registered = false;
-	mutex_unlock(&dev->lock);
-
 	rc_free_rx_device(dev);
 
 	/*
-- 
2.53.0



