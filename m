Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C89B51EE0C;
	Wed, 23 Sep 2026 14:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173797; cv=none; b=YyYXYZdx3nwZX32IDjae6znnrns+/dhPO7eik7a0Ckax+5a4Y6BcLUuxINDjvuC5tkebOQlXZL5ItjjgLfHQXYdsqaTc+9A1v4agDsADTbXGGHrUHwVFBorwQChPG0xyxUH9rPVIdtjv3wSddIn+XqpDQANA6EgW0jwhDlKzxJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173797; c=relaxed/simple;
	bh=CdKyLr6VtkkD0Erwz/YqCF4jpUZheXMsIaLmkeILE4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZEx9PSegVrp/ibpJ0M2CNy2xn/ufZt87aeodknCPfn8JA0iqCoY3gJSsJlRj9JPVcQiNPxeKsnseq/3mxC8tPyV55DFFFSNSO+BqR+E7WRLk+wlQ5qiYvhb6XUvuvzXcv+8troMV3YlukVA2EDkJan+46e294vqOLpmKB4Hsco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KKIoqWyx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KKIoqWyx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403121F000FF;
	Wed, 23 Sep 2026 14:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173795;
	bh=mLYCtBmV0dwtglMGph0U5zVSja+PwoGV3OT3uTFRHWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KKIoqWyxwWZor4FiASmvGFNVN/erUy49nTtADkBVcIJPfmNPpx/UOia3jSHkvHBGq
	 GiRTDpTGmzNaT8aZBMSglGkNImwPjBthplzEBoENmzt7BPscGfna6PZNRP1o3nNRPD
	 g9GwzJreFfLVzga2lRv0LY7I5/wtfOeHwiXuHieo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.2 347/438] mmc: sh_mmcif: initialize IRQ-thread mutex before requesting interrupt
Date: Wed, 23 Sep 2026 16:06:08 +0200
Message-ID: <20260923140653.811266180@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit d5ea0d226e8f0801d78702142a124d78c317d822 upstream.

The threaded IRQ handler can run before devm_request_threaded_irq()
returns, but thread_lock was initialized afterwards. Initialize it before
requesting either interrupt.

Fixes: 8047310ee984 ("mmc: sh_mmcif: fix a race, causing an Oops on SMP")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sh_mmcif.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/mmc/host/sh_mmcif.c
+++ b/drivers/mmc/host/sh_mmcif.c
@@ -1461,6 +1461,7 @@ static int sh_mmcif_probe(struct platfor
 	host->pd = pdev;
 
 	spin_lock_init(&host->lock);
+	mutex_init(&host->thread_lock);
 
 	mmc->ops = &sh_mmcif_ops;
 	sh_mmcif_init_ocr(host);
@@ -1519,8 +1520,6 @@ static int sh_mmcif_probe(struct platfor
 		}
 	}
 
-	mutex_init(&host->thread_lock);
-
 	ret = mmc_add_host(mmc);
 	if (ret < 0)
 		goto err_clk;


