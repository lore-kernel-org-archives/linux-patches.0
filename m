Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E20531629;
	Wed, 23 Sep 2026 14:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174991; cv=none; b=rBHB2I/Vm220x0p9OBNsPgAfrIQRseMqu0981g6yhu6YLxhd8m+pGLEWjRGHNQ8QdcLORWwlKUQizobopSyA8K1ad3DyVW1V0AVD+9ptqcv6t9uRbblgLtLMpHUMksmQH0TBlODxs7wOzTuGVRAt7awStaiTweMpc+oWN15o8F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174991; c=relaxed/simple;
	bh=EWn63qg3swwCcg1zA6B7zBEQB3CaC9nEn9Bqxao+N5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QezGQ73/p1FSsHb0ZiIiBTz6Zb1g/cRWnP3Rr6iMNaRipRuW2jUFXxIKwquRg7t1GO6G7upaWoKaKkxJlFqqbVZdmpmwjq5p3Wjumh0Mfys7Vqig1a/d0g6r1LQ5W5X2vGxe2yHwm+XGLc0LsyAB6W8cp8fHJ7WuZTFZBPwK9U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TDtM++9j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TDtM++9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE761F000FF;
	Wed, 23 Sep 2026 14:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174990;
	bh=ZgGSYVIJwQeKZy616Fi/s80xHvA/bQ544mw6qMhnRiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TDtM++9jmcwFIS0D6uWFroIRBftBoFovt5cvYZN672uw5+DG0gcimUVGRhIUBkdQ/
	 n6j8P9dVvxXWwntocBNI4ew4wSmKNa2N9/cNXyBu8tsg5TyaPCiBAlM0Yz0MoT7wcB
	 SbGJm7pMR6U8JWNbcepGKq7E0tonBAew8CTIi7ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 288/398] mmc: sh_mmcif: initialize IRQ-thread mutex before requesting interrupt
Date: Wed, 23 Sep 2026 16:06:02 +0200
Message-ID: <20260923140650.887312274@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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
@@ -1462,6 +1462,7 @@ static int sh_mmcif_probe(struct platfor
 	host->pd = pdev;
 
 	spin_lock_init(&host->lock);
+	mutex_init(&host->thread_lock);
 
 	mmc->ops = &sh_mmcif_ops;
 	sh_mmcif_init_ocr(host);
@@ -1520,8 +1521,6 @@ static int sh_mmcif_probe(struct platfor
 		}
 	}
 
-	mutex_init(&host->thread_lock);
-
 	ret = mmc_add_host(mmc);
 	if (ret < 0)
 		goto err_clk;


