Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027375;
	b=yB0Q2AKYCfYlldG74kHyLLZT1uys8/Y0T24MDXd9xhsLZxje0dlNlPOk5ybu5fbFHTVl
	 14Bz3uaiCZklgBvUbEY17gnYAWe+HjEpu6WT+YH1lvBXuQODARjvXzNxutxdrdUcTcW/4
	 Unm7q0TGwS72U04ovlvOZwVe9pc6VC1tjeM0NtsPeWULJ3rW4DrUh74CTjIV9cL0H4LRA
	 kcVuQxEehJ64hjGG672cBS+prB0HBhbXFURGiFjiwhXN+1ckW+2G0SI9wuSbhvqGU6hIX
	 GQfLRnsA4kFop9J+I2Oa9n38ExWn9Z3o4Qe/LD1HYM51k3ZeLvvTTCqFIvJDNRubZig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BBZnHvO7LnkEI68DrKtIqmLtzbUC4GNqbFp3A7n+3Mo=;
	b=AN2Ojbx9uD+y7PtlhLd+DmJjejh3t7thW/jqaa+/ALV8C1UfTXQRhxWzzQg+O3y59FSD
	 0Noc6poSdJjJOrini05HgwrzcxvxXuH61wUSbAv16j1ObwxxIOBMQWzDsZZSwb9nPTPw7
	 avUtgmp7uRaQdfYN7s1mjJwdiFLDKol5QA6LwJaYmHcZAGRUglN+jaMAzEvHri7d+NTnj
	 ht8bK49E1J5cXZjuF7qtona/Wxbv0Wt/Yy54cufpRArEMD9E28R5/2zW/6AmmLD4aJy9A
	 xyRNjlJSI2eYWYHvUhvVs7alQELttlIsPvYabE4Vh6YtuIb/iuf977Mwdit8GiOLc5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r1YeU+Ka;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788D260A2613;
	Wed, 18 Nov 2026 18:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r1YeU+Ka
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837EF1F000C5;
	Wed, 18 Nov 2026 18:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027375;
	bh=BBZnHvO7LnkEI68DrKtIqmLtzbUC4GNqbFp3A7n+3Mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r1YeU+Ka0bRy3nMDmgiHhQBvZ/T7MyNDRPCQxE6szlLmwsyjix4VRhV7W3CggiIY4
	 fTw9X+xuQ8TSOQXgiX2yv4eDwjNjOt1lCTjNjjpDwcMqmHurzhK/lbQHhUfDCSs/7q
	 ksTuSFRCo+9ihbwUfobwRGaAnBhi5YeZsBqdjchY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Ambrozewicz <aambrozewicz@nvidia.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1766/2151] gpiolib: clear the event clock flags when a line is released
Date: Wed, 18 Nov 2026 15:58:21 +0100
Message-ID: <20261118150226.169294312@linuxfoundation.org>
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

From: Adrian Ambrozewicz <aambrozewicz@nvidia.com>

[ Upstream commit d35f61581ee67f8d4d58c325bac813cea528b6b9 ]

gpiod_free_commit() clears the flags that a request sets on a line, but
not GPIOD_FLAG_EVENT_CLOCK_REALTIME and GPIOD_FLAG_EVENT_CLOCK_HTE,
which gpio_v2_line_config_flags_to_desc_flags() sets from the uAPI v2
line config. Once a line requested with
GPIO_V2_LINE_FLAG_EVENT_CLOCK_REALTIME or
GPIO_V2_LINE_FLAG_EVENT_CLOCK_HTE is released, GPIO_V2_GET_LINEINFO_IOCTL
and the line info changed events, the "released" one included, keep
reporting that event clock for the free line:

  GPIO_V2_GET_LINE_IOCTL, line 1, input, event clock realtime:  ok
  close()
  GPIO_V2_GET_LINEINFO_IOCTL, line 1:  input, event clock realtime

The flags are set before edge detection is set up, so a request that
fails in hte_ts_get(), for instance because no HTE provider handles the
line, leaves GPIOD_FLAG_EVENT_CLOCK_HTE behind as well. The next uAPI v2
request rewrites both flags, but requests through uAPI v1, sysfs exports
and in-kernel consumers do not, and the line info then shows the event
clock of an earlier user for them too.

Clear both flags together with the other flags of the request.

Reproduced under QEMU with a test GPIO chip: after a released request
with the realtime event clock, and on a kernel with CONFIG_HTE=y but no
HTE provider after a failed request with the HTE event clock, the line
info of the free line still reports that event clock. With this change
it reports none.

Fixes: 26d060e47e25 ("gpiolib: cdev: allow edge event timestamps to be configured as REALTIME")
Fixes: 2068339a6c35 ("gpiolib: cdev: Add hardware timestamp clock type")
Signed-off-by: Adrian Ambrozewicz <aambrozewicz@nvidia.com>
Link: https://patch.msgid.link/20261012-gpiolib-event-clock-v1-1-aambrozewicz@nvidia.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index a0a0d8ca6d82e..3fb738f61bf79 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2519,6 +2519,8 @@ static void gpiod_free_commit(struct gpio_desc *desc)
 		clear_bit(GPIOD_FLAG_BIAS_DISABLE, &flags);
 		clear_bit(GPIOD_FLAG_EDGE_RISING, &flags);
 		clear_bit(GPIOD_FLAG_EDGE_FALLING, &flags);
+		clear_bit(GPIOD_FLAG_EVENT_CLOCK_REALTIME, &flags);
+		clear_bit(GPIOD_FLAG_EVENT_CLOCK_HTE, &flags);
 		clear_bit(GPIOD_FLAG_IS_HOGGED, &flags);
 #ifdef CONFIG_OF_DYNAMIC
 		WRITE_ONCE(desc->hog, NULL);
-- 
2.53.0



