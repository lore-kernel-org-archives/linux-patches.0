Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9F4366075;
	Wed, 20 May 2026 17:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297723; cv=none; b=QQLQ/u2/z+qV3xu0EXkcvrvqxL4Cnsq0RFHpAJZVrsjZdfMOFcVBQCrI5mmTcbvu7TWDOHMmrfRzb3L2k6YYdLq97gcjAFAptZA2N5CxNQkRjcIfmsZn/RZLGLbzkMOob5FZQvlCrNkF9p6ryVu1lmDxzKPSfdVb2ihzamK3dwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297723; c=relaxed/simple;
	bh=RC66k9Telz+lLovEjBHJiWJohi1aH1OSoxTEzrI7R9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+fG/TytNdam7phbkASHUTi5UEFFKqhhv/FmtrBZye+ouKihSCEaERiQ1XbQfHf5yydc75c2EOIftFva0VJgrPb7bM3fI8o5B79EvuOvly5I8AbnaPmafAwjYmepiyOi5oUNfOlJPJK5JoAYESQU7Vwcp35jWB31wQoo6RZt5qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RMSiPUyp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RMSiPUyp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC361F000E9;
	Wed, 20 May 2026 17:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297722;
	bh=RzkEZ6pSt4naS3I/IOqSetfC0x0+Dr7TjejzpchNQQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RMSiPUypzRwVG0YyEVdElw5BD//brXSZoCB0Xkdwe+psMFLb/r+90mLYrTHg1/F2H
	 n4HRxRGuNXW3FR827CXggIkDKhUEO/OgTat+Bi9XobVGrBas2FjWnTto+Gjp8wEQiS
	 CkLRMhynEKZoqHjH+tHw05kY1TRP2JVSVlBOcqHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohsin Bashir <hmohsin@meta.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 140/957] eth: fbnic: Use wake instead of start
Date: Wed, 20 May 2026 18:10:23 +0200
Message-ID: <20260520162137.591156082@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohsin Bashir <hmohsin@meta.com>

[ Upstream commit 12ff2a4aee6c86746623d5aed24389dbf6dffded ]

fbnic_up() calls netif_tx_start_all_queues(), which only clears
__QUEUE_STATE_DRV_XOFF.  If qdisc backlog has accumulated on any TX
queue before the reconfiguration (e.g. ring resize via ethtool -G),
start does not call __netif_schedule() to kick the qdisc, so the
pending backlog is never drained and the queue stalls.

Switch to netif_tx_wake_all_queues(), which clears DRV_XOFF and also
calls __netif_schedule() on every queue, ensuring any backlog that
built up before the down/up cycle is promptly dequeued.

Fixes: bc6107771bb4 ("eth: fbnic: Allocate a netdevice and napi vectors with queues")
Signed-off-by: Mohsin Bashir <hmohsin@meta.com>
Link: https://patch.msgid.link/20260408002415.2963915-1-mohsin.bashr@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_pci.c b/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
index 698b8a85afb31..99b7c0718e80e 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
@@ -139,7 +139,7 @@ void fbnic_up(struct fbnic_net *fbn)
 
 	/* Enable Tx/Rx processing */
 	fbnic_napi_enable(fbn);
-	netif_tx_start_all_queues(fbn->netdev);
+	netif_tx_wake_all_queues(fbn->netdev);
 
 	fbnic_service_task_start(fbn);
 }
-- 
2.53.0



