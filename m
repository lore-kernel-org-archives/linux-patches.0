Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5513637647B;
	Tue, 21 Jul 2026 17:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654621; cv=none; b=jRP4W1RasWA4WRoV9xx2mVSM+13gvnUaApWLrzRWW+mnPhF4c6dEgt06sz7MkBtxtVzIJDIQ+H1uB0ZGsgXpzPorDoWCzZgBQE0L12ufvt+UKAh5Y6LL5CWNoN0LyvWgtjxHeOc8uRSj0vxZ4KjqkyxP3vZHvk5V0AygbrdyHtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654621; c=relaxed/simple;
	bh=I6DY7lUq0MVIPX61Vhm/RUdLjsNP/TAv/JeCwdxt3Xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uT/2AZG9odJE8t7TlVIvFER2HXSE7AT9XBw5JxgGsf6xg4wrlBRv94y1hRXfD3HMsMjdv8s830HxKd1JHdFELlqR2vmMMQzdgUIK2LOmyNEkqpKpo2PTg0F+jAlueubvFrCE4MWz7sUy5DKHmz2sc/wOxAD/jRS4Z/Wfm3bM9as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cvdXtBtk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cvdXtBtk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3A01F000E9;
	Tue, 21 Jul 2026 17:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654620;
	bh=bUDKwJCXMkU+69xDCQb6eKfOfUIgiRgUhKS12oEQ6wA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cvdXtBtkpV8MYUSY30nFmKxFTTcPInaYF53HqUdwSaWkpcKsGUVnkv5gg91PZ78WQ
	 A0/74K6Y/gGcbmx0K6+3UiG+yNKVvsYEkXf7R4jrMrSQv5wzlVbrtdr7axxe/nwuDx
	 4+nKxzlxeJPwGwOOuLuY1k3YEI/EYDNse0IxysLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kartik Rajput <kkartik@nvidia.com>,
	Frank Li <Frank.Li@nxp.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 7.1 1774/2077] dmaengine: tegra: Fix burst size calculation
Date: Tue, 21 Jul 2026 17:24:07 +0200
Message-ID: <20260721152634.594697982@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


