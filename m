Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EFD249F9;
	Tue, 11 Mar 2025 15:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706272; cv=none; b=T8E9T4Dh4LseZh4y5Z4Hc3Xhpgrb2YoqGDiNiLK8aszMo3/rQihAtaCAVlya1t6tBBVUcBGoJ+hGLlnrmUcLAaXexS5CG8EZmWyH8hK2nHoNyi/merUjogJrlOQPuwDUxPyecrVek+Wkr7IYlzPpf788NNM3RUS6RNu6OiHOtGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706272; c=relaxed/simple;
	bh=94aqw5A1pdKoOTGM7TkWWa+sR/5DlzxX6XmUQa+5j9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJ4VJrL1UbID4Ginh3sYfjlbJ10xOfi6PlLr4+m4l1bKQusOTjO+uAYNc/7bu1uqPtQtS1RlPLEFLznOUa4uShn+9Dc7malaB2/0eAuEkcE7Mj0ONK18l0zBSjldwabt2v5QAPv3y23y5AtUzt25e/8T6bWKihpDgSRuIhrRDUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JoUChumX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JoUChumX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3071C4CEE9;
	Tue, 11 Mar 2025 15:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706272;
	bh=94aqw5A1pdKoOTGM7TkWWa+sR/5DlzxX6XmUQa+5j9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JoUChumXny0tRAVe22Q/NdXdkbPAaVPANToqICh9NJZgOlbsEldlEr7F/+mvjyTDe
	 OsIiSGj7odaXRgLFTEg3WG1oMZb7FkbVm9Y645SxPQu0FFZ4Jx6+7gXvt3H2xzyjOw
	 oYNX/ELdhYiUaz9tzEQIP5Cty3qew4w7zKpyVARc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Prashanth K <prashanth.k@oss.qualcomm.com>
Subject: [PATCH 5.4 321/328] usb: gadget: Check bmAttributes only if configuration is valid
Date: Tue, 11 Mar 2025 16:01:31 +0100
Message-ID: <20250311145727.657791102@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


