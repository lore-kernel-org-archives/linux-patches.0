Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE0C2E3AF9;
	Tue, 15 Jul 2025 13:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585880; cv=none; b=e7FraSYetIMYQNGcdhIsDXonXRw5avYEAJ3lsc0YwpZZRS8y4dL7kV6AniiIvA0IejpVPa1JKf8CxKYU4JrUnfuybFf265tYu3Y5kJkwsJIhMvLFgOUXwSbRClbXkKCluzSZ4IYBiCAp9ml2B4hMraq+YtmPGXfKZIpqLZMZcxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585880; c=relaxed/simple;
	bh=cEJgvMiUzXVtoJnDBZZsuB40cgX3M/O4aBVqCGWag7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EbmP02zEssAe6YCja9mJLEQ17LYzlXn+ucTp2QESxoXmZ2FIAPNRo4DZk04sDWwHvg2IC226xeQfB62a3d9fKh7vRyGd6VPWJG9+VnbiZAaqBe5YD1wZQeXBV4c9y40ERGKOC5cDfHSoPtXheZmulBrdEK+gDqDcX2/ECB1D5VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VvjK7iH4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VvjK7iH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32DB9C4CEE3;
	Tue, 15 Jul 2025 13:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585880;
	bh=cEJgvMiUzXVtoJnDBZZsuB40cgX3M/O4aBVqCGWag7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VvjK7iH4H+7ZWuX/0xJia3nouq66XZFFZ5ZHYx01/OlY3Id5gp+w3w8oK/AeSpNws
	 /xw6dfpiz01Wq+peOEx/yqoZntYWuvGYmLHS00ChzOla2TW6mGgQ2tbXec6Dx/0WLu
	 MhlNYt9ewmo8BA0copit8ZL7+CdmhYOUIJ+gswUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/109] vsock: fix `vsock_proto` declaration
Date: Tue, 15 Jul 2025 15:12:28 +0200
Message-ID: <20250715130759.372770819@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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
index f8b09a82f62e1..1820b87b8b7ff 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -236,8 +236,8 @@ int __vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
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



