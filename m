Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E762E5187E5;
	Thu, 17 Sep 2026 17:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664551; cv=none; b=I1OPqoLcNyapIVwO9gfldNNWDCkugDNN+MuAuSu8NdXy44RqkmTdWdiGJ8Zx1q2L7Nu3I71e/NL4l+Ux5hCbA4ASG8Hg7JXs13ZNMrTpVye5hJDG0ifsDxXn6kvRlEk0T1dzzlFl2cF2eljiNxZ0vueDECADw4MBm4Q0twK3bf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664551; c=relaxed/simple;
	bh=yp+EtWmBUWqqU3sVWg79pMKtURQufcICVIxwUgfAJWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cs/ycFs+zc8yOz7Ze8xiSrcxAmo7s0cVakXzZXLP73o3Vwj2ODloh6hsGfG5brwSmeyNm7R5bs53EX//DkKde7jToqSbh706d2tuYI1FLq6XUQ2nSo6ydj33ZQqhyq6VjQOlcBFdurA5jit4QMknYcjGkExW/v0itpziY4CaBIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iU9EaOpz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iU9EaOpz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124521F000FF;
	Thu, 17 Sep 2026 17:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664549;
	bh=WcvCwbvcWxkuBmsCkOJj22dy7L6ar+1QfRF3lAF6azE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iU9EaOpzwQV8x2GoCOWmPR6ThW7SNmMLN25pD3klB0wPYiOg/3ykfATtBhIbjZpUg
	 LwYJOlYRPTCmv8z0vx5IFtuAslERoiiEH6ARrP+O4MlXrcoUbjTH0v4TmipWdNI4fB
	 bmdy8nIwqKgPh1wpykZJ3Wz20n8//3wyEKa2VF9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Raf Dickson <rafdog35@gmail.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0409/1250] vsock: use sk_acceptq_is_full() helper in all transports
Date: Thu, 17 Sep 2026 16:03:24 +0100
Message-ID: <20260917151603.111085090@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raf Dickson <rafdog35@gmail.com>

[ Upstream commit 4ff2e84ff1b33d79fa0e3ae355ce4a334908ef9a ]

Replace the open-coded backlog check with sk_acceptq_is_full().
The helper uses > instead of >=, which is the correct comparison
per commit 64a146513f8f ("[NET]: Revert incorrect accept queue
backlog changes."), and adds READ_ONCE() for proper memory ordering.

Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Raf Dickson <rafdog35@gmail.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Luigi Leonardi <leonardi@redhat.com>
Link: https://patch.msgid.link/20260612045842.122207-1-rafdog35@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/hyperv_transport.c | 2 +-
 net/vmw_vsock/vmci_transport.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index 4da752b47b116..54c7f51f9145d 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -323,7 +323,7 @@ static void hvs_open_connection(struct vmbus_channel *chan)
 		goto out;
 
 	if (conn_from_host) {
-		if (sk->sk_ack_backlog >= sk->sk_max_ack_backlog)
+		if (sk_acceptq_is_full(sk))
 			goto out;
 
 		new = vsock_create_connected(sk);
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index 75bf643ff6faf..4f02a6f269cdb 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -1002,7 +1002,7 @@ static int vmci_transport_recv_listen(struct sock *sk,
 	 * reset.  Otherwise we create and initialize a child socket and reply
 	 * with a connection negotiation.
 	 */
-	if (sk->sk_ack_backlog >= sk->sk_max_ack_backlog) {
+	if (sk_acceptq_is_full(sk)) {
 		vmci_transport_reply_reset(pkt);
 		return -ECONNREFUSED;
 	}
-- 
2.53.0



