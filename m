Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD3643CEFA;
	Tue, 21 Jul 2026 20:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667468; cv=none; b=aIsU+iiD6KENyVNG7Z6yOkxRVcpDedbTiaf0g9D+CMgSFAboW3kLYbL9bn0WhE1FqL1w6qPPsIGlN6/ZieIvwPdFviwqgBnS/oN0eGXF+XukjpdyLRMSKNgISDCG6KwHwL73IR+8138NvRIk2uyYRtoB2GIn15J2wDY2OTec5+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667468; c=relaxed/simple;
	bh=f2+GhIm16YOl6bewkXz/CI8L8BkANGKAhkAZNZo8LRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EEKtgV4civ2RQau636em1wpNnP/kuhdOZwMSOB7PJqQuYgElVTNGxqc5X3iYL6vlKA6rpV+pt1mL3GDYNZkoe+vqiIaunYjptyO3weWeQKT1mDv/9+QcHoTtbMICDy/8UkP/5q18CZLMACj2bf+YiqV5UAfTVPT+x5Tol4ZSq6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HM9kvGeN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HM9kvGeN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A911F000E9;
	Tue, 21 Jul 2026 20:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667461;
	bh=nmni4wdce7Naxv+NvtLoPNOtGQHEzawjy0S7zUqYGU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HM9kvGeNppmJ/wvdj1lBIYjbFpXUba71PIpN2vy7pJUQabeEX1hQD+f2gIcTYVQ0Y
	 uV/NVu0rtICoA5QaqR5tklrfz7SJ0WUJyf/OFMIE/jtY0sPHq6Na78KnSkLIqE5ULX
	 qV6qy0H2WqzWYKLD04W+Y9K0qC+rkStNffJUv6gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 1071/1266] Input: ims-pcu - fix potential infinite loop in CDC union descriptor parsing
Date: Tue, 21 Jul 2026 17:25:08 +0200
Message-ID: <20260721152505.785039842@linuxfoundation.org>
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

commit d4579af29e67ca8722db0a1194227f8015c8981d upstream.

The driver parses CDC union descriptors in ims_pcu_get_cdc_union_desc()
by iterating through the extra descriptor data. However, it does not
verify that the bLength of each descriptor is at least 2. A malicious
device could provide a descriptor with bLength = 0, leading to an
infinite loop in the driver.

Add a check to ensure bLength is at least 2 before proceeding with
parsing.

Fixes: 628329d52474 (Input: add IMS Passenger Control Unit driver)
Cc: stable@vger.kernel.org
Assisted-by: Gemini:gemini-3.1-pro
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/ims-pcu.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -1675,8 +1675,9 @@ ims_pcu_get_cdc_union_desc(struct usb_in
 	while (buflen >= sizeof(*union_desc)) {
 		union_desc = (struct usb_cdc_union_desc *)buf;
 
-		if (union_desc->bLength > buflen) {
-			dev_err(&intf->dev, "Too large descriptor\n");
+		if (union_desc->bLength < 2 || union_desc->bLength > buflen) {
+			dev_err(&intf->dev, "Invalid descriptor length: %d\n",
+				union_desc->bLength);
 			return NULL;
 		}
 


