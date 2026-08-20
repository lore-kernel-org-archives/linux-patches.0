Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D094947D478;
	Thu, 20 Aug 2026 16:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243683; cv=none; b=Vop1ibJAX0/Cgrqxl8Pef9Qb0Yobkmu9hkThEmefdT+Py5xPTHc/HnsaTvwVDFbOCzc1gSMbRlwRhDsL58dp/eXVKUhMejuRwjio68D1FYJJSdARx68le1aym+jXGPFcV/N50sPCb6pdtz4DowT7wiyxpnKdoajQ8WkzZ7fd4nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243683; c=relaxed/simple;
	bh=ucFTfzzGd8abfaZ4FecKQlfsCtNVjZEsoBmfqKhrg0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tyCAuORvfSfIuHLQsZXbdJLBAsDmXqegzkr0DJ4Bl1bPWzp/rUDkaMRnOZyvUsp9+7gnW2QWTUTIhC0U7AawPUwQVldt8j06qwsIWEbSNqoE6xMy75P0Fk5mXvWInDF+7+DmO+8hCD/TxBc5UOOk364NOMteE3DfZg3dS1m/qhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JHhNVc+4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JHhNVc+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15CAC1F000E9;
	Thu, 20 Aug 2026 16:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243681;
	bh=qsddNVTNzQkJXadSuVmaG4wtz6xlsoHsNfU3emvrONA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JHhNVc+4367oVlfa0lTq6VQVhz7za5xNrkGb0ohKbWdAGKQjZCFlBxnpW20yXUy5r
	 aa6IsnLga1P5KEwedSBGSqTnmtDgOflX80EORoqpVAzIFlvdEPUxFlbxIEtLN2QWeQ
	 bY41kMl5Qut1fsXwzpXQXrLC6qENIkCvWDsTRUz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 179/272] media: aspeed: fix missing of_reserved_mem_device_release() on probe failure
Date: Thu, 20 Aug 2026 16:56:03 +0200
Message-ID: <20260820145236.833388888@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


