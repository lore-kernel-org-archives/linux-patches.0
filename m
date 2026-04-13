Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5027D2F6931;
	Mon, 13 Apr 2026 16:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097216; cv=none; b=mKCRw/5Ql/+DaA1Km7NApZUVZTi4xy5ZHm4g0/wkIyNVHVbtLZrDHdY1tiQpBY7HUzgHgPoh00YFPxbnp1HVesFJLedGk2ZKszP7eP8zB6BW4EGCt6ynBHcbSji3N1V3x9RhGQBOrNtc3fA0X33FGJwFx0/EHlBrEqZIjJ++9LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097216; c=relaxed/simple;
	bh=SHKfes1oVR7sGvA7fpYSDJziw2PjHIX1mQSOkPFFdIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwfwC3zs7wIFb3ZJqUtqJxC6C5mNOpXK5uPsz6TgUNS+OazZV4LPrpdlhfg4gE6i0k9BLgqh/dZSwuxpaDJKekOot9xjzVBKC+KHdan/o6vTen+R05GEuslieuj7eHWvM22fs38WV9sxczPel8dV7NgKAdBha/mKkyje9UZNoyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8claS9X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8claS9X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA54FC2BCB3;
	Mon, 13 Apr 2026 16:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097216;
	bh=SHKfes1oVR7sGvA7fpYSDJziw2PjHIX1mQSOkPFFdIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z8claS9Xc2289jecwp25TZUCeHKX4F16DVt20bHT61u50JUvvnPMxFk1KPvT39UPW
	 NkyuPFJjbeHEXYwRQDVvUfjPVuTZ8pCWxRu/dpTiQKZJX/98HlXK/PF4UoOzdZ0CfV
	 3vCkLnvcVNd25IgqlM0qqZ+4jdm/hIfEqEJdzAeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	stable@kernel.org
Subject: [PATCH 5.15 049/570] can: usb: etas_es58x: correctly anchor the urb in the read bulk callback
Date: Mon, 13 Apr 2026 17:53:00 +0200
Message-ID: <20260413155832.277856643@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/can/usb/etas_es58x/es58x_core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -1467,12 +1467,17 @@ static void es58x_read_bulk_callback(str
 			  urb->transfer_buffer, urb->transfer_buffer_length,
 			  es58x_read_bulk_callback, es58x_dev);
 
+	usb_anchor_urb(urb, &es58x_dev->rx_urbs);
 	ret = usb_submit_urb(urb, GFP_ATOMIC);
+	if (!ret)
+		return;
+
+	usb_unanchor_urb(urb);
 	if (ret == -ENODEV) {
 		for (i = 0; i < es58x_dev->num_can_ch; i++)
 			if (es58x_dev->netdev[i])
 				netif_device_detach(es58x_dev->netdev[i]);
-	} else if (ret)
+	} else
 		dev_err_ratelimited(dev,
 				    "Failed resubmitting read bulk urb: %pe\n",
 				    ERR_PTR(ret));


