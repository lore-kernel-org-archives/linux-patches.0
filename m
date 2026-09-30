Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E77522F17;
	Wed, 30 Sep 2026 17:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791001; cv=none; b=bVDCF8wLnvj1dqeEW8i9Nq76EwtUa5Qv+no+IKEmaE05uXDVJT1sEqQT9xALsYzIgwu2JKbkdWjdfeaXlvw4OKrsgZuBDhYMwMbCyYk7JLJo6i422aHKLAcYA7Wv2ZJ8tbk7gzBfNJL3xggqfh1A5UDPgi2WFjv4vOcCw5F4IQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791001; c=relaxed/simple;
	bh=RDTkamLgkbEqPf4V2LGCTGsylrzwGj1wWqfteM0CqzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VulNonEXeKHX5dPWLFlqvCK6GKUkpsOMJldHTntWKJhV71O3xc54SUthZssoNKe9AA0hVhhcvk3x2s365oWWaVG4fRAUoEa+kX9t4uTT7lmdO8wJcxEiIVDQqs/rNIANMV69Gu74/MA68XiaivlsF76KEK7hGJrhALFu2YTL6bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fEo14NMs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fEo14NMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0D71F000FF;
	Wed, 30 Sep 2026 17:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791000;
	bh=jMxmKhOnv7SH7KzN6+sWwdCE9WZ3kfCfTEPF3TS7wGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fEo14NMsGlbj9RJm91RhF5SZIFCg8atr11V1/T7TlzuLJ+rfiIX6mMDoW1mrrXrV8
	 H/ct3YmfkSJOtqf3uSC3LfuAXO0JGrPhooI/cfgklPMH8DdktXNjYoys1q2t5mKU2p
	 e0zse4+p2pOrp/MbZ/3s++TH8LsX2IjAYNpQvaLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Raf Dickson <rafdog35@gmail.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 149/752] vsock: use sk_acceptq_is_full() helper in all transports
Date: Wed, 30 Sep 2026 17:20:19 +0200
Message-ID: <20260930152401.410649443@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0dde20d8f8249..a60a26eaecaf5 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -314,7 +314,7 @@ static void hvs_open_connection(struct vmbus_channel *chan)
 		goto out;
 
 	if (conn_from_host) {
-		if (sk->sk_ack_backlog >= sk->sk_max_ack_backlog)
+		if (sk_acceptq_is_full(sk))
 			goto out;
 
 		new = vsock_create_connected(sk);
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index ac68f1afc44e1..936cd088160c9 100644
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



