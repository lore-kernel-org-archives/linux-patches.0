Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3BA1A76D4;
	Tue, 30 Jul 2024 17:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359762; cv=none; b=QKbasR675X8dAVv+PuktRuLaQdUlDtKeOG9Z4T6hOI6cKRNHH/wjXaLIixjFmQYQsMDOYyisjgyL54URyZbO65sdhcGh3P1PutiBUtVepyeg5nR2m9KW/e+ffT9NDaavS5Aua3AK+SS5CP1aUrU90FamGyw4P2fNNnaWpWprfaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359762; c=relaxed/simple;
	bh=obCVzz3z8gVUphU1T3h9NYo02BwUt8gj+UVryV1cEY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QviJt5RgnQLTcEjRTBhIDtQ6KX0RatzVSbz0vEHm5ziMSV/u6IDMZewBxPunoS+k+JZJ03CBg45k/Wy19+st6iMiT0uk17q61RDuV0IsvpaRlvIJDCJegN2G1RBsOn/sBvCYfpNNIG1zzjRowX9MVyuDBBNcxBbd+FVqgA/fjaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X78R7WWh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X78R7WWh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157D5C32782;
	Tue, 30 Jul 2024 17:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359762;
	bh=obCVzz3z8gVUphU1T3h9NYo02BwUt8gj+UVryV1cEY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X78R7WWhT9DsHLG66ZoUkSVlgAt+bJP/Kpo8H0tcUhv0ClH+Tkcct4E4qAU+m77pB
	 IZcX4kdHAvY+iDl/lR8hweeJq5AXhTRzV0XtwYC3Y/te4Yk6kXiIYxfpkPV55tqEoG
	 8iPL2Nuxe/6b0PEzIHH1CuysqU9YVwytAoj9Mz44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beleswar Padhi <b-padhi@ti.com>,
	Andrew Davis <afd@ti.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 529/809] mailbox: omap: Fix mailbox interrupt sharing
Date: Tue, 30 Jul 2024 17:46:45 +0200
Message-ID: <20240730151745.632656927@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Davis <afd@ti.com>

[ Upstream commit 0a02bc0a34cd53c7fe5bf4bae6efb56ad47677fa ]

Multiple mailbox users can share one interrupt line. This flag was
mistakenly dropped as part of the FIFO removal. Mark the IRQ as shared.

Reported-by: Beleswar Padhi <b-padhi@ti.com>
Fixes: 3f58c1f4206f ("mailbox: omap: Remove kernel FIFO message queuing")
Signed-off-by: Andrew Davis <afd@ti.com>
Tested-by: Beleswar Padhi <b-padhi@ti.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/omap-mailbox.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mailbox/omap-mailbox.c b/drivers/mailbox/omap-mailbox.c
index 46747559b438f..7a87424657a15 100644
--- a/drivers/mailbox/omap-mailbox.c
+++ b/drivers/mailbox/omap-mailbox.c
@@ -230,7 +230,8 @@ static int omap_mbox_startup(struct omap_mbox *mbox)
 	int ret = 0;
 
 	ret = request_threaded_irq(mbox->irq, NULL, mbox_interrupt,
-				   IRQF_ONESHOT, mbox->name, mbox);
+				   IRQF_SHARED | IRQF_ONESHOT, mbox->name,
+				   mbox);
 	if (unlikely(ret)) {
 		pr_err("failed to register mailbox interrupt:%d\n", ret);
 		return ret;
-- 
2.43.0



