Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2630B40C03;
	Tue, 29 Apr 2025 18:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950003; cv=none; b=XfD0pzat/KMYF90icGe6PufFnGT3KZehM89kZzmvwMNNdjTsZZMZjhcSFsf/P+sPj7zoH9xbMYkhPP6wH3QTAj9AzyZMl8FKx5HEwIYycbx3CJD3oTEhxhNbHDuBpSHVZQFe/lCVMG8O4H54LJGTgTpLJlyABSHqilxI+2alZLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950003; c=relaxed/simple;
	bh=9SG0UWbXuUCE+mv0SKbz1QpH+eauLrUmyksjYMBPrbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gnHSqUHWg9rLhX+TTOCq7lINkzlfB7Y61FK+hvAbBQkIkqmfiDrfBdo2BVBItEAKUI4W641uhOZiT8prwvBppr59Q8J+g826WKG2vpKW4zEZndyydxh8FvOTh182fNtNFhSmVaBdI2IYt9uq/XqCIskRy1OId6rf1dgKaMGMCq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1XAzsN5e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1XAzsN5e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB871C4CEE3;
	Tue, 29 Apr 2025 18:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950003;
	bh=9SG0UWbXuUCE+mv0SKbz1QpH+eauLrUmyksjYMBPrbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1XAzsN5eJwVuExvqyOuMJsMbH6j3GFd6v0iCYkEo3m1CN3VyADbA4HQ7+2dNlXYlN
	 0mTc9JzPyiJGVhaONKGrWZYGnW+3U+xLNVGHOv5AFo7IspXansHbi/C0qPidE61qqd
	 tw11XPkqUNJutngJpE5+wONgDOh+cVgMqo6LHmQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.1 095/167] USB: wdm: wdm_wwan_port_tx_complete mutex in atomic context
Date: Tue, 29 Apr 2025 18:43:23 +0200
Message-ID: <20250429161055.600274802@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


