Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5175C2D7DEF;
	Tue, 31 Mar 2026 17:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976960; cv=none; b=RvQlFIXCI+mZJ6vgJDvGf2/JP8ZJPBz6dRuEVA9rMgApL/4yuZ3ndJYkZ1tCvK80SOCSlzy4dZx6nRD3XzMsTdsU3zRyFG8HObC2zLvuAwlF7lqtDBeHZnpk6JHE6atjcXaZVWjQSnt8Wnmv8Qsk0iyM8P0+eVL/6LgfpuNmM0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976960; c=relaxed/simple;
	bh=F/zi6yb2td36HaalZAi2Dn/WoKhZJZ9E+3YFhnTqqp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RECaxJDnqSUZG/rTjTbE7qlUodGk6grHni9BHDYykoF+ZGtBSnEblOixZsHL9jyVsx6QAnIXEfM7IwtkfGURjBIq/q6S0PjRwuEqm4e/5Cu1V3YUY1za4JpV+50Ip9iW67ZDIazDyDgChOF1GFxPu/Bu+qX5ZjkkwTixrJMBoO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wPxLBPjq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wPxLBPjq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA272C19424;
	Tue, 31 Mar 2026 17:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976960;
	bh=F/zi6yb2td36HaalZAi2Dn/WoKhZJZ9E+3YFhnTqqp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wPxLBPjqFk67xep4cRasF/l+8SOzwsFK2LvA1+mV0+PkmG8ExmiQbEeS4OQ93Jo9F
	 QdXQZFzKwPgm5sgPDOdXW7mIfBC1wtw/QbFFJyCGGJYeRLBGX11IS3Cm+R3mDyRfff
	 PXIXenW/dWM8Pcj3wRIGr09wHeAwPp1gfnKS2/hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tuo Li <islituo@gmail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 294/309] dmaengine: idxd: fix possible wrong descriptor completion in llist_abort_desc()
Date: Tue, 31 Mar 2026 18:23:17 +0200
Message-ID: <20260331161804.393027219@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Tuo Li <islituo@gmail.com>

[ Upstream commit e1c9866173c5f8521f2d0768547a01508cb9ff27 ]

At the end of this function, d is the traversal cursor of flist, but the
code completes found instead. This can lead to issues such as NULL pointer
dereferences, double completion, or descriptor leaks.

Fix this by completing d instead of found in the final
list_for_each_entry_safe() loop.

Fixes: aa8d18becc0c ("dmaengine: idxd: add callback support for iaa crypto")
Signed-off-by: Tuo Li <islituo@gmail.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260106032428.162445-1-islituo@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/submit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/submit.c b/drivers/dma/idxd/submit.c
index 6db1c5fcedc58..03217041b8b3e 100644
--- a/drivers/dma/idxd/submit.c
+++ b/drivers/dma/idxd/submit.c
@@ -138,7 +138,7 @@ static void llist_abort_desc(struct idxd_wq *wq, struct idxd_irq_entry *ie,
 	 */
 	list_for_each_entry_safe(d, t, &flist, list) {
 		list_del_init(&d->list);
-		idxd_dma_complete_txd(found, IDXD_COMPLETE_ABORT, true,
+		idxd_dma_complete_txd(d, IDXD_COMPLETE_ABORT, true,
 				      NULL, NULL);
 	}
 }
-- 
2.53.0



