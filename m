Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027372;
	b=ijikQ3i6KnEr/TO4bk5HW1e/VFol2iehx0gPdlLZYmgEjMvKR0iXcBIWRpRwz6F2vH2m
	 wSG3dj5iH7BIbC9fuRLN1Lk44Zoyu8NP4rTpLBIS6MO7uQz6puPQiWaDJn5LzxtjdWtjN
	 Jb4e2/I5ZYf5y4Z3waKTMpKcuggNWz2SftLRn85ePmVGAHIdlEgxL0AO9tuAkaJBVdjjw
	 3j/Wb7gwpy0mxbyNhP2t2cxbmpKVoKswKERBmgECVW4HPCga94YnMwH+Qv9k+YTvEOr8Z
	 RrDgCLqeMo6elanOqeF8pNYLeraGfI53lWRrWLO8QvzvqS5rbvMVzur7ykuuZvYXfHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027372;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5go++4AUwOd/UyrrFANtAZAqCYIs0Ao7sEfmFXQ0fgI=;
	b=W/QkqChdt2qhw4PuPnGP4zL7clz8tocAiwv/5CKL9RNq7LOfQjSTOll1DY4cIxhQxZfX
	 kb7IU1N5J2ZGygJmiq/H2P0OM2vtt4G8HFr2iyTdDQzxgmpCtfGEhpemHCbFnXK7V5Uko
	 jkJOOx/rs5xR4m9GVzG+O+IS3ApfkB2hospKcqskIHEbS2YU6Lo9OnKEOHHBktv9im0kC
	 T1ZFiYD2iOP1naLlzeTUs8gttAOJyiyZCgtpe5nSS9+04S5679ATUdfgCMnTbctiOFn7k
	 AG/nXI1oWIBOl3zuZA2+R5r9oTE7ZA8AXkKNkUfMwxiOWIPYoctN+9e/uuXDJEtzNZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m5TTmW+S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65722606A331;
	Wed, 18 Nov 2026 18:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m5TTmW+S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCEC61F000C4;
	Wed, 18 Nov 2026 18:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027372;
	bh=5go++4AUwOd/UyrrFANtAZAqCYIs0Ao7sEfmFXQ0fgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m5TTmW+ScfZToP0zjyMMKIN4yEgmVy4l1tjlblwGYgFUkaWaHkz8agNWkWcfRUXz0
	 Xa96chEZq+hzNtGjrgzDCDrdZDqKqWZCizIAgV9zGlS7yjGQAiW86ZLIg1tQPspVMs
	 0RZN3Vqf2NQrJhxZKNEgq8EqUFQCHnkCuXnmxmjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Kent Gibson <warthog618@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1765/2151] gpiolib: fix memory leak in gpiod_set_array_value_complex() EPERM error path
Date: Wed, 18 Nov 2026 15:58:20 +0100
Message-ID: <20261118150226.132841848@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index c23ba5e94cd6f..a0a0d8ca6d82e 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -3694,7 +3694,7 @@ int gpiod_set_array_value_complex(bool raw, bool can_sleep,
 				  unsigned long *value_bitmap)
 {
 	struct gpio_chip *gc;
-	int i = 0, ret;
+	int i = 0, ret = 0;
 
 	/*
 	 * Validate array_info against desc_array and its size.
@@ -3772,8 +3772,10 @@ int gpiod_set_array_value_complex(bool raw, bool can_sleep,
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
@@ -3806,10 +3808,10 @@ int gpiod_set_array_value_complex(bool raw, bool can_sleep,
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



