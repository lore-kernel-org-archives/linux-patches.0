Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047547;
	b=gJGaq2JwexijNh2eXGgONlgGOy8kKfB6UzYXO5/6zVBXJElU7BLRtFR9yQWfGhRdXmK+
	 bcE+8mKTxm12sJ7SCafC7cGkdnTTUvKR8B2wtZaLEej0wurva8LMb1kEOkCOTIeXFIj6M
	 /zosIkMGZedHHnpjZ1TbokTcN1pS3dJahDYVJHdO6C5u3jGA+PQdNX5a1cRvgX9osMJ62
	 AC4fjy2uiVdCX+lA0EWjVGH5J1pYlwRDURwLJ7nrYsDJPl/uiSKxq3bt2dD3d5L3AFdh0
	 t2h4O9yuLPuDYqZnWFJzTU9AbO2qjtUUhwu8GK0f5c7DTqGBXybWvSnG1YlBlNqO4wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047547;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RDmUZLEvBrBFickH3ru5tqXw4sq80O3S9TMQ4OW3T3Y=;
	b=mvCc5MROsqbtPynr8MSc4KkbK2PLJjDNSQvIVYRIUB/zgJqNoy7O0BouZjqJ58ne5F6d
	 yMlI76hn2EOKz9of5NGz433ZVYwQXsJA3lqZia7h+I8QXraM5BV90wWNFF+lSJrNA/9wD
	 oDCTIj0MsrRkPx+a1II7UbMWbvxXeGgBrwgxRfXuBrV30BsneVsItLJ+mN27OXVcoXtS5
	 iE1grd4zszb2od1DpdX9dKRZmuIRwwStC8eZiW8R64WGFyHJ0yt7KL8UohcotEcd2p2Ai
	 D2/S9M841Fm34ND3PXxYYKwXjxBkBvaf8yfikzTOAF3OeGUm05pkrvHLlcbBiR1AvEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="CHF/54AU";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66F5606A31C;
	Thu, 19 Nov 2026 00:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CHF/54AU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350141F000C4;
	Thu, 19 Nov 2026 00:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047547;
	bh=RDmUZLEvBrBFickH3ru5tqXw4sq80O3S9TMQ4OW3T3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CHF/54AU9/IgkmH5OpvPuq8JW6ey9dvRfaB3nmHCcjmINw/rEH2IG70IHLFPF6phb
	 md2fWYWgwUfJW8dOI5dhR0THiHMnDpNjf2gYzPDLd2qMRB9XRZqvHb2N2snZIDPupQ
	 RR0kTf2ky2R+75b8WTa19p6oTtCxk+BHjbHylFMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1641/2857] mptcp: pm: kernel: use RCU to free endpoint listeners
Date: Wed, 18 Nov 2026 15:44:35 +0100
Message-ID: <20261118150300.422101544@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 49b09ae0bf57b4230187d4cdd0a370558e44a6e8 ]

mptcp_pm_nl_create_listen_socket() starts the TCP listener directly
instead of going through mptcp_listen(). It consequently misses setting
SOCK_RCU_FREE on the parent MPTCP socket.

tcp_child_process() can invoke the listener's subflow_data_ready()
callback without holding the MPTCP parent lock or a reference to the
parent. An authenticated MP_JOIN racing with endpoint teardown can
therefore access the parent after its last reference has been dropped.
The ADD_ADDR error path can also close an already published listener.

Set SOCK_RCU_FREE before __inet_listen_sk() publishes the TCP listener,
matching mptcp_listen(). This protects the parent on every subsequent
close path, including a failed endpoint addition.

Fixes: 1729cf186d8a ("mptcp: create the listening socket for new port")
Cc: stable@vger.kernel.org
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20261030042255.74216-1-kylebot@openai.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ sashal: adjusted listener-creation context for kernel_listen() instead of __inet_listen_sk() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_netlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 05fb4d43187ad..a618ebbc42b09 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1261,6 +1261,7 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 	}
 
 	inet_sk_state_store(newsk, TCP_LISTEN);
+	sock_set_flag(newsk, SOCK_RCU_FREE);
 	WRITE_ONCE(mptcp_subflow_ctx(ssock->sk)->pm_listener, true);
 	err = kernel_listen(ssock, backlog);
 	if (err) {
-- 
2.53.0



