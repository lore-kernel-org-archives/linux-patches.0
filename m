Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2283C1085;
	Sat, 17 Oct 2026 17:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259216; cv=none; b=Qwo4YTAvukCe+caqm7md7Zt8C1y/ls5gFZP3pLHVR7UvE7jUPRCj9NaMLNHtySQdgA9CC53649SSMkRdnocTjY7+gYcpQLgQ+xCAu1CNdUhXPf1fJPNvDnQI2oyH6WeOm6KuovcjedfutzUdyD0x8Q6NNJHgLPXg2Y8D2/61uOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259216; c=relaxed/simple;
	bh=VZY4NM7G9eFwmzJYp3LUYfGzBaFOPZ1kNeQfVSwdioI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fm5SaM3DBmOc/dmuT3CkzrIGx/iWdZJP+NcceBBP5bDIFTbNYsy0MYErp03VYf01OtIe3toUTTLBeddNVbSuWYr3FhX7vii789/RnaxX4AQvr6vrU0XrIAAJyB4Qb4QmOghdlUW3F9Rsh4pe7XvplAlCNi/R7NS9Hlsx0Ooo78s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W2EWbKoR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W2EWbKoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196B51F000C4;
	Sat, 17 Oct 2026 17:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259215;
	bh=tGCm/OHOZ2CJuFHXZTCmgM5U/qDeipv1cguHv5HJhtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W2EWbKoR/0cWlIbPN0jguuIYLYDJLABoB4tl34O5k81fjz+ZbFJd9cmCoTgaEJmeI
	 nhFO5fFC2s/+HUH1D2GdWbs5i+1K+6OqLcsCSkMPsXqeEgXuNySOIMCErQR/64qgGm
	 1Nl01baymWngC/Mdldze6fIl/kpMT4EGwuEDWv3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Sun <samsun1006219@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1139/1674] net: udp_tunnel: prevent double queueing in udp_tunnel_nic_device_sync
Date: Sat, 17 Oct 2026 17:56:51 +0200
Message-ID: <20261017160500.396218586@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a08b0b6e0727c..65a4731d6d842 100644
--- a/net/ipv4/udp_tunnel_nic.c
+++ b/net/ipv4/udp_tunnel_nic.c
@@ -301,7 +301,7 @@ udp_tunnel_nic_device_sync(struct net_device *dev, struct udp_tunnel_nic *utn)
 	const struct udp_tunnel_nic_info *info = dev->udp_tunnel_nic_info;
 	bool may_sleep;
 
-	if (!utn->need_sync)
+	if (!utn->need_sync || utn->work_pending)
 		return;
 
 	/* Drivers which sleep in the callback need to update from
-- 
2.53.0



