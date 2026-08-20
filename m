Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2512737C92A;
	Thu, 20 Aug 2026 15:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238263; cv=none; b=hv/9ISL7N67oywGP7JwGtT3akJt7Xq44WSRuoW5BDRKKapFOuPWdoY7QiMkHRKDf4Pp/KodxOy1oRz9wD/tomCxWIjMeciArflcISLZ9+LPGyQviG2n8qWsgxJZw1+WvuaLSPp4sbbPfwmvfnBVPayITxUvMg0xvInNBG++nl2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238263; c=relaxed/simple;
	bh=q02SaPUZhs+zOB0N9bbb/P0fmcx65TMIEz+5YJGG9CI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aS6QnDTNjw7g8RVeCSx668IRAZc6qT4QwM2RCwrxAQFvf5QDE3lHdTo0G/QPgjRWIWZuaE8bl433CDl4ffbY9lmLdSfAGNyMwWmG5j//9wiq2H2CoFUYPAzI9BMoWw8HPYfnrFgXRDUN9Q0tKq4jen50dq5Ia2qp1YJYliXZK6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OYhMXWMx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OYhMXWMx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783931F000E9;
	Thu, 20 Aug 2026 15:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238262;
	bh=AVuTSUha+hSvyvIhA3enCJ6glCNBab5lfrLqWRYFid0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OYhMXWMxScxndCans8yfg538kng/9gb9+Ggt53c6vu+j9KFY+o7fanQd95CdDJPJN
	 yqMDFcenhGiseWf78whHMRnJq2bdj9DNSXXOPOa/DPsEGgDf1xmmH5PLtifvmrBFQs
	 ehodpn3m6KtQ2rOW5RHnVxPdapdGyBO+7dWF+UfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.1 086/228] mmc: loongson2: Fix sg iteration in data reorder functions
Date: Thu, 20 Aug 2026 16:53:48 +0200
Message-ID: <20260820145247.259408226@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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
@@ -641,8 +641,8 @@ static void ls2k0500_mmc_reorder_cmd_dat
 		return;
 
 	for_each_sg(cmd->data->sg, sg, cmd->data->sg_len, i) {
-		data = sg_virt(&sg[i]);
-		for (j = 0; j < (sg_dma_len(&sg[i]) / 4); j++)
+		data = sg_virt(sg);
+		for (j = 0; j < (sg_dma_len(sg) / 4); j++)
 			if (cmd->opcode == SD_SWITCH)
 				data[j] = bitrev8x4(data[j]);
 			else
@@ -758,8 +758,8 @@ static void ls2k2000_mmc_reorder_cmd_dat
 		return;
 
 	for_each_sg(cmd->data->sg, sg, cmd->data->sg_len, i) {
-		data = sg_virt(&sg[i]);
-		for (j = 0; j < (sg_dma_len(&sg[i]) / 4); j++)
+		data = sg_virt(sg);
+		for (j = 0; j < (sg_dma_len(sg) / 4); j++)
 			data[j] = bitrev8x4(data[j]);
 	}
 }


