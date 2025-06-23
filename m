Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B8170838;
	Mon, 23 Jun 2025 21:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712948; cv=none; b=affFmEyRkfLJjWBRPnmhgXJNxj+YfBu6TEEWxQeSxCnnmxJj4rfZt4haS67C0WBPvEzY7iPdWOTRHoZurs2J3h/K1170FVvWWLACB9U64iVdjmwnI+L2+EjDqWBbIXx56d6kqaNXsK1Zbym/3rpGmJSwdaaksULoXvzlIv6uoRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712948; c=relaxed/simple;
	bh=zUU5QXN4aP6ZH0Nn9L0DaW1kGEmP5/dMso8esHR+CPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CeWCCkLb+yToteMs/QFOgPMxFkA1BEl1wy/nCes/dL39H4UvAVtFAkMxY7maF/8kWvSfcj75C9K7J34lR6bZX+e5L3y3lqskMEMuQKlcUxDGmxAyx90GMGirHQwjyAJK1RVD5jVGrGXzTYSGEABEucF59aawp3w6vSPaK74mh54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ShiJaEB9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ShiJaEB9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9501C4CEEA;
	Mon, 23 Jun 2025 21:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712948;
	bh=zUU5QXN4aP6ZH0Nn9L0DaW1kGEmP5/dMso8esHR+CPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ShiJaEB9DLqTyx+k12ZjSxBLDlf/PO1j3O7oNhwXWtoHcnspNiTF60n3Dw64W9Yz0
	 rrxbkXCb79SrnKTYLn2pY0sAy+isenepWFHJAfNLTlR4b2mxGNxvqt7OClJaNXbUui
	 ik53cL6Ef4BCUNj0+MH3lPiZn1FwNPXoBp2rzgL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 302/592] media: platform: exynos4-is: Add hardware sync wait to fimc_is_hw_change_mode()
Date: Mon, 23 Jun 2025 15:04:20 +0200
Message-ID: <20250623130707.578747710@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
2.39.5



