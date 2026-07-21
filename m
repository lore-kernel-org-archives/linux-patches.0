Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013C743B6E1;
	Tue, 21 Jul 2026 22:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674394; cv=none; b=nx6vdc5ZIz9FHxtzFsEc5uQII4b6JKQiERVxsBq7u/3R1LtTbo9bKwpg7yuAX0/ukN1Ir8bfbLF6gTl9HXuuf1K5U8lpaAw/a/usI0Vd0lXewGOmSzU8DOkD1FormZPhuTVv1+7e3ISy89YmhJEqbFinGgqe4VdjwmNaEghS38I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674394; c=relaxed/simple;
	bh=HQxnzGSO5jSq3JJHHudFuRgSlVL27Hhyx0Sizad7fO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R6kUJT4xTiZ7bMR+gl1Sfu10yppzRXsZl6NM8tHXCUgOTB5iusfZoNmdcqZ2+G4gE4cpqoQIDglGID/R7Tk6HE9zw3X8cqRJQa5n2d3iYIcQtSqJkmx0K8Zg0iX59OLALx46udUqVkJavGu6lS4oueq5hvqmflEIGR4Mwdaf9Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D1NCoOZU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D1NCoOZU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37A11F00A3A;
	Tue, 21 Jul 2026 22:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674392;
	bh=nAHcNV8msLSgNUiqoEKtTrXT6grS/MoDnJ0TdTHn/3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D1NCoOZUQE02NrPU4SNp7Pg79BSzyLFIERddajh0912DyYXV5stMFX4UgMGzZR3g3
	 5uV2uUG+tMJBbmfiUumEoC0JYPTJZtsnTv6NWJVxyK1PH4vCTWjqm6fUyyyuihuxOK
	 XYGPwbkzv0VTmcqBB0lfJgMIj5oTkCryBd9gdCjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 524/699] Input: ims-pcu - fix potential infinite loop in CDC union descriptor parsing
Date: Tue, 21 Jul 2026 17:24:43 +0200
Message-ID: <20260721152407.514545217@linuxfoundation.org>
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
 


