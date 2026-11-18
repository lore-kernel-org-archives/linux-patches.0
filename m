Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035191;
	b=rzTB8AYLIo0bnUtiHD/5+0J4ECwzbZ9TQ4ON+vfHnRA9Rq8Ep5EsnZS3loryuu38xzrA
	 Ka7Ry4Q1Ou7zWXzFyaATMSCUUg/lYPmE4GOifApnfkaOtZzUR3rEaK1rytvVJFEofKSq1
	 aa2MBiccka1Yo5r4bjaZQTXzfUqbBKLTQoUwqISsqQ0mM4A6L6SQNB/2U0JaGG/TyI2IY
	 mUEnB5j+MoXhKOvvLJ45Ux+jKGqPSaYtSAodGfe7X06db6Xvm5NFNAEf3GXBpcOoppixA
	 QYFVLpY3Sb7wVSu9f541uc26ZE1YIHYTuxsHg52mJgQBQqRvVsIB2pHgEPqi4L77sYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035191;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DGr1W5lhGTkEIet0qDdLoiCml0heC7HnaqPwukQ8xuc=;
	b=JDvxI0ILUzJmyb7Iz4AqzoijRYGZIqFn2xsFMOQGVizstEr+vKqbYPZksvNuBhxYXUYh
	 Ah45pfMbV75cF89Fvt2eiEAmq74iVE+9IsQiOXz9N3OVIj0phBmOGzTuRmdzHf066GBrz
	 69eyRsYKPEemu4nb9pdILqdKSW0c/hZoK9xFoq6sGFUeOcleQ3AZAPb6u9W7tmsTKx1+x
	 JlKHiKhYX9REcYNG3OqPQUT7e2ijleb3Mbl0rF8WtWCF4xVacrYcouXooSrVmdsIOxtic
	 USUk0YhlLNuAQkHu3xePYz6DhhnirZEYa56T+Z7pAwVfQ1sddO0tixkW0t3YNkQTWaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZecSKIXt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B183560A2623;
	Wed, 18 Nov 2026 20:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZecSKIXt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05EA21F000CA;
	Wed, 18 Nov 2026 20:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035191;
	bh=DGr1W5lhGTkEIet0qDdLoiCml0heC7HnaqPwukQ8xuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZecSKIXtJ/WVzQ0lT4v6hFEvfjH7ZWRDkonkpDEgcxPJlOWWk8b7ue2sXjtEhrNHk
	 ylYOtsGzKOeJc4NAd83Kz2sodyIPExPbdSU/l7w2Kbn3/8ol1PtOcFtWeGYmVsXWjU
	 BsXjiV62se9aqJpdg/aIt7MvYrYvHT3m0roxr1E8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0636/3318] media: rc: After rc_unregister_device() timers can be re-armed
Date: Wed, 18 Nov 2026 15:20:58 +0100
Message-ID: <20261118150337.001420398@linuxfoundation.org>
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
@@ -1742,6 +1742,11 @@ void rc_free_device(struct rc_dev *dev)
 	if (!dev)
 		return;
 
+	if (dev->input_dev) {
+		timer_delete_sync(&dev->timer_keyup);
+		timer_delete_sync(&dev->timer_repeat);
+	}
+
 	input_put_device(dev->input_dev);
 
 	put_device(&dev->dev);


