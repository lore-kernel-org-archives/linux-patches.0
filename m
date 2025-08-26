Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3032BE7D1;
	Tue, 26 Aug 2025 13:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215011; cv=none; b=PejOKLJ03aAKe3Jc8WFAAR8FgZVTROGEGWJh0KXVktE7YphndLU5ArQjuWqjH+jHqe5NUpn5A0daBeryvTsRDghH0L7VbOVbo6FMCWwTouM44wrpQfCAyIfsHpZCoZo52A4oxCTvZRJ80+6kiBtbjos7tQzzRQgJsTDWese/bgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215011; c=relaxed/simple;
	bh=auKGtMx+m6u8++31PZx+XFH2eldrIJFwakN/iwkk+ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GNEfpEAYsfPKnP3g+fhCaUL6xtb4ejTJGWm+6uiVBGzE+FVqS8l9vKJqt9U9NWvlSuLq80EL6FH/HLu9M3o+CqfQr7i9fDNM25+Y5MZPQ+TLtuh1Bgawharn3pr58nE857gmksn1kGOsRLNdylDPk6Zh58GnD0Xdv/FCebpZQ6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gxh+YbEp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gxh+YbEp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F1AC4CEF1;
	Tue, 26 Aug 2025 13:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215011;
	bh=auKGtMx+m6u8++31PZx+XFH2eldrIJFwakN/iwkk+ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gxh+YbEpBCXSfBA3NTXrqb60G2kQwGf+6kW4ze2b9nq7AKKIreNyNm14ycgpw/IdV
	 Z8U9IGDHWrxHj2eP8NCNwzuPXffhOk5zQR95GATwy95pEcoZQ8l5ld7BXdQ2Y5qAWQ
	 vuOi6VMncO9xnVX6Y3UYZjA5rhto0VjJdMQibxNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.1 322/482] media: vivid: fix wrong pixel_array control size
Date: Tue, 26 Aug 2025 13:09:35 +0200
Message-ID: <20250826110938.765929445@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

From: Hans Verkuil <hverkuil@xs4all.nl>

commit 3e43442d4994c9e1e202c98129a87e330f7faaed upstream.

The pixel_array control size was calculated incorrectly:
the dimensions were swapped (dims[0] should be the height), and the
values should be the width or height divided by PIXEL_ARRAY_DIV
and rounded up. So don't use roundup, but use DIV_ROUND_UP instead.

This bug is harmless in the sense that nothing will break, except that
it consumes way too much memory for this control.

Fixes: 6bc7643d1b9c ("media: vivid: add pixel_array test control")
Cc: <stable@vger.kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/test-drivers/vivid/vivid-ctrls.c   |    3 ++-
 drivers/media/test-drivers/vivid/vivid-vid-cap.c |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/media/test-drivers/vivid/vivid-ctrls.c
+++ b/drivers/media/test-drivers/vivid/vivid-ctrls.c
@@ -238,7 +238,8 @@ static const struct v4l2_ctrl_config viv
 	.min = 0x00,
 	.max = 0xff,
 	.step = 1,
-	.dims = { 640 / PIXEL_ARRAY_DIV, 360 / PIXEL_ARRAY_DIV },
+	.dims = { DIV_ROUND_UP(360, PIXEL_ARRAY_DIV),
+		  DIV_ROUND_UP(640, PIXEL_ARRAY_DIV) },
 };
 
 static const char * const vivid_ctrl_menu_strings[] = {
--- a/drivers/media/test-drivers/vivid/vivid-vid-cap.c
+++ b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
@@ -475,8 +475,8 @@ void vivid_update_format_cap(struct vivi
 	if (keep_controls)
 		return;
 
-	dims[0] = roundup(dev->src_rect.width, PIXEL_ARRAY_DIV);
-	dims[1] = roundup(dev->src_rect.height, PIXEL_ARRAY_DIV);
+	dims[0] = DIV_ROUND_UP(dev->src_rect.height, PIXEL_ARRAY_DIV);
+	dims[1] = DIV_ROUND_UP(dev->src_rect.width, PIXEL_ARRAY_DIV);
 	v4l2_ctrl_modify_dimensions(dev->pixel_array, dims);
 }
 


