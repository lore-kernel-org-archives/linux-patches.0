Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AABE279918;
	Tue, 21 Oct 2025 20:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077588; cv=none; b=fcIPnAcithpmpNe6MfFp8W0WLGi5ayy5X3adbu/37he52qdJJmpxfoYnZ2PDAQpSn3CVxKy2d30YI3BsckkLoCg3RwWOwrepHxF1dlyxEIahBSDfFkI7Wf2Tif00XPUY9KWF6Izbxcd798yAcRR/SALEtn0Mz4q4T09bMQzyuwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077588; c=relaxed/simple;
	bh=UMVs+srk+4DGryPDwutWcQDeEGfrKAYoap6EhX4JXzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NxFVrQsZETo3BBkoxIjEu0Z1NrUlV16GELQbwC6c1CfVR+ZjjE0IJKlC5Ss37KIb2xCBSqnexQTUpuz/PFbi2ujjSOMpBJLK8gS6yQ6JIb3WVZNdxYRueQOQLehJEte3wE7LZqr5TQjEKtcbmiSO/+EvFzQt2OzrV/v2Y1oyPPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vtjZiuUy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vtjZiuUy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C34C4CEF1;
	Tue, 21 Oct 2025 20:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077588;
	bh=UMVs+srk+4DGryPDwutWcQDeEGfrKAYoap6EhX4JXzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vtjZiuUymGfRaYAY4xy+TlSiOTqAoFJG2Qim/p1LhQ1e1s8gGVrC/atRcxq0bVGBg
	 +jF1zWFTJZpI67axg6kAR2O9A/BlmCxf8uD2SgpTytZFoTXxMeyyEBmvvIWHnLRsUy
	 v9ISslcFMNjeM6cJRWGUbkHhb0KtvifjuGF0nOFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Hannes Reinecke <hare@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 135/159] nvme/tcp: handle tls partially sent records in write_space()
Date: Tue, 21 Oct 2025 21:51:52 +0200
Message-ID: <20251021195046.393066189@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wilfred Mallawa <wilfred.mallawa@wdc.com>

[ Upstream commit 5a869d017793399fd1d2609ff27e900534173eb3 ]

With TLS enabled, records that are encrypted and appended to TLS TX
list can fail to see a retry if the underlying TCP socket is busy, for
example, hitting an EAGAIN from tcp_sendmsg_locked(). This is not known
to the NVMe TCP driver, as the TLS layer successfully generated a record.

Typically, the TLS write_space() callback would ensure such records are
retried, but in the NVMe TCP Host driver, write_space() invokes
nvme_tcp_write_space(). This causes a partially sent record in the TLS TX
list to timeout after not being retried.

This patch fixes the above by calling queue->write_space(), which calls
into the TLS layer to retry any pending records.

Fixes: be8e82caa685 ("nvme-tcp: enable TLS handshake upcall")
Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 1413788ca7d52..9a96df1a511c0 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1081,6 +1081,9 @@ static void nvme_tcp_write_space(struct sock *sk)
 	queue = sk->sk_user_data;
 	if (likely(queue && sk_stream_is_writeable(sk))) {
 		clear_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
+		/* Ensure pending TLS partial records are retried */
+		if (nvme_tcp_queue_tls(queue))
+			queue->write_space(sk);
 		queue_work_on(queue->io_cpu, nvme_tcp_wq, &queue->io_work);
 	}
 	read_unlock_bh(&sk->sk_callback_lock);
-- 
2.51.0



