Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215508;
	b=KV4IlGgLDzoHU+4nOqneWG8DAEG1IyaXKbY4VXsz6taVvYKheNVPlF6A4LTpN2En/B4o
	 HjHbO2WiVvl+1Dc4uavvCoQ3qHapXy5LeJVLdGYgRXVlS3wExiaOEQJvaWRKt2dsq1p1+
	 lNhFKzReYMYPwY6jXlgK1B1FRDJ5XVSFbfZwOhvTDJC911154TsSMWTfyDN3FQpm5CSE6
	 PxGfSeiWH7ZC1sOHVXZOlF/Rx9Ev5zixHeqGYEgT4M2vVaPG2lB8eVngCCj2eUmE1NCIV
	 UPqhmYVp69nvBmzPuFMayHAcQ9xnsBUkL5Bwkxiz/qQi7FAbistyJWwuNPhQ4hsfmAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215508;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xNyxObFKussLmgjZijr/z00m/0ihgvSNzE4I/YlkqTA=;
	b=jINvcXpDDHTpxvjQgzBZRUUrhvNIKiw51hpO3ddOD2e6O/4B6WdEyC2sMzlRjzs5xo4u
	 VN2UXsn7Ow/4IUBzCkbdn1PkFBTvzHG0MKRNUFznq97gZUMYrtErkBdlPlRHlemzPNwd4
	 U4d1P8pej0OfofeJZkqDPEW9ZEN/rs1Ovug8djD0QtZ+WHyTrwmW2h1oyyFWrQ1okO/jK
	 +cUGsJSIyHVLBK89r1jypJ0jNI8GkUTsg5z6zgwEvnZ5JM6Sg1rtKqAF6a1K/Yn8dxOCA
	 Dcf1XIiwgMk1IRk7iBTWIt5VIM26362tNSqR7DW8IhwDci4Vc0uPzPwkoZzfZjyT2fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EXH+kG3M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F053606A31C;
	Wed, 28 Oct 2026 19:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EXH+kG3M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF3E1F01825;
	Wed, 28 Oct 2026 19:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215508;
	bh=xNyxObFKussLmgjZijr/z00m/0ihgvSNzE4I/YlkqTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EXH+kG3MUvjcNnR/ro4W42j83pbmkrhe4s+ssQKfNzNmvWZQrpBwlXCnER+DHqG/K
	 D0KQUiOn45Y8tdc9g5Yx2rOVcY0/mHWEhz290YltQ5CNhW3e7KSfKAPhlKIi38bF4N
	 R1p988rA9Tueg3jEMRg8yV0gFfU2QjT/y31yriSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Sun <samsun1006219@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1236/1887] net: udp_tunnel: prevent double queueing in udp_tunnel_nic_device_sync
Date: Wed, 28 Oct 2026 17:55:32 +0100
Message-ID: <20261028170527.550145711@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 72b0210cdead7..e6d6c4f716379 100644
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



