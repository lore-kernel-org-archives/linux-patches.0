Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25921446073;
	Thu, 30 Jul 2026 16:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427748; cv=none; b=IGmSUcLBNI7NpyqEVKMjOo/Jrn0ZBdhUuZ803AgmIXArjLItEkbNwT4wJRgDpQ2wFUbgDOuj4dTcdNZebur5dPX0UEALcIv9n9da3LeCv6Tl9SJdAv5xBTOR45+9iFELeDviugYIjfizi6/N1TZBXQB7f4TlMlM4RpNmMtj1Wtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427748; c=relaxed/simple;
	bh=nmKRzAKgLWxKLoPYzejIlrRJKtplo5DIN9imzfSXqvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DjXmHVpABhMDwzCrioLV6GA3mqulSB5zMoRm1Q9IHkBO0mAEIRShj6du8bmHs9DCe8O3V0q8SRQYSAxlEanmvyf848AfE/hjzPUcViXm/LajzRhqPU0VybUaT3GyPW3g7lCeaytOWBtHpfnW88YJPkxdn2gbOn2mPBVkjY2PPrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Co+LDJAi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Co+LDJAi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78ECB1F000E9;
	Thu, 30 Jul 2026 16:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427747;
	bh=MxndDLTwuGsinPy3gbUhVz1/Ozh/Un9stQa2H527jUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Co+LDJAiZBwV8UXEiLpgDMsM2za7mIC5qYTy6VaF7qTxOQ5fTXhuZGYaEXX6uOonr
	 hPESZ8oZkScFI/iXsm9ev4YWEgZBVbMy+pkyBrm3xEn9Fwc+zPREtxJ6NHj/dadTyI
	 jB0dAjEecE1H0Y6wJdJif4T/q7nTrL4uY6tkh67Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 235/484] media: aspeed: fix missing of_reserved_mem_device_release() on probe failure
Date: Thu, 30 Jul 2026 16:12:12 +0200
Message-ID: <20260730141428.583054010@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2193,6 +2193,7 @@ static int aspeed_video_probe(struct pla
 	rc = aspeed_video_setup_video(video);
 	if (rc) {
 		aspeed_video_free_buf(video, &video->jpeg);
+		of_reserved_mem_device_release(&pdev->dev);
 		clk_unprepare(video->vclk);
 		clk_unprepare(video->eclk);
 		return rc;


