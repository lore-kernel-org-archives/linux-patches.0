Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CAD22FF57;
	Mon, 10 Mar 2025 18:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741631046; cv=none; b=pmsf8O6S86hnFoCwcJAXVkwG+4HhdBM29AmZfx0u+rCKT+JvsFxKBQkl7lO9i4JvaABib5rgzxmTIexw+LnCueZ3kdkojHr3cbc9/evvLmwahvaIoU38neFCgVtE/eL+nzQj/8mHl33XexkW/LhaAQS/Z5j8U/ghWMHXrtky6V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741631046; c=relaxed/simple;
	bh=imqqZ7d6CVFqf5c0gfG+OHTgeo2IIHFGExwgrgT5DRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MCCcelRc2OqUGz75xA0zomH7xV3ni4Fc0gwMHeaj6r+r757zHRJQw6apDLiPTWllC0FkdkkplCSiIJ4w88+IO2X1o1TXKzOfUDiEzDjwQ2rKD3bOSGK9dtHROKDLKq+lZJyZA1fUIaD6SB4z0/WXbMAakGH5ZsMpbe8QtVM46CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yiKlhRI1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yiKlhRI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AC1C4CEEC;
	Mon, 10 Mar 2025 18:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741631045;
	bh=imqqZ7d6CVFqf5c0gfG+OHTgeo2IIHFGExwgrgT5DRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yiKlhRI1Nuwy8cM5iU70qHDi3M1gCm+SLD/O+eiW02WqgVwnAdN4jp9FqY48OO5AX
	 Bz/hGbYPFdNaN6QfeSySyWtMlLttTvWXprZv6phe4vnwT33lECxjZdSw4S32arBgXI
	 Q5AiL/ttx2YHQAJ8FvdFOP/8FtMqVMmPPL8vWRto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Prashanth K <prashanth.k@oss.qualcomm.com>
Subject: [PATCH 5.15 593/620] usb: gadget: Check bmAttributes only if configuration is valid
Date: Mon, 10 Mar 2025 18:07:19 +0100
Message-ID: <20250310170608.941771608@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prashanth K <prashanth.k@oss.qualcomm.com>

commit 8e812e9355a6f14dffd54a33d951ca403b9732f5 upstream.

If the USB configuration is not valid, then avoid checking for
bmAttributes to prevent null pointer deference.

Cc: stable <stable@kernel.org>
Fixes: 40e89ff5750f ("usb: gadget: Set self-powered based on MaxPower and bmAttributes")
Signed-off-by: Prashanth K <prashanth.k@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250224085604.417327-1-prashanth.k@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/composite.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1005,7 +1005,7 @@ static int set_config(struct usb_composi
 		usb_gadget_set_remote_wakeup(gadget, 0);
 done:
 	if (power > USB_SELF_POWER_VBUS_MAX_DRAW ||
-	    !(c->bmAttributes & USB_CONFIG_ATT_SELFPOWER))
+	    (c && !(c->bmAttributes & USB_CONFIG_ATT_SELFPOWER)))
 		usb_gadget_clear_selfpowered(gadget);
 	else
 		usb_gadget_set_selfpowered(gadget);


