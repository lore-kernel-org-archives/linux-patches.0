Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E251D37C109;
	Thu, 20 Aug 2026 15:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238913; cv=none; b=APvJ7xzlV0i5eQUyYgjxzyoonQbl14V6Zd+PZixHs5ebyxEAjrrYrUgc60LfKHzGMWfY1wA+jQAiO+7/PmdfLjJYGOT0ZYIsKkbPjQdOCxI9JiEeL3HVUOUyskwwkxqqNBpJPy6FlZMow5yUCDjdymW9w46jjMs+g0RG6p2aDnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238913; c=relaxed/simple;
	bh=H+sszjKWNO/YzUh65ccnuiKo8s4SWAGkrFdNDgM5Ae8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvkxJS6MZv35wpEP2av7UdbfdcKmES4Rw41tv26+52y5pmog6JN2YDRznFHTBHevp5IqNmhYHtOzqOayCnTJvVeHbrr4OExCQHMWxzyeFYYoLLuE3i2P2h6/HqSt7Vzv1QXvA1VWFQG1BvgvN5HXoi2s+3LHUWHjhn3zoS9D9qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=05gml6TJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="05gml6TJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC061F000E9;
	Thu, 20 Aug 2026 15:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238911;
	bh=YUdZaqJ3nNGYJI/mfFntExqJOScAhAqBHWxaqPkBN8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=05gml6TJO0e6STjCaMNpgf6/XZFGyE0hKE5XSTrq4fpWMHnVjHP78HNJCeESSPnXA
	 E0Q5cE05BdHE5nv23QUUc4JPPAH1B/hwysh8ZaLDAiENSL5iXiW3T43wAFyvrAczE3
	 DG5MFhdow6Rb52V9X9z+s0yhDH+WBVOMCFhDa7jY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 6.18 077/217] eth: bnxt: always set the queue mgmt ops
Date: Thu, 20 Aug 2026 16:54:05 +0200
Message-ID: <20260820145239.945386632@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

commit 1410c7416dc343f15e9b7152eabddbdbe483002d upstream.

Core provides a centralized callback for validating per-queue settings
but the callback is part of the queue management ops. Having the ops
conditionally set complicates the parts of the driver which could
otherwise lean on the core to feed it the correct settings.

Always set the queue ops, but provide no restart-related callbacks if
queue ops are not supported by the device. This should maintain current
behavior, the check in netdev_rx_queue_restart() looks both at op struct
and individual ops.

Reviewed-by: Subbaraya Sundeep <sbhatta@marvell.com>
Link: https://patch.msgid.link/20260122005113.2476634-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: Max Kellermann <max.kellermann@ionos.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -16325,6 +16325,9 @@ static const struct netdev_queue_mgmt_op
 	.supported_params	= QCFG_RX_PAGE_SIZE,
 };
 
+static const struct netdev_queue_mgmt_ops bnxt_queue_mgmt_ops_unsupp = {
+};
+
 static void bnxt_remove_one(struct pci_dev *pdev)
 {
 	struct net_device *dev = pci_get_drvdata(pdev);
@@ -16977,9 +16980,10 @@ static int bnxt_init_one(struct pci_dev
 
 	if (BNXT_SUPPORTS_NTUPLE_VNIC(bp))
 		bp->rss_cap |= BNXT_RSS_CAP_MULTI_RSS_CTX;
+
+	dev->queue_mgmt_ops = &bnxt_queue_mgmt_ops_unsupp;
 	if (BNXT_SUPPORTS_QUEUE_API(bp))
 		dev->queue_mgmt_ops = &bnxt_queue_mgmt_ops;
-	dev->request_ops_lock = true;
 	dev->netmem_tx = true;
 
 	rc = register_netdev(dev);


