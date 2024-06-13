Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BEA1E519;
	Thu, 13 Jun 2024 12:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282569; cv=none; b=ltS8ibQQeesb1doit+yCYGMNVkq7fn3/E7yzn2y8bL3er32b1xVsSz0uB3ynZz4qpu9DF6t9wVVu+6quAlJPzjmeGyOkel8dRvA2M2LEVbMKIukyNH/82tcQX8co3q0EoTBbNSdT9fsRaY+ijF97qyDV3UUZqBuoG2Ew0jDfQ34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282569; c=relaxed/simple;
	bh=P2qcha44o+iyv+kaBynde0LW7gEV0Sbs5sEVxoXQTXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/ng52B+SD0Jh5Xa2L5eCU3gQzG4mqZ8bS29XYnogDooSZelRbsvGuzjjqOlfDoRQR3EhLCf9O7CitnDQJx/dg/GanuA/rRKxl8ZqG9BXGVibyhBG5JXXGbDDdNdurWt3amWvO57NyZOwPtF8n+rC0oJ8R0yeDyddh3jLBH39XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cse8p3ji; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cse8p3ji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ABAFC2BBFC;
	Thu, 13 Jun 2024 12:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282568;
	bh=P2qcha44o+iyv+kaBynde0LW7gEV0Sbs5sEVxoXQTXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cse8p3jiKTSPxjIRuTs5xGAQxbt07fUdnemWqpgZrS/mMskcQv15Hn2HcNaeZ144/
	 wXZkORCiCp35fQ9iCbs+Moxz6lrIfjRDIrj1cFRT5Py8UNfNVaoeykd493bC4y6DMq
	 aU/faVw+JEHSLZb6qf9URySaaYH5v9xrwpm3rdP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi.grimberg@vastdata.com>,
	Dan Aloni <dan.aloni@vastdata.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chuck Lever <chuck.lever@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 290/402] rpcrdma: fix handling for RDMA_CM_EVENT_DEVICE_REMOVAL
Date: Thu, 13 Jun 2024 13:34:07 +0200
Message-ID: <20240613113313.463445024@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Aloni <dan.aloni@vastdata.com>

[ Upstream commit 4836da219781ec510c4c0303df901aa643507a7a ]

Under the scenario of IB device bonding, when bringing down one of the
ports, or all ports, we saw xprtrdma entering a non-recoverable state
where it is not even possible to complete the disconnect and shut it
down the mount, requiring a reboot. Following debug, we saw that
transport connect never ended after receiving the
RDMA_CM_EVENT_DEVICE_REMOVAL callback.

The DEVICE_REMOVAL callback is irrespective of whether the CM_ID is
connected, and ESTABLISHED may not have happened. So need to work with
each of these states accordingly.

Fixes: 2acc5cae2923 ('xprtrdma: Prevent dereferencing r_xprt->rx_ep after it is freed')
Cc: Sagi Grimberg <sagi.grimberg@vastdata.com>
Signed-off-by: Dan Aloni <dan.aloni@vastdata.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/verbs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 41095a278f798..34413d4ab0e52 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -258,7 +258,11 @@ rpcrdma_cm_event_handler(struct rdma_cm_id *id, struct rdma_cm_event *event)
 	case RDMA_CM_EVENT_DEVICE_REMOVAL:
 		pr_info("rpcrdma: removing device %s for %pISpc\n",
 			ep->re_id->device->name, sap);
-		fallthrough;
+		switch (xchg(&ep->re_connect_status, -ENODEV)) {
+		case 0: goto wake_connect_worker;
+		case 1: goto disconnected;
+		}
+		return 0;
 	case RDMA_CM_EVENT_ADDR_CHANGE:
 		ep->re_connect_status = -ENODEV;
 		goto disconnected;
-- 
2.43.0



