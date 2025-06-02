Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4324D22E01E;
	Mon,  2 Jun 2025 15:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876943; cv=none; b=q+mB5D8TSa9SSE3166pTW/4i3on816ghM88KKNDj3ZLT3EhkQeSUSlzGstC3JdzFhZcL3ubMm8IUfgZL2qkFz6QEpTUH61itoNEUBgS/xqRskBllmYrxbpFt1SDzZeCf+DjMPpORLz5lgnUmhS0bseQzGJTAJfMsVNPJ+3FZapo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876943; c=relaxed/simple;
	bh=yl9olcrvA6Wf0XHXJWNJYxi1FZwwNvQMxuP5+ghUQW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dChT7HgD54eOfbqHXQ8e98Ia9IaOFTKM2bIQ69y8DuiIEqPnri3UB4M75e5Wa3oiGcGPaGpRuXPUhqgfA89iPedPu8/FAlmMqFYObrVwqN13zwHUTXyS8fyKsOUE5leP4ED/KOu9aGyiC2e5plDEC49zGgWxx1qo85effn6ICGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xJEz15PW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xJEz15PW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B072C4CEEB;
	Mon,  2 Jun 2025 15:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876942;
	bh=yl9olcrvA6Wf0XHXJWNJYxi1FZwwNvQMxuP5+ghUQW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xJEz15PWzn2jc9I8LrgXihlV5XGhLOeF/qrftUAyMvBzXueJpYyWe9PFR9yTTMI+f
	 2RMAOqONPQULUZfYymozkKUWzoTdh908vmvazsGqivGJnG6J/Yd2hz0KXA+piAlStL
	 tltf0y1g0+BL2PCx2njpJypRGzj3lld8q+u5Zlfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Sven Peter <sven@svenpeter.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 123/325] soc: apple: rtkit: Use high prio work queue
Date: Mon,  2 Jun 2025 15:46:39 +0200
Message-ID: <20250602134324.790208985@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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
index 8ec74d7539eb4..1ec0c3ba0be22 100644
--- a/drivers/soc/apple/rtkit.c
+++ b/drivers/soc/apple/rtkit.c
@@ -731,7 +731,7 @@ static struct apple_rtkit *apple_rtkit_init(struct device *dev, void *cookie,
 	rtk->mbox_cl.rx_callback = &apple_rtkit_rx;
 	rtk->mbox_cl.tx_done = &apple_rtkit_tx_done;
 
-	rtk->wq = alloc_ordered_workqueue("rtkit-%s", WQ_MEM_RECLAIM,
+	rtk->wq = alloc_ordered_workqueue("rtkit-%s", WQ_HIGHPRI | WQ_MEM_RECLAIM,
 					  dev_name(rtk->dev));
 	if (!rtk->wq) {
 		ret = -ENOMEM;
-- 
2.39.5



