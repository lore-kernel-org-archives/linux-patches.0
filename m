Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259322E49B3;
	Tue, 15 Jul 2025 13:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586820; cv=none; b=Y6uln6kk/mHqMN1nG8ZA+5jjJ0DKHwER3a4EKGDOIG86XKMgz60DxITaPwRvQUOMA382jvO0KPO3oNe8mA0k9uU4FYOT/UqiP5DmnAmf8uf2YDpS580w38eYlJfsEW5HeWpZJf73LoRCcd6J4s9HQw8YOeh1qMHbEHhXeZ+jLFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586820; c=relaxed/simple;
	bh=Mh339nMFlqfqIZPNLVVJ/yTbBIH+8urxHtQbVWKO6qE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jkT+Dv0n4RNBEP6DaNx8JXMkVkGKvjNpcFwUlEWe/ujHzxwjeO6ZqE7SE47HIjYK/5UT/x2S0N/YzxmJoKs2HnxTxJ0CnBLFwIH63SEMy4ssWOEBCwT6qp4vQhb4h48WG90jX+7RYxYN7cGu7+ZsXver36jnnL2IAPgAhvkBESc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c+0ugZ/I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c+0ugZ/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3032C4CEE3;
	Tue, 15 Jul 2025 13:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586820;
	bh=Mh339nMFlqfqIZPNLVVJ/yTbBIH+8urxHtQbVWKO6qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c+0ugZ/IjaAYoq6OdKYiQuuFz5pROBW9gqFz+98DNFZ419FBCJ2fouik3Uu3qRxvg
	 beXbRREDl4Ad4WRAM6PuNvkw8eK0Frl5WWcUfgrcCiPLE2H16pKpCRU37zLzDyvp0Z
	 tbHdSIAeQXtM4VoiPhQ9IDLvFmTIYMt36zhcSlVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 029/192] vsock: fix `vsock_proto` declaration
Date: Tue, 15 Jul 2025 15:12:04 +0200
Message-ID: <20250715130816.030028882@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit 1e3b66e326015f77bc4b36976bebeedc2ac0f588 ]

>From commit 634f1a7110b4 ("vsock: support sockmap"), `struct proto
vsock_proto`, defined in af_vsock.c, is not static anymore, since it's
used by vsock_bpf.c.

If CONFIG_BPF_SYSCALL is not defined, `make C=2` will print a warning:
    $ make O=build C=2 W=1 net/vmw_vsock/
      ...
      CC [M]  net/vmw_vsock/af_vsock.o
      CHECK   ../net/vmw_vsock/af_vsock.c
    ../net/vmw_vsock/af_vsock.c:123:14: warning: symbol 'vsock_proto' was not declared. Should it be static?

Declare `vsock_proto` regardless of CONFIG_BPF_SYSCALL, since it's defined
in af_vsock.c, which is built regardless of CONFIG_BPF_SYSCALL.

Fixes: 634f1a7110b4 ("vsock: support sockmap")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://patch.msgid.link/20250703112329.28365-1-sgarzare@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/af_vsock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 9e85424c83435..70302c92d329f 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -242,8 +242,8 @@ int __vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
 int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
 			size_t len, int flags);
 
-#ifdef CONFIG_BPF_SYSCALL
 extern struct proto vsock_proto;
+#ifdef CONFIG_BPF_SYSCALL
 int vsock_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore);
 void __init vsock_bpf_build_proto(void);
 #else
-- 
2.39.5



