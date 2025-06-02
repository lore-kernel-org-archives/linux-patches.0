Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72832236E0;
	Mon,  2 Jun 2025 14:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873518; cv=none; b=DXF0CCwMmLTPSf13HiKe5bWF0iwQXipAWwMqu3RiVRrYCq0tmjo9UbfhYtu58jPDub7N1+wJVCm93sNZ4iXxpXb0k0NVH+symq3bmRfl14ThxqR0D4c+5LywBdHHwtH7bPi8/RUBVJePYWQwWKoQc1ZIeIPOZMyqOIZWOnTL0ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873518; c=relaxed/simple;
	bh=f5F94bB7GFBnwY4dpUGOUNkHqOfKiMhdxitYjagVeyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cjmGaqxG/+WUIqsLqGM9lrp4yTzSJRNtK75yeREYkTakKLpKbh4jJmu2tFusabW0qCAPtfAWHiNYLoysrraxViyvclg/Z8Bl2hfowGxbCC+Xb2NfH4zjO1q6weDjNdy3gS1lP6QjfY7TFZob/N/jkae4pk95Z8Us5TTgIbLLjW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qb+Q3x/x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qb+Q3x/x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565BEC4CEEB;
	Mon,  2 Jun 2025 14:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873517;
	bh=f5F94bB7GFBnwY4dpUGOUNkHqOfKiMhdxitYjagVeyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qb+Q3x/xb7ieJiZHWkV7u0jtFjSrGsAKRllv0eCLhX1qcZPAWzkGpLqwH9lDBmuiv
	 ZDfM5bojOqq9BfUh7MIv4gGrJa4seeVL8nn/7gs1zeF290aTQDGbmZ80NHbIu54pfs
	 LOuuz5HqYWvhpI6Oi/aqNvMOvl8rtkaT7BwJciaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Sven Peter <sven@svenpeter.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 166/444] soc: apple: rtkit: Use high prio work queue
Date: Mon,  2 Jun 2025 15:43:50 +0200
Message-ID: <20250602134347.641115167@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Janne Grunau <j@jannau.net>

[ Upstream commit 22af2fac88fa5dbc310bfe7d0b66d4de3ac47305 ]

rtkit messages as communication with the DCP firmware for framebuffer
swaps or input events are time critical so use WQ_HIGHPRI to prevent
user space CPU load to increase latency.
With kwin_wayland 6's explicit sync mode user space load was able to
delay the IOMFB rtkit communication enough to miss vsync for surface
swaps. Minimal test scenario is constantly resizing a glxgears
Xwayland window.

Signed-off-by: Janne Grunau <j@jannau.net>
Reviewed-by: Alyssa Rosenzweig <alyssa@rosenzweig.io>
Link: https://lore.kernel.org/r/20250226-apple-soc-misc-v2-3-c3ec37f9021b@svenpeter.dev
Signed-off-by: Sven Peter <sven@svenpeter.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/apple/rtkit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/apple/rtkit.c b/drivers/soc/apple/rtkit.c
index d9f19dc99da5e..b9c5281c445ee 100644
--- a/drivers/soc/apple/rtkit.c
+++ b/drivers/soc/apple/rtkit.c
@@ -744,7 +744,7 @@ struct apple_rtkit *apple_rtkit_init(struct device *dev, void *cookie,
 	rtk->mbox_cl.rx_callback = &apple_rtkit_rx;
 	rtk->mbox_cl.tx_done = &apple_rtkit_tx_done;
 
-	rtk->wq = alloc_ordered_workqueue("rtkit-%s", WQ_MEM_RECLAIM,
+	rtk->wq = alloc_ordered_workqueue("rtkit-%s", WQ_HIGHPRI | WQ_MEM_RECLAIM,
 					  dev_name(rtk->dev));
 	if (!rtk->wq) {
 		ret = -ENOMEM;
-- 
2.39.5



