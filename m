Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7D64CEE6B;
	Wed, 30 Sep 2026 16:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784544; cv=none; b=TDs3MDOVgBWkrOK+0S3DNluRb8H2iJtHgZD6Y8LpJSaW+87R9pVRCeTvDVfqV98CmkdlBsiDA02eReY3D67o5Gq7lSpNjnMEitsZUl+8kd+TlOIMJJeqpmLThQRRj8H5CjJitdT7bY/Z9q4cuPmbx6t2ArB9DQx27E5mI6NFsqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784544; c=relaxed/simple;
	bh=07h1Fs/eXHoOPkWBoi2YSIChij6kxFkBS6sjnlL6qf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXMG6urBo42x1pdUKLEYbBZvkTQJdXgeMhw/Eh8cUjUnSvrRrgCvxpKDChThLozyii3t38LLZfcr0mjls1sisMl2AEq6NByPif6OmAZhhg9chD/tF6jE9tOcGSIMy34/vbfJUrMepd2qd7UZH/uHCHBcsK26AgtE+fJUOJn7BRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XimCYFJL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XimCYFJL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438811F00893;
	Wed, 30 Sep 2026 16:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784538;
	bh=h/ik29czE/OnykwvAev1nuEFbK3CHyX587uzdCRFkbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XimCYFJLqyIBRXgvWL/9C32uqW0vAJlFPosXkHua1R2gRUzWTdb+hyEdl4p5DBnu9
	 vaqjT4cZfE1mUolgIQ8jBulwkMtSCPtoy0i7pq4K6DwDvMDVLtVEVYOhE1b3HCV1pN
	 tiWWwidVzC9oJAni+11rNZMAqHFFxdGxM3MOTJ1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Raf Dickson <rafdog35@gmail.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 191/982] vsock: use sk_acceptq_is_full() helper in all transports
Date: Wed, 30 Sep 2026 17:15:27 +0200
Message-ID: <20260930152420.918426900@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index cf8a2194a37f7..66dd3ded053fe 100644
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
index 6217c3122a074..ff3602d45de92 100644
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



