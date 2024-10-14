Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12951AAE2C;
	Mon, 14 Oct 2024 14:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916036; cv=none; b=dAyvKWfXi0H1oXvmu6nm3Kk3nmX59sgklPEV+w8Sqk2zzpFkFYIRtznlYu88+q1CAEVkW6cj3nklGY57gHfnUBDQ444X58NT3g05mrmJF98R2fsVJMtdpC9Z18OtN/YKtdxuG83GplRewlM9kVqZLHCsrUKV2oQMnhzfM64RtzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916036; c=relaxed/simple;
	bh=RSW588COH2tQaQ8X+CGYYaPSAgsa+Q2L3pzbxQrqS+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rn0qky+libSV/cFWnYZcErZguDFIfZXe5DwUderXCnp2yiSM2qflPqDemX8DFAUODz+8hRdODewqEvMGLKm0muTWst4F2dGFSDurIz8Xm0PTH8U9tutXGNXR0o8tL5BBhvh0TUANLpvafEwOsEi1SssppQOFAY2JmqutDiYnMbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FWTOtRrN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FWTOtRrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C95C4CEC3;
	Mon, 14 Oct 2024 14:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916036;
	bh=RSW588COH2tQaQ8X+CGYYaPSAgsa+Q2L3pzbxQrqS+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FWTOtRrN9YScbXE8coXVtwUnvSCuImzSVrBd03Iac+s4mNQKYtIhdJ/G6OorU9EvJ
	 jI00FwDDKHiQQxdBq/42pel99311QaLzw1WsPCxIfcVM5tqPL4zi8JZIL+5gSzp5yp
	 8BJS2MZbRCuKTExQakcBP6d5SnXzlT7G8NFE6s8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhishek Tamboli <abhishektamboli9@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 068/214] usb: gadget: uvc: Fix ERR_PTR dereference in uvc_v4l2.c
Date: Mon, 14 Oct 2024 16:18:51 +0200
Message-ID: <20241014141047.643887587@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhishek Tamboli <abhishektamboli9@gmail.com>

[ Upstream commit a7bb96b18864225a694e3887ac2733159489e4b0 ]

Fix potential dereferencing of ERR_PTR() in find_format_by_pix()
and uvc_v4l2_enum_format().

Fix the following smatch errors:

drivers/usb/gadget/function/uvc_v4l2.c:124 find_format_by_pix()
error: 'fmtdesc' dereferencing possible ERR_PTR()

drivers/usb/gadget/function/uvc_v4l2.c:392 uvc_v4l2_enum_format()
error: 'fmtdesc' dereferencing possible ERR_PTR()

Also, fix similar issue in uvc_v4l2_try_format() for potential
dereferencing of ERR_PTR().

Signed-off-by: Abhishek Tamboli <abhishektamboli9@gmail.com>
Link: https://lore.kernel.org/r/20240815102202.594812-1-abhishektamboli9@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/uvc_v4l2.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/uvc_v4l2.c b/drivers/usb/gadget/function/uvc_v4l2.c
index a024aecb76dc3..de1736f834e6b 100644
--- a/drivers/usb/gadget/function/uvc_v4l2.c
+++ b/drivers/usb/gadget/function/uvc_v4l2.c
@@ -121,6 +121,9 @@ static struct uvcg_format *find_format_by_pix(struct uvc_device *uvc,
 	list_for_each_entry(format, &uvc->header->formats, entry) {
 		const struct uvc_format_desc *fmtdesc = to_uvc_format(format->fmt);
 
+		if (IS_ERR(fmtdesc))
+			continue;
+
 		if (fmtdesc->fcc == pixelformat) {
 			uformat = format->fmt;
 			break;
@@ -240,6 +243,7 @@ uvc_v4l2_try_format(struct file *file, void *fh, struct v4l2_format *fmt)
 	struct uvc_video *video = &uvc->video;
 	struct uvcg_format *uformat;
 	struct uvcg_frame *uframe;
+	const struct uvc_format_desc *fmtdesc;
 	u8 *fcc;
 
 	if (fmt->type != video->queue.queue.type)
@@ -277,7 +281,10 @@ uvc_v4l2_try_format(struct file *file, void *fh, struct v4l2_format *fmt)
 		fmt->fmt.pix.height = uframe->frame.w_height;
 		fmt->fmt.pix.bytesperline = uvc_v4l2_get_bytesperline(uformat, uframe);
 		fmt->fmt.pix.sizeimage = uvc_get_frame_size(uformat, uframe);
-		fmt->fmt.pix.pixelformat = to_uvc_format(uformat)->fcc;
+		fmtdesc = to_uvc_format(uformat);
+		if (IS_ERR(fmtdesc))
+			return PTR_ERR(fmtdesc);
+		fmt->fmt.pix.pixelformat = fmtdesc->fcc;
 	}
 	fmt->fmt.pix.field = V4L2_FIELD_NONE;
 	fmt->fmt.pix.colorspace = V4L2_COLORSPACE_SRGB;
@@ -389,6 +396,9 @@ uvc_v4l2_enum_format(struct file *file, void *fh, struct v4l2_fmtdesc *f)
 		return -EINVAL;
 
 	fmtdesc = to_uvc_format(uformat);
+	if (IS_ERR(fmtdesc))
+		return PTR_ERR(fmtdesc);
+
 	f->pixelformat = fmtdesc->fcc;
 
 	return 0;
-- 
2.43.0



