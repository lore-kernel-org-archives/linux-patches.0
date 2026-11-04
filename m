Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831505;
	b=hc5ltQ8vb9b6iLz7Dn6YpEBH32y5VmLxLoHlm7ogpS0L/MUnd5cz8IW1U/OWGg+n+30j
	 2m2j/wNE5L/xGH4dzE6GvZW+hJEfrElfF/X7laiJ47SWyL5KdO19YURvUskvj/ruo3Uqc
	 EO0O2HUpCQVjfNajLT0R3v1oBxR63QrtOpf/6mgTL1/IkzXa/AdkD06QMC2vE81t53pRL
	 e3nPCCHFANY8nu14av+JljitIoNQ4OlgS6a8XbkbZtmlk+BRHK/mbphGsJ0gBFg/V1kKa
	 ctzVDsg6og1Ms4I8K8Fr7235XX72ybonlD+cj2Rwees8Ik63galrdXgyeJY2B5u5TSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831505;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c0atzLCf2tL8+JeHkLpq+eTKz0KVEsRURpK9hOhLODM=;
	b=xRUe5MP4LMe2yWvdJFqqmYL0KYp5UHPun5BMnNZHc90ke2NvLuSSskohLWwFOeC5Vd4p
	 ZheKT/UZZ+jMlvT8QDsER1wzWTjRmjDJ/SvDZLQX84K+2YknzgCagPf6Sfajuqw94/HU1
	 wl0YE8ECumB/vcoZP+f9z2H9Y8qSwnkUODZzCo4kB4xwXt4EvPsndlNKcFcG6IZ3l7IX6
	 8INT3XbK15kS0NCnkOcAWI4cW+oBQB0XDqDTLaZBXySeiHrkkoz6AAsg+92woZkPA/ux5
	 Bcz+dVHJooHY2v2cQSNl3kimCurYpmerBtf8iewQNKd5DOVUsDsE8dI3UszG7Y6JLyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="iuxS5w/u";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7042A606D80A;
	Wed,  4 Nov 2026 22:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iuxS5w/u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083841F0093A;
	Wed,  4 Nov 2026 22:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831505;
	bh=c0atzLCf2tL8+JeHkLpq+eTKz0KVEsRURpK9hOhLODM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iuxS5w/uezcAty/qJQ92cdImjahslyo+HqbD+ShLNqYblwFT4QZlV0KkBgVdxMUBW
	 UUY/tImywM/StwkdDJkh3CviWhRH+OvKQwiqivmpnVS+x57DAMHycKuQmMsqKH9xCz
	 I2jRgXjs1YsE4Mk9eQkWR2Uu2I7c7yNIkbcwm8G8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 0743/1005] media: rc: Ensure that rc_unregister_device() does not free input device
Date: Wed,  4 Nov 2026 16:07:56 -0500
Message-ID: <20261104211104.281453742@linuxfoundation.org>
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

commit 61c7ca95d2483c77dfdde1b007cbe846f145dec4 upstream.

During or after rc_unregister_device(), IR may still be reported which
results in a input event being reported. This could result in a null
pointer deref in rc_keydown() or a use-after-free of the input device if
the pointer was read before it is set to NULL.

Fixes: dccc0c3ddf8f ("media: rc: fix race between unregister and urb/irq callbacks")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/rc-main.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1742,7 +1742,7 @@ void rc_free_device(struct rc_dev *dev)
 	if (!dev)
 		return;
 
-	input_free_device(dev->input_dev);
+	input_put_device(dev->input_dev);
 
 	put_device(&dev->dev);
 
@@ -1854,6 +1854,8 @@ static int rc_setup_rx_device(struct rc_
 	if (rc)
 		return rc;
 
+	input_get_device(dev->input_dev);
+
 	/*
 	 * Default delay of 250ms is too short for some protocols, especially
 	 * since the timeout is currently set to 250ms. Increase it to 500ms,
@@ -1880,10 +1882,8 @@ static void rc_free_rx_device(struct rc_
 	if (!dev)
 		return;
 
-	if (dev->input_dev) {
+	if (dev->input_dev)
 		input_unregister_device(dev->input_dev);
-		dev->input_dev = NULL;
-	}
 
 	ir_free_table(&dev->rc_map);
 }


