Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A650A32;
	Tue, 22 Jul 2025 14:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192957; cv=none; b=lfEJqirijVk+TVlxkmL0+yg1FTalx8Giq0itcpwuvF1hJKLvM//60JMvsCRlu9wJeghAplHVRqspBdiudSEa5cdaoe8FzkWzsx+N1jSnPAavNIbEbcT/E2ALSOTH05gZkSSEH/Yb9psEIYuXJm9yJRwI7czRrS6rTqpXyEHRtsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192957; c=relaxed/simple;
	bh=tCPsPIth+1pP8Ffb1gIh2Z8/6OYZL7F4g9MkOUQmimo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pa9ryhgVnJvgYX6NqPDc9kY0SeKpprthvJZaJ1x1gjS+saMupBT6T+yKwQc7tNc0DT2VRMgyZhWq7adJIa5zd3SNz83g2/A9cVnpFaCeAqYoEcAEpK8kv8nmqhYLRv0IA5UFz0sF00YM6LoTwNe67ppW01H7dkVNdVQkcexNeTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2qoapzou; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2qoapzou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F2BC4CEEB;
	Tue, 22 Jul 2025 14:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192956;
	bh=tCPsPIth+1pP8Ffb1gIh2Z8/6OYZL7F4g9MkOUQmimo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2qoapzouWOJRPazIoXeWGQHQ6lpNkdPpAxC2jKh5/hkOJWyQNuthVdRc3il73Cb8k
	 PQ/1MW6uI5n7F8qYh4VBHua8GS8Ut4LbFjXnml2IWJwi5ypCQKimPMuCav6872AZNk
	 Pmy2AldIEWVr8bRu49g6AlWsBq5BnoyOYwMzb2y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 101/158] nvmet-tcp: fix callback lock for TLS handshake
Date: Tue, 22 Jul 2025 15:44:45 +0200
Message-ID: <20250722134344.516045650@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 0523c6cc87e558c50ff4489c87c54c55068b1169 ]

When restoring the default socket callbacks during a TLS handshake, we
need to acquire a write lock on sk_callback_lock.  Previously, a read
lock was used, which is insufficient for modifying sk_user_data and
sk_data_ready.

Fixes: 675b453e0241 ("nvmet-tcp: enable TLS handshake upcall")
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 259ad77c03c50..6268b18d24569 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1941,10 +1941,10 @@ static void nvmet_tcp_alloc_queue(struct nvmet_tcp_port *port,
 		struct sock *sk = queue->sock->sk;
 
 		/* Restore the default callbacks before starting upcall */
-		read_lock_bh(&sk->sk_callback_lock);
+		write_lock_bh(&sk->sk_callback_lock);
 		sk->sk_user_data = NULL;
 		sk->sk_data_ready = port->data_ready;
-		read_unlock_bh(&sk->sk_callback_lock);
+		write_unlock_bh(&sk->sk_callback_lock);
 		if (!nvmet_tcp_try_peek_pdu(queue)) {
 			if (!nvmet_tcp_tls_handshake(queue))
 				return;
-- 
2.39.5



