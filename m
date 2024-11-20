Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56F31A2C25;
	Wed, 20 Nov 2024 12:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107392; cv=none; b=RTNCPErVE8elWlH8EcV1dFjRuL46TaunlwmFFAABN9sYSLnQKaYTbhTTMDxb4Kvy+P0ucXtbeelR1eK58YnC6daNDO+UTWKLseifcNyglHKLXm+w43xSVPLHQFS0cFnV4KU7LDgAAc5K3GpYcRYrSn1/zwiN/bCRMqqrad1jCPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107392; c=relaxed/simple;
	bh=bm8wfbm+He6fD+0Fp/sOOWr5Yg6s37EdglFrc3V+E9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lVcq7jZQPIuwY+ad1FS6HdSpbI+1s55wLNAZYdB4O98dhQUL/gNFAa8VpujbutnJc/y1IYyyvtS1VnBhf2evtPRhrGxLB1K6CPfMvgMuMlDj5XTy99fBkEpi9svNrlW7Waz+RVjpPJFoNNaQRD1kosYki9A63bgC8j3tOfsvZOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aU7kWiM6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aU7kWiM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B4FC4CECD;
	Wed, 20 Nov 2024 12:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107392;
	bh=bm8wfbm+He6fD+0Fp/sOOWr5Yg6s37EdglFrc3V+E9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aU7kWiM6ns/VOW/yrPazmBrUi0I3VEeGzoRD77hgrlstSrpi+k+/8NqMB9XaOET5y
	 Cu2xLkOVZvsNn9zHCp4yMQFtKcycAD9DYdJr3LoNsZub9C4z+RABsZgwmehZjEhphs
	 Ppx/aogjdiXz4A8aqz+rJw6WIJuxEMMcC9QzNHBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benoit Sevens <bsevens@google.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 2/3] media: uvcvideo: Skip parsing frames of type UVC_VS_UNDEFINED in uvc_parse_format
Date: Wed, 20 Nov 2024 13:55:56 +0100
Message-ID: <20241120124100.503739172@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120124100.444648273@linuxfoundation.org>
References: <20241120124100.444648273@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Benoit Sevens <bsevens@google.com>

commit ecf2b43018da9579842c774b7f35dbe11b5c38dd upstream.

This can lead to out of bounds writes since frames of this type were not
taken into account when calculating the size of the frames buffer in
uvc_parse_streaming.

Fixes: c0efd232929c ("V4L/DVB (8145a): USB Video Class driver")
Signed-off-by: Benoit Sevens <bsevens@google.com>
Cc: stable@vger.kernel.org
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -371,7 +371,7 @@ static int uvc_parse_format(struct uvc_d
 	 * Parse the frame descriptors. Only uncompressed, MJPEG and frame
 	 * based formats have frame descriptors.
 	 */
-	while (buflen > 2 && buffer[1] == USB_DT_CS_INTERFACE &&
+	while (ftype && buflen > 2 && buffer[1] == USB_DT_CS_INTERFACE &&
 	       buffer[2] == ftype) {
 		unsigned int maxIntervalIndex;
 


