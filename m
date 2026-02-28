Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE9F36C9D0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302220; cv=none; b=CEPXdG3i1vrVoNimidhb/nNIiOcg+zRyfiChMZF9HZVb5UUKCrkM+5M5t/8Ef8Msw3SpX+FanO/r07Ym9Unz4MlvS7BWvpp4kiM/s82y7tUl71AJJS5GnxsdhnUlFWqClvfU4dlEzlU+ydUGtrGVA3uSj/OmbARapRmnhmzg/AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302220; c=relaxed/simple;
	bh=GR69O+x54Fgm/Ah8XG5KQPAerQOlnAyJMmX/b7fBqPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ffErUUId0uHaYN3DywqiJuUIS2RT3uqvl8cjLEcd9vp3/R8yM9gJxmMPoYIX/q1FWdnszdyhnKq8WQ/1dDYwcjglvDc4dNQCFOCVOX9vOYx47rrdM8sDEaSfWrEjCMsbs19eBNxpforj+Xbz8sMiHLSjibAPChVQjNHQv3QesWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YuMdXGVl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YuMdXGVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3A7C19423;
	Sat, 28 Feb 2026 18:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302220;
	bh=GR69O+x54Fgm/Ah8XG5KQPAerQOlnAyJMmX/b7fBqPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YuMdXGVli64N2em62+WEPB4bH6FvuJSD4OYwa4a8yBLIQw3twhhhrr9BRDK0kZCOH
	 wER1jWqRQRfcf+Qc6m5jnKVDBnv+CjkZJpZYKrQG1zMEI1C5kNjZLC16m+gYfz8LRU
	 pWmMegx8NuK6kJvODX7YKvAay9haT9M5ysm4qX85yZfYsXLIBkDbee0tB10HKL2KyR
	 En6I0eWszlItWwKUX868z85y1WS1MWd8dBcs3uCeRLgqGL/lFfMkuOzHk1LkYf34rg
	 gcp++YSq8uWS5/yvL9afxLbyLaAC1D2rzMGLwSRH7xm/P3ISia+NoZCA7xYAHawv9R
	 mzoqAswaumusA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Michael Hennerich <michael.hennerich@analog.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 227/283] dma: dma-axi-dmac: fix SW cyclic transfers
Date: Sat, 28 Feb 2026 13:06:09 -0500
Message-ID: <20260228180709.1583486-227-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 4f426be286884..93e00130400df 100644
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

