Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E8947A862;
	Mon, 31 Aug 2026 13:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184455; cv=none; b=GMe/tYAE3bKVktkUgMHmaCTTMZP7M85haDhmn4QhFhsgAphI0WoggYC/3qd6lEhtXLmACjF2QpLE5qLGQRLnc17VrlLtw3chRa92diMQXr1KwEVkAWCCBJKbSDe87jMjSSA6WLg+lywGA8zVOpVABr1NlT1/KsXM5Gb59kgL5t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184455; c=relaxed/simple;
	bh=b6LlTJ1f7Mroi6E/xGeP8KveHYGjQTARGkmaBEJZln0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DVWHRG0T8op7PwrhfX1WjVlQ5GQesvK3ErNj01RRNobAM8RWaqfLcFKN3ZYBQ3VW9hOL6/d9j8lf/Ap3ptrhpmgDuVru394Jhka1NBLzbBwhYoJTN0UH02hvK/4wX/sDrhS0dqjEvfJLAMgCVTjUPiP9ih6shHEUvvde1lrD3l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AIlvNJyd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AIlvNJyd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5271F000E9;
	Mon, 31 Aug 2026 13:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184453;
	bh=IHY5N2T4MN0sGZK2pGswFzGAT0FElJT59w2Gsw8ZcKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AIlvNJydWqt1bl0BTjAd5ch/3N1Zv0RURwUDM6xd7MessxKolV+Enfk/n5CgHBnjs
	 JKJ2qmNolxsCdpDK83gLeWMy5D91rBGliEfXSKc/7JeWsFncKA9jg1igk5owFwtYge
	 9ct07mBZ+BGEhrKM+OYS9ZR8fsy67IZDBnhpK7C0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 14/91] media: platform: exynos4-is: Add hardware sync wait to fimc_is_hw_change_mode()
Date: Mon, 31 Aug 2026 15:34:02 +0200
Message-ID: <20260831133400.289424092@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit bd9f6ce7d512fa21249415c16af801a4ed5d97b6 ]

In fimc_is_hw_change_mode(), the function changes camera modes without
waiting for hardware completion, risking corrupted data or system hangs
if subsequent operations proceed before the hardware is ready.

Add fimc_is_hw_wait_intmsr0_intmsd0() after mode configuration, ensuring
hardware state synchronization and stable interrupt handling.

Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/samsung/exynos4-is/fimc-is-regs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/samsung/exynos4-is/fimc-is-regs.c b/drivers/media/platform/samsung/exynos4-is/fimc-is-regs.c
index 366e6393817d2..5f9c44e825a5f 100644
--- a/drivers/media/platform/samsung/exynos4-is/fimc-is-regs.c
+++ b/drivers/media/platform/samsung/exynos4-is/fimc-is-regs.c
@@ -164,6 +164,7 @@ int fimc_is_hw_change_mode(struct fimc_is *is)
 	if (WARN_ON(is->config_index >= ARRAY_SIZE(cmd)))
 		return -EINVAL;
 
+	fimc_is_hw_wait_intmsr0_intmsd0(is);
 	mcuctl_write(cmd[is->config_index], is, MCUCTL_REG_ISSR(0));
 	mcuctl_write(is->sensor_index, is, MCUCTL_REG_ISSR(1));
 	mcuctl_write(is->setfile.sub_index, is, MCUCTL_REG_ISSR(2));
-- 
2.53.0



