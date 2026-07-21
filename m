Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CF12EBB8D;
	Tue, 21 Jul 2026 20:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667417; cv=none; b=foq4WMa6j0tf+EYoj1V9C9CeYOpQ+wHp+nL0QYtQqJGCrverc/YydyOzFk3+XQGTppRFvVbsSxOggCG1Tc5uCHr7WG/YF5Rljstsyz2Hjc6TjBn1Eat1hFZKBVKLBBRrJiWIjerJWXk94Ag55q4LFZAoYIuNBJ/4WE1tRbcJzxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667417; c=relaxed/simple;
	bh=aDmGdITT/fE+UcU0qto9AbYX03H29UM/mK/wEvF641w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=slb8eqIfA9BpfKi6Ks2ei/sENL7G56Wf8btmeqjcQ2PWMCquq94Y8F13oZg2fB+a6uns1bf0EDRglNu53ZYVFstZ+jCZ8hLJJ6EAHlj03mM86tGVS3VEUoHVfZiphUUSVm5/Tkj1SEA0G2Le30uIyB7caD5CRDqYUOk8PHi1faA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ugiKpEsj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ugiKpEsj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D85011F000E9;
	Tue, 21 Jul 2026 20:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667416;
	bh=y3rkyiaGpqEQyfQJQH8ORtrVPF88ooX90LpwWMNlaYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ugiKpEsjyBGjma5fVlB2jyavP4Lp+HHbGEmtgAiqUWGucVUisslu4a9b3wXJwlewu
	 0h5b+7z0r3NAomFOvnXq/hoSXZfTbKSPdTLW894+eex8LSrrDuFwfqc/T4NeHxP3nB
	 ATB1TLuA8MffxTX+RqTrFIK8g+NkKCl0y9G8ufZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kartik Rajput <kkartik@nvidia.com>,
	Frank Li <Frank.Li@nxp.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 1016/1266] dmaengine: tegra: Fix burst size calculation
Date: Tue, 21 Jul 2026 17:24:13 +0200
Message-ID: <20260721152504.563666693@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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


