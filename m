Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB98647D471;
	Thu, 20 Aug 2026 16:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244403; cv=none; b=horccI6OAu+ZHhSlfKN1nR9r4NkcdzpGeF5NUbfhdJukcmIZdKFKglwo8mBETXhAtwuT0gJdKifBp2D1Kg5TVmzDrzTf3a1pPgDYTFLL7N6uZ8G74YBZmDbeWX5ZW9tjWs3aYalyWZui8ww5pKdOOoJAkX+1/2b0Mwgbe+50X6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244403; c=relaxed/simple;
	bh=3o1P/zcfhnEh1kiAg3sMd7nepIInkC4hkDfTGIFMPI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aLv6OTH/Blj34vK78+VwuP8kZRfu6ybFEeAQQNzp7w324+klThECWqSN/+UE+QFy7vDw/RLkIGaWRYbhUAybeHjXbDDEtsHQei/j+IKmv/ooQmhrm303FtuHgABJNT/+XFbkPLq2Y/bgLaiG0aXoutNNUs9Kt74FaWj+rRb80OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHuRmnF5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHuRmnF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9391F000E9;
	Thu, 20 Aug 2026 16:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244401;
	bh=JwYoiE9LjFVmJVNi3MlX610NC+tibPefKp2YtM6G9zM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oHuRmnF5V25JVPV+7GOASvs/9GlEV0NxfsHFjCIwe9E6YR5RUxok/holBtAG1WH+B
	 Q1tE9aNp4WWiq+EiTWKAEkfkyQmDNJEO87J1juQsGr58nAMRhnbPQWGa8Xjyw0HQNI
	 3B4NECctbKUOFsAN+nEnMjnpjCHU3Yd9cgppeIHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 156/235] media: aspeed: fix missing of_reserved_mem_device_release() on probe failure
Date: Thu, 20 Aug 2026 16:56:32 +0200
Message-ID: <20260820145221.200796494@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

[ Upstream commit 253c8ef7d57da0c74db251f385324faaa5ae2257 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/aspeed-video.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/aspeed-video.c
+++ b/drivers/media/platform/aspeed-video.c
@@ -1724,6 +1724,7 @@ static int aspeed_video_probe(struct pla
 	rc = aspeed_video_setup_video(video);
 	if (rc) {
 		aspeed_video_free_buf(video, &video->jpeg);
+		of_reserved_mem_device_release(&pdev->dev);
 		clk_unprepare(video->vclk);
 		clk_unprepare(video->eclk);
 		return rc;


