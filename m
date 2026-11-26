Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705329;
	b=5jBCQR7xMiXJY2L6h/I0OF8Wvvy9a7tvKTd0dRI1/jAoq2Rz615ZKjHwSYT/gxcL3ZM8
	 NQc7WebIU3pyeg73NUDfF7EC7PgHnrzbxToEgq0uwsn59pZ/mmDI2KLjH/ZErRhQAnkPO
	 L7XqDg4dzC8qoZTLFOqv58+72tDjk2qZc9Y3yzDO23KOaiWhPrZgdc9D6gygnTWIpZBsz
	 2b/mZo7AQRGzYiZHOFSsyQJVWXUEa7sGmEmMctdtcsc6PvpKt0UMaeaTyc/Yz1m7GDkDO
	 98vUMKN6reQyVSXa6XHnAlPlJAikVcWHhHApDuBnnZ6ZCo2s7OiDXMXjpgE/08aNR6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705329;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xuchjF9+T3SyumI3kh7TB4cFXcnsSoScyhi/U5sgkxE=;
	b=4idb4brc/dH+Gg96mp8Tzol4wcZd/eO8ZaV0q9QviTAan/dRsUotpUN56lCQyGMCNfla
	 an0LPlo+lubPzdmqHg33lnsyZy5s24TOtvis2dU+gLDMWBRw1ZPqLZVVp8UEzFOivIDot
	 Z8UnpbRHVwBqVow5fVbtBpM/BeQNmnxuH8NHshCjFxF+VJUrCJnpVscxK5WwrfjVzMiJ2
	 2Aq1a1/9uV4AqKvj4nTp4gjQMk8dfn0XCeptCk8x7QGt2zg5jZs0GetR0znDd2pavKdYH
	 5n92SkFD4nCZDQfOtcRK940JMNXB1mYjYvfFdXycYWzsUxRQpIJN3qTQVviq6oiS/zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wsIkQoXs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072D9606A32C;
	Thu, 26 Nov 2026 15:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wsIkQoXs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6140A1F000D3;
	Thu, 26 Nov 2026 15:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705328;
	bh=xuchjF9+T3SyumI3kh7TB4cFXcnsSoScyhi/U5sgkxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wsIkQoXsVQGdqL2rUFay3vgPVlY+WfTbwuGSXQVx+Svr6ZgW/rjMUCLAqFwnmoQ66
	 jgzazQzusrE9GmF69UfzJ3TDXkQbhpL6qD8Ll6o9/NF9OLPfnB7F1K7T+HjkwzR5Vo
	 PTg3vxHLvOoV41fey/amna1JRCvwKgnTyAjpbygc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junyoung Jang <graypanda.inzag@gmail.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 160/319] igmp: use the joined device when leaving a multicast group
Date: Thu, 26 Nov 2026 15:38:48 +0100
Message-ID: <20261126144010.357356790@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ed0e342e9bc60..6164c8e51dd8d 100644
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



