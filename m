Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773922;
	b=S0UVvjfrjIMMy90kqxeRaiUc7dGcYRlNmp70WJf9QFjc0GtO/jlw1DjW50ZRwE3JTxtZ
	 6dghLBUJ4fFHjpFHF7DkkXWKWzm18un4eOCNBlzI0GQ3WuO5IoTOspzPXQihM5+vlLzGM
	 FGsf8qXRaGSq59l8SZk3bhotZ92fASi8vZQZRDGI8iV/XFqS2ujQTAoyAvaHRplWEG6zP
	 WCtInZTpXlaCae2sIG9YNkMayfAyk8NZJEBkWRgrHt4hhapy3nk17TJZ+qPwND5xGSKZC
	 zqJImNJRHMdJl26N4/yklgZZg6ZYL25dBu0Tf2iQdeT1tvAUJQbJxH6jGsnjToDJ+Yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4ap+k0vTYW6STMcG4y5acq0QYTHKWsTM8JkGZu7OTXc=;
	b=HBkglW829QrA3UrJ39EYYO4hqeNbDD2KTlnziRSDHBM8ke6n8SOGx91HzDqDMkj96v/F
	 bGIkj+xij5iTBeObYHtnXd3cFELP2Y7T+ZjMhJoo8jxhOigVP/StzzKWjo1ZyTrwumw3E
	 mY3WF2vfpiJafBpNdyeMFSgubd+tqKGJG473mCk4fEuTclN/IoW0y7rWYksjE4yP/upOK
	 p05pfe3IAsk6Qn3YMP8ozJBbGZrm3v0KgMaNFkTW7ssMzFBaEQRREMiPVbTIRwlUYboGh
	 /aadlCKVbgugJHNFNY75RiIVq7OujgyihvbEFnHP8f3ksKj1tNTbZq6I1rFBYA7Bkqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RKYhjqrj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA20606A31E;
	Fri, 23 Oct 2026 16:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RKYhjqrj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BAC51F01829;
	Fri, 23 Oct 2026 16:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773922;
	bh=4ap+k0vTYW6STMcG4y5acq0QYTHKWsTM8JkGZu7OTXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RKYhjqrj3aJaNtl3TpZnJ7FNiFQLu09ylPr0yplcg7EDqMFWp4Z5SrqgUbMSxo2vh
	 UaxxvnOW2+kzO99YkyfHSEV0tDHAn5PTOPP6jzRL8pZQG68c2zWyliq4uyMVOX8aSO
	 CnkIRBDqFe7ZgU3PHG5gmQ0xu69sxPKNSWzH8VWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Kent Gibson <warthog618@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 062/193] gpiolib: fix memory leak in gpiod_set_array_value_complex() on error paths
Date: Fri, 23 Oct 2026 18:35:39 +0200
Message-ID: <20261023163715.672189580@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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
index 9d3c33e1c9f99..d0efcb96d2769 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -3798,16 +3798,17 @@ int gpiod_set_array_value_complex(bool raw, bool can_sleep,
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



