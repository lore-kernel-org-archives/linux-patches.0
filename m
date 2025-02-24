Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FDD2192E8;
	Mon, 24 Feb 2025 14:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408191; cv=none; b=br4aZTJhlAtjNVUVfYmMYJXWY9z6GBr3lj01vFUHphTPLlsv7sRjiYjaqDENT/PDCXEj8oUE7xeeETp6SSaqQRI8peDN+Oj/eCtIwVpaeD14hZFkxgMcYI0GTjix0A+KCtEkDMwTWyZyjHMokbmjJdQRfxyn3vo3LG8DGmIQBo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408191; c=relaxed/simple;
	bh=zbrax0Tv0N6hSSUEJV5wgQwXRzcoN1zIz/6kX+VUuPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EtcFMmPXw6jI3RirWRoDetlvJDDWalXlQ353GptQKZZFtyiZvWCj4QPl83u6R0+SkvmR7eIzzmwbpe0p55Z7GPG/qL4kBCGWDCvd52OoAa1MOnv+DuLkfLh7Vt056K2Hao94xJEdUx7QovDpU8h0rj4m6OHFnNImXbuXFt/16+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=igOfmg9I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="igOfmg9I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959F7C4CED6;
	Mon, 24 Feb 2025 14:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408191;
	bh=zbrax0Tv0N6hSSUEJV5wgQwXRzcoN1zIz/6kX+VUuPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=igOfmg9INcyoseMUO2j/CuN6mxVV6PC99meFQoCfvU27E4xNu2sfcBcGuu/8c8vRu
	 wke3ExunLBI1nBOHDt3ncoHolBo/aIjwHpn9o0Ok6/V2Cn8XB+PmbV0Kz4Cx8gCn5G
	 dIsQiHIgcP4WV394tkdgGApmobezx62tABEYts7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <mrpre@163.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 099/140] bpf: Disable non stream socket for strparser
Date: Mon, 24 Feb 2025 15:34:58 +0100
Message-ID: <20250224142606.906731813@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index dcc0f31a17a8d..3a53b6a0e76e2 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -300,7 +300,10 @@ static int sock_map_link(struct bpf_map *map, struct sock *sk)
 
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



