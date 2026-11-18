Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040124;
	b=XMffHhpK6INyObu13NQRJdSCJKrGs02kP8CojGHgpmIcXQZUCYCeG55QCR2AN2gMk9Ig
	 BKbE67di1HnxO7ceUBpgETd7Lv6rju5Dg7GfCJ1ALgpcJrapgNVif8m6hfOICFz6Dz75b
	 fiLGCAM9IQaD9CvZdJFwkisBSuLQABVag5gUcGBU36EVWD0if/sndAXGYqyUDHxhEdbp1
	 UKCdmsTtL0OdHDb1kIQGLhLU3Wu/b8FzUEFrZ2Wq5cQJ9RJJtci3F1yTqRLTcoDnVj78M
	 8pNoxR1jFaNtDliI+KGLzoGHwqydT1xb0Qa+QH8+iqIX2FE+4zrCSTy2pk6uZxK5S0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040124;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8+IdeluatVwNSeJp+zSMgUYMdyGAJUg3VSg4siifI7Q=;
	b=MmwvhETHkGyGHibMq7J1FjQP3nP/BYfn9zyonYxHL65Hu3ylIYzQDtown9dzh5bJVj30
	 0L3P7ZR757teZmPue1dNtDpn4W4NeiN/WD2tccvHCLJ77Qa2e9G76hExQ0WUMDXlsFZZG
	 R2Of4IrYIf4vf9GGOocXtePnj2KZHFck17S4wYKXjapg74QZh6IfaQQpkNfbqBvBubGeM
	 cnsdF+n45PVR3BmlJ1uYBizKMSOMhFls74RelwIpK3B6fyyWzq88bJvFJedRV5M8qU2u1
	 d2gCxzR2CsNABky0Ok/3V3zYjij98ltwQEeESb3gfkGBjDR4b0RNApKCV9lfSKJ+8dQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WxszoCVb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7666606A32C;
	Wed, 18 Nov 2026 22:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WxszoCVb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F1B1F000C4;
	Wed, 18 Nov 2026 22:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040123;
	bh=8+IdeluatVwNSeJp+zSMgUYMdyGAJUg3VSg4siifI7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WxszoCVb7tWfk56zrP/M1p+w3LikNC1hICSuY0kgH/mKs2st93R3WiATLVQEsuz2l
	 ermKkVBIUI6MXeHNuaGzqVv5CIRn1t24J3Vydqf5AkN67iW3EJrCepYdc+9MtTsMWC
	 ONn77RduskZ/bQ7YpG+lruwgih8/jXhJWA1j9r/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Prabhakar Pujeri <prabhakar.pujeri@dell.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2344/3318] NFS: use TCP for MOUNT when xprtsec= selects TLS
Date: Wed, 18 Nov 2026 15:49:26 +0100
Message-ID: <20261118150431.947637562@linuxfoundation.org>
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

From: Chuck Lever <cel@kernel.org>

[ Upstream commit 72233aabc78cd0415c850641bc2a6e4fea23173f ]

An NFSv2 or NFSv3 text mount that specifies xprtsec= but no
mountproto= crashes in nfs_init_timeout_values():

  RIP: 0010:nfs_init_timeout_values+0x10a/0x110 [nfs]
  Call Trace:
   nfs_mount+0x1c3/0x330 [nfs]
   nfs_try_get_tree+0x1e5/0x460 [nfs]
   nfs_get_tree+0x64d/0x6d0 [nfs]
   vfs_get_tree+0x2b/0xe0
   vfs_cmd_create+0x5f/0xd0
   vfs_fsconfig_locked+0x50/0x130
   __se_sys_fsconfig+0x2f9/0x3a0

nfs_validate_transport_protocol() sets nfs_server.protocol to
XPRT_TRANSPORT_TCP_TLS when xprtsec= is present, but the switch in
nfs_set_mount_transport_protocol() has no case for that value.
mount_server.protocol stays zero, and nfs_init_timeout_values()
calls BUG() on a transport it does not recognize.

mount.nfs always appends mountproto= after probing the server's
rpcbind, so only a caller that bypasses it, such as "mount -i" or a
program that drives fsconfig() directly, reaches the crash.

Select TCP for MOUNT when the NFS transport is XPRT_TRANSPORT_TCP_TLS.
nfs_mount() requests no transport security, so MOUNT already runs
over plain TCP whenever mount.nfs supplies mountproto=tcp.

Fixes: c8407f2e560c ("NFS: Add an "xprtsec=" NFS mount option")
Signed-off-by: Chuck Lever <cel@kernel.org>
Reviewed-by: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/fs_context.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/fs_context.c b/fs/nfs/fs_context.c
index 41126d6dcd760..649d27a9398e0 100644
--- a/fs/nfs/fs_context.c
+++ b/fs/nfs/fs_context.c
@@ -370,6 +370,7 @@ static void nfs_set_mount_transport_protocol(struct nfs_fs_context *ctx)
 		ctx->mount_server.protocol = XPRT_TRANSPORT_UDP;
 		break;
 	case XPRT_TRANSPORT_TCP:
+	case XPRT_TRANSPORT_TCP_TLS:
 	case XPRT_TRANSPORT_RDMA:
 		ctx->mount_server.protocol = XPRT_TRANSPORT_TCP;
 	}
-- 
2.53.0



