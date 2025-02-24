Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1624B14012;
	Mon, 24 Feb 2025 14:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408964; cv=none; b=EzCW7kTMc/+kQ6i+/mxqSBnny8R0wfwcmKDfwN7bYIhDvyh9MnktI2nEToV/TyOryQUOIOxqDwijtj6ztFRX8lIZ2IOjqmZJvJWng+wow+foe9DniK0jBqXiN9+fi+B8SSxE0D36lZvXwIZN1q6X59wy9Js1PKa6v0gFCIO9yVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408964; c=relaxed/simple;
	bh=AEjcHLvn2a++Q/X5sRQUcAUNoSoYDzPs1VPneOVYM70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IViewoLKeFIOi6ybKKWxH3XOZ3bdXEtbVJ7PrXePZ0oUkDFrqk1uLgLKqYuei/xZkWNngwDKwBMjo7+94ggKWY+VNH9HN9xTxEL2xpNbHoyODchzMl57+yqp6lSvgpLxj8l+X0x8Z+lviKaGXSY6PXtRsGVHuEcHqaGFBHVnT64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ck7xqolI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ck7xqolI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6F0C4CED6;
	Mon, 24 Feb 2025 14:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408963;
	bh=AEjcHLvn2a++Q/X5sRQUcAUNoSoYDzPs1VPneOVYM70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ck7xqolIOPBRIsm44iw6UgXiwE/A0A5zF5bdbgWMHigycApFYGbVYrrP+Hn2sgT9Z
	 /F+UnDBu1Nyq7ffEUWWdYUdneLqbgcvBtD9ul11TAhFfb2tWNx6U2hu6tAuLkRnvQ4
	 rG35Rfvk7mNWPJ97pEF2ySKu/Grno+J7N6vwJ2ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <mrpre@163.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 055/138] bpf: Disable non stream socket for strparser
Date: Mon, 24 Feb 2025 15:34:45 +0100
Message-ID: <20250224142606.642901093@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <mrpre@163.com>

[ Upstream commit 5459cce6bf49e72ee29be21865869c2ac42419f5 ]

Currently, only TCP supports strparser, but sockmap doesn't intercept
non-TCP connections to attach strparser. For example, with UDP, although
the read/write handlers are replaced, strparser is not executed due to
the lack of a read_sock operation.

Furthermore, in udp_bpf_recvmsg(), it checks whether the psock has data,
and if not, it falls back to the native UDP read interface, making
UDP + strparser appear to read correctly. According to its commit history,
this behavior is unexpected.

Moreover, since UDP lacks the concept of streams, we intercept it directly.

Fixes: 1fa1fe8ff161 ("bpf, sockmap: Test shutdown() correctly exits epoll and recv()=0")
Signed-off-by: Jiayuan Chen <mrpre@163.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://patch.msgid.link/20250122100917.49845-4-mrpre@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock_map.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 2f1be9baad057..82a14f131d00c 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -303,7 +303,10 @@ static int sock_map_link(struct bpf_map *map, struct sock *sk)
 
 	write_lock_bh(&sk->sk_callback_lock);
 	if (stream_parser && stream_verdict && !psock->saved_data_ready) {
-		ret = sk_psock_init_strp(sk, psock);
+		if (sk_is_tcp(sk))
+			ret = sk_psock_init_strp(sk, psock);
+		else
+			ret = -EOPNOTSUPP;
 		if (ret) {
 			write_unlock_bh(&sk->sk_callback_lock);
 			sk_psock_put(sk, psock);
-- 
2.39.5



