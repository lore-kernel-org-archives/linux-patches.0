Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8222BF012;
	Tue, 22 Jul 2025 14:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193536; cv=none; b=ZDsNmDxaX1fGmfmTQL9CIaSyDXnuUl+hVqZMFeb374slk33h8+WbUDwQJGJAD3TVRfB5gVQlh7V8qYwDvlWiHXdayz2oxThyCbfhUHCpfqC454NURtvgWCmDRd+OD4RGhRlpV9eRVIbxQnAKYsPMTfGMmuFwfAcajVf7DPz+m6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193536; c=relaxed/simple;
	bh=gKHDyxkDhCi99UUgujlro/c+mxlAI1Q+Ug5snpT5+w0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iUWUTjmF52onhNH8D03vTe78VF1SLefan/VfPRYm5EWeB9WQbTIvO2wxLsIjg5MZlH7k8HvelW3SHsAAc/m2c6x14gq3MMBVVfg6oTyNSyeo8vxmEqiL6oL7ePspNshxufhm6ruR+3Hlpw5NV9ERnQJlmaZFwlGKy9TNXumJBbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nu64Hb9z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nu64Hb9z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B885C4CEEB;
	Tue, 22 Jul 2025 14:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193536;
	bh=gKHDyxkDhCi99UUgujlro/c+mxlAI1Q+Ug5snpT5+w0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nu64Hb9z4uUbUxK9t1G4saCaQVvVkXEKTb2n8Fwq33ZzUMnyHmwp+QGalZvbacJbp
	 uD9AOABKgM+YoT6yoVtcebvx7//yjQ3P0DeVcUOFHIqlIANB5iLIRhOfHydiFKkdnW
	 mO0mI1z5viskrQ8oza7lpiDa0KFuWyrUOgl/xnIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 122/187] nvmet-tcp: fix callback lock for TLS handshake
Date: Tue, 22 Jul 2025 15:44:52 +0200
Message-ID: <20250722134350.295701376@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 12a5cb8641ca3..de70ff9102538 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1967,10 +1967,10 @@ static void nvmet_tcp_alloc_queue(struct nvmet_tcp_port *port,
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



