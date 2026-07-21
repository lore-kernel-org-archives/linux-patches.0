Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A56046D2A4;
	Tue, 21 Jul 2026 18:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657898; cv=none; b=RikERfLvAwQl9Z7k3UrDrD3eAk+H1dKfJ1HncqwWIP1VKBuhA6VX9B7qjuLARBL91qU6l78rZSdHcdCXAXWc1BGWk1jzhdv4oVNzFZiWpeCK9d+Xjq38yZEdjgxf/0w3msAg7205+5gNo4U8U0v4fNoL7IeuosoW7D4vKZbV4aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657898; c=relaxed/simple;
	bh=SHn9VgcLEw9/43D8+N1oF+y/p6L39vg7EEjrhKX9xCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ex3kDqveTPK9bOINixi2T7HW96FJH6agocuaMJviRS2G336SrqCckiJIbRuSkVXQw7b6lZJq46zpXmHS6t+W3g7KEv4S+Wf1pRrZ1qk00hmQs0DaiTalPVejLNtX5DO24tJqNLxiS5eigowOwSXb1JeoM2MkwzmspdL8jopTKR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ejn0DYBI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ejn0DYBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9C21F00A3A;
	Tue, 21 Jul 2026 18:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657896;
	bh=Tf/BZd1t9NK7Cpb9OFPz1sVDmwtU0eDTgg0gBy1PPJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ejn0DYBIdIgO9bJqTqeuml/sLmYaAzSOXsCwT88lT2mI2tgKmoMK16SODajm3al+y
	 ke/wzGJDQDmtntmI7FXIJD5b44h0GR37UKs0oB7jwxcolujzqgxh+RiN1ASM4/hI25
	 /PxQ/esYZZaIMHWIghnsNqedQP0geiwa8rR6qigg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Sun <samsun1006219@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0940/1611] net: udp_tunnel: prevent double queueing in udp_tunnel_nic_device_sync
Date: Tue, 21 Jul 2026 17:17:36 +0200
Message-ID: <20260721152536.530833487@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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



