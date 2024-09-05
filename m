Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C201494DB;
	Thu,  5 Sep 2024 10:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530690; cv=none; b=I0Hz4OmIkd2mR7YD68Df1fXdLc0B+5gE9X8zvdFmavPeyFfZsbe4ge9yIX1JECdphuFiUhFUdY2OemeHBsHO+0XGVkzyG/3A1AUg51oGt7yzdcEE8fI8vcWs4NV022o53d6vBfWUbSpICcIF6Zx06BoRr3op53GrmFIgVstOalk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530690; c=relaxed/simple;
	bh=TJI2wB9AYWEcxR5j0rz7Ym1GOpJfFG6rNqCYMNPBeYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FfIpO0kaMttQFEVuqaaunPUH/dqReGDmf7bXXp6gB64UyaitLiJg8W+imPHrM+NbKJlh9S2v+K8yuEySKESUxml4bmUSg4lpx0/Xe8qRc70UFqMg/pahIngIS+Yir0c6bqZvdVLdDRi+kJ6MIFWXpXeAusBqsLETDupY8PIHVjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pg4YwfO8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pg4YwfO8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C86C4CEC3;
	Thu,  5 Sep 2024 10:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530689;
	bh=TJI2wB9AYWEcxR5j0rz7Ym1GOpJfFG6rNqCYMNPBeYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pg4YwfO89ugcDDB7ex919sIcG5sZ7lMffdWrpRUOHFEmo/25LQ03YBo0SUO9X3RDw
	 CHTPN1ms3q46adXNasgJGFc4D9+hoLVu4UWHx8T16lNk36jE7b0AVfw6o/jVRBIfvW
	 PGFRNBLddjWnGzpByhhFp75LSO8eth9moNLbocAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 093/101] media: uvcvideo: Enforce alignment of frame and interval
Date: Thu,  5 Sep 2024 11:42:05 +0200
Message-ID: <20240905093719.762694800@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit c8931ef55bd325052ec496f242aea7f6de47dc9c ]

Struct uvc_frame and interval (u32*) are packaged together on
streaming->formats on a single contiguous allocation.

Right now they are allocated right after uvc_format, without taking into
consideration their required alignment.

This is working fine because both structures have a field with a
pointer, but it will stop working when the sizeof() of any of those
structs is not a multiple of the sizeof(void*).

Enforce that alignment during the allocation.

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/r/20240404-uvc-align-v2-1-9e104b0ecfbd@chromium.org
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 191db831d760..004511d918c6 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -666,16 +666,26 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 		goto error;
 	}
 
-	size = nformats * sizeof(*format) + nframes * sizeof(*frame)
+	/*
+	 * Allocate memory for the formats, the frames and the intervals,
+	 * plus any required padding to guarantee that everything has the
+	 * correct alignment.
+	 */
+	size = nformats * sizeof(*format);
+	size = ALIGN(size, __alignof__(*frame)) + nframes * sizeof(*frame);
+	size = ALIGN(size, __alignof__(*interval))
 	     + nintervals * sizeof(*interval);
+
 	format = kzalloc(size, GFP_KERNEL);
-	if (format == NULL) {
+	if (!format) {
 		ret = -ENOMEM;
 		goto error;
 	}
 
-	frame = (struct uvc_frame *)&format[nformats];
-	interval = (u32 *)&frame[nframes];
+	frame = (void *)format + nformats * sizeof(*format);
+	frame = PTR_ALIGN(frame, __alignof__(*frame));
+	interval = (void *)frame + nframes * sizeof(*frame);
+	interval = PTR_ALIGN(interval, __alignof__(*interval));
 
 	streaming->format = format;
 	streaming->nformats = 0;
-- 
2.43.0



