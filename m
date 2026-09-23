Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4199370D54;
	Wed, 23 Sep 2026 14:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172908; cv=none; b=fdQodot2ttj06VLj24FCbDAhdMOki0g7D2RJqseKfBBMsQDyzz9TZnsuX14EDl7COsr64BZyZNJF40FOOmNdOmVHVbi4pnExX0WGNw5FbrFh8qlLB+WpRDXVR1Fkjw8mRISs58/WUFEsQ32tsqosOp5Z+LezvouUKkk4Z6BI3KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172908; c=relaxed/simple;
	bh=FgdCAGzUAZBIh9vcW4yYgPpVuz1sFa/8bPraM1IXRCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uErp7XAFUj6Bjow4EEHrKPw8DFkvnj5qNjVQ6ib6kUbZuDGIy4+P05L4PjcynAegYbLvoU8OCcKWxsy7QJXm2No3UfGJpKteyl9b6gQFCGOOXSTcKaDcKRuU88TxXn8pNtONl3bOHekWhobb2bAvKvuvzFIyjCbmhr3D2ZdcuC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=psBsi+R4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="psBsi+R4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090001F000FF;
	Wed, 23 Sep 2026 14:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172906;
	bh=wM6OIxYg3Ky9JYnbToeHnTfL/+acRWLgRQ3Bg1VMCE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=psBsi+R4AyZCpEogA2ZZhEi9+5Lixm42DpoHYpegC6wcY4KeAcRHHddAKepQ9Bz8n
	 gu4WMtzHj8PZiEODmyIACyUP5nksMEtdol8z0zPOP/2pZwkqLvJNQP5QXX779WKQeX
	 q0xRt5iSgLZ4pFEa6n25tJi7JM1oII0is1FRs6vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 096/438] dmaengine: pxa: fix double counting of the hw descriptors
Date: Wed, 23 Sep 2026 16:01:57 +0200
Message-ID: <20260923140647.266066498@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit f6504be006aa4bb4bd26285f410a885c17920d65 ]

pxad_alloc_desc() was converted from

        kzalloc(struct_size(sw_desc, hw_desc, nb_hw_desc), GFP_NOWAIT)

to kzalloc_flex(), which sets the __counted_by() counter sw_desc->nb_desc
itself - but only where the compiler has __builtin_counted_by_ref(), so
from gcc 15.1 or clang 22.1 on. The loop below it still increments
nb_desc, which makes it come out doubled there and correct elsewhere.

nb_desc is what pxad_free_desc() iterates over and what
set_updater_desc() indexes from, so set it explicitly and drop the
increment. The error path has to lower it to the number of descriptors
allocated so far, otherwise pxad_free_desc() would free entries that were
never allocated.

Fixes: 69050f8d6d075 ("treewide: Replace kmalloc with kmalloc_obj for non-scalar types")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20260817-dmaengine-pxa-v1-1-850c215c1196@pengutronix.de
Link: https://patch.msgid.link/20260817-dmaengine-pxa-v2-1-f42ab0569a48@pengutronix.de
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/pxa_dma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/pxa_dma.c b/drivers/dma/pxa_dma.c
index fa2ee0b3e09f8..fc43124fefa89 100644
--- a/drivers/dma/pxa_dma.c
+++ b/drivers/dma/pxa_dma.c
@@ -744,6 +744,7 @@ pxad_alloc_desc(struct pxad_chan *chan, unsigned int nb_hw_desc)
 	sw_desc = kzalloc_flex(*sw_desc, hw_desc, nb_hw_desc, GFP_NOWAIT);
 	if (!sw_desc)
 		return NULL;
+	sw_desc->nb_desc = nb_hw_desc;
 	sw_desc->desc_pool = chan->desc_pool;
 
 	for (i = 0; i < nb_hw_desc; i++) {
@@ -752,10 +753,10 @@ pxad_alloc_desc(struct pxad_chan *chan, unsigned int nb_hw_desc)
 			dev_err(&chan->vc.chan.dev->device,
 				"%s(): Couldn't allocate the %dth hw_desc from dma_pool %p\n",
 				__func__, i, sw_desc->desc_pool);
+			sw_desc->nb_desc = i;
 			goto err;
 		}
 
-		sw_desc->nb_desc++;
 		sw_desc->hw_desc[i] = desc;
 
 		if (i == 0)
-- 
2.53.0



