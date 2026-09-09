Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D22F569F26;
	Wed,  9 Sep 2026 14:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962715; cv=none; b=jHt/ikYKMALVlxLWOUm4/cYGrpU7O+ySzRh/E+RTY50nUwjGbd9as7F/uxLmVqASuuTC5DLUZkC0Gpxlv+HGObBOWycJfWRLZ/wFPe2Gq+jxUJLOorMnr+qvi+48T3wP2sbe8IO+Zdlvfb5mmcZUuyIgAeo1+w7hDdXOo0OS+T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962715; c=relaxed/simple;
	bh=P4YWrvhg7H5pAPF4Ofq9QEyGgCzZJJzQwcYPWp6kM8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jzNSYFkYeCBWEo+0fsMwQJfFDaN4AUqIrT+TyAwdzMq7LuKwc2tv26QNaKdRlfuL7lk02KtXgaKC6N7+mRbASbhUtDR08UX5QKgADkVuDIlBT/mQdo2Bt47CcTY5Izc7awPvgcZn+OJyAsgFDJWcKcjscM0K9to/n0tM3rDnr7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MH6uDS+U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MH6uDS+U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47791F00A3D;
	Wed,  9 Sep 2026 14:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962714;
	bh=1+N6+wqJ6IkjuL2zi9SEgpFHjfDWLIP/tVL5Kb/05bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MH6uDS+Ubg6zbfouWHbUAehhsoMpoZMQEhEXm7H7gy8a7ogPJl+PoCv+GFqN80X5k
	 q0IDHJNCqjKaUbP3TRU+jHVs2pQKl6a2dWL2IraXZ/Bg1YaPDdT+XFUv3UvRnpMI3r
	 ybOpxrrRe8Uqb5B93uvG+8ESW9zks2CCKiJeFw9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugen Hristev <ehristev@kernel.org>,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 7.2 348/556] media: bcm2835-unicam: Fix pipeline wrong validation for unpacked formats
Date: Wed,  9 Sep 2026 15:40:28 +0200
Message-ID: <20260909134242.901441064@linuxfoundation.org>
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

From: Eugen Hristev <ehristev@kernel.org>

commit 4f26c8345dbfa92f19078c788be1b9bfd425ed60 upstream.

The commit
08f9794d9b79 ("media: bcm2835-unicam: Fix RGB format / mbus code association")
introduced a check to see whether the format requested is the same as the
fourcc in the format list.

However, this breaks the case when userspace requested an unpacked fourcc,
e.g. RG10.

Unicam can work with or without unpacking pixels, e.g. pRAA or RG10, depending
on what userspace requests.
In the unpacking case, a dedicated register is being set.

If the userspace requests pRAA, this works, because the check validates the
pipeline:

v4l2-ctl -d /dev/video0 --set-fmt-video=width=3280,height=2464,pixelformat=pRAA \
 --stream-mmap --stream-count=1 --stream-to=frame.raw

but, with
v4l2-ctl -d /dev/video0 --set-fmt-video=width=3280,height=2464,pixelformat=RG10 \
--stream-mmap --stream-count=1 --stream-to=frame.raw

unicam complains at validation level:

image: format mismatch: 0x300f <=> RG10 little-endian (0x30314752)

This should work, because MEDIA_BUS_FMT_SRGGB10_1X10 can be packed into either
RG10 or pRAA depending on the packing register.

To fix this, modified the condition check to also allow in the case when
requested format (fmt->pixelformat) is equal to fmtinfo->unpacked_fourcc.

Fixes: 08f9794d9b79 ("media: bcm2835-unicam: Fix RGB format / mbus code association")
Cc: stable@vger.kernel.org
Signed-off-by: Eugen Hristev <ehristev@kernel.org>
Reviewed-by: Jai Luthra <jai.luthra@ideasonboard.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
[Sakari Ailus: Added Cc: stable.]
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/broadcom/bcm2835-unicam.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/broadcom/bcm2835-unicam.c
+++ b/drivers/media/platform/broadcom/bcm2835-unicam.c
@@ -2158,7 +2158,8 @@ static int unicam_video_link_validate(st
 		 * In order to allow the applications using the old behaviour to
 		 * run, let's accept the old combination, but warn about it.
 		 */
-		if (fmtinfo->fourcc != fmt->pixelformat) {
+		if (fmt->pixelformat != fmtinfo->fourcc &&
+		    fmt->pixelformat != fmtinfo->unpacked_fourcc) {
 			if ((fmt->pixelformat == V4L2_PIX_FMT_BGR24 &&
 			     format->code == MEDIA_BUS_FMT_BGR888_1X24) ||
 			    (fmt->pixelformat == V4L2_PIX_FMT_RGB24 &&


