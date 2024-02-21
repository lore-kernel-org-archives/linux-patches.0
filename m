Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CA63EA71;
	Wed, 21 Feb 2024 13:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521154; cv=none; b=X3xrHEZDfVkff7WWk5X9ggQ7IDH5eBjk7AgGLTzhwhBglmrYWvKsS3KkR/mA3uuN2TQ+Pfe8NZ7vlzLvsOJZMZJ5/jNJm4S+t9Lo6VmzUzK2Rj0uKps+zcA2Z0j5FrYk9lJkAOZeh8FtFlFabzqi7QBmPm1j/eplNlbc1YAlqj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521154; c=relaxed/simple;
	bh=seQsWcEqfHz5ZJ6TSOOCCTpEs7C29ETyoSDGpnZBYGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SAls8v5dMpXkm0IDuVhdXFbESZFl96lRl+ZV8h6KlBh+x6XoUbb+juDTzPNB8FYgexF45C8N1bJvQXwbWZsjL+ehB3Qw/MKSlcvJTnO99f1OvYSvMvGTv/MShGHLDrLhCp2ay1UqQzNDZe0DiZ/j1afCyTRtU7Zie3j5IYJs04I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eWHnJSep; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eWHnJSep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F42C433F1;
	Wed, 21 Feb 2024 13:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521154;
	bh=seQsWcEqfHz5ZJ6TSOOCCTpEs7C29ETyoSDGpnZBYGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eWHnJSepY3J8BMlZKpC7lmDr1RQBdI4VAig8Ub/PIO+XG1XWpJuF3bjgEqR+UH3se
	 isqUA305vNZ9OjX450MmC9/eax/0xIpU3CR9FGRwNPPYKwzYUKaczQNtswi+kvNCPm
	 N2kDSdGCKURqv0VbOaQt7l4N5H4nXBGQ6sBo8J28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 035/202] fjes: fix memleaks in fjes_hw_setup
Date: Wed, 21 Feb 2024 14:05:36 +0100
Message-ID: <20240221125932.926203508@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 9c652c04375b..c3fa8db69b9e 100644
--- a/drivers/net/fjes/fjes_hw.c
+++ b/drivers/net/fjes/fjes_hw.c
@@ -235,21 +235,25 @@ static int fjes_hw_setup(struct fjes_hw *hw)
 
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
@@ -260,11 +264,11 @@ static int fjes_hw_setup(struct fjes_hw *hw)
 
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
@@ -287,6 +291,25 @@ static int fjes_hw_setup(struct fjes_hw *hw)
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



