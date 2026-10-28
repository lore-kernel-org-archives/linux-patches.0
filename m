Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210709;
	b=pi9OTUItOdbkzAOAuHnImDTURQRbrA8aiDvGvhDzJmwEJx2Zfi8YK7yLfN79lR7nIS00
	 ozewS+nr0vxyc4lUQRBeubtuBl6mgAsIt1Vzb+uAXO6HwB/t5K4KwEtAUuwBRpLozyiD8
	 tKIZDsE33NQ8y9r1fqC/bjoBTm0zj4UJvNQXPktv/2IyXW8SC9pMUf+UUKNbMasLiUX9a
	 7wexknqzHKhPYmjSPueSAdgB6Wg4K3keNsr961bBP/WzS02nX1VzfpC8zDXh5wB5sQhuG
	 vfJVqbtLr6qgCO4sd3PlhCJIrm3fKwjJNbJSXpJ2K0jMQ79XLqTVkPggpARh5W2lu2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210709;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FAmOhegtfZt0F+SncKLWnNfUfj+N6mctecVQLIUY8MU=;
	b=qvK1KglDvbn63qlRfU7ON6bJuJawA/NvKetbO76fSkj3mgMoAEfvGTDGCqdC3lmv3zzb
	 81iW5EyepgHC576lD3gATM+K1nAMIZUFdtYXEqbv7DHQZrwPefdn3NAN+1J1mXRTWu++i
	 DHwhEEQs5hVtadsfZy94vtUj44eoi9ukCWbLIH5XEMtXTboJ9JWZZy0y5uTC+ydpdOyFu
	 hFC2bgogZ+C0u/io/yJc1QINSicr8RDS4ACdLx244woTLPg7LB/U6OD0oXWt7kDcl8US3
	 t3W4a8Wcpc3Z81DbMJ8T6QPqsgKkIGXcgwaWVKg3oPQfEaw8MZTrPbpXddYanm4dmgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JNoyMqax;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A9C606A31A;
	Wed, 28 Oct 2026 18:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JNoyMqax
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2A01F01825;
	Wed, 28 Oct 2026 18:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210709;
	bh=FAmOhegtfZt0F+SncKLWnNfUfj+N6mctecVQLIUY8MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JNoyMqaxpn3MGYfli/MT0LxLmjKJc2H5HbBpX/7jTD849xvOYhNAFKNqm95BD0IME
	 9Xekifo9Una/DWnHkbnyo7z7lKf/sPikL8D4173eLOQsDJnLIM6yh6VN2uyCS+8oTO
	 NmEMwaYVwFDm4hH1dZdZ+ScoYvOOjK4xt8uauchE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 084/571] media: zoran: Avoid freeing a registered video_device twice
Date: Wed, 28 Oct 2026 17:53:51 +0100
Message-ID: <20261028170010.020395684@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 0735e0b5a96761a9ce277a238e834008ad92a0a5 ]

zoran_init_video_device() installs zoran_vdev_release() as the
video_device release callback through zoran_template. After
video_register_device() succeeds, video_unregister_device() drops the
registered video_device reference and the V4L2 core eventually invokes
that release callback, which kfree()s the video_device.

zoran_exit_video_devices() called video_unregister_device() and then
kfree(zr->video_dev), so device teardown could free the same
video_device twice.

Remove the direct kfree() and clear the cached pointer after
unregistering. The pre-registration failure path keeps its manual free
because the video_device was not registered there.

This issue was found by a static analysis checker and confirmed by
manual source review.

Fixes: 82e3a496eb56 ("media: staging: media: zoran: move videodev alloc")
Cc: stable@vger.kernel.org
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/zoran/zoran_card.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/zoran/zoran_card.c b/drivers/staging/media/zoran/zoran_card.c
index 11d415c0c05d2..b6a9fef71ba2e 100644
--- a/drivers/staging/media/zoran/zoran_card.c
+++ b/drivers/staging/media/zoran/zoran_card.c
@@ -832,7 +832,7 @@ static int zoran_init_video_device(struct zoran *zr, struct video_device *video_
 static void zoran_exit_video_devices(struct zoran *zr)
 {
 	video_unregister_device(zr->video_dev);
-	kfree(zr->video_dev);
+	zr->video_dev = NULL;
 }
 
 static int zoran_init_video_devices(struct zoran *zr)
-- 
2.53.0



