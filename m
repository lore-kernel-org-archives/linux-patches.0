Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FD141735B;
	Tue, 21 Jul 2026 19:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663979; cv=none; b=E6m8j6Q44utfFwOd6vFKIZMJNhaCN7K9lyO0BIS0aUjAR3hi90Ab2wIMFeoUFxtioyicUnL9CPEHUJcIE/lXNR/z6TgUKEWbucR3QhFofXLj8+jD+2M6enQ9jWf+e1OdSvNMrFdb00uLeTuQYKC92hBYUqNLv+xJSIjK6ZQl8pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663979; c=relaxed/simple;
	bh=podvp5PehA00tNiTzm3rxIMD7li1GgG0xWTRnNVXJtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGX4OYwcdBl4+fOKwpj409eksap3qDsT0pHb9wjUOtOlw+rqnxVfOQGobaTJyRIYaBmDe9Ps8vfgIR1rzBpSHl4rkNi/1LoIPq1rpuoHZCSaXDkW5AkA6KeIBxTmY9CsAZDeiy6wpneuv8oki2MsckqaUqcS8CDjAvj1/2wuFlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L/jose3o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L/jose3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF101F000E9;
	Tue, 21 Jul 2026 19:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663978;
	bh=zHOc2bTjCfiRqQXT4eFL7zCWS8qb41P70TB5XF3jBvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L/jose3oF5PPKeViL8ULh5N1++0sxIUWpJyMOhxJ51cuUvc7CxELhUufASWi/kGWK
	 MnvD37FCwGqEu1TcXT7DO9Hnek6rN3VVzlfdagnij4rIyqv11CywW7Yvic0/LJDNN4
	 nRe+ymN4ULkdRRiLcCE+FeYnohOsUk1pa3cQIxdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 1028/1276] Input: ims-pcu - validate control endpoint type
Date: Tue, 21 Jul 2026 17:24:31 +0200
Message-ID: <20260721152508.999280100@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
@@ -1689,6 +1689,12 @@ static int ims_pcu_parse_cdc_data(struct
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


