Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A71246326;
	Tue, 29 Apr 2025 17:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946161; cv=none; b=FXHYd7H/h2sAtQz21rYxMrnG4gJ4vBR5FsPzlfOHtCIfcKSSLxxb6AG6a3ASFn4uPxkZmRbVZlHyP6c0l++JQzX2rHwDj8VEDXx2G4EniiwT5BsWoWbnJJEs73wQb6WN+cNx35O29rDtSuySTZjowp78P9zSDAaqBgoMxj2ky2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946161; c=relaxed/simple;
	bh=w+AMD5QeMTEaf6tcvzH/kTW4MUvmKVHI92MG3vTaQqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h9NxMoQ7Sl14FXVPyh7y9KznZ2eE5L2TgW8YskaIbBE5SjvhSxrSZWd+aINtxDbIF1yIposqs41xEtNlT/NLzvMYe9CCs9ZoXyEiDfnMtCqf89HM3qIAiX+nURl4ILmJc6Mi4c+w5Huhj55RRGJWqB+GuQddnyDV02b/3xIj2g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x3XDrJF7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x3XDrJF7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB196C4CEE3;
	Tue, 29 Apr 2025 17:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946161;
	bh=w+AMD5QeMTEaf6tcvzH/kTW4MUvmKVHI92MG3vTaQqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x3XDrJF7dUS3tsWVckPyx9aIpBi5Stf39wNbLHrC8PdtfAhlbtmlw0hwbJiUwCFi7
	 IYDrLBGHufvWOHMvhlWQVaWl54Kn6zTpE0JIJFrdxHOouuwqx3QdOv3+oYuAPlJmuC
	 R5X735PUoLweXlkMhoogCs5AMHsNqpyyEaBLkHik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.14 175/311] USB: wdm: wdm_wwan_port_tx_complete mutex in atomic context
Date: Tue, 29 Apr 2025 18:40:12 +0200
Message-ID: <20250429161128.198684566@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


