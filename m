Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FDB403B1E;
	Tue, 21 Jul 2026 17:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654914; cv=none; b=DdEWUFLExYrMBEUxUt8DmKjnKQmR8yQyNaCp+5sTxA7/0m9Rf6EwN3DvKpQmrRvAOa4l2Ycpd8jTGsWJPdTno7+/DI8/MnQwJFP64Q7+c1SLaCpFPbtat9xOTIVp/6iZSb4WvpTQyrb85THorswvhooXfiRp8CnAIUb6vPWZ8zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654914; c=relaxed/simple;
	bh=fbkSiEBL9IYrbXbGmAh1JipPzxtBQukbNlE/Hxkam7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rsZps4FQRSSQXiJnakeYOu4Vc5YO3/1bzsP21a+0DmqlYSdZSxMfxTYNoMTEexuWPCQ5mbW6uVZtTcuPuXODu93U82ty9UOT2zlaIaakvabIS4/JKW0n1QTBTkX4srNU+QEN8YasEE2C0bPMJzn4IZQvbxQQHdCvMfZgKEnjs08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D+Tb7rZI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D+Tb7rZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD951F00A3D;
	Tue, 21 Jul 2026 17:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654912;
	bh=DIxuyAfr3N/S4s+jrpXkTTIcgD4IhtskmonnI3H+hgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D+Tb7rZId8jFFMeBOThzljGJ+6fUbcOJ3oy+ztAEReJ+r5cUSE12awP8jZzTKxspp
	 70u3njy4tlnAUaZm/nEYTiCJfLeNpawZRbNw91ItDlAyOUeXHhwvQKHgakdhfaEYdK
	 w4dtCHbD5IV3UGP5ZRbgEVBYw2VZhr6Pv4Zt59HM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 1883/2077] Input: ims-pcu - validate control endpoint type
Date: Tue, 21 Jul 2026 17:25:56 +0200
Message-ID: <20260721152637.136232209@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit baf56975806534268e24acf9a8abb1c447ce11e9 upstream.

The driver currently assumes that the first endpoint of the control
interface is an interrupt IN endpoint without verifying it. A malicious
device could provide a different endpoint type, which would then be
passed to usb_fill_int_urb(), potentially leading to kernel warnings
or undefined behavior.

Verify that the control endpoint is an interrupt IN endpoint.

Fixes: 628329d52474 ("Input: add IMS Passenger Control Unit driver")
Cc: stable@vger.kernel.org
Reported-by: Sashiko bot <sashiko-bot@kernel.org>
Assisted-by: Gemini:gemini-3.1-pro
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/ims-pcu.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -1709,6 +1709,12 @@ static int ims_pcu_parse_cdc_data(struct
 		return -ENODEV;
 
 	pcu->ep_ctrl = &alt->endpoint[0].desc;
+	if (!usb_endpoint_is_int_in(pcu->ep_ctrl)) {
+		dev_err(pcu->dev,
+			"Control endpoint is not INTERRUPT IN\n");
+		return -EINVAL;
+	}
+
 	pcu->max_ctrl_size = usb_endpoint_maxp(pcu->ep_ctrl);
 
 	pcu->data_intf = usb_ifnum_to_if(pcu->udev,


