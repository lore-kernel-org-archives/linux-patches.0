Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C171F55ED;
	Tue, 21 Jan 2025 17:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482134; cv=none; b=hgrPHF47k14gajBVq1yQ5zwz93cjP5bRjz2x5z/ReHW9n+xof3DvQF2u519SDqnw4zx3Ph1/Dxt7nNg1DxJ7a+RhjJyM/Qfjod3gb8M8tYz9fuZDjt/iT1qyBkKkObLzrf35yUfi1zSz8rmNlZUKIycyv5DSjHHXuRCeRjqrq+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482134; c=relaxed/simple;
	bh=rxf7ZTS0zaTnLeS36J72oj9h57rnlBLwwxLVIpTMfxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lp9KYWypXjP2c+jHm//wAdPMoUg9XqTO1ZBezyi2a1MzXg+8DVNNaKjeTFeVdy9gzbCHFyXcisW4RE/qfj4b79b7d83vRFz5QWR83UphKs4/inGJUHZVaoFgiGPegA/esaL79wHUxThQeSLCGIVRQ59gbXM5G+egV7j77UhKrSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EuX24wfZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EuX24wfZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2727BC4CEDF;
	Tue, 21 Jan 2025 17:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482134;
	bh=rxf7ZTS0zaTnLeS36J72oj9h57rnlBLwwxLVIpTMfxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EuX24wfZo+c2lEHZSRR4j3QiWMhl1llLD5yt9qQ79GgLnxQ+LOIYRX6tSInKNQFQo
	 qzUDOWnHyOvk30dZZiA/XZkkQGi/rGm30Kn7A3Xxh3Lb0W3kdynHW6Z0CCxvXYf0Hq
	 ktElC8yq9m2GWuX1NTYQOElr4L7Chl2lAqEZTCt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	syzbot+3affdbfc986ecd9200fd@syzkaller.appspotmail.com,
	Hyunwoo Kim <v4bel@theori.io>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 45/72] vsock/bpf: return early if transport is not assigned
Date: Tue, 21 Jan 2025 18:52:11 +0100
Message-ID: <20250121174525.158011882@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
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

commit f6abafcd32f9cfc4b1a2f820ecea70773e26d423 upstream.

Some of the core functions can only be called if the transport
has been assigned.

As Michal reported, a socket might have the transport at NULL,
for example after a failed connect(), causing the following trace:

    BUG: kernel NULL pointer dereference, address: 00000000000000a0
    #PF: supervisor read access in kernel mode
    #PF: error_code(0x0000) - not-present page
    PGD 12faf8067 P4D 12faf8067 PUD 113670067 PMD 0
    Oops: Oops: 0000 [#1] PREEMPT SMP NOPTI
    CPU: 15 UID: 0 PID: 1198 Comm: a.out Not tainted 6.13.0-rc2+
    RIP: 0010:vsock_connectible_has_data+0x1f/0x40
    Call Trace:
     vsock_bpf_recvmsg+0xca/0x5e0
     sock_recvmsg+0xb9/0xc0
     __sys_recvfrom+0xb3/0x130
     __x64_sys_recvfrom+0x20/0x30
     do_syscall_64+0x93/0x180
     entry_SYSCALL_64_after_hwframe+0x76/0x7e

So we need to check the `vsk->transport` in vsock_bpf_recvmsg(),
especially for connected sockets (stream/seqpacket) as we already
do in __vsock_connectible_recvmsg().

Fixes: 634f1a7110b4 ("vsock: support sockmap")
Cc: stable@vger.kernel.org
Reported-by: Michal Luczaj <mhal@rbox.co>
Closes: https://lore.kernel.org/netdev/5ca20d4c-1017-49c2-9516-f6f75fd331e9@rbox.co/
Tested-by: Michal Luczaj <mhal@rbox.co>
Reported-by: syzbot+3affdbfc986ecd9200fd@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/677f84a8.050a0220.25a300.01b3.GAE@google.com/
Tested-by: syzbot+3affdbfc986ecd9200fd@syzkaller.appspotmail.com
Reviewed-by: Hyunwoo Kim <v4bel@theori.io>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Luigi Leonardi <leonardi@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/vsock_bpf.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/vmw_vsock/vsock_bpf.c b/net/vmw_vsock/vsock_bpf.c
index 4aa6e74ec295..f201d9eca1df 100644
--- a/net/vmw_vsock/vsock_bpf.c
+++ b/net/vmw_vsock/vsock_bpf.c
@@ -77,6 +77,7 @@ static int vsock_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
 			     size_t len, int flags, int *addr_len)
 {
 	struct sk_psock *psock;
+	struct vsock_sock *vsk;
 	int copied;
 
 	psock = sk_psock_get(sk);
@@ -84,6 +85,13 @@ static int vsock_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
 		return __vsock_recvmsg(sk, msg, len, flags);
 
 	lock_sock(sk);
+	vsk = vsock_sk(sk);
+
+	if (!vsk->transport) {
+		copied = -ENODEV;
+		goto out;
+	}
+
 	if (vsock_has_data(sk, psock) && sk_psock_queue_empty(psock)) {
 		release_sock(sk);
 		sk_psock_put(sk, psock);
@@ -108,6 +116,7 @@ static int vsock_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
 		copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
 	}
 
+out:
 	release_sock(sk);
 	sk_psock_put(sk, psock);
 
-- 
2.48.1



