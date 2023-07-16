Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AF98F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:53:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA1DC433C7;
	Sun, 16 Jul 2023 20:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540832;
	bh=p7am9TTNBXF8qb27S43SSilCFqt3kUBNuGHheqgk9Pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cKIBc0TKZipLZh26M56IMybOUTbhU+QjSLNz/DC7qfhssmqddBqrHn6Mmc+EgJcA8
	 pThq5nb7PS/X6KoWvZ9OtLt1CIIq+LdwsYLN3yQbnLjABtY82uzVl7MxQMrMiEYfBU
	 PL8IUf3MYWK5JFPd9Wk/AfXMHNr/nrVAwTyb+paU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 504/591] xsk: Honor SO_BINDTODEVICE on bind
Date: Sun, 16 Jul 2023 21:50:43 +0200
Message-ID: <20230716194936.930008087@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ilya Maximets <i.maximets@ovn.org>

[ Upstream commit f7306acec9aae9893d15e745c8791124d42ab10a ]

Initial creation of an AF_XDP socket requires CAP_NET_RAW capability. A
privileged process might create the socket and pass it to a non-privileged
process for later use. However, that process will be able to bind the socket
to any network interface. Even though it will not be able to receive any
traffic without modification of the BPF map, the situation is not ideal.

Sockets already have a mechanism that can be used to restrict what interface
they can be attached to. That is SO_BINDTODEVICE.

To change the SO_BINDTODEVICE binding the process will need CAP_NET_RAW.

Make xsk_bind() honor the SO_BINDTODEVICE in order to allow safer workflow
when non-privileged process is using AF_XDP.

The intended workflow is following:

  1. First process creates a bare socket with socket(AF_XDP, ...).
  2. First process loads the XSK program to the interface.
  3. First process adds the socket fd to a BPF map.
  4. First process ties socket fd to a particular interface using
     SO_BINDTODEVICE.
  5. First process sends socket fd to a second process.
  6. Second process allocates UMEM.
  7. Second process binds socket to the interface with bind(...).
  8. Second process sends/receives the traffic.

All the steps above are possible today if the first process is privileged
and the second one has sufficient RLIMIT_MEMLOCK and no capabilities.
However, the second process will be able to bind the socket to any interface
it wants on step 7 and send traffic from it. With the proposed change, the
second process will be able to bind the socket only to a specific interface
chosen by the first process at step 4.

Fixes: 965a99098443 ("xsk: add support for bind for Rx")
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Link: https://lore.kernel.org/bpf/20230703175329.3259672-1-i.maximets@ovn.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/af_xdp.rst | 9 +++++++++
 net/xdp/xsk.c                       | 5 +++++
 2 files changed, 14 insertions(+)

diff --git a/Documentation/networking/af_xdp.rst b/Documentation/networking/af_xdp.rst
index 60b217b436be6..5b77b9e5ac7e6 100644
--- a/Documentation/networking/af_xdp.rst
+++ b/Documentation/networking/af_xdp.rst
@@ -433,6 +433,15 @@ start N bytes into the buffer leaving the first N bytes for the
 application to use. The final option is the flags field, but it will
 be dealt with in separate sections for each UMEM flag.
 
+SO_BINDTODEVICE setsockopt
+--------------------------
+
+This is a generic SOL_SOCKET option that can be used to tie AF_XDP
+socket to a particular network interface.  It is useful when a socket
+is created by a privileged process and passed to a non-privileged one.
+Once the option is set, kernel will refuse attempts to bind that socket
+to a different interface.  Updating the value requires CAP_NET_RAW.
+
 XDP_STATISTICS getsockopt
 -------------------------
 
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 13f62d2402e71..371d269d22fa0 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -886,6 +886,7 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 	struct sock *sk = sock->sk;
 	struct xdp_sock *xs = xdp_sk(sk);
 	struct net_device *dev;
+	int bound_dev_if;
 	u32 flags, qid;
 	int err = 0;
 
@@ -899,6 +900,10 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 		      XDP_USE_NEED_WAKEUP))
 		return -EINVAL;
 
+	bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
+	if (bound_dev_if && bound_dev_if != sxdp->sxdp_ifindex)
+		return -EINVAL;
+
 	rtnl_lock();
 	mutex_lock(&xs->mutex);
 	if (xs->state != XSK_READY) {
-- 
2.39.2



