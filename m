Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033273;
	b=2ogQhO3li9ANkgsvtRPP/rWR+3ChdWDL12OcQ8GYvYChBKWqViboO+Y/B5ce9V0eNyfT
	 YyBta57keyyfb3ASrkMqnqZeQ4NGOeFUCyRA+/XRTZ714VDezKl0zOzLABly99Sr5WKau
	 p0erfHGkN3OOz7lPp9yWLqdE3pzYdobQycr1JiF/qMwyFUXH8qysQnloeC0IRSvBrOguN
	 SdaAVEKYbJcoHYMiNQ2xlJxKE8cA5LwodHxhE+GmVavk6K33ttfcqaGiYOV/p++rBgINP
	 i+KQsG1t1fXa79qZ5BmdmCWOI1gDd9iEgwHeGw7hhq2q8wQFoMi3uL0oXZIlLuAkJQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033273;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d1LQJzWhe7X3UEL8J4FUxeFygbxJqVbqjqmbiN6DwZY=;
	b=2vf7tdlrWWVUU7wueLVYJwF7uFZq03yJfcgOPD4tjfYnvBHIGHevuZO4yLGTXCOptDNT
	 A/f+uCI9377JrJNtkBgmKR0YLF0x+AVRr9QUZpgIFxV/YN1IpfpMLk7c7sLad8LgPxfX2
	 5DhWx6N835bO6HqpeFPH+t813NiAl93r1EQeT2aUpaOwk7VMKbUM99vlxca+uVdJFlx2G
	 PbEDJ4y4i3ipieVnVvE8eRkLbVrbdYOHWhtYbQ19k3Hgpc2iP37mUTFK7CB3tyy/M+hzR
	 neg7Ti/dnme3A0XGACyne7FvklMhH2l3x2y6bLc34A+gV/ht+W3gTU2lqsudQM9M82Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DYdQXPT5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AB5606A330;
	Wed, 18 Nov 2026 20:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DYdQXPT5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC361F000C4;
	Wed, 18 Nov 2026 20:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033273;
	bh=d1LQJzWhe7X3UEL8J4FUxeFygbxJqVbqjqmbiN6DwZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DYdQXPT5+ZXLxvQ57PecD+CrTOoqAdxxuOab7/apX1X4/HTnCAgkZ3OzZRCMv1jUc
	 IfaqZUp2v6RWRnM6FjpMKDb/p/uSPg/wcOz0SERIyesxgLu1xZ00dAo8BARzxwEe+0
	 GBAzpaK+UdwX+EISD7FoxWcRi37E++9Og3nSttcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Liang <shaw.leon@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1710/1756] tun: drop batched packets while the device is down
Date: Wed, 18 Nov 2026 16:03:57 +0100
Message-ID: <20261118150117.699111691@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiao Liang <shaw.leon@gmail.com>

[ Upstream commit 8f44631ba02afe9fff2f0a0fb66560ab19df87fd ]

tun_sendmsg() handles TUN_MSG_PTR batches from vhost-net by calling
tun_xdp_one() instead of tun_get_user(). But this path does not check
IFF_UP, allowing packets from a guest to be injected into the host
receive path while the device is administratively down.

Check IFF_UP in tun_xdp_one() before running XDP or building an skb.
Drop the packet when the device is down, matching tun_get_user().

Fixes: 043d222f93ab ("tuntap: accept an array of XDP buffs through sendmsg()")
Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20261027101830.85327-1-shaw.leon@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 479108e87e3d8..461b02721aab9 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2483,6 +2483,12 @@ static int tun_xdp_one(struct tun_struct *tun,
 		return -EINVAL;
 	}
 
+	if (unlikely(!(READ_ONCE(tun->dev->flags) & IFF_UP))) {
+		put_page(virt_to_head_page(xdp->data));
+		dev_core_stats_rx_dropped_inc(tun->dev);
+		return -EIO;
+	}
+
 	xdp_prog = rcu_dereference(tun->xdp_prog);
 	if (xdp_prog) {
 		if (gso->gso_type) {
-- 
2.53.0



