Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D1B81AA7;
	Thu, 13 Jun 2024 12:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281460; cv=none; b=DVpDSQ7l4GyJW4DX2uFfUZVuQldHB6cQjYySqDmt9IHxnsUidgmeNWOjiZCYDVY0H6KmSCgaq/+SH+LAMSLMQVLa0iDbAuT0fB1SFp7FIfvatkCf6GZ1eHXEjvlczlzAXQmqhCwzGa+adxU+w5TqhCQr7RWXXrofi9lIy23oI0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281460; c=relaxed/simple;
	bh=HWUaNmE1L3yrqAKgUVfAIhBRSme8W6TBUuU8QfcjqW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZzNEC1nVWUlyjm4RCWzqup94rCRhoPDoHmj+xIzHPeJp27zkuORPTXo9dfurj7rVfRlU+B8mlNfPHmWJ6HSlNvYV0UiMEDnTtqRT7GE0mRltggq83rb3Kz6yr6vbVvN9s0D/qINoOfs8CflxXDqylYxYzrkIcbSx7v+0Cod1Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1+OF5IHW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1+OF5IHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C2CC2BBFC;
	Thu, 13 Jun 2024 12:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281460;
	bh=HWUaNmE1L3yrqAKgUVfAIhBRSme8W6TBUuU8QfcjqW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1+OF5IHWFjBFYe1TaOMnSJF7+0UtaY9WTVIJCGlZN3ygt+LrZlIDxLkPybuPJi03X
	 WOQvb9QqiwB/6qmEiblX2+Ni/tTaIxKUlXm3BennUn1wpf9x5ak5aA8EJ6Np/+0W1q
	 ygGe3k0sISstYHib8/IZPXHRB/XsIwgyb9et8HuA=
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
Subject: [PATCH 5.10 231/317] rpcrdma: fix handling for RDMA_CM_EVENT_DEVICE_REMOVAL
Date: Thu, 13 Jun 2024 13:34:09 +0200
Message-ID: <20240613113256.486300871@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d015576f3081a..9e9df38b29f74 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -268,7 +268,11 @@ rpcrdma_cm_event_handler(struct rdma_cm_id *id, struct rdma_cm_event *event)
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



