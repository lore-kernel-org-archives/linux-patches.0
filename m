Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054352;
	b=DkLZ3UcfIL+joON846TOQBD9AnM97ZgzTNJOF0/SgnB0tFDRmtFT8Bkc3uq6tjhvnhV/
	 s6pf3WTfx+cCEvnY/0zxTKojhzE8oa1C39QFUZcg3a1R9DAa52xHmjIoKLun2AufZTXuR
	 W2WkRjkTtdgRzQCX1OHns99b38yFlsuMLRyAmryL5ZuG52AAOICwGjYjVTn3GZ2b1kCXT
	 EdovH2MK6WdCs8u2SEwvsXXp7MyFr3f/0FPn1q45tmq4/I2Nq0wJp+ttjp8RJGbANHkON
	 62XcHswkSfzwXyufyMBpyQOb4AEr+LzLfRSF04PUJGYf7FiZ/hUT4RWphDKTSwrubAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054352;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HX77RaJy1vhz7rl3IDxOX1Wx6ENbntFR5VcLbPBqL1E=;
	b=vZQObqe6nq0jRwWaUhsDQ6Y0CvU5vqm80o3+ABKVcbTu24n0mKu/5H18qoxaGcZ90ogD
	 eL2dIqz9nf6grOXZg9o1zQnqkcslL608x8zX4YXuznpO46iW13EAFWKuSVYGxpdfrhLeJ
	 W9WNKLbd/rt7k8lwzmDHmvluajT7FnnM/vlzDd7urSTTzCaM89b1jXkgsecL14dZn11Dc
	 PKEFO8XCuKmavgptdJumasN9RLokZxweOPKghQn1YGaJJ+YMg2UyBMwI3h2jYmNhHCo+3
	 gkLFMZxKgCdZDduC+DGdb5Ej3W2gbr1epl+KRpDViOYGgp54AYKftkDqRCUkVw+FIGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zxdne3Ye;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF0E606A331;
	Thu, 19 Nov 2026 02:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zxdne3Ye
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E971F000C4;
	Thu, 19 Nov 2026 02:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054352;
	bh=HX77RaJy1vhz7rl3IDxOX1Wx6ENbntFR5VcLbPBqL1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zxdne3YeZCAES1Z3oHzF7Ek0oAFKO+aTyai+EokePT4NYlLI2T4AVIfjW+PAh51kx
	 Qq9bhELfnGpsBTCA/No2H5QWptv/DSf92IUcqmeDDVn8gC416fzh35yWfzRGnm3UgD
	 LRChMeZOE1FSHm3ojOi8bFhE44oDi0e2u+7acWOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1242/2214] mptcp: pm: kernel: use RCU to free endpoint listeners
Date: Wed, 18 Nov 2026 15:48:38 +0100
Message-ID: <20261118150101.402688174@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
[ sashal: adjusted context to insert the flag before kernel_listen() instead of __inet_listen_sk() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_netlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index e912615e008f3..b748558fd27eb 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1111,6 +1111,7 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 		goto out;
 	}
 
+	sock_set_flag(newsk, SOCK_RCU_FREE);
 	WRITE_ONCE(mptcp_subflow_ctx(ssock->sk)->pm_listener, true);
 	err = kernel_listen(ssock, backlog);
 	if (err) {
-- 
2.53.0



