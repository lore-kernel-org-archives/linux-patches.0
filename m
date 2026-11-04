Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831368;
	b=45wBNlL1Xf3yuiqJFVqs6WghH7164Fim1sqq0O9cXARpL9dLv6lDicMXfdKhFiNuVmgM
	 Rvsmrd7s24emBdVT4+qTYTFjYKXL0j2dwgTC3GXpabYtEH6CioHizyUtJAsjM7Bw0ddAe
	 b8HWV1TwgNwCQVxO8tdswT91k54nwtYQxxiyHfb45l0xPGap9S2k/QTqRjuVFENUg5Ipy
	 MgDhEtfqFmElfeb0EPtLbuoa1uiMGSUf+Wta/oLsvDxizSv1GpWIdFuL11E/B8F5wRY0T
	 GsO50meY249XSI2+e+CGEcR643yBTd28dNL3mQjSQw097ANMakDdEg9cJTyByn552Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831368;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J+NeDLnU+37Ruf0X27b+NDnSCnwbsKpcT6x+dKRdTbs=;
	b=pL3wRMJH598FidE11tkTolutzxsMaGoAjIWIApr6euGpa45AkmF9FplzzAEdpWsxnAoD
	 xUEsyzxOYBR/PLT0B2IP4zdmlVqaNU04XDLjAdS+jkxj9djMTyTg1k56wy+vfOIjkV+Cf
	 yepWYuHxAw8y2BKJ8M/ud6cVXpkdxBHWaZDtjqS9k68vgoVdohddTza3YcVoFRtmvUXcA
	 HbJ5PeBFN8js6LvhXE4mVghaH9OpTNSuId1rstdzvOH/HEWKoAdZDYeJ/h55R/Q41esrF
	 oArtjR2J0r6YTfdL5UzRAXP6FltYtOdRWcuzEuWhkvhl5TAbENBR57Vrj8yL0fYccLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PDXwE++m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6010606A33B;
	Wed,  4 Nov 2026 22:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PDXwE++m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6052D1F000C1;
	Wed,  4 Nov 2026 22:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831367;
	bh=J+NeDLnU+37Ruf0X27b+NDnSCnwbsKpcT6x+dKRdTbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PDXwE++mRkOUCmIz2MjQTI8dD6ldau3lG5jBgh59RMkcdoIgnZjQ3KA3Aaf17HX+m
	 A3TaIz4ICQ0NH0x96zh72fn7iJykpb2Q1EHC5vgZi2NK4cmKQiEnOPKbPww4gjAumU
	 s7UXA8wk20gVl80S3azbzoBF2T73hCpyG3eluQqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Wendleder <gonsolo@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 0661/1005] wifi: b43: fix use-after-free in b43_bcma_remove()
Date: Wed,  4 Nov 2026 16:06:34 -0500
Message-ID: <20261104211102.197730501@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
@@ -5663,6 +5663,7 @@ static void b43_bcma_remove(struct bcma_
 {
 	struct b43_wldev *wldev = bcma_get_drvdata(core);
 	struct b43_wl *wl = wldev->wl;
+	struct b43_bus_dev *dev = wldev->dev;
 
 	/* We must cancel any work here before unregistering from ieee80211,
 	 * as the ieee80211 unreg will destroy the workqueue. */
@@ -5677,14 +5678,14 @@ static void b43_bcma_remove(struct bcma_
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


