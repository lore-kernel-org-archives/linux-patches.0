Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038865;
	b=QqAMnsDsEtF7oWxEsUmtLmaeisz7H6ujUWae6Cs3cRqV1YLzn6pq0lpd9iRyXsxcnH7I
	 BKfPV70rKYRzMmfzVWuRVrFozq4jvrDyd9gUhDhGSarrP/6URciNCrWyYCIR6ZjeWupmZ
	 N29PjMWTKo67SrsTs8rcrUMd1/g/EWZbqkxRaUUPf7OP9+bvAVmPDoxLXhOEpj88FnO0D
	 k9CSVtZwel7p+zIBvbcScZ2bK4hsrxvcF8bxLU7YSlNNSi5TTaVOKSsTXJw9pDJrHj0PM
	 pqn0zmJSUyQSBFBj3kf4MeB6qSeYUpaj4owVDKF5Ub66wmQnWKhyuBG4MH2UL692uQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038865;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xzNLAWNKPhiLGRRpOo/jp/YcZfRY7pGkMWplb7DY0W4=;
	b=bkru2x+lQL9Bx+pH/hOP/ZdutEo6nqLBYYC0hGVOJSwQlCccv1CFUe78XJTJYaAB+x4f
	 o/36ip3dze3wKfCLm+D9Hd+ufDZcM78kGo6jngakRPJrpQATTlEq25g31bj2F5Sltjct7
	 L6OqX90eiSQfOqRz3rjc5xlQTqbghv8aJKt5WlCp+6iCBe5ELyxbmYg9euDSJYrNh+tSX
	 p5+HPsH3R9zi8ig4hCMz22YtvhmKc5GLiAtGAhnDaVx0OcIrkuCCTOnO0JvGuiAm+yh4Y
	 I5Ynsr+E8G+I1kYFyaPwMAOvKrhY3HfXlqHWAyJHUjHQN3e8M7neHnvvFM4RE1eoEuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z5lcyg6f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB883606A31C;
	Wed, 18 Nov 2026 21:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z5lcyg6f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6AF01F000C4;
	Wed, 18 Nov 2026 21:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038865;
	bh=xzNLAWNKPhiLGRRpOo/jp/YcZfRY7pGkMWplb7DY0W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z5lcyg6fzl7tlfZxo0YIvCkoh1a+f0tzn2IRH8wmsJWYBQ2r5347zoSYNv81BmSxZ
	 8P+emfOshAhh5FtgiNE0hW0vIfu6J38T94X0XOFpMxu7ZkRIV/Px3a9a48Wu9Bv6RV
	 L+h3JEncKHMfIAeRLVgw0aR/wjdZ6SNrlCdg9zhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1895/3318] mptcp: pm: kernel: use RCU to free endpoint listeners
Date: Wed, 18 Nov 2026 15:41:57 +0100
Message-ID: <20261118150418.859523822@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: redirected the unchanged hunk to the original path-manager source file because the code had not been moved ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_netlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 8eb7fed89d6fc..81d78a5121fb1 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1273,6 +1273,7 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 	 * old status is known (TCP_CLOSE).
 	 */
 	inet_sk_state_store(newsk, TCP_LISTEN);
+	sock_set_flag(newsk, SOCK_RCU_FREE);
 	lock_sock(ssk);
 	WRITE_ONCE(mptcp_subflow_ctx(ssk)->pm_listener, true);
 	err = __inet_listen_sk(ssk, backlog);
-- 
2.53.0



