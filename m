Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF81C399015;
	Tue, 21 Jul 2026 19:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663060; cv=none; b=fwOTC0Kbq0EHOslOsN64frdic2tUX81tagROr7E7xAn0e2mPzKunNiNxquCkLxRBULbA4pwBSK3oFrjGsMG77U4+84CiQ2zf3IqgEuXHA3mfL/kcyAOJfCVJb+6YKtRvQWv6tNsHTaW3e5j0irRxv1eVsDRTVIiLvxqljMGsAac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663060; c=relaxed/simple;
	bh=Foz5bMnVF1Il6+83h8yLGVD5EPTXWpzORHUh8aZkuHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXkzT2otrY543I+2KWFqkQvv5iSsHfJI3ReBM6jOPe/pXdinCAsKJJmXb1X75zYXe4eA4IH2fKcj4onrqsTrxKwztzz6p4EaZwrAbcvXKyeTAZPsbY8q763kr3HUOO6HI8s3VDEuUh3axUP463JfrH1ZKySCo13E2KV8fWb62+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WA1HHRaB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WA1HHRaB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30CD31F000E9;
	Tue, 21 Jul 2026 19:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663059;
	bh=9Ic7oK2QPXI48J8Drk+1XUJbMk+vjO5F+YZISmg5G1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WA1HHRaBwv57MHfcAHZ8GjXCMJvbdJHjM48cePAS+vkNr9xnAJ1zP4I8yZvPBCOLG
	 TzUgd9cRFv87N/m0vxCSVYn4mUQEy37gauixmXjfdQ/BtrYJEd/hfpB1XEwL+R4qdy
	 ppCGSVSLvX/gyZMZxj4xMeh9445ST7gOJTtth27Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Sun <samsun1006219@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0679/1276] net: udp_tunnel: prevent double queueing in udp_tunnel_nic_device_sync
Date: Tue, 21 Jul 2026 17:18:42 +0200
Message-ID: <20260721152501.292623752@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ecf69d4b43370c587e48d4d70289dbdb7e039d4d ]

Yue Sun reported a use-after-free and debugobjects warning in
udp_tunnel_nic_device_sync_work() during concurrent device operations.

The workqueue core clears the internal pending bit before invoking the
worker. At that point, a concurrent thread can queue the work again.
When the already running worker eventually clears the work_pending flag
to 0, it mistakenly clears the flag for the newly queued instance.
udp_tunnel_nic_unregister() then observes work_pending as 0 and frees
the structure while the second work item is still active in the queue,
leading to UAF.

Fix this by returning early in udp_tunnel_nic_device_sync() if
work_pending is already set, preventing redundant work queueing.

Fixes: cc4e3835eff4 ("udp_tunnel: add central NIC RX port offload infrastructure")
Reported-by: Yue Sun <samsun1006219@gmail.com>
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260625065938.654652-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp_tunnel_nic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/udp_tunnel_nic.c b/net/ipv4/udp_tunnel_nic.c
index 944b3cf25468ee..b13e8f7092f463 100644
--- a/net/ipv4/udp_tunnel_nic.c
+++ b/net/ipv4/udp_tunnel_nic.c
@@ -301,7 +301,7 @@ __udp_tunnel_nic_device_sync(struct net_device *dev, struct udp_tunnel_nic *utn)
 static void
 udp_tunnel_nic_device_sync(struct net_device *dev, struct udp_tunnel_nic *utn)
 {
-	if (!utn->need_sync)
+	if (!utn->need_sync || utn->work_pending)
 		return;
 
 	queue_work(udp_tunnel_nic_workqueue, &utn->work);
-- 
2.53.0



