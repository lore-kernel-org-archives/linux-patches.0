Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F68D25E813;
	Tue, 11 Mar 2025 15:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706649; cv=none; b=uf8lriSGQwcOVb3qjVD/9nnj97C2WM38wus6sfIjwBSL4xMUF5bBAwFYjjSWVOhYBMTSzQi0vY2BlEL6WKZBcFOd1sBSDGSCJpkXVT2fdf0ZgAWzF3YU1cxKpdfIFEmq2WZY9OmnzRleIHtlpiu7lJuap362/I/jllWL4cjL9+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706649; c=relaxed/simple;
	bh=3piwH3z7wFM9OWET56uBmNJqXOpqT8+tUBO+Pq9DTtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAts2qMnkiJKYn6oAJl6rtSCn/c/QlFPSQ/c7TwBG0GJMsFgvhVkLm30gcLQkYKfbof54xGPgQCEK2QqsnI44xd5jrPaM/i0TcigtQx1N2Oi/OPveJ7Xr3bqz5ch3CsBzoNSUT1t0+5k9APQNHCLPILV0j/KE5YaKed+3DtVUdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fuTeNWGK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fuTeNWGK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC5A3C4CEE9;
	Tue, 11 Mar 2025 15:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706649;
	bh=3piwH3z7wFM9OWET56uBmNJqXOpqT8+tUBO+Pq9DTtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fuTeNWGK/hFucicFMHTyH/NQKE16bVTlEAwk/CK/Wd8zUyVvSoaRZNmJBvp4+rAE6
	 +yrO6OdPbFS29ZUmWgrgJoUlwdrBqnCeul/4QlEd7PchXUAymAaVs/JQm7GtM6KAUX
	 ZNVCr5xkC0YYCx+UnF2KhjtYbotbxOFdfZBT/wog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.10 120/462] usb: gadget: f_tcm: Fix Get/SetInterface return value
Date: Tue, 11 Mar 2025 15:56:26 +0100
Message-ID: <20250311145803.100644845@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 3b997089903b909684114aca6f79d683e5c64a0e upstream.

Check to make sure that the GetInterface and SetInterface are for valid
interface. Return proper alternate setting number on GetInterface.

Fixes: 0b8b1a1fede0 ("usb: gadget: f_tcm: Provide support to get alternate setting in tcm function")
Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/ffd91b4640945ea4d3b4f4091cf1abbdbd9cf4fc.1733876548.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_tcm.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -2102,9 +2102,14 @@ static void tcm_delayed_set_alt(struct w
 
 static int tcm_get_alt(struct usb_function *f, unsigned intf)
 {
-	if (intf == bot_intf_desc.bInterfaceNumber)
+	struct f_uas *fu = to_f_uas(f);
+
+	if (fu->iface != intf)
+		return -EOPNOTSUPP;
+
+	if (fu->flags & USBG_IS_BOT)
 		return USB_G_ALT_INT_BBB;
-	if (intf == uasp_intf_desc.bInterfaceNumber)
+	else if (fu->flags & USBG_IS_UAS)
 		return USB_G_ALT_INT_UAS;
 
 	return -EOPNOTSUPP;
@@ -2114,6 +2119,9 @@ static int tcm_set_alt(struct usb_functi
 {
 	struct f_uas *fu = to_f_uas(f);
 
+	if (fu->iface != intf)
+		return -EOPNOTSUPP;
+
 	if ((alt == USB_G_ALT_INT_BBB) || (alt == USB_G_ALT_INT_UAS)) {
 		struct guas_setup_wq *work;
 


