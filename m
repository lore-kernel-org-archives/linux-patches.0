Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590494;
	b=FLyKjN4YotOt8CBuJCkiTi0yUAxjG7yNeKDJYyogSaepezNnVwWB0qPLca5ppluGezQ+
	 VfsUPZPLduVEFYG0VbkxfxUa52+eEKA1+E5VmZBU7CGqfTDqhcxHRvAjeRQqUYbvaqAOa
	 OgYY6pSNvUO+FmMuDWkoKMI1RoTu0pd82PaAUiqLZ1b3ZEPPVp3mh+KqjnOo0SLCGHw5P
	 3QYSlzh9ORLjThqD9kXefb5JaWrfT6gygwcJ5I6iUbXOWnqzfcfFgnkJKwcRRlfpnnEqD
	 xCCXng2m3jquMjPF7ClKaYS2M0xeZKBQktK7GIbM7pMQnU6GSIhrqg0WBpLmIFTxMhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590494;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IfatEY/1Z7rBOGZMcwP0hihw8f6C6JyiKefFvNHkyhs=;
	b=x7GxuqI5ZO74QK3NRyWKzPvE6bv4iCx8ZM6lAHCOZc4OTqbgYB9fbRPYj96zzvbZbd2u
	 8ndnIo0ETrQWR1Za9mzduPiBiLuCSrH1VSmCnHvpGnnI5Nqa4zQlM7JLIyWO3tr7kEs2c
	 BuulTEPvQi5gShGWRwCpaZVw8RubaYS/eUPkNc93qyIqJ7zGScSpDdTJr1LCjda9T0WxT
	 tczdMas70+wOvutQN1DFPShDxwYfEIukNUdB3WCVlFozjRS8yRco/VF6DFIRnYFQhrAYF
	 EJPCMqo41mPabebt9TJX6SU1irqATuQnbLeObCuJzaCMkzKua3a5FuzXD5wTRXsyk0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f6T+pLPX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E52606B356;
	Fri, 13 Nov 2026 17:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f6T+pLPX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41CA1F000C4;
	Fri, 13 Nov 2026 17:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590493;
	bh=IfatEY/1Z7rBOGZMcwP0hihw8f6C6JyiKefFvNHkyhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f6T+pLPX+C4/EuxDxV9bvHFxk4BYIr/spEKjgHeXJEW+/So/A6tfHJvIny05npd1u
	 R2O/F5AnIBOGMvtjILm/ouzDZKDuPvYXG8DkcngvrputJUqgWmOoE878u7m+ouYijC
	 Gi2S5A9Vz3D4NruDYoULBWhkLcagRw/FWf7vyQLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 442/686] mptcp: pm: kernel: use RCU to free endpoint listeners
Date: Fri, 13 Nov 2026 10:49:35 -0500
Message-ID: <20261113153835.867740860@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_kernel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mptcp/pm_kernel.c b/net/mptcp/pm_kernel.c
index fa34a333a3110..cf635b84fff4a 100644
--- a/net/mptcp/pm_kernel.c
+++ b/net/mptcp/pm_kernel.c
@@ -881,6 +881,7 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 	 * old status is known (TCP_CLOSE).
 	 */
 	inet_sk_state_store(newsk, TCP_LISTEN);
+	sock_set_flag(newsk, SOCK_RCU_FREE);
 	lock_sock(ssk);
 	WRITE_ONCE(mptcp_subflow_ctx(ssk)->pm_listener, true);
 	err = __inet_listen_sk(ssk, backlog);
-- 
2.53.0



