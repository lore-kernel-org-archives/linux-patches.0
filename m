Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B142FDC38;
	Tue, 26 Aug 2025 13:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213700; cv=none; b=J7t/xj4qatyJ1rZa6AWUgiAJ2WMTNKGzrq5k5ekloGVJUCxXSuOeohTdUpeSiTIXm09WxGP0vxwlyIgAxd9o6Y9sNnyugWDNzI5j9U/Z8V6WthEd8MBEuvGzg+JWKgEwSyoyqdYnQx+2DrmH6MdTCo8bjwUNFLRH56Q/FVXqPRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213700; c=relaxed/simple;
	bh=bCtS59WwfMaH0v1zcOo2BAPM4yM27HiiaeF4IA9JytY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Es5E8yAIsVi6iH4mgxT35lsnLXPjYc4x32aA67z5NWwgRy4WeVBG3m8UPMZQuhnRYWM7+oWdUrChxeXrjtl90Vj1ccAz3RQratAi3PP78v/kpsOw8XV7yksMvbZo+7z/xY6GdvnrTQdmGIx3N1y9O2KbR7kHI2oHQIbl4tlxOsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dNQsddBD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dNQsddBD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A07C113CF;
	Tue, 26 Aug 2025 13:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213699;
	bh=bCtS59WwfMaH0v1zcOo2BAPM4yM27HiiaeF4IA9JytY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dNQsddBD+DmJ/glAy7qMV2f5y1efLiSD1LmIwzePFamExbx+mG2RRZpKGwPxJ3FK9
	 K2ltEuUeIAW7GE25YvOiaIaGM9FPFxK6hr4lOE/rIap9cAMYsYv4nIbeYUjk1bc9Yd
	 b12frQrtaIoaHG10OBmIUAFLnVGGKg/D3F5Q50tI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Bryan ODonoghue <bod@kernel.org>
Subject: [PATCH 6.6 416/587] media: venus: venc: Clamp param smaller than 1fps and bigger than 240
Date: Tue, 26 Aug 2025 13:09:25 +0200
Message-ID: <20250826111003.521233244@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

commit 417c01b92ec278a1118a05c6ad8a796eaa0c9c52 upstream.

The driver uses "whole" fps in all its calculations (e.g. in
load_per_instance()). Those calculation expect an fps bigger than 1, and
not big enough to overflow.

Clamp the param if the user provides a value that will result in an invalid
fps.

Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
Closes: https://lore.kernel.org/linux-media/f11653a7-bc49-48cd-9cdb-1659147453e4@xs4all.nl/T/#m91cd962ac942834654f94c92206e2f85ff7d97f0
Fixes: aaaa93eda64b ("[media] media: venus: venc: add video encoder files")
Cc: stable@vger.kernel.org
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
[bod: Change "parm" to "param"]
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/venc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -411,11 +411,10 @@ static int venc_s_parm(struct file *file
 	us_per_frame = timeperframe->numerator * (u64)USEC_PER_SEC;
 	do_div(us_per_frame, timeperframe->denominator);
 
-	if (!us_per_frame)
-		return -EINVAL;
-
+	us_per_frame = clamp(us_per_frame, 1, USEC_PER_SEC);
 	fps = (u64)USEC_PER_SEC;
 	do_div(fps, us_per_frame);
+	fps = min(VENUS_MAX_FPS, fps);
 
 	inst->timeperframe = *timeperframe;
 	inst->fps = fps;


