Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091FE155333;
	Tue, 29 Apr 2025 18:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950495; cv=none; b=bcv2AIlWJpHx98W78XB+1kkQQRn3grVJkiVMWgyc00HNE0ddEUSKAH8vFX+0ShltDWjTW0M+Ehc8nLCfwHeyc9xunwJgbK83YJmk7RfT9cuLhqBrmVFGxaIsXO8KAVII8bv9ON4XbUpx8c/4mzsG2D4QZyVHIu8oM3WiP6b2bpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950495; c=relaxed/simple;
	bh=NBxqrnU0u+SJko2txkAvulZ3FaKIpeceqSGh/WCbejw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFtXEHPgg7jm4RKpUIIN3YCp1MR20kPk8D90DH2MuNxiK01MN89r9GzJN064IqFURIzWX5djdDLEe4D7xU5u4yH2HKgm47PK317bqBoTC52ZN0DXA+x5qmMJ+hp4qDIX5H2wLHz7Ty5yhDjc8A/PIA4e0eA63A8fQmQdXmyGf5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bG/sIkax; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bG/sIkax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A111C4CEE3;
	Tue, 29 Apr 2025 18:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950494;
	bh=NBxqrnU0u+SJko2txkAvulZ3FaKIpeceqSGh/WCbejw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bG/sIkaxcOQgoGxBuaRAx1Z0gxRMysg/ilKsAMxIrOAKjwkM41wTPrXy54zRzUqoe
	 6r9UFLZiWjUEzBBqh+HrTv1pl1wLCX+hzIPm1J3AEPr7VmtFQFKIchwz3Yr2cZ3ME/
	 sjBWsTO/9YOViLhWZLZzGeEqNw+rBrIp+Qvq890k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.6 114/204] USB: wdm: close race between wdm_open and wdm_wwan_port_stop
Date: Tue, 29 Apr 2025 18:43:22 +0200
Message-ID: <20250429161104.099664899@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit c1846ed4eb527bdfe6b3b7dd2c78e2af4bf98f4f upstream.

Clearing WDM_WWAN_IN_USE must be the last action or
we can open a chardev whose URBs are still poisoned

Fixes: cac6fb015f71 ("usb: class: cdc-wdm: WWAN framework integration")
Cc: stable <stable@kernel.org>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20250401084749.175246-3-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-wdm.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -726,7 +726,7 @@ static int wdm_open(struct inode *inode,
 		rv = -EBUSY;
 		goto out;
 	}
-
+	smp_rmb(); /* ordered against wdm_wwan_port_stop() */
 	rv = usb_autopm_get_interface(desc->intf);
 	if (rv < 0) {
 		dev_err(&desc->intf->dev, "Error autopm - %d\n", rv);
@@ -868,8 +868,10 @@ static void wdm_wwan_port_stop(struct ww
 	poison_urbs(desc);
 	desc->manage_power(desc->intf, 0);
 	clear_bit(WDM_READ, &desc->flags);
-	clear_bit(WDM_WWAN_IN_USE, &desc->flags);
 	unpoison_urbs(desc);
+	smp_wmb(); /* ordered against wdm_open() */
+	/* this must be last lest we open a poisoned device */
+	clear_bit(WDM_WWAN_IN_USE, &desc->flags);
 }
 
 static void wdm_wwan_port_tx_complete(struct urb *urb)


