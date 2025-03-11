Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAAB25D8FF;
	Tue, 11 Mar 2025 15:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707575; cv=none; b=mwV1LV+OWAdmILd+bN3E5iIJQsLTJFv0V9JEUFKe0XnNi3gtzNNe3OKmazYdCaRH4GQOrILzwExKx+znfrI8mQLXhOFRhJw3oUouh/VqAc2BJ4rDwx/vd/Ju8GTgTb1hmU5+lqZVjApqLHpL2arAVTCQ0AI1Uu5yk8DxROUSpuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707575; c=relaxed/simple;
	bh=rLRRot7LQSSJiy/gdVQJ6jEIVlK6gTNDz1k64p/5+wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U515zD5uvMQjAO4gNxiYhga7w6dWtOBFMn33PX7WiEyYyyvhD7sGOVXevXTfkP0PQ6+3TsQ8pTznRCcSPDttqhcoMdbC8bAJooCcxxUWTuJPRRtpQ0zOzs1ShvdBKjZa0HV2CbeQBiFR0HuhtZgSkAuYyHMp6vOSANec3PNko5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2VHJyFmN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2VHJyFmN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7F7C4CEE9;
	Tue, 11 Mar 2025 15:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707575;
	bh=rLRRot7LQSSJiy/gdVQJ6jEIVlK6gTNDz1k64p/5+wQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2VHJyFmNqREpK15yB1ABH3ssJmidu8D9/Q5gaPN+unwpRJBdO677++P1oki7b1JeW
	 inuS5HOIWc2Y8GZmLd8hvvC3RlEg03aMZO2ySWDeRau0BWGg518ZW0Ox6tnEq+5Eud
	 G459Wde/hDPqzi4caHxWiVOWUOzuqm7Z6GkKfZM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Prashanth K <prashanth.k@oss.qualcomm.com>
Subject: [PATCH 5.10 435/462] usb: gadget: Check bmAttributes only if configuration is valid
Date: Tue, 11 Mar 2025 16:01:41 +0100
Message-ID: <20250311145815.517649641@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -916,7 +916,7 @@ static int set_config(struct usb_composi
 		power = min(power, 900U);
 done:
 	if (power > USB_SELF_POWER_VBUS_MAX_DRAW ||
-	    !(c->bmAttributes & USB_CONFIG_ATT_SELFPOWER))
+	    (c && !(c->bmAttributes & USB_CONFIG_ATT_SELFPOWER)))
 		usb_gadget_clear_selfpowered(gadget);
 	else
 		usb_gadget_set_selfpowered(gadget);


