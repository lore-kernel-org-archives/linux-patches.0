Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624929;
	b=bFicMqoyhAT9IFUQ131spaQ7IF9ammLkBdwHS4zJllsq4fwU72GW+GuVE3qUkAEQ/Vka
	 sBrglJ9I4RWAEmpJ69QR/RQpPuE7UFOluO1XfQfMTlC864jd/Rt/or6sCdqdzZt382aFO
	 jubvhiwON+JdxG6JZ26ZY4neV3IRlxbxIGkemsCXayZRjmXqpooic9xXJgl+JZYCn5edZ
	 M9NI0ehAhrRDBs+aiSZU0XeOgOe5Ib3M1ypLJd/vrJXl4ROgtEFDjdDvqamEkBdA+SB2V
	 OUB6onsT1EvkSXlAmCUgilIR5r21l8gOH09UQjdRD0NOaZjW3W5Wbsb3ff1Vv6CWmpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624929;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hS+4vMfcKcgV6Xa113dtRWBeWrdwa7jn2rTcXg0APm0=;
	b=luQiUe3g8Wpa5irltMnkM91dKj5jxOKhs/VfMH70iulVdEbNJ6WKgmPvDBWGbbKvTJQ5
	 9rOxOBctgVhVAW7Mon7jLOMhb56+yWKM5mqL01CvDvUidy6s21iZmxoPuhVEgQd86hY5l
	 p6qBF9FcygKw11BGXGSmc1Zxok1oKatrseLNlGF2p+6iDzm45fI0stu7RbzZo+Raq4dKA
	 LoUAxCv08wkINSGV9p+S7I8VvnPP62zB7FN6XqGSderYV0DqNGEQGXhcET/0euPPbiD5f
	 7yTEHaduxrkbP8KWZ0jx7UNQYIAr6FgnWErPrt8SXjrsFDLn2sGlBd8R+MoID2HnGcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ziNSbGk7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9514A606A323;
	Wed, 25 Nov 2026 16:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ziNSbGk7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722E31F000E6;
	Wed, 25 Nov 2026 16:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624929;
	bh=hS+4vMfcKcgV6Xa113dtRWBeWrdwa7jn2rTcXg0APm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ziNSbGk73Wb6g09ANXpWPwiqy/N0kCu/Sy7sop+8l5YN79NejN2wTRu41zRI1wdtJ
	 nngrePmMpADMUsmLgLWRVsm0xy/DwSQs24wFH377Y4bxQhY9OH4F9oaxLrJIyX/hgk
	 uUKzFybOnBwCre1y/SLv/AZyBhbW69bvgnq0fpnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junyoung Jang <graypanda.inzag@gmail.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 350/816] igmp: use the joined device when leaving a multicast group
Date: Wed, 25 Nov 2026 15:31:38 +0100
Message-ID: <20261125143857.299730525@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
index e827537ec15b0..c2105be6b2e69 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -2355,6 +2355,8 @@ int ip_mc_leave_group(struct sock *sk, struct ip_mreqn *imr)
 				iml->multi.imr_address.s_addr)
 			continue;
 
+		/* The drop request may not resolve to the joined device. */
+		in_dev = inetdev_by_index(net, iml->multi.imr_ifindex);
 		(void) ip_mc_leave_src(sk, iml, in_dev);
 
 		*imlp = iml->next_rcu;
-- 
2.53.0



