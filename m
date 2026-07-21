Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145D447127D;
	Tue, 21 Jul 2026 18:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658842; cv=none; b=baCgBSBlWIHvlVzO0dIXYkSL40tbAqHXPcpADh6AAQZTSdwRGDKoLDVY4LjALHJJKxsbL60pTNOU1p/t8TkYPGwvO+kPTfQiyzs5B8jjJ22Q8bqjmQ4fzn09fx7L3CbnoQC3KIMVfCzyEfagpLuNkDU6rG3KcGhgBaePFlEkpoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658842; c=relaxed/simple;
	bh=UmWibYr1ENTZVlEWutqMXa/k5xZcSF6wAiFugIvRL4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rTKGsZ0xd8HGQ6Jq9TfBCTZjnWUpg+IdGj4yVsvhCAWb9TO00slZmopY5PxQvgzZLxM/lS5FekrMY8gG0HQdcuqk/ubJuMC7GUz6BF0G77CXKx/mR7wkox4RTeE0ZOWIkHVnjrZkd4nB+7k5lIraGgb4tjCOIPX5XE28uUq/U2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lF4lBtgK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lF4lBtgK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23E41F000E9;
	Tue, 21 Jul 2026 18:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658841;
	bh=I2S3zlLIJ7ACD9PZCeAmb9fiwFkKvf4U4JMW/YzEKd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lF4lBtgKDut049vmvCs3RtgY/DbEk80t9gm+wXjsVjTTjCo3fTaPZcNsYdAej3RGy
	 LoZ3y5IMTP27QSg34ZQEAW92jP/PTP3c6n2xWXlZHxvDX8bCQnXMOp/mxT3ZvGexfv
	 8I6uCRf297dKo+1nUAQJcFu8xVJ+oD7IRAMiIz5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kartik Rajput <kkartik@nvidia.com>,
	Frank Li <Frank.Li@nxp.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.18 1294/1611] dmaengine: tegra: Fix burst size calculation
Date: Tue, 21 Jul 2026 17:23:30 +0200
Message-ID: <20260721152544.551478821@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kartik Rajput <kkartik@nvidia.com>

commit 4651df83b6c796daead3447e8fd874322918ee4f upstream.

Currently, the Tegra GPC DMA hardware requires the transfer length to
be a multiple of the max burst size configured for the channel. When a
client requests a transfer where the length is not evenly divisible by
the configured max burst size, the DMA hangs with partial burst at
the end.

Fix this by reducing the burst size to the largest power-of-2 value
that evenly divides the transfer length. For example, a 40-byte
transfer with a 16-byte max burst will now use an 8-byte burst
(40 / 8 = 5 complete bursts) instead of causing a hang.

This issue was observed with the PL011 UART driver where TX DMA
transfers of arbitrary lengths were stuck.

Fixes: ee17028009d4 ("dmaengine: tegra: Add tegra gpcdma driver")
Cc: stable@vger.kernel.org
Signed-off-by: Kartik Rajput <kkartik@nvidia.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://patch.msgid.link/20260422064134.1323610-1-kkartik@nvidia.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/tegra186-gpc-dma.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/dma/tegra186-gpc-dma.c
+++ b/drivers/dma/tegra186-gpc-dma.c
@@ -825,6 +825,13 @@ static unsigned int get_burst_size(struc
 	 * len to calculate the optimum burst size
 	 */
 	burst_byte = burst_size ? burst_size * slave_bw : len;
+
+	/*
+	 * Find the largest burst size that evenly divides the transfer length.
+	 * The hardware requires the transfer length to be a multiple of the
+	 * burst size - partial bursts are not supported.
+	 */
+	burst_byte = min(burst_byte, 1U << __ffs(len));
 	burst_mmio_width = burst_byte / 4;
 
 	if (burst_mmio_width < TEGRA_GPCDMA_MMIOSEQ_BURST_MIN)


