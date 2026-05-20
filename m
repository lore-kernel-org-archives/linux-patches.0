Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132C63F9267;
	Wed, 20 May 2026 18:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300297; cv=none; b=cZbQULMNIPl2azfv/yzB47vriQrpGas3PLvyka0lAHAHoh0ysjcvYlZPtkJN0xgAvdESfgc52AqB/WbDaMqCuNsTBIH3909NCUFbYLjb/uEMZc9YTN/iBOs3RC4uA70sqVjUH6d2yHE7RmHPovTzfpfSa93loYkTCGM48TGqoAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300297; c=relaxed/simple;
	bh=5bBb5gzAni5mw3KY3e9lUfXbZWagC6Pl3ItyygPu/w0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PkIkdIy6y0LLL7OvMs8bHGFo+ENixEZQ38O2WSXpKhv5ngsHcUxuqCLHUrbYx6MaXkPEP/ZGjRFBVjmmV7VHzLcTYWg2d3wiZxuR0+EDfVCS+c092WO1Qrx6Z1WSpWFSsLBwNdIe8FMTHuZPfUPHCIiL3wm7jJ8/uouc9GZBowo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vQ3S5q7k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vQ3S5q7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443EF1F000E9;
	Wed, 20 May 2026 18:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300295;
	bh=GncQEhOPI7jE3cPY0nj+DOqKWiDYbxMzmvyttg0MZuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vQ3S5q7kdzAZC4XwrXsYubfZTzlXdFEG/Zk03xNKzkfDyJe7v7CMvkUQKQfNpvk+w
	 IG/cp8gzJcHm8Z8eCdhX5zHbt4KSVDZrnI9BqH3+yZElljW3dyRGCnIJRp1PWlqTUF
	 rJJsmqFJpKxT9X4O8IPNXgXmHH2GZmqECpXMOnD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohsin Bashir <hmohsin@meta.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 079/666] eth: fbnic: Use wake instead of start
Date: Wed, 20 May 2026 18:14:50 +0200
Message-ID: <20260520162112.944473939@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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
index 72bdc6c76c0c5..53bb1d691cc0c 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
@@ -137,7 +137,7 @@ void fbnic_up(struct fbnic_net *fbn)
 
 	/* Enable Tx/Rx processing */
 	fbnic_napi_enable(fbn);
-	netif_tx_start_all_queues(fbn->netdev);
+	netif_tx_wake_all_queues(fbn->netdev);
 
 	fbnic_service_task_start(fbn);
 }
-- 
2.53.0



