Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CFE29A9CA;
	Mon, 12 May 2025 18:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073428; cv=none; b=cKf/k6NL53HYEBMiCi/7CB0SfJVcuykcoVnywZ6r7RkawAECDdBtZg4sPvPRPj6FEDqP+svz16osGrfgv/r6ev/Mb6StM0z3qCtPyXtzNHOXk9nvtZqbxMX4Ntkr0x8wxEtrzt3G5BS61Kjrz7Ql5wc+coc8lCQ5ghz1ausY+cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073428; c=relaxed/simple;
	bh=k+WdecO1fhbnigWmCR5/6ziaRJmWJfoghIJ7NDh0D+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pKAXfZfysx/PYAVvBhkINvo+HJlh0WK9vctBunhaJQ/nHqxWMZES5jH6q7wdUWfAgYkFqMQSpyXuxLK7MAQJvzzFZocsxBlsObl0RBmWeP8hxLce6YhmJxNIUGfT/NCFaeaafhfWTf2zDWeOSnbnPBY//PkRBAeYBHpIuApQ3Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A1U261ry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A1U261ry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62FAC4CEE7;
	Mon, 12 May 2025 18:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073428;
	bh=k+WdecO1fhbnigWmCR5/6ziaRJmWJfoghIJ7NDh0D+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A1U261ryuGwSxi4HAhJg2iJH/N7uzgPXeh7b0GyES/ot3DFBz+kbMJwgbFCCZX0qe
	 u4ZCeW1VgKQgGMmbWz6TnwE60iv8tcum6yQ7vDMj+q+IlGmCdOfVV27E/kqahmnqNh
	 Opc20AnN0xFHe/olB9ZquOageuWvqqFzAmFX08CI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Prashanth K <prashanth.k@oss.qualcomm.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.6 071/113] usb: gadget: Use get_status callback to set remote wakeup capability
Date: Mon, 12 May 2025 19:46:00 +0200
Message-ID: <20250512172030.566470064@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

From: Prashanth K <prashanth.k@oss.qualcomm.com>

commit 5977a58dd5a4865198b0204b998adb0f634abe19 upstream.

Currently when the host sends GET_STATUS request for an interface,
we use get_status callbacks to set/clear remote wakeup capability
of that interface. And if get_status callback isn't present for
that interface, then we assume its remote wakeup capability based
on bmAttributes.

Now consider a scenario, where we have a USB configuration with
multiple interfaces (say ECM + ADB), here ECM is remote wakeup
capable and as of now ADB isn't. And bmAttributes will indicate
the device as wakeup capable. With the current implementation,
when host sends GET_STATUS request for both interfaces, we will
set FUNC_RW_CAP for both. This results in USB3 CV Chapter 9.15
(Function Remote Wakeup Test) failures as host expects remote
wakeup from both interfaces.

The above scenario is just an example, and the failure can be
observed if we use configuration with any interface except ECM.
Hence avoid configuring remote wakeup capability from composite
driver based on bmAttributes, instead use get_status callbacks
and let the function drivers decide this.

Cc: stable <stable@kernel.org>
Fixes: 481c225c4802 ("usb: gadget: Handle function suspend feature selector")
Signed-off-by: Prashanth K <prashanth.k@oss.qualcomm.com>
Reviewed-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20250422103231.1954387-3-prashanth.k@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/composite.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -2011,15 +2011,13 @@ composite_setup(struct usb_gadget *gadge
 
 		if (f->get_status) {
 			status = f->get_status(f);
+
 			if (status < 0)
 				break;
-		} else {
-			/* Set D0 and D1 bits based on func wakeup capability */
-			if (f->config->bmAttributes & USB_CONFIG_ATT_WAKEUP) {
-				status |= USB_INTRF_STAT_FUNC_RW_CAP;
-				if (f->func_wakeup_armed)
-					status |= USB_INTRF_STAT_FUNC_RW;
-			}
+
+			/* if D5 is not set, then device is not wakeup capable */
+			if (!(f->config->bmAttributes & USB_CONFIG_ATT_WAKEUP))
+				status &= ~(USB_INTRF_STAT_FUNC_RW_CAP | USB_INTRF_STAT_FUNC_RW);
 		}
 
 		put_unaligned_le16(status & 0x0000ffff, req->buf);


