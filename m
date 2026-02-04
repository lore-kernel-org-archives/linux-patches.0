Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC84A2D8DA3;
	Wed,  4 Feb 2026 15:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218639; cv=none; b=aXnwvvHkEI9tvtmQ/HQHZ0fFxbONIc7k/ZX+dOBphrBNnZ27SeNT67/1o3eRWyiAcYh9mDMCKccB2+4tGosZrsrqutk18+maI+j67wdyEQ1Xjmthhpx3N9inQV7JTFb0t71BuRYTvdHI+PkhFK+IoDj62IUud448Q9icDKsymME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218639; c=relaxed/simple;
	bh=mGH1iaPOpwmUi08AMDW+RmamzOoH/lG5whHG4NMZXqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/OmKi4J17U+qboZXsPK8k5/ykdalNLL5qSC8GGKh2GH55hiW73QNs+WMsuWe5nyy9xtdUmaKVV/8vLfMG7/QIGuQjITt6Rc5toOkoBY3xx3TDZQIrLGxGPPaFfoVEsYPi3JqaljuO4vp1FIQ05tdfgx5TELU7cvdboQJ/DEcKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=krVc3UTh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="krVc3UTh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E671C4CEF7;
	Wed,  4 Feb 2026 15:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218639;
	bh=mGH1iaPOpwmUi08AMDW+RmamzOoH/lG5whHG4NMZXqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=krVc3UThNB5bBkSn8jfeIdhbh/7axziDe0e+BjqiTPh8MsehkmwhrHpR6juNclbpZ
	 GEw7RBRDXjv4bqlcdmQ+XMJ4/OHL5fNjuXIimv7qI1VYfLR0j5vl+Yz0OVMmgOx5ih
	 uAkF7nqsVfSsHRVOmFFCmWFlbn+8s37+/PQeZyR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 07/87] octeon_ep: Fix memory leak in octep_device_setup()
Date: Wed,  4 Feb 2026 15:40:05 +0100
Message-ID: <20260204143847.177719916@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 8016dc5ee19a77678c264f8ba368b1e873fa705b ]

In octep_device_setup(), if octep_ctrl_net_init() fails, the function
returns directly without unmapping the mapped resources and freeing the
allocated configuration memory.

Fix this by jumping to the unsupported_dev label, which performs the
necessary cleanup. This aligns with the error handling logic of other
paths in this function.

Compile tested only. Issue found using a prototype static analysis tool
and code review.

Fixes: 577f0d1b1c5f ("octeon_ep: add separate mailbox command and response queues")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20260121130551.3717090-1-zilin@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 1b2f5cae06449..449c55c09b4a5 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -1283,7 +1283,7 @@ int octep_device_setup(struct octep_device *oct)
 
 	ret = octep_ctrl_net_init(oct);
 	if (ret)
-		return ret;
+		goto unsupported_dev;
 
 	INIT_WORK(&oct->tx_timeout_task, octep_tx_timeout_task);
 	INIT_WORK(&oct->ctrl_mbox_task, octep_ctrl_mbox_task);
-- 
2.51.0



