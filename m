Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3EF737F31A;
	Thu, 20 Aug 2026 15:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238881; cv=none; b=VCoO/H/cMZU+FGi3u3cid9q/aCN/E2cKCb6vHNy+3C7KIeQSWqfSmUzqUVMoR5jOjuJIBzqKw7u/TkuMrSxZEv/8ovL+GkhevwFmIqOcMkJoHuh2WwSQ94plomEdzPEfhbqtw/GSHyQbAp0Wqgxtn585oC2JRLRpumLHRnQyGfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238881; c=relaxed/simple;
	bh=A40Me3YMKyuadQ2AG7W1R02wqpgNkZxfBSsdXJvJxEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CjH0AehpLU8gt66vdEBUWDQTFrURzhOCJ5RRx43ZLhMvj7sFBkbvrMILR1IpW0ZCEKpYOJ6q0e6wikIrOTd803ufG1bEjcSG8s4DThsY0UxeLsy2MkH4hJ60H/eKDTlCLYCvJ5B1zDuEiLS91PWgPpru0qIp7eq564HSZwLq34k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GxLPVX91; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GxLPVX91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB051F000E9;
	Thu, 20 Aug 2026 15:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238880;
	bh=uWYG2vmKfYZqyqVGW2XuBSaYS2fTT6WgtVx01yLt1+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GxLPVX91aHwYRqZ+hoXnpZ9zDvwuUer538E22A77//vZM6sST1yqpa2GCzKt2ZqS4
	 GHCfkLvQxwB2UXY9egrtdm1dmR1Gbo1fRMv1lGjTft62XLsawxxWRsNL4MSsjgMpQu
	 2+Alg8P3V/8JsUM7CB6ZKjTD+rsgcfIw6j5Y5E8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 072/217] mmc: loongson2: Fix sg iteration in data reorder functions
Date: Thu, 20 Aug 2026 16:54:00 +0200
Message-ID: <20260820145239.791231382@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Binbin Zhou <zhoubinbin@loongson.cn>

commit 00179ed9fbe07799676e2cb63c4e7f0e7cd80a5c upstream.

In ls2k0500_mmc_reorder_cmd_data() and ls2k2000_mmc_reorder_cmd_data(),
the for_each_sg() macro already iterates over the scatterlist entries,
with 'sg' pointing to the current entry. However, the code incorrectly
uses '&sg[i]' and 'sg_dma_len(&sg[i])' inside the loop, which treats
'sg' as an array base and indexes it again, leading to access of
wrong sg entries (or out-of-bounds if the list is not an array).

Cc: stable@vger.kernel.org
Fixes: d0f8e961deae ("mmc: loongson2: Add Loongson-2K2000 SD/SDIO/eMMC controller driver")
Fixes: 2115772014bd ("mmc: loongson2: Add Loongson-2K SD/SDIO controller driver")
Signed-off-by: Binbin Zhou <zhoubinbin@loongson.cn>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/loongson2-mmc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/mmc/host/loongson2-mmc.c
+++ b/drivers/mmc/host/loongson2-mmc.c
@@ -628,8 +628,8 @@ static void ls2k0500_mmc_reorder_cmd_dat
 		return;
 
 	for_each_sg(cmd->data->sg, sg, cmd->data->sg_len, i) {
-		data = sg_virt(&sg[i]);
-		for (j = 0; j < (sg_dma_len(&sg[i]) / 4); j++)
+		data = sg_virt(sg);
+		for (j = 0; j < (sg_dma_len(sg) / 4); j++)
 			if (cmd->opcode == SD_SWITCH)
 				data[j] = bitrev8x4(data[j]);
 			else
@@ -761,8 +761,8 @@ static void ls2k2000_mmc_reorder_cmd_dat
 		return;
 
 	for_each_sg(cmd->data->sg, sg, cmd->data->sg_len, i) {
-		data = sg_virt(&sg[i]);
-		for (j = 0; j < (sg_dma_len(&sg[i]) / 4); j++)
+		data = sg_virt(sg);
+		for (j = 0; j < (sg_dma_len(sg) / 4); j++)
 			data[j] = bitrev8x4(data[j]);
 	}
 }


