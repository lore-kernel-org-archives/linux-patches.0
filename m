Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585899;
	b=ChotRPy3RX1O1mwJjsgHQGELNaoKkneYY9U3IMOgrRychGmSWM0S7iYeA1kTQ3t/w9pk
	 9H15Dgk8yNALKfmSN6KA5Yk2wR7lpyWnnqswvW3l/u7eWYDtzZN2ryNbOHzN2CwhFdUDV
	 CZ87h1qKW46WWpq9x//BxQjOxr3eErkvlbPBlZKdqTAC8kwexg8hLbS54ZWtIpkk6RuNm
	 ++BiqyIFy3Hm7XDQ/XAJezy41/C9veR9oIoNgY3zayfFTsIL62vfbLSsjFtNYyo2Nj6Rr
	 1BiXppYQTiIfHJ7WEIUVcIDA06OS6xKs+awMpnRNtWQd3Nv8FCm9FD1v79A79AMMAhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585899;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I4RDqc99Iemnn+j0KFG9CY/5UMe8CW4PC20keqzeLj4=;
	b=3FgZ+yqrr6WbLW9TUb3dH2AKJ2y27q8h5d3SqocQAs2AKOv4cdxkgSCPT8E+Vw9Ca/VJ
	 33VTzjtLnLbjY/OowP8OjGIKQSI8UnkpVqwF+AQQUn9hDJMCeQNzlQ39ZBE+NguXJuiV8
	 Q8uOqO5VBHHI8MR2b0jGw4Pl2lMKoyg51qmxG7M8npBRNjfTrNohTwqmpTy0SvPJyf/5X
	 Eb0piq76H0TiHWzJa5vohDZ2OLNxv60jYc5IZQpK6yKbnKUUsMTrSP7PbWSfnPa3E6DdI
	 /AvdgTpfWOzV1BZqkBYW+GLhSeRsr8B0iIUiEIF6jfR+MtA8gMYbYmK0vuSkafEZzXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tZCzVwGJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD07606EAAF;
	Fri, 13 Nov 2026 16:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tZCzVwGJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A781F000C4;
	Fri, 13 Nov 2026 16:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585898;
	bh=I4RDqc99Iemnn+j0KFG9CY/5UMe8CW4PC20keqzeLj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tZCzVwGJCoXWDwhEIwFcJtA1z7vRo/N5Qcws48iVAcZQZUMWTLgwJIm1W/fJTDhLS
	 Xp6myhSQw3j6cqGSrcLZzlHsrShOZhzzQnw8ajlVHtWZ9m4vya6ie35p2LrrDu+nCs
	 3Zc1RRhSp5xSspLprIMTp0vhTyh5OF4I8Ge9TtGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 411/507] mptcp: pm: kernel: use RCU to free endpoint listeners
Date: Fri, 13 Nov 2026 10:51:55 -0500
Message-ID: <20261113153810.667019509@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 1a77508132354..f7396628490e3 100644
--- a/net/mptcp/pm_kernel.c
+++ b/net/mptcp/pm_kernel.c
@@ -906,6 +906,7 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 	 * old status is known (TCP_CLOSE).
 	 */
 	inet_sk_state_store(newsk, TCP_LISTEN);
+	sock_set_flag(newsk, SOCK_RCU_FREE);
 	lock_sock(ssk);
 	WRITE_ONCE(mptcp_subflow_ctx(ssk)->pm_listener, true);
 	err = __inet_listen_sk(ssk, backlog);
-- 
2.53.0



