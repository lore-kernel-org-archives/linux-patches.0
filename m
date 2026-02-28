Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7027136C9D8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302358; cv=none; b=A12OOsZ5NqTcW8NYUw0C46ZCOLlMbn9gFFpdT/r9GyAHY0BL9VCIg0dYWAsD0sDu/zlBP64N76Bh5h2VhdrVn077VNRbJS+H1BwtwD8B5wFNLx8twZl91ldaf+SjcBPaKfW6wbMrArRGxT6EndF/Wi/7voIzNQHSqAn5YYu1dBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302358; c=relaxed/simple;
	bh=EE6p/UWOdTkT7VhS7rr9hblIQsTGj+IPshl+HgqfJq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJ+it8FsIjVySBsT7TtgOsn8E3/TcjwnojLpwBiZmin/3CSA94vIeeysmSbri93uRUMnnYQksoyhtO/0xacgjx1Kt2GiTZtBpy1vccbb8aoWreGWNCR34T1Jj/6Nzz9LxQ3tBEv6JRbJ7omGn/eP3Egs2eDSk+/GY33B3h9S0R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r8Dify2F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r8Dify2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A461AC19423;
	Sat, 28 Feb 2026 18:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302358;
	bh=EE6p/UWOdTkT7VhS7rr9hblIQsTGj+IPshl+HgqfJq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r8Dify2FbzksYcn4bee90CwswYgee6AFmzNpP2Qt5L+1nxEBpX5kFLN3w+pCBKU1J
	 B1FSBh5TJCR22YKblgnJ5QxSbXywZ0KIUZ1iSzc1mjBv9LRLGgnnoMl3UBabip8b7l
	 njRZaPtpBB0FU60WSNvom9jKt7qNZFt0Vq6qY493X3p7JgPeHT29ASQr9D8tG6K05M
	 /Q2+3lqAjLGAn5ruW94RxMT+Sol7iEuKnoKXWMjTvszS0Ij/O2BF+jU2puCFdnMyI1
	 009eYgp5HgH8M9QlSpaSrA4RpC1sTxvrK+l4FGO8gmc4Whf+8Ed3kHVAOrFLc9w2o3
	 VDtS2JKVqPNNA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ricardo Ribalda <ribalda@chromium.org>,
	Itay Chamiel <itay.chamiel@q.ai>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 084/232] media: uvcvideo: Fix allocation for small frame sizes
Date: Sat, 28 Feb 2026 13:08:57 -0500
Message-ID: <20260228181127.1592657-84-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 40d3ac25c11310bfaa50ed7614846ef75cb69a1e ]

If a frame has size of less or equal than one packet size
uvc_alloc_urb_buffers() is unable to allocate memory for it due to a
off-by-one error.

Fix the off-by-one-error and now that we are at it, make sure that
stream->urb_size has always a valid value when we return from the
function, even when an error happens.

Fixes: efdc8a9585ce ("V4L/DVB (10295): uvcvideo: Retry URB buffers allocation when the system is low on memory.")
Reported-by: Itay Chamiel <itay.chamiel@q.ai>
Closes: https://lore.kernel.org/linux-media/CANiDSCsSoZf2LsCCoWAUbCg6tJT-ypXR1B85aa6rAdMVYr2iBQ@mail.gmail.com/T/#t
Co-developed-by: Itay Chamiel <itay.chamiel@q.ai>
Signed-off-by: Itay Chamiel <itay.chamiel@q.ai>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Tested-by: Itay Chamiel <itay.chamiel@q.ai>
Link: https://patch.msgid.link/20260114-uvc-alloc-urb-v1-1-cedf3fb66711@chromium.org
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_video.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index da693e3905dd9..87262bf0232c4 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1758,7 +1758,7 @@ static int uvc_alloc_urb_buffers(struct uvc_streaming *stream,
 		npackets = UVC_MAX_PACKETS;
 
 	/* Retry allocations until one succeed. */
-	for (; npackets > 1; npackets /= 2) {
+	for (; npackets > 0; npackets /= 2) {
 		stream->urb_size = psize * npackets;
 
 		for (i = 0; i < UVC_URBS; ++i) {
@@ -1783,6 +1783,7 @@ static int uvc_alloc_urb_buffers(struct uvc_streaming *stream,
 	uvc_dbg(stream->dev, VIDEO,
 		"Failed to allocate URB buffers (%u bytes per packet)\n",
 		psize);
+	stream->urb_size = 0;
 	return 0;
 }
 
-- 
2.51.0

