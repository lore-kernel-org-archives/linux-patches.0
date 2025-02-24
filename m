Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65612837B;
	Mon, 24 Feb 2025 14:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408550; cv=none; b=WSPmIZijAhw332R7RDe/asG8zAEBGM3EK83AuIUBqr88iS3kBrlR7eihMxUf22f7dLJt5kXZm56DK0+77E0t6l5f2JGc868dSCIxsYGKb4Zs695LXipyEk5FK6FaHrSliF0/GBiMf2ueCK2o+NDKMEGFyRbKwsW2tQsvJOj5ikA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408550; c=relaxed/simple;
	bh=+ahInQ8gESVwu7aN+CcauTExKgH//qjHQjP65ypRrsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q5bZW0XOLBIM/QzQvI+iKKZz12SZcGVzIYGMGQcImejdKBygRiiN5IErv9zbxX+nxO30SBABC4rnju5GH+LqMLPW9ztgmxZf4BbXeCt61r73cK5K48vMd3WAxDVjnSwKc/Y7GEkR8nKt3lqJmalt9UrGwpo32GMtG2clP4nzXac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mvu/gxKt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mvu/gxKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21768C4CED6;
	Mon, 24 Feb 2025 14:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408550;
	bh=+ahInQ8gESVwu7aN+CcauTExKgH//qjHQjP65ypRrsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mvu/gxKtgj/ZVqgPMK+oI8Fl84K9cnSBPCtJrAmU4HZMcjuMq1zx14UMN9tWjRJ0D
	 9FlW0R3uvsQNU2zK/5WdF8UANWF1RbyDqVomp0ziPHgzkrfP9G4Z9PNX22lzBJ11e7
	 JqS+eup5RLJ977qFS5PTbhdGEGj3TdMA6uBcciiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 059/154] sockmap, vsock: For connectible sockets allow only connected
Date: Mon, 24 Feb 2025 15:34:18 +0100
Message-ID: <20250224142609.396430849@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit 8fb5bb169d17cdd12c2dcc2e96830ed487d77a0f ]

sockmap expects all vsocks to have a transport assigned, which is expressed
in vsock_proto::psock_update_sk_prot(). However, there is an edge case
where an unconnected (connectible) socket may lose its previously assigned
transport. This is handled with a NULL check in the vsock/BPF recv path.

Another design detail is that listening vsocks are not supposed to have any
transport assigned at all. Which implies they are not supported by the
sockmap. But this is complicated by the fact that a socket, before
switching to TCP_LISTEN, may have had some transport assigned during a
failed connect() attempt. Hence, we may end up with a listening vsock in a
sockmap, which blows up quickly:

KASAN: null-ptr-deref in range [0x0000000000000120-0x0000000000000127]
CPU: 7 UID: 0 PID: 56 Comm: kworker/7:0 Not tainted 6.14.0-rc1+
Workqueue: vsock-loopback vsock_loopback_work
RIP: 0010:vsock_read_skb+0x4b/0x90
Call Trace:
 sk_psock_verdict_data_ready+0xa4/0x2e0
 virtio_transport_recv_pkt+0x1ca8/0x2acc
 vsock_loopback_work+0x27d/0x3f0
 process_one_work+0x846/0x1420
 worker_thread+0x5b3/0xf80
 kthread+0x35a/0x700
 ret_from_fork+0x2d/0x70
 ret_from_fork_asm+0x1a/0x30

For connectible sockets, instead of relying solely on the state of
vsk->transport, tell sockmap to only allow those representing established
connections. This aligns with the behaviour for AF_INET and AF_UNIX.

Fixes: 634f1a7110b4 ("vsock: support sockmap")
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Acked-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock_map.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index f1b9b3958792c..2f1be9baad057 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -541,6 +541,9 @@ static bool sock_map_sk_state_allowed(const struct sock *sk)
 		return (1 << sk->sk_state) & (TCPF_ESTABLISHED | TCPF_LISTEN);
 	if (sk_is_stream_unix(sk))
 		return (1 << sk->sk_state) & TCPF_ESTABLISHED;
+	if (sk_is_vsock(sk) &&
+	    (sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET))
+		return (1 << sk->sk_state) & TCPF_ESTABLISHED;
 	return true;
 }
 
-- 
2.39.5



