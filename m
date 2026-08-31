Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8C84B205C;
	Mon, 31 Aug 2026 13:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184271; cv=none; b=dWnXJ/HXoDcXkj6kKaHDUVFXQn68DuircBJMm61G0+BgM/LmQUZyf7/i4W3pyw4Il6wK+3J06C9ZIH1gzXKy48WEhgZSL4aFYzwR4kCazATFW+lyrwaP9FOTR0x0pmY8kJURWQO1mgW9sSBuDVEWIHmVGgFfQp9HS74rKSUX/rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184271; c=relaxed/simple;
	bh=0nMdcWHoMbjFkXKaW9LYyviE9P+UWMTOEpxrEDXJu4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ricAYuFnNPcrb5YAmnvVs3a02G6LXy4qdnXpFl4szM+/AXvpBbDfZmaQVzclTrf3DY/xw1sOqma8z0qysz8ldRyH3Nq9bzE2xYlEr4w/TXV/OwgUf/DilTSLdRbyRZnHuI8yoghCOzur/EoKdL4hhqdi16fThjPWZE3CfYQOoos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QlwfXcSt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QlwfXcSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB88E1F00A3E;
	Mon, 31 Aug 2026 13:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184269;
	bh=cjFn8OLFRtQc9ugRdL6cFIF/sxJTTNG2Ga5OyTphwxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QlwfXcStyChfOArGcTpD62hKfrdu6F38VspwMOPsOgkKrCxOgAeNb6Mk5qnMJz5nX
	 whWv2YjFetyXCYu5NolDPNv67fHJITV0akOuCbUwpFOdKreWuC6Wssj4f872R/Xr0U
	 J45MrftUwXXZFC6hz9/6l9vvNKu/Xcw1LXYHIbXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 21/99] media: platform: exynos4-is: Add hardware sync wait to fimc_is_hw_change_mode()
Date: Mon, 31 Aug 2026 15:33:50 +0200
Message-ID: <20260831133400.965838271@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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



