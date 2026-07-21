Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF8A43F8DE;
	Tue, 21 Jul 2026 20:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667566; cv=none; b=SbW5Dw5tRSz+MGS3E9AwTxL6pE5tS8JJw7dB+LN1hv7pf2IH6ELGwdnVm2j5GO9HiVVuXHlciy4Viod89KubFcKFPuRBRXzRqa0t7j1z7ojMpbAz9zYtDWfPID4F7tn9H7PQwcPuU13tRMuioppY8IakmxqFOgUGvpyEw5r5eHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667566; c=relaxed/simple;
	bh=GLa/mJqV5RkorBjkDs9mUubSqUFUQkEWf77TLfFVtsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BrHSW9dyiRrs6srsVvwLSeqfmwA4puWEm7B1Rcj3w6W7jG3gNiLn9kkv/pwqLTIdNa+vjdAquseGaDoD2IG5yq6Dhvtx87/06fBA4ia27/i88W6sFBg7GsMAPO49nEQvErf4CpSghFK5iX3DcX46SeTeeqCb4iT5BnnBRlqypvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T9N2ZA0f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T9N2ZA0f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 100101F000E9;
	Tue, 21 Jul 2026 20:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667564;
	bh=3zne5w7NU81DLXb1F6s6LWpO6HBSm/HFDAhNhU6oNXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T9N2ZA0f9MqhIPaGWMweipoW/FvMFLfjwTntv7W/U04n4G6IEAxdd8oj+hWOKQw7o
	 TS8QGZw3DFK7yl6pnCf8GjWdgmXQQkz9Ll8WjvjLYaP1RB5P72WMxlsdt4W98p0Z4m
	 Oh/3/19CmNTw4vGtU8TBbDK4LU80l4bdfd3Pdyf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 1067/1266] Input: ims-pcu - validate control endpoint type
Date: Tue, 21 Jul 2026 17:25:04 +0200
Message-ID: <20260721152505.697124301@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


