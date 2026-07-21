Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4A2314D34;
	Tue, 21 Jul 2026 17:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653444; cv=none; b=OSblq4OHcAKs9H/mR7wFo1TvujlVx1xkaXL8HnUMLu+B5uvz63EZJzt+WrAwFJf+2jY2TCeB7j5y2qvd6FKVzjz/ZUVWzWwsx8xjcKxguI6D4LwiCIwmH3500pZyzWs6c2dkva/lVqhKHbqaPw/DDjvf5857+0nfuz+MfJBDoEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653444; c=relaxed/simple;
	bh=tQfrkNhZ2Qo3YT/7k3KuN/TsDYzg8mSzCQGljA92KJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qScOx58s30vwZmzcnKPtTI3vpheX/WDbNObG52++HsVIxV/BzctwA+QOtFaJtvMz05hlfGbzj8qD7rkdxKDqAefqIss+iUoWY5CU0RUi7p6kYBi45woTIaW2363HCCgMSjaTkAV5YGQjcZZMVqHuJytxfnpAgRBL9Bo7hW063U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tHWOCjat; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tHWOCjat"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19DBA1F000E9;
	Tue, 21 Jul 2026 17:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653443;
	bh=1KB6DLs+CaNz3EIrWS2J/urdS5HCmlitA8prTyhc7gI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tHWOCjatGDheWJ5i+3hGXZhoG5HD9Y5S/8pv6FzBqTMWw+JaS5KpYEsD3ATzqVWN8
	 4Ag3d5LWSs65bLG13Gq8hDQ5LT3PldiiRnSCZqXmhi12aY5W1oWrH6QhdPVlmMpmOp
	 MQsNLGhhhrZ8B1i7zaQkqTjqaFoCuxGY1kdGeMgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Sun <samsun1006219@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1292/2077] net: udp_tunnel: prevent double queueing in udp_tunnel_nic_device_sync
Date: Tue, 21 Jul 2026 17:16:05 +0200
Message-ID: <20260721152623.293363770@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9944ed923ddfd1..3b32a0afa9798d 100644
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



