Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E0A344028;
	Tue, 16 Dec 2025 11:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885479; cv=none; b=BfCdi3nTmJz6TkUGf4fd7cDdXhSU2IC9N241JqzCBaFxSjgBIlBtxsfHMi5J3YA0F84y8Y5lGELIhEpHrAAzVZJUIRztxhrwtn5srEK1ECu8aXmj4HK1j0696JKMeb+aLPGXRVC9ROoOIBj7EljMr5/ehz2P3lYvqxGWVEFBM4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885479; c=relaxed/simple;
	bh=K8q4yIDQ6jxTzT5hOnaA6qktIO9qkyLSd1EgY1+Xrn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HY1FmqozLLWpQ5kXa/tGEKhNCbcdizBl03iW4xoaGMD2wjqmklYiWdguVtkj+Zml4NAlNs7OkrY02WuRzmfg5GlADlPlNvrS2b0V3v2Q6CX4Vzjy1E6Gma1YOntKIuoOa4dmo50MTvcTlVCaiTx2LMma1/EkBOco6TSUjs5/RZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w8jjfzqo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w8jjfzqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6694C4CEF1;
	Tue, 16 Dec 2025 11:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885479;
	bh=K8q4yIDQ6jxTzT5hOnaA6qktIO9qkyLSd1EgY1+Xrn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w8jjfzqoiZyS9jSK8oRGa1T29Q/u1EMyETbU4gFowfw6ho5vn8VxaI84s7ig4zBzn
	 gu74xD3FHMfutPUcB/KHTsEHiuEn624M2W0KSDatbm6oLbETJaNNG8Bg/7bIT8aqPt
	 se+W9X/UJ61cTN0UtOVvG1sxlUYn2STnVBTJ0WfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Chu <yschu@nuvoton.com>,
	Frank Li <Frank.Li@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 134/507] i3c: master: svc: Prevent incomplete IBI transaction
Date: Tue, 16 Dec 2025 12:09:35 +0100
Message-ID: <20251216111350.384836181@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 9641e66a4e5f2..e70a64f2a32fa 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -406,21 +406,27 @@ static int svc_i3c_master_handle_ibi(struct svc_i3c_master *master,
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



