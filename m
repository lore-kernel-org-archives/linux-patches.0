Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1EE13BAE2;
	Thu, 23 May 2024 13:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470343; cv=none; b=Zn257AANdZMoZHFHsfXSi4mHWtjcA0QlKOdA5Cf6dZYdDIT95N9V/LDnFTd4akq8vw4wFpu9MmX1KxgxhBm/ZqB/R/4nOXAGoLqmQHZvO9al6Hb6C+OX+bunVHRbvyouEHXqhsl2So7Ro5DslwkSYABahQAK1i49DGfAPAw/UGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470343; c=relaxed/simple;
	bh=ilrApoZFho2H220uP2dGrrk5TSpwBEEdij/960F1Nkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=atTwSReAL6rWLy8OJEtT6oHalXo5DPIMuChfzuot8qtBukGclM2VCyy5YpQPgBa7cFSn+XcBW2TggwjsiI7KC7PKZZkmHvxjHE4s+cKyY4xuqC8k5sPaAOurPkrj5C4clisNu+SkaMEJn60H1ZA+rWCgM1ytwLP5AMpzW/XS3VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WyTUDjYx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WyTUDjYx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DDF1C32781;
	Thu, 23 May 2024 13:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470343;
	bh=ilrApoZFho2H220uP2dGrrk5TSpwBEEdij/960F1Nkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WyTUDjYxHNznixyIpcdWaUvvNvgFJ/oKaW2y8GAfxERHvcY3X2HyVsj50ZyLchqh3
	 nB792I4CQWk/ynFd3tldQz0khAQ5siPWikHA82MrqSP8K19NC16JjkX/8Ug3+zBvVP
	 +nSw48gbUHh6xilUwW5DWDP3h/ICXFFJrax9YTn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.15 20/23] remoteproc: mediatek: Make sure IPI buffer fits in L2TCM
Date: Thu, 23 May 2024 15:13:16 +0200
Message-ID: <20240523130328.712314820@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130327.956341021@linuxfoundation.org>
References: <20240523130327.956341021@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -126,7 +126,7 @@ static int scp_elf_read_ipi_buf_addr(str
 static int scp_ipi_init(struct mtk_scp *scp, const struct firmware *fw)
 {
 	int ret;
-	size_t offset;
+	size_t buf_sz, offset;
 
 	/* read the ipi buf addr from FW itself first */
 	ret = scp_elf_read_ipi_buf_addr(scp, fw, &offset);
@@ -138,6 +138,14 @@ static int scp_ipi_init(struct mtk_scp *
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


