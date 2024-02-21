Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B08469318;
	Wed, 21 Feb 2024 13:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522065; cv=none; b=i0EQKKDvc0fqEi0M0rlnR+WecX5uTn5jG5jeLoucOODPrbs79mvirxMWjYZDZCfEdhC6x+i1pUg7OMkIezZKAPbOn3fhE4eWWKHgyexODaiZMvyeQhdI1QDMk/U+iYVTEoXYGbO5XLaJ8RUeP52dqyN8m4nDY3Vba+ZCjpV0QFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522065; c=relaxed/simple;
	bh=JFeZMby3k2WVXiBlSW3ZbM1KTyFMwvxDT+O7zWSgpBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFlRb+2pagZrXLOIZPZoy4Wj5g7TcP1z2PA5DELIc8vuNH3+B+cXsvqjYFM2TEctXx1wwFllo+3VUA/bfhlV/cm5hZjNnsO56S4l+VHTG9eetliotbpgoFCWkmmUhqp93RU5JApcZiBNH5X8BI4OmVVul7p02N59sO5nv5twg2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hjKmoP0l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hjKmoP0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA88C433F1;
	Wed, 21 Feb 2024 13:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522064;
	bh=JFeZMby3k2WVXiBlSW3ZbM1KTyFMwvxDT+O7zWSgpBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hjKmoP0lBzI1XmTqRMsTFUpIuo8Sw6XZQ/MYj/n3cDRfO7Q3xCrS1DioRFbrQZ6X6
	 DdArEhkr0am3F48W/jVeu110BRPQxBEtF7ZKdhIaB4uoW5mJW82zOxSj4hnYoEv9hL
	 ziVIkvzB5pebBKNby0++Ji+NoEYWblJSnECPVI2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 070/476] fjes: fix memleaks in fjes_hw_setup
Date: Wed, 21 Feb 2024 14:02:01 +0100
Message-ID: <20240221130010.522499427@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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
index 065bb0a40b1d..a1405a3e294c 100644
--- a/drivers/net/fjes/fjes_hw.c
+++ b/drivers/net/fjes/fjes_hw.c
@@ -220,21 +220,25 @@ static int fjes_hw_setup(struct fjes_hw *hw)
 
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
@@ -245,11 +249,11 @@ static int fjes_hw_setup(struct fjes_hw *hw)
 
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
@@ -272,6 +276,25 @@ static int fjes_hw_setup(struct fjes_hw *hw)
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



