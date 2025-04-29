Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E71421883E;
	Tue, 29 Apr 2025 17:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947939; cv=none; b=qbzZJWLKxYyLXKhKj/M5zs+gAFQg2aCQQkZqI89BHW9LcKUa7INUQgHUxUY+/3NNeKSw560gZPzvq7HkpsALrvV4RuhYEwLSwMX2DCpAb5VkLWNoijLDijf7QNc2m+9+5JAZFmGFoGEhXOdeBdTT+BRuV0CpWR945IYmBFQlHno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947939; c=relaxed/simple;
	bh=2RxM8alxVG6n+hNYHd+5KKy4DlXETaHWykob08/MBpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EnONIzgNUbsTlngI1vHuJpuVuPYY+pWkn8z4vL04WOtGUCmnk5wMlh/r7/aM7gSQYakHspwpY9A9S3qYPuwhGyV0x99UzMPpxGYLyPxVN8k3Ko8U0OD5zpKtDDVatN4aX0A5IfZb9uk8bjgnzoOP5/PZlOBSgESfguV+QlXJ7+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v+V+fsN6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+V+fsN6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE368C4CEE3;
	Tue, 29 Apr 2025 17:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947939;
	bh=2RxM8alxVG6n+hNYHd+5KKy4DlXETaHWykob08/MBpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v+V+fsN6dtm+zRoPr402dYGJoLotbxvDp17+esUl5umgpqcWTL3ABS6r6zvlxQYO4
	 oQYWKsPVyxyd5qC+hMInzshu7aGX3NdLqXDWoVR9pf0Za4aPW47gmokA7mIrG1EYn/
	 kE8v1N4HBBHhYM8NVaptp+J8VBvAAiYiNBzufhmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.12 150/280] USB: wdm: wdm_wwan_port_tx_complete mutex in atomic context
Date: Tue, 29 Apr 2025 18:41:31 +0200
Message-ID: <20250429161121.258253796@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit 1fdc4dca350c0b8ada0b8ebf212504e1ad55e511 upstream.

wdm_wwan_port_tx_complete is called from a completion
handler with irqs disabled and possible in IRQ context
usb_autopm_put_interface can take a mutex.
Hence usb_autopm_put_interface_async must be used.

Fixes: cac6fb015f71 ("usb: class: cdc-wdm: WWAN framework integration")
Cc: stable <stable@kernel.org>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20250401084749.175246-4-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-wdm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -879,7 +879,7 @@ static void wdm_wwan_port_tx_complete(st
 	struct sk_buff *skb = urb->context;
 	struct wdm_device *desc = skb_shinfo(skb)->destructor_arg;
 
-	usb_autopm_put_interface(desc->intf);
+	usb_autopm_put_interface_async(desc->intf);
 	wwan_port_txon(desc->wwanp);
 	kfree_skb(skb);
 }


