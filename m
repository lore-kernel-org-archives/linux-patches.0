Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A282D2D9780;
	Wed,  9 Sep 2026 14:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962626; cv=none; b=XXkpCYSV8V/9plUNcIABiNfAZCeWmriH1b+kZfqvi6KMtV+/3obWfPyy77hStLLAVnh9yKA6HduvwsNHL7R5fQV/vrykXqETk3UhEwJsPXduqGt1jSg7RJ6TUznaChx22A0xCJXGJki6lxhwU31qwsEmgzkVcyiJpbrMuIP8TPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962626; c=relaxed/simple;
	bh=YpNC/plauai0EGfqx/fbGbAq/d6f2e5c8yw2tjiF07w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8BYwlLeCzjgGMtpwimD83uYtWhnw4n/+97WR5SRhrksqlE1aPshKqvQVGki5vPh4ytqm0sMpJ7DNIEmP9JDNpLmg63TVEIEHSSkKDrbnBbIYltB8o4dO16NfPuv+q4KSeOVnCa0wV9j2wm8JNUg/r9nlqskK2IGQTi+P0mGb4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SJUE3Cfs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SJUE3Cfs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04B41F00A3A;
	Wed,  9 Sep 2026 14:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962625;
	bh=VLOrZiKRc0/h5g63wW9MjqbPDJiQZ97+ZjyEjpTj508=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SJUE3CfsxXAdcuMjwnABkDHc7iUU5AjgPYhNgph0rwMxDh/NAUzpZ4BHfTCzP9SvX
	 T9IiPxa+bY7dBtGzakocUpQnlVoM+n4rXKpJ9hYA8FX+riA92mJ2y/m9Ce+6WAQ4k6
	 YZoPviIxBD9LREY1tPZIsPY5+/29daFFRaBHg3ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 356/556] media: cx231xx: reject geometry changes while the VBI queue is busy
Date: Wed,  9 Sep 2026 15:40:36 +0200
Message-ID: <20260909134243.193327353@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 627a121c15fe05a541f44d86016294b80bada75d upstream.

vidioc_s_fmt_vid_cap() and vidioc_s_std() change the device-wide
dev->width / dev->norm but only refuse the change when the *video* queue
(dev->vidq) is busy. The VBI queue (dev->vbiq) shares that same geometry:
cx231xx_init_vbi_isoc() latches dma_q->lines_per_field from dev->norm,
the VBI videobuf2 plane is sized from dev->width / dev->norm in
vbi_queue_setup() and vbi_buf_prepare(), and cx231xx_do_vbi_copy() then
recomputes the destination offset from the *live* dev->width and the
latched lines_per_field on every URB completion:

	offset = lines_completed * (dev->width << 1) + ...;
	if (dma_q->current_field == 2)
		offset += dev->width * 2 * dma_q->lines_per_field;
	memcpy(plane + offset, p_buffer, lencopy);

Because the VBI node shares video_ioctl_ops with the video node, an
application can size a small VBI plane (REQBUFS/QBUF with a small width,
or with the NTSC standard), then enlarge dev->width (or switch dev->norm
to PAL) through the video node while the VBI stream is running -- the
change is allowed because only dev->vidq is checked -- and let the device
deliver a field-2 VBI payload. cx231xx_do_vbi_copy() now computes the
offset with the larger geometry and memcpy()s past the end of the smaller
plane that was already allocated, a heap out-of-bounds write whose offset
is attacker-chosen and whose contents come from the device. The
per-field guard in cx231xx_copy_vbi_line() does not help: it bounds the
copy against the latched lines_per_field, not the plane's real capacity,
and vb2 does not re-run buf_prepare() for an already prepared buffer.

Refuse the format/standard change when the VBI queue is busy as well, so
the geometry cannot change underneath an allocated VBI buffer.

Fixes: 7c617138b825 ("media: cx231xx: convert to the vb2 framework")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/cx231xx/cx231xx-video.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -898,7 +898,7 @@ static int vidioc_s_fmt_vid_cap(struct f
 	if (rc)
 		return rc;
 
-	if (vb2_is_busy(&dev->vidq)) {
+	if (vb2_is_busy(&dev->vidq) || vb2_is_busy(&dev->vbiq)) {
 		dev_err(dev->dev, "%s: queue busy\n", __func__);
 		return -EBUSY;
 	}
@@ -933,7 +933,7 @@ static int vidioc_s_std(struct file *fil
 	if (dev->norm == norm)
 		return 0;
 
-	if (vb2_is_busy(&dev->vidq))
+	if (vb2_is_busy(&dev->vidq) || vb2_is_busy(&dev->vbiq))
 		return -EBUSY;
 
 	dev->norm = norm;


