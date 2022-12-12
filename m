Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D1E28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97007C433EF;
	Mon, 12 Dec 2022 13:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670853279;
	bh=3qeGPIic+tXkC9ZVgcHHgkL/JEKzUHw+7msJA/t5gRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YPXp8yowrKq7u2Z9pY0OtRnNSl4Xu2/n5o6DL373ebfgGgDlpOWrDqN7RA/2cpXDt
	 2vIYw7ffKAL4Zyyrmy+ycW7eRZPD2mABUXrJSslOlC0fu39TSf0RA/PS3E7H7uPyXR
	 wRVDzPwcYYXy6wXQxdwUNVk2SVVQUhwuGgr1Ez34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 4.9 12/31] media: v4l2-dv-timings.c: fix too strict blanking sanity checks
Date: Mon, 12 Dec 2022 14:19:30 +0100
Message-Id: <20221212130910.637578211@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130909.943483205@linuxfoundation.org>
References: <20221212130909.943483205@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

commit 5eef2141776da02772c44ec406d6871a790761ee upstream.

Sanity checks were added to verify the v4l2_bt_timings blanking fields
in order to avoid integer overflows when userspace passes weird values.

But that assumed that userspace would correctly fill in the front porch,
backporch and sync values, but sometimes all you know is the total
blanking, which is then assigned to just one of these fields.

And that can fail with these checks.

So instead set a maximum for the total horizontal and vertical
blanking and check that each field remains below that.

That is still sufficient to avoid integer overflows, but it also
allows for more flexibility in how userspace fills in these fields.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 4b6d66a45ed3 ("media: v4l2-dv-timings: add sanity checks for blanking values")
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-dv-timings.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -155,6 +155,8 @@ bool v4l2_valid_dv_timings(const struct
 	const struct v4l2_bt_timings *bt = &t->bt;
 	const struct v4l2_bt_timings_cap *cap = &dvcap->bt;
 	u32 caps = cap->capabilities;
+	const u32 max_vert = 10240;
+	u32 max_hor = 3 * bt->width;
 
 	if (t->type != V4L2_DV_BT_656_1120)
 		return false;
@@ -176,14 +178,20 @@ bool v4l2_valid_dv_timings(const struct
 	if (!bt->interlaced &&
 	    (bt->il_vbackporch || bt->il_vsync || bt->il_vfrontporch))
 		return false;
-	if (bt->hfrontporch > 2 * bt->width ||
-	    bt->hsync > 1024 || bt->hbackporch > 1024)
+	/*
+	 * Some video receivers cannot properly separate the frontporch,
+	 * backporch and sync values, and instead they only have the total
+	 * blanking. That can be assigned to any of these three fields.
+	 * So just check that none of these are way out of range.
+	 */
+	if (bt->hfrontporch > max_hor ||
+	    bt->hsync > max_hor || bt->hbackporch > max_hor)
 		return false;
-	if (bt->vfrontporch > 4096 ||
-	    bt->vsync > 128 || bt->vbackporch > 4096)
+	if (bt->vfrontporch > max_vert ||
+	    bt->vsync > max_vert || bt->vbackporch > max_vert)
 		return false;
-	if (bt->interlaced && (bt->il_vfrontporch > 4096 ||
-	    bt->il_vsync > 128 || bt->il_vbackporch > 4096))
+	if (bt->interlaced && (bt->il_vfrontporch > max_vert ||
+	    bt->il_vsync > max_vert || bt->il_vbackporch > max_vert))
 		return false;
 	return fnc == NULL || fnc(t, fnc_handle);
 }


