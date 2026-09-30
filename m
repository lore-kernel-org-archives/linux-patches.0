Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C45A502554;
	Wed, 30 Sep 2026 15:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782673; cv=none; b=djAz0lCs2eZjzQbyJQPwpxh0OcWdVCcfZZvUqlJXs3iqd+zUzJsYR1Zg8YxiGe4wmbkApLaWNzE4EoXgeAvH3mOrAM95mv0ICisPuuUWKdfuMM0Buc4vxo3iIax7qpIAcydZh8l7k9PnvZOHMdKmvJkgQHXWVjfz/yUNzir6DcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782673; c=relaxed/simple;
	bh=pXaR+pXxigscULlfbD0CFr8Pj/xPbXxKSMkpdylfb+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvmU+95VRtjyyRpiIlS0iGQ+wB+xHPzQVh/wrZvFezwiwaBQyqHfyUt6sgOawm0rLodIbmQ/AP9Z4Gglfx8uE2KGtMxdGRxabcPMcBfaZCdkm8RHNiYM4Y04ZYmoXy78sLTDtLmoFKcUanxAfvgbTk+1Gj4tJH7LY/3rEaft+d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E0ehtTEV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E0ehtTEV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A631F00898;
	Wed, 30 Sep 2026 15:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782660;
	bh=M8Lbropj7gG2ll2A7wnTP/kJgPhBSWpvHaKDRazHsbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E0ehtTEVW+Gl1Vf/+ACVimZTCekhQLrNIYdOqpIdCf6uzL+shGa+ClgMXCVKw0jL0
	 Kj2+jiMMh7oHZPSexsS4MSH6kpTHC0mO2p2+z18XESBFzdsVeQodj5yLLVo1gCdOVV
	 2x1GypBGF1AR6sbQ7FL+4RB92PdiYkvFabwlAAOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Raf Dickson <rafdog35@gmail.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 126/595] vsock: use sk_acceptq_is_full() helper in all transports
Date: Wed, 30 Sep 2026 17:20:19 +0200
Message-ID: <20260930152350.449087366@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 974a33015f37c..f0c6291d39243 100644
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
index aa6f2a1429666..4085163bb92dd 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -1004,7 +1004,7 @@ static int vmci_transport_recv_listen(struct sock *sk,
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



