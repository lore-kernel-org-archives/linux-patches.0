Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035040;
	b=R9tuNtWrJ0E3fllS4wKgu0+fioTzmjWEkkNkRzxLOxFdtP0DOGY3TOJgldGJqYGmjQu0
	 0UxnZjE/xxvnuE4dVObUtMoiGcB0eDCZrPakUR5HNlweIPZruOa4DxhWGA8WIgApprmKA
	 bZR7DpkvhDRNcHQzOAT2XSN2CoM/Sfi6yS0wsp2qF6sp4egaRmsiR0yFC4sWjrLTiFfbk
	 d1izkODXwfxVeaKoKW/4BNHKs2tmyflQi+H9v7DB8kAIy+N51BRk9pkEaKuB9SRW7BC+X
	 M7tRXFAz11Ub9HCIgwI/ItocjnJbE+Pvr2RjUEgVlMTgu7+Es9PGSb1k2xoPH7ZIxXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035040;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e2MnYaAX6SKE93WTLAXsvw6am92lEg+puQKnnIvUdxs=;
	b=McrdpX4DIRB3KxJS6fQPTT25CyhOCeOgMXKcXBs2OAd7c+LJC0W21ZSA/ce3EqpCIntw
	 8Ka3bec57HX6qGi34UBvZMFnEvN+FpFNecMfObrJDiqScNw2soZGgwGad3H+IuXgCQ3yC
	 ZlZr8nzB5PrCLtkvE5WeN7faFlM+SnU6MLua3Yns//LaN1oHqyUuQIhjgOBXrXO7hqEXC
	 o7XKV+5e71L8Jw+QcV2E4dYuRNDmnMBHCbZ9Kgb2lTHv99kamOpd4aL7M+lobKM3Wkhzu
	 Ime7LgXjCBQArky8WcxxGgeYoORJ1xvnN2jMrQa9NDKYmyqT8DhqxLYaUpXvUdYUJMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NryeX8PL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936BA606A31C;
	Wed, 18 Nov 2026 20:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NryeX8PL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC48B1F000C4;
	Wed, 18 Nov 2026 20:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035040;
	bh=e2MnYaAX6SKE93WTLAXsvw6am92lEg+puQKnnIvUdxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NryeX8PLLinpB0RG028l0plF6++FARTI4rZ22DVixb3EGsoTAA8eB4eJyV+M82Puc
	 Ti9q/HvjDtz4Oz80K+HON7K937i7FNrL+WuuQ4Y0JHiEq3778yW9zbul/BpRkWjBGE
	 x5nTwlybdmHgKDBoWFPLxJbS7WC8kZzBaruAkmuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Wendleder <gonsolo@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 0582/3318] wifi: b43: fix use-after-free in b43_bcma_remove()
Date: Wed, 18 Nov 2026 15:20:04 +0100
Message-ID: <20261118150334.987124368@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5659,6 +5659,7 @@ static void b43_bcma_remove(struct bcma_
 {
 	struct b43_wldev *wldev = bcma_get_drvdata(core);
 	struct b43_wl *wl = wldev->wl;
+	struct b43_bus_dev *dev = wldev->dev;
 
 	/* We must cancel any work here before unregistering from ieee80211,
 	 * as the ieee80211 unreg will destroy the workqueue. */
@@ -5673,14 +5674,14 @@ static void b43_bcma_remove(struct bcma_
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


