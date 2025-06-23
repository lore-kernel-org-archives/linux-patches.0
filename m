Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E429370838;
	Mon, 23 Jun 2025 21:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712936; cv=none; b=YA/QyF59VLrw7W9OfN3/Yi4EHLAy10N5lTPtOTxa+k+bGtJX9eqqQNHbsamMt6z9Osh4wSbR6rynyKexyFyggLcqCiLkx2lK/WG00DpZtRXLAAqorIQoN98K4wRu0jYJZQupL+rx/YWyJamzXyybX727O8PKdA9o4qJz9suQDLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712936; c=relaxed/simple;
	bh=0+I22fZl1Uveo26MaDpfhtV7/iWP6sfoN7/yJD9xrbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQiZelRUbYp5f663ynGNMKa6UlNiN0wZdQU71Ko2HbEEB//mDhaHjknzAokHKE/fGJuw6CjUTFBlHMWtFibrbpp8pIgciFai843Sy/6wFKrqJpN5wctmsy2B5W5zoPYmnG1XopqGEQ9Azew+p58/a91QedlKqhzlZS0nD6fjyrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xBkOQ0r/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xBkOQ0r/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E98EC4CEEA;
	Mon, 23 Jun 2025 21:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712935;
	bh=0+I22fZl1Uveo26MaDpfhtV7/iWP6sfoN7/yJD9xrbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xBkOQ0r/01tXX70lO+Vpr4C3AtHPxK6mYkTqYKf3M3rKvxl3t/4eYuEkgy6bWpgNt
	 r4Or/n2Sm5lq9LAL/LsZ+dhf23Byzb9YhlN/CEDQByGOjk2zdXVjt5c20uav2pEDLQ
	 YTA8nX0iwDByp8zRUWfNcqFLn81mo19JLwP4bhKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 156/222] media: platform: exynos4-is: Add hardware sync wait to fimc_is_hw_change_mode()
Date: Mon, 23 Jun 2025 15:08:11 +0200
Message-ID: <20250623130616.775216020@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



