Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A550B14265E;
	Thu, 13 Jun 2024 11:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278970; cv=none; b=LR3CL2+599MY1IjyuWh3DAsFjtJUuxp2TQLmPXAFTffGQnpr2RsYVVplZn2bkLizMWbi1flEGasV1y9eK3TA2/JWAY35O+9fy+/FUt5nApPcplMmlQgSB04/tH8UpVJnFrOsiwRppVqBm9346Q0egP/Xh94Lubh2LBj5UC/A170=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278970; c=relaxed/simple;
	bh=dm/AiXYmNcZHTJEkx5e5Zu9ZBPF0+mffnP2aquopTVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LsywPf9XhtlLtXLp/u3Fk1Qkd7yh4cIx2WMP7Byicb3FOmH40pESXEvOxzJCc/upzQ3oIdzhWxYyNZByyitb0+nZ3FxjfFoK+NSe+0Jf9DLXUUiSOmEt/HOkIhzPEEGVgCVAFZz6sye7ruMH/izyilwgsR/h94R/VebgGRCOJHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c+dP2fCQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c+dP2fCQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB49C2BBFC;
	Thu, 13 Jun 2024 11:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278970;
	bh=dm/AiXYmNcZHTJEkx5e5Zu9ZBPF0+mffnP2aquopTVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c+dP2fCQt14DFYKGlHm8KL8tYw83MQ3jZguH/KxqRtHsVXXbRcp8OSUPqih8MzdUa
	 p8mpqYgaKm/yVkU9v8uycIoUvQFTG8ps85FhJp/MIn5Jr3+gmQH4FNvxfESIFvbAXn
	 mvT6OyQwgv4fgncAb+kDxCatFjtFZTUcZK5ffhCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 114/213] media: stk1160: fix bounds checking in stk1160_copy_video()
Date: Thu, 13 Jun 2024 13:32:42 +0200
Message-ID: <20240613113232.398202069@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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
index 0e98b450ae01b..687c7b6a0c303 100644
--- a/drivers/media/usb/stk1160/stk1160-video.c
+++ b/drivers/media/usb/stk1160/stk1160-video.c
@@ -109,7 +109,7 @@ void stk1160_buffer_done(struct stk1160 *dev)
 static inline
 void stk1160_copy_video(struct stk1160 *dev, u8 *src, int len)
 {
-	int linesdone, lineoff, lencopy;
+	int linesdone, lineoff, lencopy, offset;
 	int bytesperline = dev->width * 2;
 	struct stk1160_buffer *buf = dev->isoc_ctl.buf;
 	u8 *dst = buf->mem;
@@ -149,8 +149,13 @@ void stk1160_copy_video(struct stk1160 *dev, u8 *src, int len)
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
 
@@ -192,8 +197,13 @@ void stk1160_copy_video(struct stk1160 *dev, u8 *src, int len)
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



