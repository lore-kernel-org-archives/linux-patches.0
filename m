Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75BF39B946
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302553; cv=none; b=Y/8VLwqAEcRnYKs831O9b8ve9d2vNXeWdPgr+AG/8qq7ibNGukAFAOoydtEhhPgG2mn24x22VDHdJkWAFaytGotQ4arnHa4JxojrTJqF5cvE30zP0Pb6iL31OjlX7rG/WDe5TTZYP8XYB/rYg8zD4q5TnkIwwKbpvddt2/m8anc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302553; c=relaxed/simple;
	bh=nnb3AXXPXbQwadlWlRYDgfNoUrBrn3K9Do/6rpR0cto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m5FMuo+DzIl9i+DWjsmZqbKKIu6uCLhTyjTVmWQU2ghLc0/IoTua3PVA/QDmaSzp7IN3wMzS6/YdOfjoumpHJaSp6FR2+61irJ3z+g6PCpnVcuk0l53cmEaRQjqvC+56N+2U7lQCK9sAS5YmDlP1Qe5mrjLLYSCKJtcUs/8uj6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R6A1k6VO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R6A1k6VO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA16C19424;
	Sat, 28 Feb 2026 18:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302552;
	bh=nnb3AXXPXbQwadlWlRYDgfNoUrBrn3K9Do/6rpR0cto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R6A1k6VO6XRPNoDx4XIaaV/fdEBwGJcL7fCIZtKIOE+MHLjFs3SwjumwRStqCgNOq
	 h0MYvoJDrR2arR2Q1/hDLpjPl34XTd33EgaKS0Ooeq7DfDBmtUeO2G8PzXzHiDOlP0
	 huPVC7hHTNY/Y13GzTERQdRbmhI0Xx6aMD/4UN1FtgVPE3Av2YmmkvcBb+B42G2nf6
	 z261c2Js+jmJvu9Q6CNqm1P1sGaGENEqM8fwvjuLaDN4fJriM1yr5LOBGDvloZLPYq
	 EDFnYeP17UxIEiX77UxJK3WOejXOANI6wflZ3OShtI2q5JR0qcbIxN9ZDmllENADwq
	 GGhWSqcr+0OIQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ricardo Ribalda <ribalda@chromium.org>,
	Itay Chamiel <itay.chamiel@q.ai>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 056/164] media: uvcvideo: Fix allocation for small frame sizes
Date: Sat, 28 Feb 2026 13:13:15 -0500
Message-ID: <20260228181505.1600663-56-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 4739633e30879..f868a13280a1e 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1736,7 +1736,7 @@ static int uvc_alloc_urb_buffers(struct uvc_streaming *stream,
 		npackets = UVC_MAX_PACKETS;
 
 	/* Retry allocations until one succeed. */
-	for (; npackets > 1; npackets /= 2) {
+	for (; npackets > 0; npackets /= 2) {
 		stream->urb_size = psize * npackets;
 
 		for (i = 0; i < UVC_URBS; ++i) {
@@ -1761,6 +1761,7 @@ static int uvc_alloc_urb_buffers(struct uvc_streaming *stream,
 	uvc_dbg(stream->dev, VIDEO,
 		"Failed to allocate URB buffers (%u bytes per packet)\n",
 		psize);
+	stream->urb_size = 0;
 	return 0;
 }
 
-- 
2.51.0

