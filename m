Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDBF199230;
	Thu,  6 Jun 2024 14:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683711; cv=none; b=kpqN4fF/Ri5afquhltokvGJFyv7sAxGkrqKkpMWqQtHNYLY0JeWbrKz7dqynN5kuyOxuAjnTlOUvaFeFdNiab4thdCwjEPEdcfFjTg9QEG6spUghB8ai8szLHETaqW2en1ZUoE+0rO3kbtjzSkH9lIGeXDfnCj/s8cHKmMIFwyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683711; c=relaxed/simple;
	bh=O8rrvzhObgyzBgulAHXHz96nM2/Xh4BXey2OZjoWZmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fRNP0fJCt/p+YTBrsQtcH4BkFGA6dAFgdH+UgXEIlx5zcL85G+BosWpO1GAFr2HEB7GyB+Ep69Az9+I5F+7tjmUuahJsFPbGc/+ImHcrB5rMXzRtv6ayE6zebj3XkWp7gPoklDZxWwtLG4ioBshHzkqXLRVttS9xMuoZ18jRCeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CB1rb3A1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CB1rb3A1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E83C2BD10;
	Thu,  6 Jun 2024 14:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683711;
	bh=O8rrvzhObgyzBgulAHXHz96nM2/Xh4BXey2OZjoWZmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CB1rb3A12xXd5UfuxO+L1ygc2MN3wLSKhPvuxQ1ym0IwbWmpmi/vGp33y32emFDhl
	 euuw/tB2usUtUg0/Y4G6u5hUW3Q7+WdPgcMEP1CoBbIZH+vrCQjbhwYq9vRMY85FX0
	 ojpEh4o91gYVfDuLGEse02/EkTAJUA8J8GAfXXZY=
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
Subject: [PATCH 6.6 642/744] rpcrdma: fix handling for RDMA_CM_EVENT_DEVICE_REMOVAL
Date: Thu,  6 Jun 2024 16:05:14 +0200
Message-ID: <20240606131753.061995081@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 28c0771c4e8c3..4f71627ba39ce 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -244,7 +244,11 @@ rpcrdma_cm_event_handler(struct rdma_cm_id *id, struct rdma_cm_event *event)
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



