Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591254;
	b=1CrXA3eC5KmKc31jXkp1vWUmBspTcV+z52rH6Dnkxmw/SALr0z+stmv+ZfnRG+dOjF3J
	 lsvbEobV3MhDAYMH86J42FXNpfQTTV1IXgHcaOE93kY64U2FVOvdSF0qrgnpGaJh7rlxq
	 yPb6MaWy9Jslg8mlAv6TqFrRiOFSsZh8DQUkD0oFa/+MEyEjCOKrmYsCTifu9VicuH5cD
	 CZ5li6RkCSu3SN+B12pyB7xnVGSgEsVxtTJz6c3FkNaW+m7NndKUs3Ght+WNv8CM4WKh0
	 u6rnJPFfbXNyCWYJRQ7SuI68T31ZwPsu5PEfATU9qaTN4bIBczm/JdIW4SP6AvMygew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591254;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WhOCbwmWIOktyGfO+xDP9PtncCGd9uJclcEr7APJpcw=;
	b=Abz3TQfsz5hDm7yGffsKy0yNHkZ7y73dJtEnlsqqHakOZdMlzycCx5Qv57uBHHw61LXz
	 7q6e3oIRvGFtNz/TlTa/c/izLe31bMV7nV2uqDkiyGQ0ifmfaYTl3pLqdy+vvfEXLWC47
	 whrajr5U5hRyqrLyHi+EhWDk7Oj5vabtCdtkYGXk5RYNbRwe9rMC5f08kH2vtwymZVGww
	 q0bfx7BDlBmtoI1wvErz3kMjsxjfr2yag/9SLsm2DJzpLoR+zY6B7BPsn3UxgaSCGaUUv
	 1KxPqK54YEkKivmlfhTgppu+RqON67QyhnEP0TI109CQVa+yZGwufe/wcgGUvrXfnFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iiDOwY3a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0216076F81;
	Fri, 13 Nov 2026 17:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iiDOwY3a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185CE1F000C4;
	Fri, 13 Nov 2026 17:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591254;
	bh=WhOCbwmWIOktyGfO+xDP9PtncCGd9uJclcEr7APJpcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iiDOwY3amniZRfPULN3iL1f+0mhV4qzj1YUEzpwRvgxL9/gbUtc9Rq7yPUtjRk45j
	 wqvTQM4Y9MRgoTL5nWocaOkAaNwaNJ8fp65dGmaUNN/5du5FOSWZjg2meH4kOFBLqW
	 3+Al7aZfBQrdzAgJf1zlpR8jtWArM/UyYlcZqUyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 377/670] mptcp: pm: kernel: use RCU to free endpoint listeners
Date: Fri, 13 Nov 2026 10:49:01 -0500
Message-ID: <20261113153824.561461995@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index 4de1375bf2a5e..6e51b16f10d97 100644
--- a/net/mptcp/pm_kernel.c
+++ b/net/mptcp/pm_kernel.c
@@ -1270,6 +1270,7 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 	 * old status is known (TCP_CLOSE).
 	 */
 	inet_sk_state_store(newsk, TCP_LISTEN);
+	sock_set_flag(newsk, SOCK_RCU_FREE);
 	lock_sock(ssk);
 	WRITE_ONCE(mptcp_subflow_ctx(ssk)->pm_listener, true);
 	err = __inet_listen_sk(ssk, backlog);
-- 
2.53.0



