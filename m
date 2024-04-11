Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F881448EF;
	Thu, 11 Apr 2024 10:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830337; cv=none; b=szGD2Ge15EbbkSnsKrv+/Coc3IHrA5UZ5M/CP9tvlPLJ2v38jYMTUbxeOantE6G6VLJQ9Om7JVQoSo1MdCqrZNwQ2wttDM7sf3hfn+oiIcNWvX0ihHajh3v8gbT9YCNRy9+DnIk2DZd5CRa1N0OL6veh/7hU3Vnvi2qAyk7kGIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830337; c=relaxed/simple;
	bh=v+pVf/IwEBRknD/6LYnQZeX0jZ60m/iedpShWaxn4kQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ElNju29y6Ffi/Z4g8AZ8IOISUB7haLzxZdhpOHvwP3XNTRC2AAAP1UIz0wjBnv8EyG8qC4drXqars7RmH2eONKPhTjhvafbhGn3oVj8jdUeowX2KAn1eP0B7XEPiqMi+KYFx9x1tnMEEYZDxUUMBO0Y8g+lvQd45Sl7yXGdMGFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TT8X0VwX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TT8X0VwX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E88C433F1;
	Thu, 11 Apr 2024 10:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830336;
	bh=v+pVf/IwEBRknD/6LYnQZeX0jZ60m/iedpShWaxn4kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TT8X0VwXIjCfVEAOJ01Axn1/e8N+gz5Drx5egfpKssr1lFHoAOQ2K2bb/iMVDAhpv
	 2diOmDwhpR1Rl6IJtKtlUto1C8gQVtYnIPpLD+Lz11UQyWFds4vKJDlZS2LocLhvAa
	 546F/1DIeP1Wpw9ySZklh9NuEN7TscFz83G8YZuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 113/143] usb: gadget: uvc: refactor the check for a valid buffer in the pump worker
Date: Thu, 11 Apr 2024 11:56:21 +0200
Message-ID: <20240411095424.308986105@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

[ Upstream commit 5e7ea65daf13a95a6cc63d1377e4c500e4e1340f ]

By toggling the condition check for a valid buffer, the else path
can be completely avoided.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Link: https://lore.kernel.org/r/20240214-uvc-gadget-cleanup-v1-2-de6d78780459@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/uvc_video.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
index dd3241fc6939d..dbdd9033c1268 100644
--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -594,10 +594,7 @@ static void uvcg_video_pump(struct work_struct *work)
 		 */
 		spin_lock_irqsave(&queue->irqlock, flags);
 		buf = uvcg_queue_head(queue);
-
-		if (buf != NULL) {
-			video->encode(req, video, buf);
-		} else {
+		if (!buf) {
 			/*
 			 * Either the queue has been disconnected or no video buffer
 			 * available for bulk transfer. Either way, stop processing
@@ -607,6 +604,8 @@ static void uvcg_video_pump(struct work_struct *work)
 			break;
 		}
 
+		video->encode(req, video, buf);
+
 		spin_unlock_irqrestore(&queue->irqlock, flags);
 
 		spin_lock_irqsave(&video->req_lock, flags);
-- 
2.43.0



