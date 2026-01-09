Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B752923F417;
	Fri,  9 Jan 2026 12:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961609; cv=none; b=TUtykybFNdZs2/emJRt+EdzJd1vI8au4SF6CxOGHzmsalX8xWGrRS+dd3Fc/UweMx+xjQZsZE8LZEP11mJaXTJdqW8O6hvWRZvVcYDi/80OCAafsXt7OzjhR3lz/nVroIHFrgfU/2X9GfSreZJXpw9n8V+17/CIaUe5LSKfWKts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961609; c=relaxed/simple;
	bh=E5+sLR+KYTQfUt1t9AB7Dx82thYzh/zb8T6zOYU6Wx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPlKMJPx2BtBrfaTX5lL9CB8l1Tboc7MlaoySIJKFOqnjpWf2jh1EbouPT19rSUNomNof8Jc0oWFZjIrxr9V7TWtshqCKWkSBStfIvdwITBhNNtrhhc8VdSSCK68fA1VQ+6nCVlUIfO72FSotglGiBceD+Xx1QHyqvqQbnCdJEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kaF7pSGr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kaF7pSGr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F3EC4CEF1;
	Fri,  9 Jan 2026 12:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961609;
	bh=E5+sLR+KYTQfUt1t9AB7Dx82thYzh/zb8T6zOYU6Wx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kaF7pSGrrmMfJS1kiRavWJ8j0n7eEOJMhUyCpLaKZ/t4WLc5RLz7uo79Af4DJ5U+M
	 R8TsASSNEKE1EMHV/OP2eqvhUK1KPMSEuVCRt57izM0r0awgnyQmyvRy+UkYzv1dza
	 Lz3l9MqMAk6YElDdMkEGihGbrEqA9EpXTDBiP2hI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Chu <yschu@nuvoton.com>,
	Frank Li <Frank.Li@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 075/634] i3c: master: svc: Prevent incomplete IBI transaction
Date: Fri,  9 Jan 2026 12:35:53 +0100
Message-ID: <20260109112120.263918540@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanley Chu <yschu@nuvoton.com>

[ Upstream commit 3a36273e5a07dda0ccec193800f3b78c3c0380af ]

If no free IBI slot is available, svc_i3c_master_handle_ibi returns
immediately. This causes the STOP condition to be missed because the
EmitStop request is sent when the transfer is not complete. To resolve
this, svc_i3c_master_handle_ibi must wait for the transfer to complete
before returning.

Fixes: dd3c52846d59 ("i3c: master: svc: Add Silvaco I3C master driver")
Signed-off-by: Stanley Chu <yschu@nuvoton.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://patch.msgid.link/20251027034715.708243-1-yschu@nuvoton.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index fda472d84549b..21ea4166057d8 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -350,21 +350,27 @@ static int svc_i3c_master_handle_ibi(struct svc_i3c_master *master,
 	int ret, val;
 	u8 *buf;
 
-	slot = i3c_generic_ibi_get_free_slot(data->ibi_pool);
-	if (!slot)
-		return -ENOSPC;
-
-	slot->len = 0;
-	buf = slot->data;
-
+	/*
+	 * Wait for transfer to complete before returning. Otherwise, the EmitStop
+	 * request might be sent when the transfer is not complete.
+	 */
 	ret = readl_relaxed_poll_timeout(master->regs + SVC_I3C_MSTATUS, val,
 						SVC_I3C_MSTATUS_COMPLETE(val), 0, 1000);
 	if (ret) {
 		dev_err(master->dev, "Timeout when polling for COMPLETE\n");
-		i3c_generic_ibi_recycle_slot(data->ibi_pool, slot);
 		return ret;
 	}
 
+	slot = i3c_generic_ibi_get_free_slot(data->ibi_pool);
+	if (!slot) {
+		dev_dbg(master->dev, "No free ibi slot, drop the data\n");
+		writel(SVC_I3C_MDATACTRL_FLUSHRB, master->regs + SVC_I3C_MDATACTRL);
+		return -ENOSPC;
+	}
+
+	slot->len = 0;
+	buf = slot->data;
+
 	while (SVC_I3C_MSTATUS_RXPEND(readl(master->regs + SVC_I3C_MSTATUS))  &&
 	       slot->len < SVC_I3C_FIFO_SIZE) {
 		mdatactrl = readl(master->regs + SVC_I3C_MDATACTRL);
-- 
2.51.0



