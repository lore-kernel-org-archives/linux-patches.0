Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057737;
	b=MFcMniOe+VM4EHU3/WQLNUjOaykoLdW7+V9UsbIhqQ3KNV3R0XEa4sMzpaHo7tzYWFfI
	 q+qf708G0Hr6CoaMxvfwZAjKm4lx+M9JQBUlOGDufI5S3IgCfQ+kZF8b2cdSXSbYF5nOY
	 cb1K3loSbohSosBehwmryVE/NZfOwyECgJSrY0oWID75lXTgGwzayEY9fPG62tFBo46IS
	 3AjJLme/+5rPhnAKwoa9EjADS/IY0Z1blQGeTXCy19kKNknNKVHdDxl0Nrh1Pti0WNbtQ
	 5IWu/ysrAsJaXpDe9ssF6gydfVCzNGYGICf7Fh97zDg7hAkgF1B9Vjj7VkFBVkFcbeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057737;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FM/+wf82G9L1tQJ2d1cwEeZnYQBEZKkKRIlD4byMc/I=;
	b=r1+jVSJibUbDXj6ySzSpKo7NTbw5hsY7jhk6VXuByX6Gk0xmPiztKBOnyvOuzXYuHVoK
	 8BkPc9Q4ckSSnut2VQQOWTPgh07WDrQtBf+J7ljpYzBoqbylldz1JCaRke3f1r74tZ72X
	 pHyAYCNZrssKMllVQz7MXeRFZluRDmyGHZjQ0z/4f1NcKr81YDWCs70LOyOzSNxqR+G39
	 rm93kJWhHFok/+GqLJRO+d8yybjLQS+BZU5BxkW/Q8qNz5O21He2karcRHnwDTqgjd2CA
	 7hg1LGisOHrOX/MaPaJfUQAr0CnsL+sOjAUI+aohc2E2ZaGHAC5O2kCfpCNfoZq32eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XLhXtL0j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41598606A320;
	Thu, 19 Nov 2026 03:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XLhXtL0j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943B31F000C4;
	Thu, 19 Nov 2026 03:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057737;
	bh=FM/+wf82G9L1tQJ2d1cwEeZnYQBEZKkKRIlD4byMc/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XLhXtL0jqWx2StHXDgcZ/ITLna+cnrO1Tb4gs6FaZ5Da/a9u2U4SpBRQNWCcck9rS
	 K18sqMp+juEg/gI2ER7myA1Opw6hwJdy2yWrQsiz7du+7SYQi+uvx6XLURZGv26jUU
	 t14g6IuhgXv4xG0nHJma7rQFokchlr6wXmz9NjZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Wendleder <gonsolo@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 0237/1848] wifi: b43: fix use-after-free in b43_bcma_remove()
Date: Wed, 18 Nov 2026 15:37:55 +0100
Message-ID: <20261118145921.856941632@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5661,6 +5661,7 @@ static void b43_bcma_remove(struct bcma_
 {
 	struct b43_wldev *wldev = bcma_get_drvdata(core);
 	struct b43_wl *wl = wldev->wl;
+	struct b43_bus_dev *dev = wldev->dev;
 
 	/* We must cancel any work here before unregistering from ieee80211,
 	 * as the ieee80211 unreg will destroy the workqueue. */
@@ -5675,14 +5676,14 @@ static void b43_bcma_remove(struct bcma_
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


