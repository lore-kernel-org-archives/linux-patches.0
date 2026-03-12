Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987E4344DB5;
	Thu, 12 Mar 2026 20:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346829; cv=none; b=eyGVDhwu3Y/Z3mpo9THoc5qztf7lNEOHGrARPUbGfr32+wWHFCpINyXBaLH7tjMxtQAAMEJgTUxdIe5ZMqV+O/jpTuPs9M092KMJfs2UA+Y8LTKA1mYxx/XNFVr+hpKdKckLY2oIHwG/FNYH1nVoyPa564j/rZXEmprwbRFlgd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346829; c=relaxed/simple;
	bh=NFpG81YhNrYrCJoQPUHz1UKQ/zUGNys2p0xqbtAMgG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGH7ve0NWiOn/nZ3h4pG38tfdplfzcsOf0pA9fjShsYkKtos8GhmNzHRNPM9PnLCxuXKfCFD9FE+518sSDVjCMHLXvsN1wRQ2/LVDSN/Jdoil0VwqXtU1dHZcmZ4DDnvkvNvNLeqE3zBYJO0IBN7CN6yDHoaIfBwNExyZ/GLDuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lkN+VKOJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lkN+VKOJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260CAC4CEF7;
	Thu, 12 Mar 2026 20:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346829;
	bh=NFpG81YhNrYrCJoQPUHz1UKQ/zUGNys2p0xqbtAMgG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lkN+VKOJCh3G+PqxpK4PHdVWL3vpuXZq+X8/Qk0MJlhjrQLZXSbfeFNSbsAMp1wu3
	 w55dKNFLorzacxeHBPIoSfqsaEAsBK7YtXS8fCb0yGT1AXnPT54teHUth4sTrR5S7x
	 6INhO6T4ZHHnZQspiek8cCObyQFDiFZcLE74J9bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	stable@kernel.org
Subject: [PATCH 6.12 136/265] can: usb: etas_es58x: correctly anchor the urb in the read bulk callback
Date: Thu, 12 Mar 2026 21:08:43 +0100
Message-ID: <20260312201023.166728340@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 5eaad4f768266f1f17e01232ffe2ef009f8129b7 upstream.

When submitting an urb, that is using the anchor pattern, it needs to be
anchored before submitting it otherwise it could be leaked if
usb_kill_anchored_urbs() is called.  This logic is correctly done
elsewhere in the driver, except in the read bulk callback so do that
here also.

Cc: Vincent Mailhol <mailhol@kernel.org>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: stable@kernel.org
Assisted-by: gkh_clanker_2000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Vincent Mailhol <mailhol@kernel.org>
Tested-by: Vincent Mailhol <mailhol@kernel.org>
Link: https://patch.msgid.link/2026022320-poser-stiffly-9d84@gregkh
Fixes: 8537257874e9 ("can: etas_es58x: add core support for ETAS ES58X CAN USB interfaces")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -1461,12 +1461,18 @@ static void es58x_read_bulk_callback(str
 	}
 
  resubmit_urb:
+	usb_anchor_urb(urb, &es58x_dev->rx_urbs);
 	ret = usb_submit_urb(urb, GFP_ATOMIC);
+	if (!ret)
+		return;
+
+	usb_unanchor_urb(urb);
+
 	if (ret == -ENODEV) {
 		for (i = 0; i < es58x_dev->num_can_ch; i++)
 			if (es58x_dev->netdev[i])
 				netif_device_detach(es58x_dev->netdev[i]);
-	} else if (ret)
+	} else
 		dev_err_ratelimited(dev,
 				    "Failed resubmitting read bulk urb: %pe\n",
 				    ERR_PTR(ret));


