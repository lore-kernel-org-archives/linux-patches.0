Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D233A6B7F;
	Thu, 30 Jul 2026 14:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421543; cv=none; b=oAljInsQpFkZNx/JS8YNH7BZngdcN3v6bbG3OnlQ51Z0ypf5ViHiPXAcucKbEo1g57sOI+x1T0tBsVJ4CRr/aIcxg1TI6w+Gu/xBEl/MpkhVErGUtdF42ERvL+6wnqysjgn2Jo12D2THw+lPnEKbQjqE+YtNdV+/u5V9CYbzLB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421543; c=relaxed/simple;
	bh=FhgkGMj523oao3TzN7mB2COGfFAptm/72I6BsqX+/II=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FyK/08Oz/gLE7nAn0eczkyJhSkhZXu26y94oLsQ/rh3DWfvd28y7hO5HsQb0D0GjdCBFEnFSS7zUZR6Tn6t6jJVS6LvfykLn3bkWLOoRQkkZUgqArjikr3MyakIIV71u5Y8QnBNbYig22r2bAGVBADqiHay9FVehJXnKy1xoVyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r8ikBeqb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r8ikBeqb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D8981F000E9;
	Thu, 30 Jul 2026 14:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421542;
	bh=PCZE3d0/ePapUhozN5FmoOLRmAqSsgu35o73eAr1GYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r8ikBeqb8ITFRkADIiNJmhomgNOxChJ8WP0N6C+jHk424d+BSkSI5OgoQebCFwEq1
	 MB5ooe5QrTFEytxRebD3dCupgIS+4MqpSeyEiiSH0LE+uqdgPHExFfBmjli3CH/Ucj
	 GyBIZFFPQwC9wOAjwAHUglio1aXbwuWSXhMS3kbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Guangshuo Li <lgs201920130244@gmail.com>
Subject: [PATCH 7.1 140/744] usb: musb: omap2430: Do not put borrowed of_node in probe
Date: Thu, 30 Jul 2026 16:06:53 +0200
Message-ID: <20260730141447.258808135@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit c947360ae63eee1c9eacc030dd6f5a53f717addf upstream.

omap2430_probe() stores pdev->dev.of_node in a local np variable. This is
a borrowed pointer and the probe function does not take a reference to
it.

The success and error paths nevertheless call of_node_put(np). This drops
a reference that is owned by the platform device, and can leave
pdev->dev.of_node with an unbalanced reference count.

Do not put the borrowed platform device node from omap2430_probe().
References taken for the child MUSB device are handled by the device core,
and the ctrl-module phandle reference is still released separately.

Fixes: ffbe2feac59b ("usb: musb: omap2430: Fix probe regression for missing resources")
Cc: stable <stable@kernel.org>
Reviewed-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260713114711.955253-1-lgs201920130244@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/omap2430.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -454,7 +454,6 @@ static int omap2430_probe(struct platfor
 		dev_err(&pdev->dev, "failed to register musb device\n");
 		goto err_disable_rpm;
 	}
-	of_node_put(np);
 
 	return 0;
 
@@ -464,7 +463,6 @@ err_put_control_otghs:
 	if (!IS_ERR(glue->control_otghs))
 		put_device(glue->control_otghs);
 err_put_musb:
-	of_node_put(np);
 	platform_device_put(musb);
 
 	return ret;


