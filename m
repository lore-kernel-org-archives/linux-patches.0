Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64701171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B84AC433C8;
	Mon, 21 Aug 2023 20:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648368;
	bh=BqPXxtOZY5nbB6UuCVLHDUGDHzYWzn1bPTBy1S6n88U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ij53scJCtU9vDzU7YVE/07XwJgYFmWlJX4cYnvO3C7LYT8NtGYwjB5GZ5q82w5w5I
	 hZLJj3dFEkAmtRR6/bbK4/KT2JmcVUTo20MuUoXEu5OY4Z0RE4AXY88lCBLCL9Ks5Y
	 85Yl2LjUPjKBs0a0k76QFgXmZdAm6D7brcDeRbeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 150/234] octeon_ep: fix timeout value for waiting on mbox response
Date: Mon, 21 Aug 2023 21:41:53 +0200
Message-ID: <20230821194135.471380287@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michal Schmidt <mschmidt@redhat.com>

[ Upstream commit 519b227904f0e70d4a1d6cf41daa5392715f2d2f ]

The intention was to wait up to 500 ms for the mbox response.
The third argument to wait_event_interruptible_timeout() is supposed to
be the timeout duration. The driver mistakenly passed absolute time
instead.

Fixes: 577f0d1b1c5f ("octeon_ep: add separate mailbox command and response queues")
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20230810150114.107765-2-mschmidt@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
index 1cc6af2feb38a..565320ec24f81 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
@@ -55,7 +55,7 @@ static int octep_send_mbox_req(struct octep_device *oct,
 	list_add_tail(&d->list, &oct->ctrl_req_wait_list);
 	ret = wait_event_interruptible_timeout(oct->ctrl_req_wait_q,
 					       (d->done != 0),
-					       jiffies + msecs_to_jiffies(500));
+					       msecs_to_jiffies(500));
 	list_del(&d->list);
 	if (ret == 0 || ret == 1)
 		return -EAGAIN;
-- 
2.40.1



