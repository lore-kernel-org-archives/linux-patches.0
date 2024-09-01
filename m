Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C40817E46E;
	Sun,  1 Sep 2024 16:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208218; cv=none; b=rsf1qIlMWgL9W4HDvG4foaux+UafE2yiUwUWf34dlIasj9sXMFYlQeVSsKM/LjHz8CTCMncatMQQDLEIQwkVAQgwsjwFD2tHKEUoueZke7nEKnxfViWXAl63bSqc3y2BBIy6TjRFOItwlXrxYaIv1lpupYqgLyzJy2pCOqcPXfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208218; c=relaxed/simple;
	bh=CHNZQSIdmpqjlEL2phEnShEUaXKZYB2Yq1Ih8Gkd/JE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O38FEofcL/gEAQ494Uy3seWpWfqxkB+dhYjP6W4xp62I2rAc73Ane9vWlQoyLB0DvaLRjaS9IiRQvnb2asKF9v500id644DYkRZbZcmZ1/ytlZHN+RqpZ66CGl78USz9bSS2oySVKgvL1bKmuWm45gpV58LGGemnKCmInWDF0oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bJGx4VD2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJGx4VD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE312C4CEC3;
	Sun,  1 Sep 2024 16:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208218;
	bh=CHNZQSIdmpqjlEL2phEnShEUaXKZYB2Yq1Ih8Gkd/JE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bJGx4VD21CC0iG/lnW1Lm0Z9tjkSaDhXRkzfyr7UD6kwPZVSBAykZZFLoxqEPBXaQ
	 BgAVH3u/GjePKQJZATb9N+h37EhykFGLa3Wvh5uhsFw19D4mzdHx21PZsC8XbcUPF4
	 D4jw1zFldyjmdZxBobDwplHG2MVuYd0K3Wq+5CXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= <jerome.pouiller@silabs.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.10 015/149] wifi: wfx: repair open network AP mode
Date: Sun,  1 Sep 2024 18:15:26 +0200
Message-ID: <20240901160818.040873135@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Sverdlin <alexander.sverdlin@siemens.com>

commit 6d30bb88f623526197c0e18a366e68a4254a2c83 upstream.

RSN IE missing in beacon is normal in open networks.
Avoid returning -EINVAL in this case.

Steps to reproduce:

$ cat /etc/wpa_supplicant.conf
network={
	ssid="testNet"
	mode=2
	key_mgmt=NONE
}

$ wpa_supplicant -iwlan0 -c /etc/wpa_supplicant.conf
nl80211: Beacon set failed: -22 (Invalid argument)
Failed to set beacon parameters
Interface initialization failed
wlan0: interface state UNINITIALIZED->DISABLED
wlan0: AP-DISABLED
wlan0: Unable to setup interface.
Failed to initialize AP interface

After the change:

$ wpa_supplicant -iwlan0 -c /etc/wpa_supplicant.conf
Successfully initialized wpa_supplicant
wlan0: interface state UNINITIALIZED->ENABLED
wlan0: AP-ENABLED

Cc: stable@vger.kernel.org
Fixes: fe0a7776d4d1 ("wifi: wfx: fix possible NULL pointer dereference in wfx_set_mfp_ap()")
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Reviewed-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20240823131521.3309073-1-alexander.sverdlin@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/silabs/wfx/sta.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/silabs/wfx/sta.c
+++ b/drivers/net/wireless/silabs/wfx/sta.c
@@ -352,8 +352,11 @@ static int wfx_set_mfp_ap(struct wfx_vif
 
 	ptr = (u16 *)cfg80211_find_ie(WLAN_EID_RSN, skb->data + ieoffset,
 				      skb->len - ieoffset);
-	if (unlikely(!ptr))
+	if (!ptr) {
+		/* No RSN IE is fine in open networks */
+		ret = 0;
 		goto free_skb;
+	}
 
 	ptr += pairwise_cipher_suite_count_offset;
 	if (WARN_ON(ptr > (u16 *)skb_tail_pointer(skb)))


