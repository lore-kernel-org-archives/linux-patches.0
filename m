Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704466;
	b=OVfzBBeFmZL/XeKP75XSg4r7ztK0zHg0+ZLwWU/OR+c+3C8y+l7tiJCcG5MarWUBlAFi
	 XeqWOqnnOgQVRnTjV31Ffv6NG9AaXzre3AeF8XTlzrsennicECpiGcd8li8lmS60Cu8fC
	 JCjrXjP4U+vKBdV5GSqLdXiNEyNBEVPReEkmA6pj8adfAVZsxWRlhvSdShbjIh5ty+DYM
	 3GlsXYQxz5JlI19TD46ydNq4D3CYUZmQP0WA8smdTyFGuNjT96YteOal1BO31rCI2Thnz
	 tU0e1tXPJrcqKTUTDZfMep2UWv9bPfaQZRbSSVC53aab3V2H07v6NPxHF0T2x2FLM0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704466;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nqOVfsEOX90x0oBcD1OFDPIiTqy062kz8WEd+C9o/qc=;
	b=T3wX4xRfnMzIGbvEmwWowUhtms7POgcQ/RGTLRi7Eu/F8xnq2jo4ydhXkIRa/f54HAyK
	 gkGgRhiFzL6EhUfCmKfMZIE9JdtGbOBa0fmLtI/Kdqk2un/ca5R7Irsasxw5aY48SkM/n
	 D5Bk4wMSCl6K0f6P9m/ovavMedxbYY0iqWuPksbZECr0b8dMMjX0WAdppZN/AYv8NMq5v
	 thUPz/WqkjRd6tIxKlaDL0AISBtXEVinKX63lM9PRv7OeeeIlh9zNVHX+aQf4+6F0dqXD
	 elCNLsM3kKkQ9bQOFc94alFrspO37H4XySZzcNqEFC0hfiMojf1m9MB1Su3BD+WHgPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ugOyZUiB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9579606A31E;
	Thu, 26 Nov 2026 14:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ugOyZUiB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C08EA1F000C4;
	Thu, 26 Nov 2026 14:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704466;
	bh=nqOVfsEOX90x0oBcD1OFDPIiTqy062kz8WEd+C9o/qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ugOyZUiB94ZEBHsjVtsCz0LbgHh2l/c3N49ns+vja7rx/rM/c6kurkQ64/c0C4Nvj
	 BtSBcHtwuTasFRZVVbTiBQY3UqiUlWBD+xbhtRo/uzTs9KKV6ovFK9ReRfZSO2PL+T
	 cDTKTXWZIVFj5a4+hIM2YAx2CkVbccl+hxq5AGwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junyoung Jang <graypanda.inzag@gmail.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 133/265] igmp: use the joined device when leaving a multicast group
Date: Thu, 26 Nov 2026 15:37:43 +0100
Message-ID: <20261126143614.323548742@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junyoung Jang <graypanda.inzag@gmail.com>

[ Upstream commit 19ec8416a76c08326fe5f814410a1b43046e63be ]

When a socket joins a multicast group, the ifindex of the device is
stored in the socket's membership entry. When leaving,
ip_mc_leave_group() resolves the device again from the request. If the
request only specifies an interface address and that address is not
assigned to any device, no device is found. The membership is still
matched by address and removed from the socket, but the group is not
released on the device it was joined on.

The group is then leaked on the device until the device is unregistered.
An unprivileged user can trigger this by joining with an ifindex and a
non-local address and leaving with the address only. It can also happen
when a socket joins and leaves with the address only and the address is
removed in between.

Fix by resolving the device from the ifindex stored in the membership,
like ip_mc_drop_socket() does.

Fixes: 4eba7bb1d72d ("ipv4: igmp: Allow removing groups from a removed interface")
Signed-off-by: Junyoung Jang <graypanda.inzag@gmail.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20261109125312.2208874-1-graypanda.inzag@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/igmp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 5d87e912e1f25..b4f9746ec7ece 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -2291,6 +2291,8 @@ int ip_mc_leave_group(struct sock *sk, struct ip_mreqn *imr)
 				iml->multi.imr_address.s_addr)
 			continue;
 
+		/* The drop request may not resolve to the joined device. */
+		in_dev = inetdev_by_index(net, iml->multi.imr_ifindex);
 		(void) ip_mc_leave_src(sk, iml, in_dev);
 
 		*imlp = iml->next_rcu;
-- 
2.53.0



