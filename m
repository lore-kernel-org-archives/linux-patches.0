Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207545;
	b=L4GYHTQ/GnoqEIDg44rpoSjIv792ugrXdwQvXi++s1BvZzU6QkC5gnaAHnJqS6V5xLck
	 FfaHNfIJiNqbxtq6Bcs8ewTkdcrxsBWAagsgeVODddlpowKNulPq3iZWLvyyQePKx3cU2
	 dta9fMIgV+b0W4rjPglYF4xCh/kHLjMeoz7gItcMYsO18qw1waLfA+vyo/tRgzZYavqOE
	 yPojT2mdSZPLbf9Mnt7mG3z8YnMlwo5JOw8yDJJdpSDAcArVEbnjciUQPY/zWpcGWoN/t
	 LZ/KUFPbqmC6DVammpg1rbeg8b28ShPlYFeMeRr8IgmtQw0fwOkDzO+tOWmjD4xm/tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207545;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/oD/UFztmMZ3rTf+m+5u66VZHhAt42uiqr9Cq4GYhGQ=;
	b=vZi3jIN6R8jbkqO/mFroh2RqEJEDp9RfF2K9EGbBjfdm0Q8fOZ3lhZzkFt8Ql/qR4GRF
	 oDtyqg+VCAW/l322xYrTp/rnEOggy+rqEaVgYPeUfd46kQv5cL//M/H0Z8nOIe48Pxras
	 wqDqGbwtHygbtPSHXH5YJuE5kAN48vIp3w2Q5PQm2ZnIrLo1DRkT3nFE31K1gztnOJybY
	 z7F2UzWRll73Rdk98MtmRn1eJB+jZs0VlcAQ/w862g/k4wPfgvJDmtD7Ssc+EGzLW91Eh
	 BgGYgh9fO9Q4ivAiyknO3tfhu9m/BOhnNr36PgWByFoFPQFk8AFch8VWJSwHpuPx1xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=phzOicMK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCEE606A31A;
	Wed, 28 Oct 2026 17:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=phzOicMK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5031F01825;
	Wed, 28 Oct 2026 17:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207545;
	bh=/oD/UFztmMZ3rTf+m+5u66VZHhAt42uiqr9Cq4GYhGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=phzOicMKebpPnVZLgWX8YK/W//6EDwZ4ZzA3tmcLtLZ55SJsWxfy/6+EAZoUf6N+7
	 4jhLL3ITgnFNdebMzvDn4dS+i9dNdu+6/wSTwEqiVZgIX+zQh9fujZjb2GnFG/PCsm
	 0wfHszw07XtBHr7x16EcGlGXHXBLvjGU8+TGyo1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Kent Gibson <warthog618@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 054/247] gpiolib: fix memory leak in gpiod_set_array_value_complex() on error paths
Date: Wed, 28 Oct 2026 17:57:37 +0100
Message-ID: <20261028165948.657900962@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Gibson <warthog618@gmail.com>

[ Upstream commit c28846ca1ac6134881114d272314623c8433e372 ]

A drive-by review by Sashiko reports that, after a failed call to
gpiochip_set_multiple(), gpiod_set_array_value() returns abruptly,
bypassing the freeing of possibly alloced bitmaps, potentially leaking
memory. It is an unlikely error path, but is possible.

Defer the return code check until after the bitmap_free() block.

Fixes: 9b407312755f ("gpiolib: rework the wrapper around gpio_chip::set_multiple()")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/linux-gpio/sashiko-outbox-168233@kernel.org/
Signed-off-by: Kent Gibson <warthog618@gmail.com>
Link: https://patch.msgid.link/20261015025749.47039-1-warthog618@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 144f1e174c545..bffdaa91d86c5 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -3578,16 +3578,17 @@ int gpiod_set_array_value_complex(bool raw, bool can_sleep,
 		} while ((i < array_size) &&
 			 gpio_device_chip_cmp(desc_array[i]->gdev, guard.gc));
 		/* push collected bits to outputs */
-		if (count != 0) {
+		ret = 0;
+		if (count != 0)
 			ret = gpiochip_set_multiple(guard.gc, mask, bits);
-			if (ret)
-				return ret;
-		}
 
 		if (mask != fastpath_mask)
 			bitmap_free(mask);
 		if (bits != fastpath_bits)
 			bitmap_free(bits);
+
+		if (ret)
+			return ret;
 	}
 	return 0;
 }
-- 
2.53.0



