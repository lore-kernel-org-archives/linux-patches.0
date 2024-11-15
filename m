Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A38E1885B3;
	Fri, 15 Nov 2024 06:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653857; cv=none; b=GdIm/wJRw2AEKDFz3dQ7s/ZaijR2MCLjK0Dt8CwRrVipG/LzFB7LGJsEjsDyZXpW6br6gIenKSAj9dKnsHGyj2aU67xbM48DyoaTffi6J4orD/PIQbLM1f/sU/PQ+dkoAl3l+ln1UN5yDE8/qcfcoz5ZsMp3NowFHQOszjV4VOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653857; c=relaxed/simple;
	bh=RDin7BcIE/G6pCsGT+jE+JR3l+gxO0KpMYF0PZCwwz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qvrwT9fyV0sYPU/4Hv3TWgxW1fEu3YurZbmwt283QpnxQc+AV9PKLwUdCpqSBlGF0e+Yc0cOR/Mdt2EIVRe7XMxoqJ1C/07/oZIf2E83hYAocAI2EW/bc8akNQPlqjO8h5MgF3BWqPZiZzMmojXSCt6Cn61SPsXOV+9zWBqvV3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D7GnUJuZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D7GnUJuZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA3DC4CECF;
	Fri, 15 Nov 2024 06:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653856;
	bh=RDin7BcIE/G6pCsGT+jE+JR3l+gxO0KpMYF0PZCwwz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D7GnUJuZ3pwmktwEJGTG4GnGFZZssmke0NbL0EvkFuD5Ndkrzf6dBK06t8j03O128
	 1KuBF5NL+t+BcD2iIpqmfFasNWG6UVULqribK2Vyl5SvDPk9eFFeMLrjeWe15Lq9Uw
	 +LRNZb3TA45D6tBlRDLvj2PTk4bsYQSVmWOL/BgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benoit Sevens <bsevens@google.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.10 54/82] media: uvcvideo: Skip parsing frames of type UVC_VS_UNDEFINED in uvc_parse_format
Date: Fri, 15 Nov 2024 07:38:31 +0100
Message-ID: <20241115063727.507533982@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -661,7 +661,7 @@ static int uvc_parse_format(struct uvc_d
 	/* Parse the frame descriptors. Only uncompressed, MJPEG and frame
 	 * based formats have frame descriptors.
 	 */
-	while (buflen > 2 && buffer[1] == USB_DT_CS_INTERFACE &&
+	while (ftype && buflen > 2 && buffer[1] == USB_DT_CS_INTERFACE &&
 	       buffer[2] == ftype) {
 		frame = &format->frame[format->nframes];
 		if (ftype != UVC_VS_FRAME_FRAME_BASED)


