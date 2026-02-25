Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FE22D6E58;
	Wed, 25 Feb 2026 06:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002671; cv=none; b=QAY7N+fBHVf4hWhdoMh9J/TR1xo5GTyt0xY1Z6M7jV08hxUkafX6MQd2YtQ2feYT9f1ciHkkemTf8/YMbaqEnQH3HKc5cfI7UwwPqDNEpz85IDvqN3raMJGTAleKGtB7ZLJHwj+ak+FZSxbRUdfU6kQi/EjWsfQIdYm2D+lRyTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002671; c=relaxed/simple;
	bh=3wqnuOaNnteNHLaHNJsdgGUmiI60+E6FNBQfVOR1O+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QCDvMKYM7DbNYSZYQphEhLXEqL33jlfc8opSWGWZMtr0sA7B7HBkqHAII9PSPkKGVCCWZ/mSHZL8tlHPyONl/gewp7TWSw5JJW0MQ4W9tqSF0xLXqrRXR/migLJ6l+fLx6z/UwK1C8I9qTnD7RVVAG3lfHObWSfZ197DUtaX8Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FXKCQcKe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXKCQcKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9DAFC116D0;
	Wed, 25 Feb 2026 06:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002670;
	bh=3wqnuOaNnteNHLaHNJsdgGUmiI60+E6FNBQfVOR1O+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FXKCQcKe5Iy1ZONNULrT8TcOVwXbZeuuudDGD34n9zPuCSIqjin71tydnvNc93CyH
	 uYQ3zBNqpVZknzpxZKAkzqy6ABADO3kg3TUHGUrCekLsBcJLUQeVRxRjyQW2KxqvP/
	 kDoutNpvRLr8gcuQyVc/tq+dkjK6cIY0r6Ru9C4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Michael Hennerich <michael.hennerich@analog.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 453/641] dma: dma-axi-dmac: fix SW cyclic transfers
Date: Tue, 24 Feb 2026 17:22:59 -0800
Message-ID: <20260225012359.491320421@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit 9bd257181fd5c996d922e9991500ad27987cfbf4 ]

If 'hw_cyclic' is false we should still be able to do cyclic transfers in
"software". That was not working for the case where 'desc->num_sgs' is 1
because 'chan->next_desc' is never set with the current desc which means
that the cyclic transfer only runs once and in the next SOT interrupt we
do nothing since vchan_next_desc() will return NULL.

Fix it by setting 'chan->next_desc' as soon as we get a new desc via
vchan_next_desc().

Fixes: 0e3b67b348b8 ("dmaengine: Add support for the Analog Devices AXI-DMAC DMA controller")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
base-commit: 398035178503bf662281bbffb4bebce1460a4bc5
change-id: 20251104-axi-dmac-fixes-and-improvs-e3ad512a329c
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
Link: https://patch.msgid.link/20251104-axi-dmac-fixes-and-improvs-v1-1-3e6fd9328f72@analog.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dma-axi-dmac.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dma/dma-axi-dmac.c b/drivers/dma/dma-axi-dmac.c
index 5b06b0dc67ee1..e22639822045f 100644
--- a/drivers/dma/dma-axi-dmac.c
+++ b/drivers/dma/dma-axi-dmac.c
@@ -247,6 +247,7 @@ static void axi_dmac_start_transfer(struct axi_dmac_chan *chan)
 			return;
 		list_move_tail(&vdesc->node, &chan->active_descs);
 		desc = to_axi_dmac_desc(vdesc);
+		chan->next_desc = desc;
 	}
 	sg = &desc->sg[desc->num_submitted];
 
@@ -265,8 +266,6 @@ static void axi_dmac_start_transfer(struct axi_dmac_chan *chan)
 		else
 			chan->next_desc = NULL;
 		flags |= AXI_DMAC_FLAG_LAST;
-	} else {
-		chan->next_desc = desc;
 	}
 
 	sg->hw->id = axi_dmac_read(dmac, AXI_DMAC_REG_TRANSFER_ID);
-- 
2.51.0



