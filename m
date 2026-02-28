Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D7333AD85
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302752; cv=none; b=Sg/XBs5bdCZ/T7gH0y6hvml//djs0Uu1i+weyHwsvzQ6d9RDOx4v4IkB7Q/K6LgjhOuoDqFNwTdTg+ohVbvsJU9JRixk8ITX1UwZ8WImLzIzpJNYRkDibOY5CKVXob00slQqaLlE2Xfu027pS7ZjHg+cahGvqQDukgGGZr6Vqoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302752; c=relaxed/simple;
	bh=9jX3Qa+vsP4rXne9iNEtm8Mq8RgB5NMkF9NAKbA6SGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fA49XycOF012Wniq76bCVRDPJ4gAOokiI9ilmlKP/zGPLkSplK7YUqT7NkA/SsLbwAxE/AEb4raF3sMK7bI9FhI7C/yBcjtMofAM7qNMA35xwtTQhiCXkOXvruNz8gag/LbPpiUvfq2qAmK2URZurJ9k1MZ84g5POkKXw6uvMtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DKH+crAQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DKH+crAQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BCB0C116D0;
	Sat, 28 Feb 2026 18:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302752;
	bh=9jX3Qa+vsP4rXne9iNEtm8Mq8RgB5NMkF9NAKbA6SGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DKH+crAQfo6X8g7fKRUq6Y6k03/oxczxFGsKRiWtjuMWoiFcOu2rEtB5RqnLZOFWA
	 9zurOrNGC57AMCYVsms5pz3Q5lyQcF8SZGsDYSLSBR8k4xM3GNY+9Z6KGc1TG/0/9j
	 Ji0tH9Z/DqD8vUfnKN6VhsS5xd6OYFTINxLaJjRQ/CejMLGbdyKGp6EkTzGZ4uVGUA
	 82T6F9ILy3Iu5vsoz5i6rBAz8XUT2bIU73JHt5Lry1LzApLvvefASxrNSo+VErX+ST
	 IgyLhidXwd/hMOCAvwndT4Y5qY5PGV3UtP0YVzWoC+l+QqkirtPW/NlgP+uHQcVKO0
	 qSvpzFh9kbNrw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Michael Hennerich <michael.hennerich@analog.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/147] dma: dma-axi-dmac: fix SW cyclic transfers
Date: Sat, 28 Feb 2026 13:17:08 -0500
Message-ID: <20260228181736.1605592-120-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index e91aeec71c811..6194ef0ac17f6 100644
--- a/drivers/dma/dma-axi-dmac.c
+++ b/drivers/dma/dma-axi-dmac.c
@@ -221,6 +221,7 @@ static void axi_dmac_start_transfer(struct axi_dmac_chan *chan)
 			return;
 		list_move_tail(&vdesc->node, &chan->active_descs);
 		desc = to_axi_dmac_desc(vdesc);
+		chan->next_desc = desc;
 	}
 	sg = &desc->sg[desc->num_submitted];
 
@@ -238,8 +239,6 @@ static void axi_dmac_start_transfer(struct axi_dmac_chan *chan)
 		else
 			chan->next_desc = NULL;
 		flags |= AXI_DMAC_FLAG_LAST;
-	} else {
-		chan->next_desc = desc;
 	}
 
 	sg->id = axi_dmac_read(dmac, AXI_DMAC_REG_TRANSFER_ID);
-- 
2.51.0

