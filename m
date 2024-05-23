Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9AB414B077;
	Thu, 23 May 2024 13:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470266; cv=none; b=Y3R8fb47kDfR6fKj8URatPsP82xS/pbCuoOUcOmorsEIymICYptMPav6bggLMjZD0TUlJas1Syow8Iwt/uwD82q2bA2YpfGtFZAhWYNc3BRf2s0ula08glGcq17flt+JYvCSOV6STLFQ+AsHR2kONLCQdk5AGwOrj2Jl8jC2Yhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470266; c=relaxed/simple;
	bh=yptMw5g5clDmkmEplPv+JAgYganX9VoNt78uNU31m98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lASRxcG28poeCuKAbSF2VhfN0NV4r/DS3uvaf3zvuJ4qDKtbmw+AL8MlzqVSaMkuVhLmGmgsEyppV1ej+kNV2SSSbBAAVQIgTEaA1EfkAPFWMmEk7AU3EudKkQ2X6Gl6Bsr8+P236CFlXSyJMZRELSOtiOV0m6TR+ErAn/JKprI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eK/DJXTw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eK/DJXTw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBDCC2BD10;
	Thu, 23 May 2024 13:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470265;
	bh=yptMw5g5clDmkmEplPv+JAgYganX9VoNt78uNU31m98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eK/DJXTwxE4Ei+w1ydT6IB+10MIGIqAhCWaAjxEWFyXsNIjhL9qnoHXYC9zJAx2wH
	 6RaR0WkyXGh9LcYon5ll/xzXku83Hup0DSdTUPegx/YXOaparljrSAgoBxAe2iTZHx
	 bgyZ3N7XiP15w27XQ0dVWUY5kGnFhq1KwzN9Saic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.9 17/25] remoteproc: mediatek: Make sure IPI buffer fits in L2TCM
Date: Thu, 23 May 2024 15:13:02 +0200
Message-ID: <20240523130331.035116956@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130330.386580714@linuxfoundation.org>
References: <20240523130330.386580714@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

commit 331f91d86f71d0bb89a44217cc0b2a22810bbd42 upstream.

The IPI buffer location is read from the firmware that we load to the
System Companion Processor, and it's not granted that both the SRAM
(L2TCM) size that is defined in the devicetree node is large enough
for that, and while this is especially true for multi-core SCP, it's
still useful to check on single-core variants as well.

Failing to perform this check may make this driver perform R/W
operations out of the L2TCM boundary, resulting (at best) in a
kernel panic.

To fix that, check that the IPI buffer fits, otherwise return a
failure and refuse to boot the relevant SCP core (or the SCP at
all, if this is single core).

Fixes: 3efa0ea743b7 ("remoteproc/mediatek: read IPI buffer offset from FW")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240321084614.45253-2-angelogioacchino.delregno@collabora.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/mtk_scp.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/remoteproc/mtk_scp.c
+++ b/drivers/remoteproc/mtk_scp.c
@@ -132,7 +132,7 @@ static int scp_elf_read_ipi_buf_addr(str
 static int scp_ipi_init(struct mtk_scp *scp, const struct firmware *fw)
 {
 	int ret;
-	size_t offset;
+	size_t buf_sz, offset;
 
 	/* read the ipi buf addr from FW itself first */
 	ret = scp_elf_read_ipi_buf_addr(scp, fw, &offset);
@@ -144,6 +144,14 @@ static int scp_ipi_init(struct mtk_scp *
 	}
 	dev_info(scp->dev, "IPI buf addr %#010zx\n", offset);
 
+	/* Make sure IPI buffer fits in the L2TCM range assigned to this core */
+	buf_sz = sizeof(*scp->recv_buf) + sizeof(*scp->send_buf);
+
+	if (scp->sram_size < buf_sz + offset) {
+		dev_err(scp->dev, "IPI buffer does not fit in SRAM.\n");
+		return -EOVERFLOW;
+	}
+
 	scp->recv_buf = (struct mtk_share_obj __iomem *)
 			(scp->sram_base + offset);
 	scp->send_buf = (struct mtk_share_obj __iomem *)


