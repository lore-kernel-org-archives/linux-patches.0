Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45390375AAD
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301892; cv=none; b=EokJ873AvXOwdbXii6V8/dKNym+IstQLvANnNdRL0NaxEXtbEh/kBs3RGaIigaBXh/92414SEkkacfbJHJLC5fAmdEi2IHEE8mo8DKTHOp+UMPjGLYJwWrYolfx1AG9vmh0jEC68X/W+DHPuKV5l025J3eHNcqoboW4gb4XVOx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301892; c=relaxed/simple;
	bh=sum8RXfU/CbJfF9bUPRbcXdflGWQHohNMu4MrXd1f7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gqy5GxlLXSnYKOr/WFP53VqXVn3UseJFagRAwuQBZT44m6sO9iiXqWN/rEPJhjZI16gFYMiYoClKiwxNgmuxvh7jwuvAFApG62vDYUZXg+ESFzaRhsDPwjd7fOFoabcfyUmBEpZSYW+sIqBiNNMYLBFEIweptQkNYLisHhjhsWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lJn7EuR/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lJn7EuR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93341C19424;
	Sat, 28 Feb 2026 18:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301892;
	bh=sum8RXfU/CbJfF9bUPRbcXdflGWQHohNMu4MrXd1f7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJn7EuR/wTPSE8PjFltjL+gizymu5Pkj7gKdLqMYUZeugTSqZfTtEs2SyTik1Tb1P
	 Qw7avxFHLS5iEfG8/WqYwf8wi8sBC70sUaREJbgT++5oUmV4LjHY1G+2TpbAmtn+pG
	 +dcBCR24o6erwCXVVfIGdA3IuR/S7hnvCgYdZCVyJQQ3VZ2qZE5kOiM0Yf6F3xj8Re
	 tQYl2wh23PiIko287CRKlopjoO79e6YtPwpqsKibsGp2gHW5lSb65G7mnC7hl4Co7l
	 IML3OMQiucztLmWCLYxWv34S+aY3DVVqDMpfuc144mD/w4d14wyH6EBXBdo/YvRQr0
	 3/a1fM4y/9X4w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Michael Hennerich <michael.hennerich@analog.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 319/385] dma: dma-axi-dmac: fix SW cyclic transfers
Date: Sat, 28 Feb 2026 12:59:01 -0500
Message-ID: <20260228180011.1568201-319-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 36943b0c6d603..2aa06f66624ba 100644
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

