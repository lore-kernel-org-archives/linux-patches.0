Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F449257851;
	Mon, 23 Mar 2026 16:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282227; cv=none; b=uwRpe0PBct/OuiGe1syrHZcfRwzEraJIthhe/XO/2XFcd9hUNKjWgkwIPL4f62HFReDlXK27aLPFXtik0UfLdOD1/kf7a5bTzUV0uzkbAbsFg1XbvHQhpey4FTg0F9Y1giDQrsuInoureXWM9btnkpouR3Xevc1Zje0AwMAK/jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282227; c=relaxed/simple;
	bh=Uqbv+vmMDx1znaRiffxJeXwlwjLfqdXzQrY2N6d44rI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHG9/o0Y5xu0w1iPsEFwr1bWyfFqB1T/6QcT58DOdEHzqMX6tgDpy82CuoJ1QIgUCgatwz6HIAcTTujJu6XOspq2dJvEHVQ/fS2vMNrkDnncJFvt0BCieZnk5p7FqMr35+Lmklq29/5NYU11rKYN/XbxyMlEa03lMCBzyLT6+40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b/fhgLGv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b/fhgLGv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9430C4CEF7;
	Mon, 23 Mar 2026 16:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282227;
	bh=Uqbv+vmMDx1znaRiffxJeXwlwjLfqdXzQrY2N6d44rI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b/fhgLGv112f2WXwhZmfBzBs+FTd2mxQSEqDA0r49E9iXSTD5/piJ0HinqSsjO+WR
	 Oc3WK7Gow79JaJDlPByZghFiPPvEyoj9VE+3VVR0wLTjuwRHKXr9QUfwNikKF1bZnT
	 lk4i7FYvrocbTWYKX7lQQxPrZxvem9nGUwQnchFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	stable@kernel.org
Subject: [PATCH 6.1 077/481] can: usb: etas_es58x: correctly anchor the urb in the read bulk callback
Date: Mon, 23 Mar 2026 14:40:59 +0100
Message-ID: <20260323134527.108434251@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1460,12 +1460,18 @@ static void es58x_read_bulk_callback(str
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


