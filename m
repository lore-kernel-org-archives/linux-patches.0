Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCEA1A0BF1;
	Wed,  4 Feb 2026 15:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218967; cv=none; b=XgUWFOLqpCYX22J7xTTzVrt2CTtUBty92GanSBLldwS7s+HwvzxGOK1pM63zw3YgICxQYU3Up79JH6fwgg8DR/+aJIOCs1dH74IUn30/FQcNPQ+LUaaTnb4F+8x1qu1Ul7sCtIIozhVduh0X9HfLnVeHMo5MR7qf5wC+2QMNvZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218967; c=relaxed/simple;
	bh=zfBROlFXU52Hmg89gTb275QFj5cHf7jdySi1wFD4/sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DmWvgK8QYrklwZ1PlsVCOm2NSgryG6cqrMPCRuQsgydheN8lYmXxazpcvKj9w9MaOSHd2L2Q7G+j9l+Lr9C6lXTNJMIosazkry3/S+c1hUxiGiT5uUJMxJFjTPEl9zbMkgrdAKIJE7asGT9Vsn5/7i524ZHmIRcf83ctVvdEGVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CN9pQPWG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CN9pQPWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354D0C4CEF7;
	Wed,  4 Feb 2026 15:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218967;
	bh=zfBROlFXU52Hmg89gTb275QFj5cHf7jdySi1wFD4/sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CN9pQPWGXYQRdn4WAC/AJgk53l8tn8YWtNg5Az799tuUXQafOkDE6IrQqkoc9WHqA
	 sc9kdARCm6u7Yx5bS0PopN2u/Y18W+e2gNMUEGljH6jT0gFJNMqPZ/X2p1I1PFOfJJ
	 8U8adjt6p1MEkNz4P4ydti1RKQdphT0Ghd6pTGcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 009/122] octeon_ep: Fix memory leak in octep_device_setup()
Date: Wed,  4 Feb 2026 15:39:51 +0100
Message-ID: <20260204143852.200734566@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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
index bcea3fc26a8c7..57db7ea2f5be9 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -1338,7 +1338,7 @@ int octep_device_setup(struct octep_device *oct)
 
 	ret = octep_ctrl_net_init(oct);
 	if (ret)
-		return ret;
+		goto unsupported_dev;
 
 	INIT_WORK(&oct->tx_timeout_task, octep_tx_timeout_task);
 	INIT_WORK(&oct->ctrl_mbox_task, octep_ctrl_mbox_task);
-- 
2.51.0



