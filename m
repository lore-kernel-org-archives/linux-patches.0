Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8EA19D8A7;
	Thu, 16 Jan 2025 23:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737071621; cv=none; b=V5R2T1Xp/sLDkGdZkmiSrzqIl2qM3tSHwS5mY47eA7kDhQ7JAePu38rJn/w/MjRxwnJ2gpr5zDlHlz1YGz2MuxHT94x64mvxCs7CTU9lQPgNQgJBZEKXT53HQDMKtgH4U3lwZIOiBtiebEyzoBBXNMJTeEUzovPeuzj29ggUBTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737071621; c=relaxed/simple;
	bh=sUMbDwsTo0VJ3yJ0XkYGuivkZGTbbE1Ft7x2hokGYGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QRkOpBVAIHV46nQwKKqUA44+m8epnWPQwKuLEZ/WoIrXBz6FGX5Raim8+tx6vrV0s+oXVbNj44l6N4Lzxzd9KToYf5ttaXlowZavvlPvLzkhU1cWEEw9/m5AnzEMl97f0Di1oGbVv5SZGqPxe2WRGzem8vLRwyTy4OWyxOBl9kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hEeAnDpb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hEeAnDpb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DF5C4CEDD;
	Thu, 16 Jan 2025 23:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737071621;
	bh=sUMbDwsTo0VJ3yJ0XkYGuivkZGTbbE1Ft7x2hokGYGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hEeAnDpb73UN8jwU4H4a31LgDSOEU5iyB350lkNGXr8LUY+apvKduRPNR78Tap0Gw
	 SIT+X0m+PjWsKb0/xMDpecX86//CMY73U+13BZApm/PpCU3DekEPwEgM2Rkm9RO9W4
	 TNOMyvz9DV/zb+iHl7ErKYjVvKsMCoWa2LpfFCFKoYlJYsCi/zddMgvy0Wodeoz6gT
	 9G2zcFVWfhEMggPrvzir5GZnfUshgwUEEwzU7sTGOHuOg3DRUTq1z8WK3GFv82yldn
	 djqGH5I9IGqcll+HQ3XhLfUgt7GcINYICVkVgq7GXvhu3nGC6ggTgAODMbaEdsAi2D
	 zEBP0zm4YuOGA==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 2/2] spmi: hisi-spmi-controller: Drop duplicated OF node assignment in spmi_controller_probe()
Date: Thu, 16 Jan 2025 15:53:38 -0800
Message-ID: <20250116235339.300485-3-sboyd@kernel.org>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
In-Reply-To: <20250116235339.300485-1-sboyd@kernel.org>
References: <20250116235339.300485-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

spmi_controller_probe() assigns a parent device and an OF node to an
SPMI controller. However, the operations are not needed as they are
already assigned in spmi_controller_alloc(). Thus, remove the duplicated
assignments. An unnecessary OF node reference acquisition is also
dropped by this patch.

Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Suggested-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lore.kernel.org/r/20250116044907.2947218-1-joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/spmi/hisi-spmi-controller.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/spmi/hisi-spmi-controller.c b/drivers/spmi/hisi-spmi-controller.c
index 3cafdf22c909..122140b97579 100644
--- a/drivers/spmi/hisi-spmi-controller.c
+++ b/drivers/spmi/hisi-spmi-controller.c
@@ -300,9 +300,6 @@ static int spmi_controller_probe(struct platform_device *pdev)
 
 	spin_lock_init(&spmi_controller->lock);
 
-	ctrl->dev.parent = pdev->dev.parent;
-	ctrl->dev.of_node = of_node_get(pdev->dev.of_node);
-
 	/* Callbacks */
 	ctrl->read_cmd = spmi_read_cmd;
 	ctrl->write_cmd = spmi_write_cmd;
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

