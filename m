Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3227755EF;
	Mon, 29 Jan 2024 17:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548591; cv=none; b=uvxgEHpJQtD+8vndT4+J+tgSOPAIK5xM2WbIBrLrLpumRNseZWlsjXmR+bxcf2JwtaaJFKXbuMCZ4sK7vAC7yIuDIER4otDXeVcDyQeQg4nNpBmUTuovFDHPU3Fj5qNWTaCTKJuLu5auVK72NEsQonCquXG4P6Gi0Kt5wEWWYOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548591; c=relaxed/simple;
	bh=QWZtqCBWlBZoQ9IVRM1kBRdMmAMO3xuyzOACU89wT28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kCwnkWFH39gClHicP8txcHgIltvn7U5tw8FEr/bLJxrKvKCY5UlOQKb1mUc2v10ITysLpVpoEBUgyhdpRSOfxwBe9UJ7OgOapkFkcm8MLcH4L/crPC9e8dUQRycpC0Ifb0tPPndoFlS65jA+VoSo4MEhnRlYMv5+QQNnCYTErK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ezH9aLcS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ezH9aLcS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9CCC43394;
	Mon, 29 Jan 2024 17:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548591;
	bh=QWZtqCBWlBZoQ9IVRM1kBRdMmAMO3xuyzOACU89wT28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ezH9aLcSvYAwNqmz+8r63akK+wO2QkfiL1P2uKr/POmRRNEs3eKD1cdkEHLpP2I3Z
	 CkcFNzmU8rWmXCtLRErw4n16BH2gLeIq877WHsORAh6w8owEA40xCI8waBjlU2Itjr
	 ZiFi4uqxpsa+Eat4jfllycAV6FF0YJNdEqKtBFjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 225/331] fjes: fix memleaks in fjes_hw_setup
Date: Mon, 29 Jan 2024 09:04:49 -0800
Message-ID: <20240129170021.457745876@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhipeng Lu <alexious@zju.edu.cn>

[ Upstream commit f6cc4b6a3ae53df425771000e9c9540cce9b7bb1 ]

In fjes_hw_setup, it allocates several memory and delay the deallocation
to the fjes_hw_exit in fjes_probe through the following call chain:

fjes_probe
  |-> fjes_hw_init
        |-> fjes_hw_setup
  |-> fjes_hw_exit

However, when fjes_hw_setup fails, fjes_hw_exit won't be called and thus
all the resources allocated in fjes_hw_setup will be leaked. In this
patch, we free those resources in fjes_hw_setup and prevents such leaks.

Fixes: 2fcbca687702 ("fjes: platform_driver's .probe and .remove routine")
Signed-off-by: Zhipeng Lu <alexious@zju.edu.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240122172445.3841883-1-alexious@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/fjes/fjes_hw.c | 37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

diff --git a/drivers/net/fjes/fjes_hw.c b/drivers/net/fjes/fjes_hw.c
index 704e949484d0..b9b5554ea862 100644
--- a/drivers/net/fjes/fjes_hw.c
+++ b/drivers/net/fjes/fjes_hw.c
@@ -221,21 +221,25 @@ static int fjes_hw_setup(struct fjes_hw *hw)
 
 	mem_size = FJES_DEV_REQ_BUF_SIZE(hw->max_epid);
 	hw->hw_info.req_buf = kzalloc(mem_size, GFP_KERNEL);
-	if (!(hw->hw_info.req_buf))
-		return -ENOMEM;
+	if (!(hw->hw_info.req_buf)) {
+		result = -ENOMEM;
+		goto free_ep_info;
+	}
 
 	hw->hw_info.req_buf_size = mem_size;
 
 	mem_size = FJES_DEV_RES_BUF_SIZE(hw->max_epid);
 	hw->hw_info.res_buf = kzalloc(mem_size, GFP_KERNEL);
-	if (!(hw->hw_info.res_buf))
-		return -ENOMEM;
+	if (!(hw->hw_info.res_buf)) {
+		result = -ENOMEM;
+		goto free_req_buf;
+	}
 
 	hw->hw_info.res_buf_size = mem_size;
 
 	result = fjes_hw_alloc_shared_status_region(hw);
 	if (result)
-		return result;
+		goto free_res_buf;
 
 	hw->hw_info.buffer_share_bit = 0;
 	hw->hw_info.buffer_unshare_reserve_bit = 0;
@@ -246,11 +250,11 @@ static int fjes_hw_setup(struct fjes_hw *hw)
 
 			result = fjes_hw_alloc_epbuf(&buf_pair->tx);
 			if (result)
-				return result;
+				goto free_epbuf;
 
 			result = fjes_hw_alloc_epbuf(&buf_pair->rx);
 			if (result)
-				return result;
+				goto free_epbuf;
 
 			spin_lock_irqsave(&hw->rx_status_lock, flags);
 			fjes_hw_setup_epbuf(&buf_pair->tx, mac,
@@ -273,6 +277,25 @@ static int fjes_hw_setup(struct fjes_hw *hw)
 	fjes_hw_init_command_registers(hw, &param);
 
 	return 0;
+
+free_epbuf:
+	for (epidx = 0; epidx < hw->max_epid ; epidx++) {
+		if (epidx == hw->my_epid)
+			continue;
+		fjes_hw_free_epbuf(&hw->ep_shm_info[epidx].tx);
+		fjes_hw_free_epbuf(&hw->ep_shm_info[epidx].rx);
+	}
+	fjes_hw_free_shared_status_region(hw);
+free_res_buf:
+	kfree(hw->hw_info.res_buf);
+	hw->hw_info.res_buf = NULL;
+free_req_buf:
+	kfree(hw->hw_info.req_buf);
+	hw->hw_info.req_buf = NULL;
+free_ep_info:
+	kfree(hw->ep_shm_info);
+	hw->ep_shm_info = NULL;
+	return result;
 }
 
 static void fjes_hw_cleanup(struct fjes_hw *hw)
-- 
2.43.0



