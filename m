Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED64813C3D8;
	Thu, 23 May 2024 13:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470513; cv=none; b=YxAvVnAaMjNAxwW0SCo5Y499nSTyx4l4dbLeO4CRx4hJSMzt/dc7ys23f247oFa6YGw9oWU9jJSi4z+dBSN6ZMSD4Iim+8UuWRaWx0CVVAB9/NSH2Bfv837yb4mSGtZkDViO1lvDozuX3HFs2N6LzsLOdDVDFxJsk02C4IqB5M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470513; c=relaxed/simple;
	bh=Oz3OXM7xvNIFQoFhY816PqPSXq60bGYVycG/Mi00SWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YiJilEX/4hw22C4fhFONgF+3ueQ7XHiEx7j57zLPNT1b2nyW8pOsDjptIRb8aJvA2CIOk3/DQ0XHwFccARBJAlCqIQO55bPiQtJ+Kcv63RtbKk0W+yd535YNPfYW7sO3QSERR7Q9CBqAydBtcmozwiI3mkyz1qIzfH5hriAOHDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y3Jt3ULZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y3Jt3ULZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21FDDC4AF08;
	Thu, 23 May 2024 13:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470512;
	bh=Oz3OXM7xvNIFQoFhY816PqPSXq60bGYVycG/Mi00SWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y3Jt3ULZ8n3V3WjMYG2WDPfUAeQLWFeWDDFK6z+xDarTrhIln4KzsBczRfGe5vCfi
	 z6qv0g/G0XAgfO/I38FJ8NvsdkUFSybX62PPCaZfO8ceIO99dLhjnUorZrjTJPVcex
	 Nkq025tUkxan/Us6iiCmKtDjsV2Y86ua873RGdDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.8 17/23] remoteproc: mediatek: Make sure IPI buffer fits in L2TCM
Date: Thu, 23 May 2024 15:13:44 +0200
Message-ID: <20240523130330.403157162@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130329.745905823@linuxfoundation.org>
References: <20240523130329.745905823@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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


