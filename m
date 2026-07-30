Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88253AFAEC;
	Thu, 30 Jul 2026 15:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424448; cv=none; b=MQRo146jSXDKsOMh4HUuPIOpFztSby1CXBLj8wuuvmB0M4qWB5A5NhX9x0R6qioj/KX9pVnj8ONzfmSuQOblu6VJ1J4d38pdZid03GDfp+ZahTEknZZzEDjyM91rm1AUmLw1zYPPIdyrU8D1bBYWcUWD14XthoBJupHf3wYXHL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424448; c=relaxed/simple;
	bh=HNEGEwBoGmJRP7eTiv8jrpzy8xDfaU5qPXoX5ap3u3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bNI1z4GuqDcIm4H+IpopA3fLWwqC3gzqN56jiAWnKb2j5BmmQosL01qj6pQRQwhgEy0GBOcNF1PyHWy08xfsm9z5gue20xQd31M0Ifhq9qd0dQTxJ3hfCwSNhHZCfc/DzG1fJiDiHAIRO5oU8jsiUWojGQwkBuHGRNYS1aV1t5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O1SgX9fY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O1SgX9fY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C19C1F000E9;
	Thu, 30 Jul 2026 15:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424446;
	bh=d3SuNBKpRXT8M3ddHQyLAr+4KkzUWO1Js5BPopWJ0No=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O1SgX9fY1SjAmn7dgYr8wiGJhbHf7KWwQ2guYUaUhvGoE+J5Etq1jFuBfRpEcqaSJ
	 DPsYhGDZxAj2+de40q298RcPUld3joFSKlFv3EuCSP1gMugThDd6r6Uyq7dG0lQB6r
	 iL+C8qNg7ID0rpGBfzdyjIRv2+1LMyzt1uy/gZZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 396/675] media: aspeed: fix missing of_reserved_mem_device_release() on probe failure
Date: Thu, 30 Jul 2026 16:12:06 +0200
Message-ID: <20260730141453.549233903@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit 253c8ef7d57da0c74db251f385324faaa5ae2257 upstream.

aspeed_video_init() calls of_reserved_mem_device_init() to associate
reserved memory regions with the device. When aspeed_video_setup_video()
subsequently fails in aspeed_video_probe(), the error path frees the
JPEG buffer and unprepares the clocks but does not release the reserved
memory association, leaking the rmem_assigned_device entry on the global
list.

The normal remove path already calls of_reserved_mem_device_release()
correctly; only the probe error path was missing it.

Add the missing of_reserved_mem_device_release() call to the
aspeed_video_setup_video() failure cleanup.

Fixes: d2b4387f3bdf ("media: platform: Add Aspeed Video Engine driver")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/aspeed/aspeed-video.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/aspeed/aspeed-video.c
+++ b/drivers/media/platform/aspeed/aspeed-video.c
@@ -2327,6 +2327,7 @@ static int aspeed_video_probe(struct pla
 	rc = aspeed_video_setup_video(video);
 	if (rc) {
 		aspeed_video_free_buf(video, &video->jpeg);
+		of_reserved_mem_device_release(&pdev->dev);
 		clk_unprepare(video->vclk);
 		clk_unprepare(video->eclk);
 		return rc;


