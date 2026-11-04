Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827074;
	b=0WWTLxtVxbxmn84084sNeQ+t+dB3FBs9/e6wmQKzwl3Ja8RcJAqzjF15PryBy2yeuy3H
	 1ZX8naqN52i3mnd6HTM3zS+k9zF8lcTFgqgijFlBj0LW1XYsnOMmCytRIBigYXWrDKUci
	 mQjCmBOoB6D2eZlhyTzHYWALNAj9Goi/SDVYqT5T3uXMj8+vGroEZx3jD4DNg+qNvj0Aa
	 VtvZW/E0KD72iWpe0AAy+80jddVIY4Ng77AymVCPc+a+Q/tVN0VbzBk7qRiW1K4xVTQXP
	 Xt1dbA0i1UdQjS1bpVV/q6q2CddAdmivMyHSEY8nnGuxnvRqfKPEShnRkI0Ki4ImM1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827074;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k7Qe4RgVYv1jCrxIRfb5vg6jfMPD3q0w/cM3sVe/nUQ=;
	b=D1jXI6JmhZ24/M9W/wc3oP+oofsYIduJgooklz+0skvELcsmEOzGnx4GDY0NOlB4IPEH
	 YAA3BFZxRsiyV9osdAGhybnxGGK3PZFAUmHqYPKX96kPJZSlYpi8q+xic8VTaC0oeZfeT
	 AGxeKL2XKNO8kdAh2tku/X7smNQ5IYwi2jjn/dqI7Mcy77kSTOTMhWm0MJAeyjRE2Zfkv
	 Evnts3yH+F+8ywvNgzlIEHmZNnjXgKisYKSqJJdrQEWmt1jZiCrGlAaYdMTnfAVtRKt9q
	 YKL/YXvWRdiK0OVm7NBZppRUp0UovqLezcas3eg9LS4fY8NShob9YF9DiIVPbedelQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yugCgxI3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C08606A86D;
	Wed,  4 Nov 2026 21:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yugCgxI3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FFFB1F0093A;
	Wed,  4 Nov 2026 21:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827074;
	bh=k7Qe4RgVYv1jCrxIRfb5vg6jfMPD3q0w/cM3sVe/nUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yugCgxI3zvTJS92YeKsInfSv/iCdsIwIk5E9fChz33ToMBWy1hXXl2jdn5Ahe05Pg
	 XZwUzrfk2cbqvJP8yjnKvRg6mPvBANIXRAU9xxF0IwLfuZVLE8vG/wOXMwPV+9TOPb
	 f3MpGjORU361FTjEzglP+uHEQQMQCUO7vF4F4juI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Wendleder <gonsolo@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.3 140/547] wifi: b43: fix use-after-free in b43_bcma_remove()
Date: Wed,  4 Nov 2026 16:05:24 -0500
Message-ID: <20261104211042.151993248@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Andreas Wendleder <gonsolo@gmail.com>

commit c6c8bc355657115664131b38c53c5ddf7d93b072 upstream.

b43_one_core_detach() frees the struct b43_wldev it is given the bus
device of. b43_bcma_remove() then reads wldev->dev again to free the bus
device, which is a read of freed memory.

b43_ssb_remove() does not have the problem: it takes a copy of wldev->dev
at the start. Do the same here.

Fixes: 96838d61102a ("b43: Fix memory leaks in b43_bus_dev_ssb_init and b43_bus_dev_bcma_init")
Cc: stable@vger.kernel.org
Signed-off-by: Andreas Wendleder <gonsolo@gmail.com>
Link: https://patch.msgid.link/20261013000124.48605-1-gonsolo@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/b43/main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/broadcom/b43/main.c
+++ b/drivers/net/wireless/broadcom/b43/main.c
@@ -5677,6 +5677,7 @@ static void b43_bcma_remove(struct bcma_
 {
 	struct b43_wldev *wldev = bcma_get_drvdata(core);
 	struct b43_wl *wl = wldev->wl;
+	struct b43_bus_dev *dev = wldev->dev;
 
 	/* We must cancel any work here before unregistering from ieee80211,
 	 * as the ieee80211 unreg will destroy the workqueue. */
@@ -5691,14 +5692,14 @@ static void b43_bcma_remove(struct bcma_
 		ieee80211_unregister_hw(wl->hw);
 	}
 
-	b43_one_core_detach(wldev->dev);
+	b43_one_core_detach(dev);
 
 	/* Unregister HW RNG driver */
 	b43_rng_exit(wl);
 
 	b43_leds_unregister(wl);
 	ieee80211_free_hw(wl->hw);
-	kfree(wldev->dev);
+	kfree(dev);
 }
 
 static struct bcma_driver b43_bcma_driver = {


