Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BED8341069;
	Tue, 16 Dec 2025 11:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884118; cv=none; b=H0InW+GgQt0axeGe9NDJob9j1JbjVivgGIuWbafOpk9xrcRJZ679xZQb4MJ4agLqeIthAFoeJiTNF2BgbCnJHYhISTomOUakejWPrnz/i++BVypW0CP6+tASTeZZ281I1mt7c9WB+y0QsO0PKNXZ7X6BPNQaWFmAKgBdgpw+AXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884118; c=relaxed/simple;
	bh=1gxOOv3aRkcMDQjreTVW0CqnaxgrkHzuk/IbbG5PsW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IB4IulWpTXv3jTiG2BfScU73iq436iJSAq/EQNt4TvHdSIaXcluvnhkd1diWGX46cnots6Kx8WX2xLWO/bVu7oc2j3fVTnuURcjuhEuw0DRHC2QSxEQllNoo8R21wHbvsHPz3vOWVxgoZi+gPF8uMWo7JyZi4PkdKHom8OKeITU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RrjZx2jd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RrjZx2jd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C7CC4CEF1;
	Tue, 16 Dec 2025 11:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884117;
	bh=1gxOOv3aRkcMDQjreTVW0CqnaxgrkHzuk/IbbG5PsW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RrjZx2jdPCfm4cpS+co5O7OhuKVn5t80sNag4523pB9fHB/+BMEeaVNtpF9zQiUEE
	 hoJicHrqBQGnWmVANIsbC3G9HZaDWIDwlZflazi3fov4F0fht6duSCuebDfD6RaqPF
	 vaWfZuBKEtEwSyxH0W/7yOH3cVIl0EQIZE7RoLTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Chu <yschu@nuvoton.com>,
	Frank Li <Frank.Li@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 095/354] i3c: master: svc: Prevent incomplete IBI transaction
Date: Tue, 16 Dec 2025 12:11:02 +0100
Message-ID: <20251216111324.363667324@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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
index a1945bf9ef19e..985f30ef0c939 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -366,21 +366,27 @@ static int svc_i3c_master_handle_ibi(struct svc_i3c_master *master,
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



