Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028339;
	b=PinBm/PaZn/P4zDttIRdVYum2V9JC0NhKe+4mcrOg8802nQA9sSzSwZD9KKF6abIzQNB
	 1hho/JLL2lKsbc7+YluM1cpPIkuFAruHcNle8alVsh+Yhvj7ZD0i9CPjDHn7PfASCIPPP
	 6WMT3CNXrlBUxkhKoUqWsY9S+R9MxvzW9JU4g61b3Gxv/9zYfqmXsihoBUkd6JjFsxNZA
	 6h93s5NPT/XYZd8CseGv809SL4TVy9PLh0XaLGJcB/pyrthxXJJna2ObA/9/zVF+Nlq9T
	 2jJEb1Uex0FYwJOCtETAhKGDBn3P0rIFifGFrf2ezOvjjbAhObUdJNsE4quQoylj4tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028339;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fNemDZ1/9Jk4nrFnvEM80qLQ0G+ZNq3miFmg3oqxvGA=;
	b=iWl8tFuFTSnYJu3DwYsnHc7F8uQkDxmtpfX5tYzq83QGEXGiLxm4GjLHzkBlUkDL8y5+
	 OPpE7OZbubkmgFeQy6Et205XkSn9nRoKq6Qe9z8Z0JG6R+oN5faDhKrVpMIOUZhMU73a2
	 yA31594A7c8cjfgipiBvddmmhWqv23ac+X7ktsa2fA2lHIajCfCI1WWssNZWBYyrzvKbB
	 m/hMowO/ObDJ9TjkVWaS6+aKP+V8s/g/Wa1yRc87u3FlyxXGOYLCAJs5uFNX+UIbRhYLW
	 kz7snLs5zNmOWs4cJ9PAMdvAM5T9zPNYjCWmw/ZZNn//9nOQMNjCPWDnGPOtb5CysTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X9PAQsYQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709B4606A332;
	Wed, 18 Nov 2026 18:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X9PAQsYQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B0A1F000C4;
	Wed, 18 Nov 2026 18:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028339;
	bh=fNemDZ1/9Jk4nrFnvEM80qLQ0G+ZNq3miFmg3oqxvGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X9PAQsYQT3uOEqB4ubqyN14eAkv8ilKRH6fFfr0IlwSK6/BKzfD9eVnVWhjhpUAba
	 TGVrWgk8NaB1EWgeFDjEIySW/TxekIHwNSqNP1D2gI5Xd7gEUsUeg4VKOohNS5TnY1
	 c10h+qjFgMvpwMUByQ+1Ia0yYqs/szfeKSGL1cRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2110/2151] apparmor: fix check SCTP bind, and connect permission checks
Date: Wed, 18 Nov 2026 16:04:05 +0100
Message-ID: <20261118150238.557893550@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit 7a82f9a06459ff1c37b5e97b204430442cc076e3 ]

SCTP mediation of bind is not being checked correctly because bind
permission needs to be checked in the sctp_bind_connect() hook.

Require for bind permissions when CTP_SET_PEER_PRIMARY_ADDR, and
SCTP_SOCKOPT_BINDX_ADD are asked for.

The peer initialized ASCONF cases (SCTP_PARAM_ADD_IP and
SCTP_PARAM_SET_PRIMARY) are processed in softirq context and are not
mediated atm. SCTP_PRIMATEY_ADDR, and SCTP_SET_PEER_PRIMARY_ADDR only
select among address already in the association.

Fixes: 56974a6fcfef ("apparmor: add base infastructure for socket mediation")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/lsm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 9b9be6849411d..9e82e4c0b0433 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -1392,6 +1392,11 @@ static int apparmor_sctp_bind_connect(struct sock *sk, int optname,
 				      struct sockaddr *address, int addrlen)
 {
 	switch (optname) {
+	/* Bind checks */
+	case SCTP_SET_PEER_PRIMARY_ADDR:
+	case SCTP_SOCKOPT_BINDX_ADD:
+		return aa_sk_perm(OP_BIND, AA_MAY_BIND, sk);
+	/* Connect checks */
 	case SCTP_SOCKOPT_CONNECTX:
 	case SCTP_SENDMSG_CONNECT:
 		return aa_sk_perm(OP_CONNECT, AA_MAY_CONNECT, sk);
-- 
2.53.0



