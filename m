Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C48EAD0;
	Fri, 15 Nov 2024 06:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653456; cv=none; b=Fm9jDS3lBsLb7LR18dibEJrZz+fTExyELycaCNxBsXHC/WFq8paE59eMaX3PXr87/h0XKwRWWRAxeNq7sE7mzg9QSJHTVTKUY9V+4kBLCvBuIo1cqoEAWeiZ9BtSC2tea/Z3vID5M8DHw9a6UMP2OASU5CemPD5/Dv/IIzTaWfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653456; c=relaxed/simple;
	bh=OH9s0nE1c6A1SxaE95y/LOLiIZpIGoArpb8uZKBvyTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fF9XwwJ7HuUNAyBaVQoymEDuQlaNYKrXByH1mKMos6OS6YqJKDBTbcWVmzhX99RnyAIzpjloJWLMy8D2uRqrCNdWTT5myEdYYVlGjRN55riwRfi+txErKo2hPrfs+yiz6bUhykVwL4Dq3S5Z0XRNmJYJokMsvtCwugJqW0eNs+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LdUszVP5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LdUszVP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D37C4CECF;
	Fri, 15 Nov 2024 06:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653456;
	bh=OH9s0nE1c6A1SxaE95y/LOLiIZpIGoArpb8uZKBvyTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LdUszVP5jP1CMHY99CH4C4A4IsT5oO+FSzqxAWQgawDlpV4cbJNYyQQ7PRZw1OYgL
	 T5jgvXRLb7WUT4lCjBDT/QL0J3w2VPnno3h2euRodyiDNUb1ojA07qS6/MzaQEdDPt
	 xbpWQKhYI3RKQ1Ylm+bFyJMpJC5clGa7aX34fBOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijian Zhang <zijianzhang@bytedance.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Cong Wang <cong.wang@bytedance.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 27/48] bpf: Add sk_is_inet and IS_ICSK check in tls_sw_has_ctx_tx/rx
Date: Fri, 15 Nov 2024 07:38:16 +0100
Message-ID: <20241115063723.944077949@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
References: <20241115063722.962047137@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Zijian Zhang <zijianzhang@bytedance.com>

[ Upstream commit 44d0469f79bd3d0b3433732877358df7dc6b17b1 ]

As the introduction of the support for vsock and unix sockets in sockmap,
tls_sw_has_ctx_tx/rx cannot presume the socket passed in must be IS_ICSK.
vsock and af_unix sockets have vsock_sock and unix_sock instead of
inet_connection_sock. For these sockets, tls_get_ctx may return an invalid
pointer and cause page fault in function tls_sw_ctx_rx.

BUG: unable to handle page fault for address: 0000000000040030
Workqueue: vsock-loopback vsock_loopback_work
RIP: 0010:sk_psock_strp_data_ready+0x23/0x60
Call Trace:
 ? __die+0x81/0xc3
 ? no_context+0x194/0x350
 ? do_page_fault+0x30/0x110
 ? async_page_fault+0x3e/0x50
 ? sk_psock_strp_data_ready+0x23/0x60
 virtio_transport_recv_pkt+0x750/0x800
 ? update_load_avg+0x7e/0x620
 vsock_loopback_work+0xd0/0x100
 process_one_work+0x1a7/0x360
 worker_thread+0x30/0x390
 ? create_worker+0x1a0/0x1a0
 kthread+0x112/0x130
 ? __kthread_cancel_work+0x40/0x40
 ret_from_fork+0x1f/0x40

v2:
  - Add IS_ICSK check
v3:
  - Update the commits in Fixes

Fixes: 634f1a7110b4 ("vsock: support sockmap")
Fixes: 94531cfcbe79 ("af_unix: Add unix_stream_proto for sockmap")
Signed-off-by: Zijian Zhang <zijianzhang@bytedance.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Acked-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lore.kernel.org/r/20241106003742.399240-1-zijianzhang@bytedance.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tls.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 2ad28545b15f0..6c642ea180504 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -395,8 +395,12 @@ tls_offload_ctx_tx(const struct tls_context *tls_ctx)
 
 static inline bool tls_sw_has_ctx_tx(const struct sock *sk)
 {
-	struct tls_context *ctx = tls_get_ctx(sk);
+	struct tls_context *ctx;
+
+	if (!sk_is_inet(sk) || !inet_test_bit(IS_ICSK, sk))
+		return false;
 
+	ctx = tls_get_ctx(sk);
 	if (!ctx)
 		return false;
 	return !!tls_sw_ctx_tx(ctx);
@@ -404,8 +408,12 @@ static inline bool tls_sw_has_ctx_tx(const struct sock *sk)
 
 static inline bool tls_sw_has_ctx_rx(const struct sock *sk)
 {
-	struct tls_context *ctx = tls_get_ctx(sk);
+	struct tls_context *ctx;
+
+	if (!sk_is_inet(sk) || !inet_test_bit(IS_ICSK, sk))
+		return false;
 
+	ctx = tls_get_ctx(sk);
 	if (!ctx)
 		return false;
 	return !!tls_sw_ctx_rx(ctx);
-- 
2.43.0



