Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090F64071E3;
	Tue, 21 Jul 2026 17:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654930; cv=none; b=p/e9ORsKGmDM7uBVjj198gOCsFLvE15PuJKUuDpPTDv7yzwOt3Wk1aPtzvYdRboghifz+dnpzEeSlFI5g+aB/1QPaBB4Sjn8kYnAexxAtt4xP1bugZesKuUIgWHI0C/M2Kv2LAs4JSXy2exwjlZAtZK2j24/bGYCFDe+JT28d70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654930; c=relaxed/simple;
	bh=sDGDv1RB4zuSPOJ5TqUbRsLhru6WQZMas05RQ4UUHHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sjge/N6B3mbkkTRBrvRe5LDRg+laDYwIlW9QMciCndkvHk2EAQ5a2n50rORGu5eQ2F1ultOVM13LUk92duAkEPE+Yd6FlIDqzAIPXTS/1IXC7WxRFdwc4AHGQ/1HJU5BWxqP4mXI8QVXbtsH4aA05uoW8zIdgi33HRA9tp6O5vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OvS0Ny5C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OvS0Ny5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2573D1F000E9;
	Tue, 21 Jul 2026 17:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654928;
	bh=32pi14mI0izoSHDdV39EgwLk8JyB/yXgMo23IS94BfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OvS0Ny5CW2MTU2KlrVnsdJaqIZQ/QfOXMujZZRUIcx2O42HsWVRYfCrcGa91fRkRn
	 +1qAQaPwbj1+XIE9ANNRlyc9r0+npTY+Ta2lSh0a0Yi5k9TqR6jvpjpJMw442IDvCg
	 E0Tp81SoBFAxLxjzAlasYMs0CVGLruaYW6YzlKzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 1889/2077] Input: ims-pcu - fix potential infinite loop in CDC union descriptor parsing
Date: Tue, 21 Jul 2026 17:26:02 +0200
Message-ID: <20260721152637.277480057@linuxfoundation.org>
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
@@ -1707,8 +1707,9 @@ ims_pcu_get_cdc_union_desc(struct usb_in
 	while (buflen >= sizeof(*union_desc)) {
 		union_desc = (struct usb_cdc_union_desc *)buf;
 
-		if (union_desc->bLength > buflen) {
-			dev_err(&intf->dev, "Too large descriptor\n");
+		if (union_desc->bLength < 2 || union_desc->bLength > buflen) {
+			dev_err(&intf->dev, "Invalid descriptor length: %d\n",
+				union_desc->bLength);
 			return NULL;
 		}
 


