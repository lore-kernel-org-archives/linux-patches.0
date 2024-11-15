Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1298189520;
	Fri, 15 Nov 2024 06:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652839; cv=none; b=e6N3E6iBZBywuaaLk/rg0PXn8al+2G9cO5s94aY12dbaOpD1xI0zHRB6xc3aCSs08AcVS7NSnnqBBDkeLnYEn9vYwQ9F/201dLj57aO6T4vP8Br2UMFX8L6KKgDgpkki0gNP8xMqGRVWn7X6+qE16CcfTrQTZwPxrCi3fjP2/+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652839; c=relaxed/simple;
	bh=gZd3COP8hZZR06w8bsATO0UiGpKWhmvT2a4QJvAh0m0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GNyHmrbx92wZZm+kGOQr4q4aYF3/2Dv6pEfLrwP4xLcM/C3umxCTNFknMtdMCs5NSMiX03ZHeY2vmK+gPAB6m8vZawImu8YUV0PCZ8bDQ26jszwu5sPl3+23XXq49AyRpidhPJKcPcclKaZZUk9lHHKRicvxui4TlOfolGQFyzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IvJUn0P1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IvJUn0P1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1D4C4CED4;
	Fri, 15 Nov 2024 06:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652838;
	bh=gZd3COP8hZZR06w8bsATO0UiGpKWhmvT2a4QJvAh0m0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IvJUn0P1KqdJGR58LdUmYdibV6kPxoSh29iFnjxmcngYiGfHmEcCuk6I7+bnEpDcO
	 iC3Di4mjfywhg+hU7oThYA+nj8mJ+5LtTYc7A+aEwKBgIvBCLzZOinGav88v/LYyIZ
	 63Mo2Vr+Kxn2ATORaZR990kTV5BvN8rQ07f0w3Ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benoit Sevens <bsevens@google.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 4.19 29/52] media: uvcvideo: Skip parsing frames of type UVC_VS_UNDEFINED in uvc_parse_format
Date: Fri, 15 Nov 2024 07:37:42 +0100
Message-ID: <20241115063723.911093665@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.845867306@linuxfoundation.org>
References: <20241115063722.845867306@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -575,7 +575,7 @@ static int uvc_parse_format(struct uvc_d
 	/* Parse the frame descriptors. Only uncompressed, MJPEG and frame
 	 * based formats have frame descriptors.
 	 */
-	while (buflen > 2 && buffer[1] == USB_DT_CS_INTERFACE &&
+	while (ftype && buflen > 2 && buffer[1] == USB_DT_CS_INTERFACE &&
 	       buffer[2] == ftype) {
 		frame = &format->frame[format->nframes];
 		if (ftype != UVC_VS_FRAME_FRAME_BASED)


