Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E78019753A;
	Thu,  6 Jun 2024 14:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682987; cv=none; b=LWFgNXZMOny6UNAgCoo7MQy7SASLYLtzroiO2C/MrzQaHpTDz18IFrqOGt2GqR0vor3YMbVHtDpl3y/04sRBm83H2UtrBNXDI8lvIuCFnla0a21fPqT4O60C/FdXq1koU3iBHTzeEveN7Ya+pjRydrA6uDfPtUkaplUPBziOd1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682987; c=relaxed/simple;
	bh=UBv0ei0u+GS+vy/9GboiPJ4ZlP5g+O7SX89gjDBzZeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WP0FxuiE2RHv2IK0P+zrPVbLKqvI0ev2yQ3MOZy61MRavoHoMrOMn+IxONv0/EFRZO7KvPie3k/dLYdAY1bvHE6KFX+MJdnwEGFCFKxlk6N/vcmk+lx4vw0qzpY4PgnYuotOeqoyUt/Dt95s7SA8EgAeipYwoyV+FKzNNCHACTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q6Ai941/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q6Ai941/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A389C2BD10;
	Thu,  6 Jun 2024 14:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682987;
	bh=UBv0ei0u+GS+vy/9GboiPJ4ZlP5g+O7SX89gjDBzZeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q6Ai941/DzAUKnSHKf+WZhw+jpzqGEYGiy35aQFQG49FNZLoyw4od9iXYJI9+pxDT
	 HvNmGddn/r1GssZechv7dBWQUVwBGPj0VemnWXDFBHCETV4rh87iB3E7eIqtJo209n
	 LWFN1AeGuLRHXl+CTWmCPDTL6Q/2atX0/H+rDkuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 175/374] media: stk1160: fix bounds checking in stk1160_copy_video()
Date: Thu,  6 Jun 2024 16:02:34 +0200
Message-ID: <20240606131657.755201510@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit faa4364bef2ec0060de381ff028d1d836600a381 ]

The subtract in this condition is reversed.  The ->length is the length
of the buffer.  The ->bytesused is how many bytes we have copied thus
far.  When the condition is reversed that means the result of the
subtraction is always negative but since it's unsigned then the result
is a very high positive value.  That means the overflow check is never
true.

Additionally, the ->bytesused doesn't actually work for this purpose
because we're not writing to "buf->mem + buf->bytesused".  Instead, the
math to calculate the destination where we are writing is a bit
involved.  You calculate the number of full lines already written,
multiply by two, skip a line if necessary so that we start on an odd
numbered line, and add the offset into the line.

To fix this buffer overflow, just take the actual destination where we
are writing, if the offset is already out of bounds print an error and
return.  Otherwise, write up to buf->length bytes.

Fixes: 9cb2173e6ea8 ("[media] media: Add stk1160 new driver (easycap replacement)")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/stk1160/stk1160-video.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/stk1160/stk1160-video.c b/drivers/media/usb/stk1160/stk1160-video.c
index 366f0e4a5dc0d..e79c45db60ab5 100644
--- a/drivers/media/usb/stk1160/stk1160-video.c
+++ b/drivers/media/usb/stk1160/stk1160-video.c
@@ -99,7 +99,7 @@ void stk1160_buffer_done(struct stk1160 *dev)
 static inline
 void stk1160_copy_video(struct stk1160 *dev, u8 *src, int len)
 {
-	int linesdone, lineoff, lencopy;
+	int linesdone, lineoff, lencopy, offset;
 	int bytesperline = dev->width * 2;
 	struct stk1160_buffer *buf = dev->isoc_ctl.buf;
 	u8 *dst = buf->mem;
@@ -139,8 +139,13 @@ void stk1160_copy_video(struct stk1160 *dev, u8 *src, int len)
 	 * Check if we have enough space left in the buffer.
 	 * In that case, we force loop exit after copy.
 	 */
-	if (lencopy > buf->bytesused - buf->length) {
-		lencopy = buf->bytesused - buf->length;
+	offset = dst - (u8 *)buf->mem;
+	if (offset > buf->length) {
+		dev_warn_ratelimited(dev->dev, "out of bounds offset\n");
+		return;
+	}
+	if (lencopy > buf->length - offset) {
+		lencopy = buf->length - offset;
 		remain = lencopy;
 	}
 
@@ -182,8 +187,13 @@ void stk1160_copy_video(struct stk1160 *dev, u8 *src, int len)
 		 * Check if we have enough space left in the buffer.
 		 * In that case, we force loop exit after copy.
 		 */
-		if (lencopy > buf->bytesused - buf->length) {
-			lencopy = buf->bytesused - buf->length;
+		offset = dst - (u8 *)buf->mem;
+		if (offset > buf->length) {
+			dev_warn_ratelimited(dev->dev, "offset out of bounds\n");
+			return;
+		}
+		if (lencopy > buf->length - offset) {
+			lencopy = buf->length - offset;
 			remain = lencopy;
 		}
 
-- 
2.43.0



