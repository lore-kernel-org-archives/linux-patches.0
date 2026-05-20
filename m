Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00BED19B5B1;
	Wed, 20 May 2026 16:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294799; cv=none; b=fGHaptRXgQnanopeVpLvH1NWtL533CGsaYnOmb3iyuKh+7QoUev0LpAspwlGx9so9ipq6NDZ2dx0BJu5vrii3PaDvNdO3/PV9HU31h8efEDpQ5QG725jipvh4ayao/3sLdgeW9vlt2ESXWtV4tJupGaI3i1OodcoPuzLcwI38Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294799; c=relaxed/simple;
	bh=5N7idAWlS6K9wipmpi/icCGK2PbvXUc55Q6Q4UTeD5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNm0MvtRYx/5eYgmb3QfuYzj7H5NXe9JmZhaSEbxFhsaH1szyQYCP8oJzDC5VpRU5yLYFfKqyZQaYSkw4j7Tw9NcMOiol7WgbEu+opjfB5QCbxrYjxxu914kdCbSsUK9c19cq2wNliN6kQpUg9TP/I1XFasIjAqJVDs3lFCr+X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1aPKQM67; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1aPKQM67"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64FBC1F000E9;
	Wed, 20 May 2026 16:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294797;
	bh=p8DfdnOddYxSCJqVNFCt+fObkKIH0UpfbseyjIK9ytw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1aPKQM67XYPD25KAPF3njPb3Dn2R+mf0K3+9o0Ux5Ry2HWflIr01RmsuE27ZXJJiq
	 CZt2TqnyK5wD9mytZAOlevTfkV/VGbLZX2xd7gUqi2M369Ov7UvQSNYT4g1+qooMDM
	 +sycPg+yG5TCnCgGgtRd7OxJjITYqeusJxSGwUwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohsin Bashir <hmohsin@meta.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0177/1146] eth: fbnic: Use wake instead of start
Date: Wed, 20 May 2026 18:07:07 +0200
Message-ID: <20260520162152.288918243@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 3fa9d1910daa1..8f331358c9725 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
@@ -139,7 +139,7 @@ void fbnic_up(struct fbnic_net *fbn)
 
 	/* Enable Tx/Rx processing */
 	fbnic_napi_enable(fbn);
-	netif_tx_start_all_queues(fbn->netdev);
+	netif_tx_wake_all_queues(fbn->netdev);
 
 	fbnic_service_task_start(fbn);
 
-- 
2.53.0



