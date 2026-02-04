Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37F2421EE5;
	Wed,  4 Feb 2026 15:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218411; cv=none; b=L1cFG8uXwvH2jAroeLVZ6GPUEL+d9c545EZ8Xjk3eBa3MrG8wS0cVUaNP9ue4WJNU5JRgva8h9P/CMj/Z1mblaII2ZzgditQ9Ni23id3TUMINOxuee5uehPNHd1n42NzJKoGs2x6jfiHdQDEiTGX4C6bFvJ9wo3/Fg/LO5oYVrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218411; c=relaxed/simple;
	bh=yPDe4uzFzAkstIgxSkQHLcDT5gGzXLUq/+bwKc07wzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LE5TFe7jUG1Rq2YxgdVeJnl7HdLbvWEsstX4x1XdTm5POEoOr6PV9dmkTGSNIykk6yTQQTMnxZAS0oIClPH2dQIF+ah6+tEVzdtOnDnb6IrRda2pK1GmYPL5I7Nubt5N7tQlu5qHJzQlWwKQtuvB6hwJc7WJkovLtWYGXb7karA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QwAjG1Xs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QwAjG1Xs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6227CC4CEF7;
	Wed,  4 Feb 2026 15:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218410;
	bh=yPDe4uzFzAkstIgxSkQHLcDT5gGzXLUq/+bwKc07wzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QwAjG1XsIons11rhLvC+yB6UjUBdSsKVe17nyWyAsVPLpM7PZh71AprBdNvFbkXto
	 FBPR/eQUaZi9yUhgnjrEUMsX/znBWnPDXaXC140eakfZBmpOPX1n0R/xevpPI1EsCX
	 1/49CpUi9lTbQHgHyg8zdomCHXEHYEw3qy/GXzCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 05/72] octeon_ep: Fix memory leak in octep_device_setup()
Date: Wed,  4 Feb 2026 15:40:08 +0100
Message-ID: <20260204143845.804844516@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
References: <20260204143845.603454952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7a30095b3486f..c385084546639 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -998,7 +998,7 @@ int octep_device_setup(struct octep_device *oct)
 
 	ret = octep_ctrl_net_init(oct);
 	if (ret)
-		return ret;
+		goto unsupported_dev;
 
 	atomic_set(&oct->hb_miss_cnt, 0);
 	INIT_DELAYED_WORK(&oct->hb_task, octep_hb_timeout_task);
-- 
2.51.0



