Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E2A223DD6;
	Tue, 30 Sep 2025 15:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245085; cv=none; b=q7exF+hVZiKKhL//HLzWUoFB1FOtMdaR0OAIlqMKC8behwQxJGliG5En1u9YIiHBjvGkeYUvICb5mS93PTRU9Td2pXntK+OTmdQLUFUPuwcR3+9a/QSkBQQ+DywocM7n45zZGkfYfYEcHStUsfqKVH71P3lfCvnHAt5Y6K36udA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245085; c=relaxed/simple;
	bh=mjFG1PkENST4NL88dcwuQXbJ752K5OyS9s8hfU/9CF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=osx5n+KASiL25N452o2NoBqRIcTsSGJwk9fPQ0RRDUoNdwnky3K2V48wRCNIraPlCBNPwv4xsz/J2l5vQY31FaoptUFAY+nOx79o9AVHiQ1vyLtornaCY42JR8QOcW97AZET4kOEXy4X4fTXR9T0L9tYp/1WF1dpXzGcDrRqSYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZMnmWRn6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZMnmWRn6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20334C4CEF0;
	Tue, 30 Sep 2025 15:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245085;
	bh=mjFG1PkENST4NL88dcwuQXbJ752K5OyS9s8hfU/9CF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZMnmWRn6iwYjtcmbHWTIHCPamYjjKubV26LU+Xx5VjooMAF79WYnXU5HQLD3HGrLa
	 VOPNJahPXhy8NnxhSh93oFbLbFBSQSRIv8SfyKnFOZdcFRjWi17GX+nrWTYEwgI+Kj
	 Oyi8P7R2TjI7bT0pEQ2I93au8oi0md/k//+y0mCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravi Gunasekaran <r-gunasekaran@ti.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 064/151] net: hsr: hsr_slave: Fix the promiscuous mode in offload mode
Date: Tue, 30 Sep 2025 16:46:34 +0200
Message-ID: <20250930143830.151314447@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ravi Gunasekaran <r-gunasekaran@ti.com>

commit b11c81731c810efe592e510bb0110e0db6877419 upstream.

commit e748d0fd66ab ("net: hsr: Disable promiscuous mode in
offload mode") disables promiscuous mode of slave devices
while creating an HSR interface. But while deleting the
HSR interface, it does not take care of it. It decreases the
promiscuous mode count, which eventually enables promiscuous
mode on the slave devices when creating HSR interface again.

Fix this by not decrementing the promiscuous mode count while
deleting the HSR interface when offload is enabled.

Fixes: e748d0fd66ab ("net: hsr: Disable promiscuous mode in offload mode")
Signed-off-by: Ravi Gunasekaran <r-gunasekaran@ti.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/20240322100447.27615-1-r-gunasekaran@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/hsr/hsr_slave.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -226,7 +226,8 @@ void hsr_del_port(struct hsr_port *port)
 		netdev_update_features(master->dev);
 		dev_set_mtu(master->dev, hsr_get_max_mtu(hsr));
 		netdev_rx_handler_unregister(port->dev);
-		dev_set_promiscuity(port->dev, -1);
+		if (!port->hsr->fwd_offloaded)
+			dev_set_promiscuity(port->dev, -1);
 		netdev_upper_dev_unlink(port->dev, master->dev);
 	}
 


