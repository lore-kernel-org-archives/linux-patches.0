Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774576;
	b=uQxP7taFdC2jZ2jtlr71AQSVCRSWBLh/f5mbsYpcCKslT87I0aWWMTcmnkWIUDkSSo4h
	 zIufpcvBixi88inKBSONIQWtARIsVCHdQUuelA4o2mHOBRztsVutAiFGv41ZflVZHZ2PN
	 x5aK9uniRCSTkdr3gAZnC5YDlHSWKdZy4MeIMSuWHT4hRhjgK2uXfDXQq4LYFGXHfapIA
	 GjVmw0aFWSL1wBI8aOkXvaXtZcEuEnq0AfN3mK11qPI+dPysHaQD/uT7zNbojqElQb7Qe
	 D++G690MIsjmnxloMQ8lkdzpVF6UWwpSFPS37H5vEtfeu8NDBwkKvBKo1zk2GToqgOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774576;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s6cd17LVpbh19h5/fzMxVXm37iIFhLm/C3hEAivIKfg=;
	b=DOWnn9VTT2qOw/sM0AC7p+dGf9MJbQ1f2G/84BZSAL1JX6h/zcVszjtFHKReUnxiirSL
	 pu8TOOqDHuUHaMVRxPRes7qqRlj3ulPG6pgtDTMRfFnT94Yf21ZJEK0azicHRt5yLZeym
	 fdCCH+3hyN9xbdSc8ho2Ul8dxU/HwE1MUQ711zTx4+tgrVGsZQK97G85SbUzjSSoV9Rc+
	 8qOP+NSHE9mypME1wFwv+P8+ZLUZ3IAk7u7sWL5rucEAraaIEYnvBGdFuZIZvjQEBqatk
	 G/csjrZAiDYLFkYFTcT/PcrT5HRXnxed0YjGlP3/FxBBA5qKuJMN65bN76bDosQXRuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s5WeL2AB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272A4606A31B;
	Fri, 23 Oct 2026 16:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s5WeL2AB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76CBF1F01825;
	Fri, 23 Oct 2026 16:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774576;
	bh=s6cd17LVpbh19h5/fzMxVXm37iIFhLm/C3hEAivIKfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s5WeL2ABTEKDpu7LbWS+/sv2TPYTdwZ2jrjsFnPtrvYi/wjkf5iGPEpAGwcAqS4Kr
	 Cz5zzPpOpK9MQOdlr7Qh+nENN8YPdRyvgm3xEhYW8wg02dSJd/iX8K761mQKDXLmPu
	 ZKco8VTQSPNsTSJhARQigbxawumxaHi/OEeJPQLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Kent Gibson <warthog618@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 085/242] gpiolib: fix memory leak in gpiod_set_array_value_complex() on error paths
Date: Fri, 23 Oct 2026 18:38:47 +0200
Message-ID: <20261023163715.788475062@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 28f7265c5d569..6e8bcf0d9da00 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -3954,16 +3954,17 @@ int gpiod_set_array_value_complex(bool raw, bool can_sleep,
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



