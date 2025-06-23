Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CC04315A;
	Mon, 23 Jun 2025 21:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714970; cv=none; b=WgR50OLxfbFk0bZ0GJ8AgJzJ4tjpHKRyPbtemeaxl71+aQ/rBP169l6bCDP1CHFNxjuu/8Xo4YVx9Sl9I5FCTu0bsmY/c/VFG+JbLcBoII51dTQRRvvi1jpHw/OpxS1+iMpZf28/uiIW4UnhkERp17G/y3FmbrmmtMfPmiviAsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714970; c=relaxed/simple;
	bh=GVnTrg8sr0T24Xi1AL3vAa0rWghpuhQllNGgQjQ+puE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZVbr3iClQilGBZd959rvr9dfyKoK3zgwbRF/7cg8FAslDmayt5u+XcEWhomvxmS/P5UbfWe8z4KfShYfAUhzyVcnw3EF34O2YV2gUDgr28brVkz7S+ek+nrhzXCnCPCAyIUCAgC9YnJBEt6AaqWBtP4fhIMGihBxS5ibVeZSbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kivw+23W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kivw+23W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2998CC4CEEA;
	Mon, 23 Jun 2025 21:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714970;
	bh=GVnTrg8sr0T24Xi1AL3vAa0rWghpuhQllNGgQjQ+puE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kivw+23W7DOoQozDkpcfgCi6aY1D+3NXVbn1uDGS8tHMSEGfzJij/hHbo/T4y8HQM
	 wLcotxeG+YdJyBpWSs9TsvOCZAVUVWu74Y3K4EmeC8YFsZNOB3MqKat9B/LQpsKAD+
	 BxKxyA/EW507XGtUhjXGrYpaRQ+90LTWU53Xf/1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 244/355] media: platform: exynos4-is: Add hardware sync wait to fimc_is_hw_change_mode()
Date: Mon, 23 Jun 2025 15:07:25 +0200
Message-ID: <20250623130634.081620648@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/media/platform/exynos4-is/fimc-is-regs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/exynos4-is/fimc-is-regs.c b/drivers/media/platform/exynos4-is/fimc-is-regs.c
index 366e6393817d2..5f9c44e825a5f 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-regs.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-regs.c
@@ -164,6 +164,7 @@ int fimc_is_hw_change_mode(struct fimc_is *is)
 	if (WARN_ON(is->config_index >= ARRAY_SIZE(cmd)))
 		return -EINVAL;
 
+	fimc_is_hw_wait_intmsr0_intmsd0(is);
 	mcuctl_write(cmd[is->config_index], is, MCUCTL_REG_ISSR(0));
 	mcuctl_write(is->sensor_index, is, MCUCTL_REG_ISSR(1));
 	mcuctl_write(is->setfile.sub_index, is, MCUCTL_REG_ISSR(2));
-- 
2.39.5



