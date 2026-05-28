Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD72B14ABE;
	Thu, 28 May 2026 20:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001058; cv=none; b=VCSleAuPrQrQ9fAa361NqJYyzgLibv0M/fOxdOzhFZjojgAaAp9cYKpPEIdMZwQumwJIjaWVxWFjRklSTsFDVfTtguQwlXpqSVA0cUXfs4yPOhtthbop2RiMs1KcSuUthl9ERXplRYvifWfIlzfwEISnaTxGlEJWvZbqfamVmgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001058; c=relaxed/simple;
	bh=VTU8H3khuyaTJv/8WZJDb9qlOG+K0uxokZemHavlXVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=piKWvMryTC+YzH0nilHq2sC3VESLMQ9Ag6X+CH0cd3SZKhuuC++vQdfwTlEJYekkLNwGHdtloSFTn7UGaqf1B/nvgq3s/CssbkW7gyialuKy8IgxxYWu/pNQ7pGya1gEx7GS3XM4g1qzO5EC1UsbGok3AdcfrYnfVvwo6ST5mb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rbPyXsgf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rbPyXsgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0D21F000E9;
	Thu, 28 May 2026 20:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001057;
	bh=zKSIBpa70RL0kjrVgukpBk7soKnfwIqtYpvXM2g+b40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rbPyXsgfGhJFJeQ3OQGX5uU5mxtfAQ4U5r9EDp0UfrnQ0RRj1a2rc2KvNnamUeuFn
	 D2KbQhdmwONSBBmDeNUoTeYWQvRP7TIeZ04Pbfmw6YdSmBGibIRuNcRfEg7rN41mRy
	 hiiks/VvbyIvJoPB+MG/uwjK8m7OLbsyo3d2nL6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 265/272] ASoC: cs35l56: Fix flushing of IRQ work in cs35l56_sdw_remove()
Date: Thu, 28 May 2026 21:50:39 +0200
Message-ID: <20260528194636.504591840@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 18e7bd9f2446664053f8c34b72abd4606d22d858 ]

Use flush_work() instead of cancel_work_sync() to terminate pending IRQ
work in cs35l56_sdw_remove(). And flush_work() again after masking the
interrupts to flush any queueing that was racing with the masking. This is
the same sequence as cs35l56_sdw_system_suspend().

cs35l56_sdw_interrupt() takes the pm_runtime to prevent the bus powering-
down before the interrupt status can be read and handled. The work releases
this pm_runtime. So cancelling it, instead of flushing, could leave an
unbalanced pm_runtime.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: e49611252900 ("ASoC: cs35l56: Add driver for Cirrus Logic CS35L56")
Link: https://patch.msgid.link/20260521123057.988732-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l56-sdw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs35l56-sdw.c b/sound/soc/codecs/cs35l56-sdw.c
index 7c9a17fe2195c..b9cc447b6e5c7 100644
--- a/sound/soc/codecs/cs35l56-sdw.c
+++ b/sound/soc/codecs/cs35l56-sdw.c
@@ -544,10 +544,11 @@ static int cs35l56_sdw_remove(struct sdw_slave *peripheral)
 
 	/* Disable SoundWire interrupts */
 	cs35l56->sdw_irq_no_unmask = true;
-	cancel_work_sync(&cs35l56->sdw_irq_work);
+	flush_work(&cs35l56->sdw_irq_work);
 	sdw_write_no_pm(peripheral, CS35L56_SDW_GEN_INT_MASK_1, 0);
 	sdw_read_no_pm(peripheral, CS35L56_SDW_GEN_INT_STAT_1);
 	sdw_write_no_pm(peripheral, CS35L56_SDW_GEN_INT_STAT_1, 0xFF);
+	flush_work(&cs35l56->sdw_irq_work);
 
 	cs35l56_remove(cs35l56);
 
-- 
2.53.0



