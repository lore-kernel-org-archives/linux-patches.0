Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8441D558;
	Thu, 11 Apr 2024 10:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831340; cv=none; b=U1/IVuQe4kSgeCwiSoZ9tfNPB9W3wgjyPpje5p0MS0U9P9Qod/QxuL1/2qRMoWmgLQYsaYyo805AHaYf9qmx9+Pz0/trAqpQr674dc0Bq6YmjlIQOrFo3gY92fUrwkJhCUXyAYzGdFIrzXjychPzXjjRJCmilN2SmF2RdUrgx/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831340; c=relaxed/simple;
	bh=mX0nmJw+03BGQLfnO7ZvRxZlwDJwGRTy0Aj1KBycMLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZ6E+c56UwFAN3aSO1+odk/RLvFl0p2XfpuWE1srDM0eSb+JQWQnpmS7BA6GFo9h6JDqxmd3973Lgdsza1xBjy0qsCzCf4B2Dx3mO3kg3PZJdUCqL6x1506OeWI0/qDijc/ggbO+v+FuMaYY+61dIpgJJIggf60dGdJOfSe32gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T9CoijV8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T9CoijV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73391C433C7;
	Thu, 11 Apr 2024 10:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831339;
	bh=mX0nmJw+03BGQLfnO7ZvRxZlwDJwGRTy0Aj1KBycMLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T9CoijV8gwxxCi4NVzvYUIDjJ6F8K8KR0enprR96+22uMdmt71QEasUTXf7MvMp/x
	 R+urYZhmzAp0B3mlBdAPecDN5N3kJ5IIbmfeU7B8kia+vHdhUNsbuLDvFzBGy6Vfct
	 K3eS2sL9Qhh5qm8MxK1Qg3M2jUQ9a5S2maq9BJF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/114] usb: gadget: uvc: mark incomplete frames with UVC_STREAM_ERR
Date: Thu, 11 Apr 2024 11:56:56 +0200
Message-ID: <20240411095419.578090624@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

[ Upstream commit 2a3b7af120477d0571b815ccb8600cafd5ebf02f ]

If an frame was transmitted incomplete to the host, we set the
UVC_STREAM_ERR bit in the header for the last request that is going
to be queued. This way the host will know that it should drop the
frame instead of trying to display the corrupted content.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Link: https://lore.kernel.org/r/20240214-uvc-error-tag-v1-2-37659a3877fe@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/uvc_video.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
index 91af3b1ef0d41..281e75027b344 100644
--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -35,6 +35,9 @@ uvc_video_encode_header(struct uvc_video *video, struct uvc_buffer *buf,
 
 	data[1] = UVC_STREAM_EOH | video->fid;
 
+	if (video->queue.flags & UVC_QUEUE_DROP_INCOMPLETE)
+		data[1] |= UVC_STREAM_ERR;
+
 	if (video->queue.buf_used == 0 && ts.tv_sec) {
 		/* dwClockFrequency is 48 MHz */
 		u32 pts = ((u64)ts.tv_sec * USEC_PER_SEC + ts.tv_nsec / NSEC_PER_USEC) * 48;
-- 
2.43.0



