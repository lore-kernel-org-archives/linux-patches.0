Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6016533438F;
	Thu, 30 Jul 2026 15:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426099; cv=none; b=sQUV8a4TUT+vJ0CtRgW9itDY0kldr0xRCAX+PSC2QcPNzYsKw/c7gbZLtN/YAAPnA1qCn127kHzY2auOIPEEDC4IKo0jtf/19HaigjQxocVl4kJ2vwBb54cgmnWOjKVhm4K2kxnMBYMDwhy0dDy5dz/0MSbM7cH0yJ0fr8caA8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426099; c=relaxed/simple;
	bh=xPWU667i+nWxIOUBbPOxDN9hkOkjIJf6ZZLPJQK4Vxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fb2U1Lb1IBqr9/GCz4gHFgnxKQP+++7h+PXIa0QkmtF3NmBNnmxhMWiZQfD1daNwSdxSjiEFtAqLiPm2L3Ndic8slz0SrsfoB4ivueHG9tcI+6wbKj4sW7qF57+wpRKIehuF4d544A+ZRiPfqt4ippvDGoADlVn30H59OjiRSXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hMqGzTFe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hMqGzTFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B556B1F000E9;
	Thu, 30 Jul 2026 15:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426098;
	bh=3xN0c4WCjbgEPeRJq57hjKiCDlblnjwaNwLhWxQEz6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hMqGzTFe6zaYl7faOq0Iyywb9pFBDqSLZKR6nb5DXt5HU/bDazVQbtXTSgJcCfNH4
	 P7Q/RrMTNT5Mc0nto3AY0Y9VzkeHqrZpQ3O4/9IYayCjLrEeNbhWOVpNo4OOhZIIVa
	 okv1GemxPdHmOmsVv1K8/dZFsTKZdGPLo4uGdVsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 300/602] media: aspeed: fix missing of_reserved_mem_device_release() on probe failure
Date: Thu, 30 Jul 2026 16:11:32 +0200
Message-ID: <20260730141442.273631948@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2186,6 +2186,7 @@ static int aspeed_video_probe(struct pla
 	rc = aspeed_video_setup_video(video);
 	if (rc) {
 		aspeed_video_free_buf(video, &video->jpeg);
+		of_reserved_mem_device_release(&pdev->dev);
 		clk_unprepare(video->vclk);
 		clk_unprepare(video->eclk);
 		return rc;


