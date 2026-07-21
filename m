Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E365443D503;
	Tue, 21 Jul 2026 22:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674383; cv=none; b=tjMHda6OjWFJn3dUBZsazVeNQ9dm9sEDn4FOStUwspkaTeSpOdwxQ2IWzt/iR8OgyfkMfJthpd4YVHF9KSpMQOu4qrmPE1mQNtgB5JtacD00/uWP+d/NFiiPuC8OpuTdb2yeL8XVIlpoJZ/x2pvGdKETAtE8KUq0vFJxNKdEcXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674383; c=relaxed/simple;
	bh=JflcinndMX0oT0rxT3hoLfk3+ims4pjwNtu1bJ7PJEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZXsLotkUitcWwQR42esyUdXM/q7/klLE5fenknkVJmkF1xauoQX0yhd1tApU6Fcde1U5jdW3WdDd+UY35PGRbCOFw9WW3lQsBZeR3vcUet7WkPeWe2rsuWVKw07dvaWWXDV+BKcH0VkijlX8hSFRWhsRKXFktpWkF3PosnCWmX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dQ9bVOqz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dQ9bVOqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B101F000E9;
	Tue, 21 Jul 2026 22:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674381;
	bh=StAwVFsKXgLEx9jY6/G1UPQcYSfehBtqZ9yi1hKrwYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dQ9bVOqzkUmrVlpJPxrRDmpPa3m16FKi8qKCqWtEYUH/FJIbVQodD1NN+fHhsqYtQ
	 lDvkXyqSOPUfYVG+tUTwEL/YFAWz0fFUiINxSyLBCngOc55wzhphtrHcSsdJT6nZ9+
	 4h0OyZziWjhSiW3c5tTWb6oPoowHoMLj8WsIxaIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 520/699] Input: ims-pcu - validate control endpoint type
Date: Tue, 21 Jul 2026 17:24:39 +0200
Message-ID: <20260721152407.427238990@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1676,6 +1676,12 @@ static int ims_pcu_parse_cdc_data(struct
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


