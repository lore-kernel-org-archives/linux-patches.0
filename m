Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3350D359A90
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302447; cv=none; b=G/x9M8k9tPDaxQt5yG8e5yPTDsmRQrDrTYb7fNYL6BiT8FEtZjHlRv9AlAqPYtbV0pQx6asp0E9GwKtTnXaQ/VcQOR+CBk062f7DNkRlnBzrl6nHsu0ng2M7GSd/5tT6VJdhqqJ5SH3KZGTdKFghAYL63c6Esl5lYZWH1R/ZkwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302447; c=relaxed/simple;
	bh=14rgckGi0jAySTnaoO5APWtJyUkq7MyCXcTZmVbwXao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t5hiLQMGsFtP+RVHArte8C1Z/fTudF1E4ixckrVEBur1XYGckw13NGjpwE/Et46tPbtpJzqn9+pAgWmZzv2wRhnW4xojW6L5PIAK3mX0kOZKYSYx1hWYqtOZOq7wPDegynDJ/ROcjnoNHDKTcEHXZXtGZRX1KAt/NBF4eC+NGSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gP2Abksk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gP2Abksk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AEC8C116D0;
	Sat, 28 Feb 2026 18:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302447;
	bh=14rgckGi0jAySTnaoO5APWtJyUkq7MyCXcTZmVbwXao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gP2AbkskNLaJN0TTcx+/Xp0tgvBcl2TFaF0tHBkxsq2eTNACWsKBg6Pu8M6cwkCl1
	 8mVlyQcTu+FMsomdYajdTS/Qi0rQTPDo1JYFZVqIjVaLfWAHSwrguNyi+sOzMjM1Ip
	 39fgku+AeYen2A7YFPwX9fvw1TdTahLZ0SFIJsI6vveFgT9JDNaAnHu6UHrGRY0CiM
	 xi7A8PJDQz23rA7VDvI9BTsGYagFha1HsaX6G7LwHGIG6iveekdOsX0tNh/j5o1Qcq
	 LnlqJSfNaFB3vFCQX3onWRkgchTmq825JJjG7qaazC3I/VW4pLO+w4WpiuWvpk2U9z
	 12U1kAIvDisEw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Michael Hennerich <michael.hennerich@analog.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 186/232] dma: dma-axi-dmac: fix SW cyclic transfers
Date: Sat, 28 Feb 2026 13:10:39 -0500
Message-ID: <20260228181127.1592657-186-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index 176cf3665a185..ac73c3b59d268 100644
--- a/drivers/dma/dma-axi-dmac.c
+++ b/drivers/dma/dma-axi-dmac.c
@@ -225,6 +225,7 @@ static void axi_dmac_start_transfer(struct axi_dmac_chan *chan)
 			return;
 		list_move_tail(&vdesc->node, &chan->active_descs);
 		desc = to_axi_dmac_desc(vdesc);
+		chan->next_desc = desc;
 	}
 	sg = &desc->sg[desc->num_submitted];
 
@@ -242,8 +243,6 @@ static void axi_dmac_start_transfer(struct axi_dmac_chan *chan)
 		else
 			chan->next_desc = NULL;
 		flags |= AXI_DMAC_FLAG_LAST;
-	} else {
-		chan->next_desc = desc;
 	}
 
 	sg->id = axi_dmac_read(dmac, AXI_DMAC_REG_TRANSFER_ID);
-- 
2.51.0

