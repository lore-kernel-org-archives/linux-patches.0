Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DB146DFEF;
	Tue, 21 Jul 2026 19:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663995; cv=none; b=gtbSMPPpPpRJPGzOUQlenHh/uMmd4HnsODlufxJEif1J+SNmRJnhujL44GBd5qrL6lJSnkDzsl7cEnyrPh+AeWh0OJTNFe9FtkPnt4UsxM4l6yqL+5N6k7RrdeKICXd+1xPTvPPWOKHT67Rt7F1KvjbRzW6WyeB7x/fVbVAooHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663995; c=relaxed/simple;
	bh=9HYbrXx1FQihLx3clPEUCMu3hUIydJz7DpxF4mTXgpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRIaDA5PnrCC0aJya0AiazwTklyd5lLzf1ZhqcWi7ebiUi75jaA5umxUgJaBEnIBI9VAxkUHDoDyznrakx9fwYKCJ0Dvs87+tNvjKCTIJxRNB6+u4+i0Ro8wFxozvaT7A7xIaIvU6nvniqoQbAZYKgjpOsyB3GeLY+cI+/ropKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DRkR6EuW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DRkR6EuW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6C31F00A3A;
	Tue, 21 Jul 2026 19:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663993;
	bh=Zz9Bnq0MX+Ceza/shgW6wi3H66DiAMrwX+s/Eil4ye0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DRkR6EuWr4Nq88NorflX45b5LOBo7iji8gJ+wWGBMOvIhTIopWgz6KuSmj6EurLxO
	 YoN89+YQ8t7fEezIzoYfjFVV6yq5zDdPMwrs8bOxfVhE28BSt5JzRSVSw2Sbp+Vnca
	 UHJIzkVuosadi+tBvey/o3B+EQRS8fxQZIc40L2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 1033/1276] Input: ims-pcu - fix potential infinite loop in CDC union descriptor parsing
Date: Tue, 21 Jul 2026 17:24:36 +0200
Message-ID: <20260721152509.107992416@linuxfoundation.org>
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
@@ -1687,8 +1687,9 @@ ims_pcu_get_cdc_union_desc(struct usb_in
 	while (buflen >= sizeof(*union_desc)) {
 		union_desc = (struct usb_cdc_union_desc *)buf;
 
-		if (union_desc->bLength > buflen) {
-			dev_err(&intf->dev, "Too large descriptor\n");
+		if (union_desc->bLength < 2 || union_desc->bLength > buflen) {
+			dev_err(&intf->dev, "Invalid descriptor length: %d\n",
+				union_desc->bLength);
 			return NULL;
 		}
 


