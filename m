Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65CC46EC78;
	Tue, 21 Jul 2026 18:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659077; cv=none; b=H7CXFCZcbMOrijHwJC1qvqJlH7JM7j66H+UVzmdqclnuiZvdDYOStS9bgJ22ePdZzg0lnoTXnqcIeg+mbDgsaYcksJvjayQxbHm0eqt8xgUKSIlbcUpuSNj80KOutYQF45UM9em5NOl+8op/kCly+4LYyS+bOQ4l+dFvRJXs3rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659077; c=relaxed/simple;
	bh=cgPjk5KyF+MsYMtGqkO9xt/gg3m0JSXF+yCSevdakOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L4bZOW9nJ720UYEq9V8iyGzGs0o0D7mMOjyhWM6O0NkThZ7w3+nz/u8AdLR45GWEOcgMI3iHMRHoiCdKc1KfQZhprIv+ILciUP9/TcpOWPfMY9vnNceTiJxNCDY1hqcbeARGFLV4JkBH5TFhlv74cdOZral5WLp51CmTQ1DwllQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eeU3wQHd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eeU3wQHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EFA11F000E9;
	Tue, 21 Jul 2026 18:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659072;
	bh=RaXJo/4zxTxV1WHfFQXpvoESn/D7NVyT4WKvWvvwlas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eeU3wQHd0fVcgwDGyrGjTi8QbI7GQLZNCIAnaAwIBTTkRY7e+hbOQFIJWR+/eLol5
	 jPliM5YLh0CVisIr7rSZWefEbtmX+8EAMhu7+bo4mANG0GFSoS3+5k6i4FhcEAEHOR
	 VZe7G7uOc+uhk6EAeUKM+P9F9IHQqDUfS6Dowc6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 1382/1611] Input: ims-pcu - fix potential infinite loop in CDC union descriptor parsing
Date: Tue, 21 Jul 2026 17:24:58 +0200
Message-ID: <20260721152546.526870087@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


