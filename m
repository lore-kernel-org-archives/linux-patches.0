Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401CA4DEC05;
	Thu, 17 Sep 2026 18:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668073; cv=none; b=nzihx3oWWWgO24Rg7ZPTt9MQLoPSNCryas1mEw70zPXUlYaFtNK/fpODFE5Gi3ztglwxkrGXnUPnC2DhCeWbarKnY1Hb3rWm0hlduq8SmLUlG7yPoKM48xxz/v2pXu/ez1RYbCMhE2esltrJfMFK6tWXziG8eV6fFLkzyo1YWug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668073; c=relaxed/simple;
	bh=j78VFiWTovpPNB/rofQQ9r4JvMyOi1dT6GYm69ar86U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LTzL+7j8RXMHyl3pmvZlQiC7AVmp/o2ART5iImmRAR50hNrGrGWEp8DuiQwnbjyPHjKckURpMt8C8KhosaMXV+DvIbEPytwZQkKBOwDmCFcoqbJZ9WoBe1BW2NihLPwLvwsDD+w2artRuKC22BWcLBxj30yt2Ocr6OHqxNuF5Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IVbMFla/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IVbMFla/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93CC91F000FF;
	Thu, 17 Sep 2026 18:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668072;
	bh=Qb0K4wQR3oPrPPUONQO5FF1qVrJGIJDXi2UyCwYo+XU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IVbMFla/y8vYj9d0WXgISUDlVmqo9T8GMRv5ep6s9Q9OYoNou/CxODEcmOzfFWCNu
	 XOjR6zB8miCLjA/FpwqXIKiI2Gzk+aX29WUmU7hGlm5dbDJWTNihZXqD4zGjfjy7Rk
	 85Ztw+vhF4z9kRi/vZHF55SGEY4FERjH+ME4ogwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Raf Dickson <rafdog35@gmail.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0304/1102] vsock: use sk_acceptq_is_full() helper in all transports
Date: Thu, 17 Sep 2026 16:04:07 +0100
Message-ID: <20260917151547.252799981@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 865e004ee286f..c73793615f706 100644
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



