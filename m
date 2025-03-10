Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024E1233D89;
	Mon, 10 Mar 2025 17:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628489; cv=none; b=QiCEtWyImq6YhN8dTgNfuBGmT0tR7ZREMSJGOuxHzlybO5S+6+1cKu9njMiavTqjAIoQ/jkdO66Z98Zdsv640GJAnzM4M9Rg5KvKEJjjBlIHWGJ34qItRUKxEJYAdooWVdM1pEL8ianS1Al0wrXMUrmw9zKTn2vNyDbXU4fmNAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628489; c=relaxed/simple;
	bh=9HEveZKMPd1bYA6968LtGWsDqIeZxzPMRT35vA9ocaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n03rd+OCDt/7ZH4gsp0mAkVA3n2SyIgh3K0uy4wm/rYJ7Fpi00vUrN4mX0+eoxXyPtzFdALr9HO86Ox1OGYn/2JrAF4nI5n2wuphpOAu785JkcsxPxhxng+scnqbz7pImIPo+kPfd0s+ROUr1KpLstwrjuHIBAqZ2WF8zhe+0Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zrTkG0wk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zrTkG0wk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E51C4CEE5;
	Mon, 10 Mar 2025 17:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628488;
	bh=9HEveZKMPd1bYA6968LtGWsDqIeZxzPMRT35vA9ocaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zrTkG0wku4xRSnQkk7ViMzB+xgEYEXe9eiTC2PEXQBVt2+MIkkUWUI1y52P6wHkMN
	 t6fxQP0rx8zJm/bmMKE8ai1m3AQTuM5L25YXY6fz89JedD+CTjNcRVVbVFSen2fVkQ
	 DngEL9qXTRkFw6TvQQJepALuqEWbY0RdJaBXjkjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 6.1 075/109] usb: gadget: Fix setting self-powered state on suspend
Date: Mon, 10 Mar 2025 18:06:59 +0100
Message-ID: <20250310170430.544896416@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit c783e1258f29c5caac9eea0aea6b172870f1baf8 upstream.

cdev->config might be NULL, so check it before dereferencing.

CC: stable <stable@kernel.org>
Fixes: 40e89ff5750f ("usb: gadget: Set self-powered based on MaxPower and bmAttributes")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20250220120314.3614330-1-m.szyprowski@samsung.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/composite.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -2491,7 +2491,8 @@ void composite_suspend(struct usb_gadget
 
 	cdev->suspended = 1;
 
-	if (cdev->config->bmAttributes & USB_CONFIG_ATT_SELFPOWER)
+	if (cdev->config &&
+	    cdev->config->bmAttributes & USB_CONFIG_ATT_SELFPOWER)
 		usb_gadget_set_selfpowered(gadget);
 
 	usb_gadget_vbus_draw(gadget, 2);


