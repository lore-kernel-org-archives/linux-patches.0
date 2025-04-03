Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF08250C09;
	Thu,  3 Apr 2025 15:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693769; cv=none; b=dVMsd4MFvZ3MLsxmh5slQMvxDX0hEcqb1EsjeqzNNoL1rojK9zAK6/A0+H5Fwxgri4IxQBMqkbZ1Pc2owupn9btPe5ajm5GHyIbG02DVTq7HXDdSTfZmkc+Y+dYIl+5L8YFTaNUo1I5u5KQ0szSN7mcPUCvAafun11oxeXjuyW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693769; c=relaxed/simple;
	bh=AjatFXcagwLA9Kl1BmJQBpMKOk/OqubPAV/Mtols4N4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EqyK1uLgxhLvVoGjr6KAtwajrS772/1KGA5kvo0t8j73S2svfU5Y43eMJc6TXEYaMRaf3EPNXxCRfiiYmTRI3l0HgQxIRClCTuA4vprGsbO0i6k6D5OkCHZq2/rGD0Mjt1jjMRXARgFg+tT5099nlCaTLgFA2iFFgjjtZFPpEfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tTx3vDtl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tTx3vDtl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC53C4CEEE;
	Thu,  3 Apr 2025 15:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693769;
	bh=AjatFXcagwLA9Kl1BmJQBpMKOk/OqubPAV/Mtols4N4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tTx3vDtlCciy9TqXl8/zKoazJtJH9Huj0R3zvB/5AYsagjDhfpWIW3jadTtRWPMfO
	 So3CFSahYbhREiZ9Lrk0HDiFUgMXr0jHxY6B1DeGW7hnfIEJTe+utuywQkocmaLxPx
	 EEdEcFIbBEqK0DODXMkUEGrTVsWNbdyt1ScVBcSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhishek Tamboli <abhishektamboli9@gmail.com>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.1 19/22] usb: gadget: uvc: Fix ERR_PTR dereference in uvc_v4l2.c
Date: Thu,  3 Apr 2025 16:20:14 +0100
Message-ID: <20250403151621.482493334@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151620.960551909@linuxfoundation.org>
References: <20250403151620.960551909@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhishek Tamboli <abhishektamboli9@gmail.com>

commit a7bb96b18864225a694e3887ac2733159489e4b0 upstream.

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
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/uvc_v4l2.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/uvc_v4l2.c
+++ b/drivers/usb/gadget/function/uvc_v4l2.c
@@ -121,6 +121,9 @@ static struct uvcg_format *find_format_b
 	list_for_each_entry(format, &uvc->header->formats, entry) {
 		struct uvc_format_desc *fmtdesc = to_uvc_format(format->fmt);
 
+		if (IS_ERR(fmtdesc))
+			continue;
+
 		if (fmtdesc->fcc == pixelformat) {
 			uformat = format->fmt;
 			break;
@@ -240,6 +243,7 @@ uvc_v4l2_try_format(struct file *file, v
 	struct uvc_video *video = &uvc->video;
 	struct uvcg_format *uformat;
 	struct uvcg_frame *uframe;
+	const struct uvc_format_desc *fmtdesc;
 	u8 *fcc;
 
 	if (fmt->type != video->queue.queue.type)
@@ -265,7 +269,10 @@ uvc_v4l2_try_format(struct file *file, v
 	fmt->fmt.pix.field = V4L2_FIELD_NONE;
 	fmt->fmt.pix.bytesperline = uvc_v4l2_get_bytesperline(uformat, uframe);
 	fmt->fmt.pix.sizeimage = uvc_get_frame_size(uformat, uframe);
-	fmt->fmt.pix.pixelformat = to_uvc_format(uformat)->fcc;
+	fmtdesc = to_uvc_format(uformat);
+	if (IS_ERR(fmtdesc))
+		return PTR_ERR(fmtdesc);
+	fmt->fmt.pix.pixelformat = fmtdesc->fcc;
 	fmt->fmt.pix.colorspace = V4L2_COLORSPACE_SRGB;
 	fmt->fmt.pix.priv = 0;
 
@@ -378,6 +385,9 @@ uvc_v4l2_enum_format(struct file *file,
 		f->flags |= V4L2_FMT_FLAG_COMPRESSED;
 
 	fmtdesc = to_uvc_format(uformat);
+	if (IS_ERR(fmtdesc))
+		return PTR_ERR(fmtdesc);
+
 	f->pixelformat = fmtdesc->fcc;
 
 	strscpy(f->description, fmtdesc->name, sizeof(f->description));


