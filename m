Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621905;
	b=f3VE1VGr16caxulRINHk1XMxtVd3fru3cWEQuqXYjV0VSd5U2fViNpqIGaL9C6+54Saj
	 W3ApgnqBehHKYAAy9sNdr2+iAABPq8yQdiJZWO81aKBgeq/MJgp2o1UYxblULwRhPhXD1
	 JTsyaskeIsYJfMjZF9kFzK0JvAB+1xeZZpxADNh3lpEBG/ZeZ05cc/H2iGPbAqNTDH93P
	 IWw2qSCqb/sYuFCWfIk7UZALbDDa0onmHfv27HMR0v6h9rJGpGiDj/UglxM8y6TXT3imp
	 gLqhiP2dBTAeJ/vh/y+qYpDDF9gKuCi1zTyjOIXtSPXIsAW2Mn2LFvRG8Iy0TVi4Vsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621905;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GATRQMUSM98KM6D7fX8quPWlpCR1oN1/QJDHu039hM0=;
	b=YvveytZS9laVJGqC6faNkIn8Km8eTSbgsRThvcjDg0uh3H8TF5Ce2DqOV8EyMta9HX7q
	 FCEni45ec9UksWIdty7GUd3erZkG/W3nYR+sj95VMLTUNyu4vUx4qxpgCUNqNt0L+MRNH
	 n3XqybBsMLfJazFVZxx/+ufMYGarKdYSZPgpXI3FPhnLO5xc/kDa/lG7ZZijZuX4NYK97
	 WRpMVAiqppYedgoaeSVkuEdsc6H+eNwkE4w9K8Gze0VvH4SV4wTljD5WH/2JRQN8ww/1O
	 zRpWHWp0QX3JVfALROcHMK2RkDcCSndBDKcTarUlahzP59elYTLlyu+98REPrmjF5Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qaFJbgyy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF66606A31E;
	Wed, 25 Nov 2026 15:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qaFJbgyy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3A61F000C6;
	Wed, 25 Nov 2026 15:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621905;
	bh=GATRQMUSM98KM6D7fX8quPWlpCR1oN1/QJDHu039hM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qaFJbgyygkIM4u8wITzgTOlCw2jv79Mb6Ll+Qbn6ID0keECNESo2dwMUxcC7foU/+
	 6pFoDEpKyCe/kdvVxLABdAxBN1c15DjJBCvWZZ+6M0XDyR5ad/efn2fMLhslz0zDaL
	 4H/Un/CF/dkSoZytBqVf6ZhFLHBTTxW+5vmxW6Xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 353/990] gpiolib: fix fast-path cancellation in gpiod_get_array()
Date: Wed, 25 Nov 2026 15:28:40 +0100
Message-ID: <20261125143830.362600828@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 51c85306270972f672737dc5e28332e2b41b26f1 ]

In gpiod_get_array(), when a pin on the same chip is not in hardware
order and the preceding pins form a contiguous block, the fast path is
cancelled by setting array_info to NULL. However, descs->info was
already populated with the array_info pointer during the first
iteration, leaving descs->info pointing to the aborted array_info.
Consequently, subsequent array operations still use the fast path with
remaining bits set in the masks and wrong hardware pin numbers.

Clear descs->info alongside array_info when cancelling the fast path so
callers do not erroneously use the aborted array_info.

Fixes: c4c958aa64f3 ("gpiolib: Fix array members of same chip processed separately")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Link: https://patch.msgid.link/20261105-b4-gpiolib-free-v3-2-bb47ad58642d@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index af33ff0778cb9..a41219961778d 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -5106,6 +5106,7 @@ struct gpio_descs *__must_check gpiod_get_array(struct device *dev,
 			 * hardware number is different from its array index.
 			 */
 			if (bitmap_full(array_info->get_mask, i)) {
+				descs->info = NULL;
 				array_info = NULL;
 			} else {
 				__clear_bit(i, array_info->get_mask);
-- 
2.53.0



