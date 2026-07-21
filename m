Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB3144AB9E;
	Tue, 21 Jul 2026 21:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670138; cv=none; b=bCZpyVRQZ3bjT71ZKd3rMtMdElP6/UcvdKOL6UiJybcSGQCtDg3WQ3Z+DV4o50+m+jzF+ODDjhBTfsGYuzwl2dvRwF8TTQsC75fVMJaHR3oaLjuRNHu1LXo2OvHZOXYh6obxrOIwjY0ow4hbxlY74YD/qbkab0kqjDjFOLkxIuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670138; c=relaxed/simple;
	bh=rk0yIfOjv4keGvBwT64Z9FeDGylQwyoY6nkcb1NyiyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xl66Kx9CXpc/PA6dD6lG0kbns+qYN+Y6JVNm8FdsWyyFz10x6CvwcSdx/XQPRVUXr0z8GaDKSkwsdssPsBiCq4HdK8FEDpAcjNciLtZ9P9m7O79K+9c0pKmNLv/wx9QaCzQOQpXDwoEnKzkHecRy4JdQe8V9slztAK5CmxUx00U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dg5RXqYW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dg5RXqYW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A271F000E9;
	Tue, 21 Jul 2026 21:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670137;
	bh=Kg4Sxtf+fRD58P4os7+aw1UbidqQL9swzC0FSF5H++0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dg5RXqYW18nSCXk2uykWVCSyJeesUaPlZwZWxfJXmJGfFnLvUoon8vaiPpaAslBeo
	 t7PJ9hERe/cDbDt1NnEQY2LylI0HK6sITS99EyOLueYKK2hAMxg4yEvKkYiRy1tZxh
	 LsMl41HmwdNkfNG2c3e1xiAaFAzj6ijvdhPfyQtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kartik Rajput <kkartik@nvidia.com>,
	Frank Li <Frank.Li@nxp.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 0819/1067] dmaengine: tegra: Fix burst size calculation
Date: Tue, 21 Jul 2026 17:23:40 +0200
Message-ID: <20260721152442.875544794@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -821,6 +821,13 @@ static unsigned int get_burst_size(struc
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


