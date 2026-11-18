Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021001;
	b=CQnxCll5UvQXH//HzHia/Krb0//tdjJKhzWjM7Nysb4kpo8nSGy48+gmbt0aUMBbo1Ib
	 6VIv1c9hUXJLTVTSm5UHYs/zLYFJtLWFmpbrwm8+KTPOla/nvlI7qgThOKHD//X6m6yir
	 gnyfMvtl6FBHRlE7ZYiRhaAfWjzLN0/VfLnULmKZfThZoFHrAim+hViIGiJ4rRbVSQeXf
	 vauU3h4OrDqNmxyzEVkM1rXAD6SB6z42rlALiE7Qnt87PQbO8OOFaVGdpz8gx1a/0GfQF
	 KLS2+gXBmMMXX5pjHDr6F0w8Am6NLjudr6iP/bd960AdJTXqN7ciOb+fVi5PqVpgPwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021001;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3kpIpMmsWgM2M5NW5Q6dYV+IUUnMBJXLbiKCVou+rX4=;
	b=CiELubhNr2CiEM61YGWNh5vB6nTeiW+ZYBTvCEJrN9EuNpwAO6Bomc+BB3gAbna/Z4Es
	 WLM2qbM21nvs2KQ4O1enhXNMAdr5wTRv8U9bz9rJlN9nwSkWwwmjbtBIrA+oRqRogQi7y
	 iVuDfv5QJj8VaZ2b4c65mLfaJOOuKeoapm3r7XgjseogKG6omoD0S85fKVdU5VgtoFSum
	 MbJzAfz2YcUcN5MVR5ymAhSQbDf2cUMO+pUHWgqipOhwuLSbAIII9wt4R9TM0hV04sXiT
	 31goDHpGgJs5PLR4MDMzzJmZB4uY5n4LkZpxLn8jHZPyGRWjx7RWmLIBOUjlXojCn9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F4KP1qQ0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B9E606A31C;
	Wed, 18 Nov 2026 16:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F4KP1qQ0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31B31F000C4;
	Wed, 18 Nov 2026 16:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021001;
	bh=3kpIpMmsWgM2M5NW5Q6dYV+IUUnMBJXLbiKCVou+rX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F4KP1qQ0ntGeoupSgjyL6F5PpaHQ6wgH+6t5L3MZp+MNMk091EsLcU1a86IDoHPsw
	 H/AS5doQ0JW8XuG/NtLhA4DemQLuRINZkhX8HoHU5poO/BBY4HcifpDintiqVNyXnp
	 HvUq/IfAS7EWFls0LG2qoRijWQZUiwYbZspCOhug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Kent Gibson <warthog618@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2153/2651] gpiolib: fix memory leak in gpiod_set_array_value_complex() EPERM error path
Date: Wed, 18 Nov 2026 15:56:33 +0100
Message-ID: <20261118150403.337490463@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Kent Gibson <warthog618@gmail.com>

[ Upstream commit 138d7365c20efe47b4caa92c46f086ec39b81f78 ]

A drive-by review by Sashiko reports that, where the line has not been
configured as an output, gpiod_set_array_value_complex() can return
without freeing potentially alloced bitmaps, thus leaking memory.

Cleanup the bitmaps before returning.

Fixes: 92ac7de3175e ("gpiolib: don't allow setting values on input lines")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/linux-gpio/sashiko-outbox-168233@kernel.org/
Signed-off-by: Kent Gibson <warthog618@gmail.com>
Link: https://patch.msgid.link/20261016105442.109836-1-warthog618@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 226ed5b8d4442..7c865640d4232 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -3850,7 +3850,7 @@ int gpiod_set_array_value_complex(bool raw, bool can_sleep,
 				  unsigned long *value_bitmap)
 {
 	struct gpio_chip *gc;
-	int i = 0, ret;
+	int i = 0, ret = 0;
 
 	/*
 	 * Validate array_info against desc_array and its size.
@@ -3928,8 +3928,10 @@ int gpiod_set_array_value_complex(bool raw, bool can_sleep,
 			int hwgpio = gpiod_hwgpio(desc);
 			int value = test_bit(i, value_bitmap);
 
-			if (unlikely(!test_bit(GPIOD_FLAG_IS_OUT, &desc->flags)))
-				return -EPERM;
+			if (unlikely(!test_bit(GPIOD_FLAG_IS_OUT, &desc->flags))) {
+				ret = -EPERM;
+				goto cleanup_bitmap;
+			}
 
 			/*
 			 * Pins applicable for fast input but not for
@@ -3962,10 +3964,10 @@ int gpiod_set_array_value_complex(bool raw, bool can_sleep,
 		} while ((i < array_size) &&
 			 gpio_device_chip_cmp(desc_array[i]->gdev, guard.gc));
 		/* push collected bits to outputs */
-		ret = 0;
 		if (count != 0)
 			ret = gpiochip_set_multiple(guard.gc, mask, bits);
 
+cleanup_bitmap:
 		if (mask != fastpath_mask)
 			bitmap_free(mask);
 		if (bits != fastpath_bits)
-- 
2.53.0



