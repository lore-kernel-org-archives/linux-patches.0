Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579F63212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:00:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0CE3C4339B;
	Tue,  7 Feb 2023 13:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675774857;
	bh=pUrUWxy+9VXbE/oU0nhgSd9iW/rNYHtePrIT8UMA+18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V7NyxpoGWFsaiikVRKSe1uGWK7VxS+H1MQFE7E0ryHN+kIX910vUGeC8niX6cZ23E
	 +FnOXvmE7bLCGhFZsnZCMjGtuf69tjNz/We30NWtQ/zHLZrpgxp2L7szvCudN2JXav
	 TIisRQrxPl2e966pxXKmyrFHVL0KIaY/VhFRCFnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kui-Feng Lee <kuifeng@meta.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/208] bpf: Fix the kernel crash caused by bpf_setsockopt().
Date: Tue,  7 Feb 2023 13:54:41 +0100
Message-Id: <20230207125635.528809195@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kui-Feng Lee <kuifeng@meta.com>

[ Upstream commit 5416c9aea8323583e8696f0500b6142dfae80821 ]

The kernel crash was caused by a BPF program attached to the
"lsm_cgroup/socket_sock_rcv_skb" hook, which performed a call to
`bpf_setsockopt()` in order to set the TCP_NODELAY flag as an
example. Flags like TCP_NODELAY can prompt the kernel to flush a
socket's outgoing queue, and this hook
"lsm_cgroup/socket_sock_rcv_skb" is frequently triggered by
softirqs. The issue was that in certain circumstances, when
`tcp_write_xmit()` was called to flush the queue, it would also allow
BH (bottom-half) to run. This could lead to our program attempting to
flush the same socket recursively, which caused a `skbuff` to be
unlinked twice.

`security_sock_rcv_skb()` is triggered by `tcp_filter()`. This occurs
before the sock ownership is checked in `tcp_v4_rcv()`. Consequently,
if a bpf program runs on `security_sock_rcv_skb()` while under softirq
conditions, it may not possess the lock needed for `bpf_setsockopt()`,
thus presenting an issue.

The patch fixes this issue by ensuring that a BPF program attached to
the "lsm_cgroup/socket_sock_rcv_skb" hook is not allowed to call
`bpf_setsockopt()`.

The differences from v1 are
 - changing commit log to explain holding the lock of the sock,
 - emphasizing that TCP_NODELAY is not the only flag, and
 - adding the fixes tag.

v1: https://lore.kernel.org/bpf/20230125000244.1109228-1-kuifeng@meta.com/

Signed-off-by: Kui-Feng Lee <kuifeng@meta.com>
Fixes: 9113d7e48e91 ("bpf: expose bpf_{g,s}etsockopt to lsm cgroup")
Link: https://lore.kernel.org/r/20230127001732.4162630-1-kuifeng@meta.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_lsm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index d6c9b3705f24..e6a76da4bca7 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -51,7 +51,6 @@ BTF_SET_END(bpf_lsm_current_hooks)
  */
 BTF_SET_START(bpf_lsm_locked_sockopt_hooks)
 #ifdef CONFIG_SECURITY_NETWORK
-BTF_ID(func, bpf_lsm_socket_sock_rcv_skb)
 BTF_ID(func, bpf_lsm_sock_graft)
 BTF_ID(func, bpf_lsm_inet_csk_clone)
 BTF_ID(func, bpf_lsm_inet_conn_established)
-- 
2.39.0



