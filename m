Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048294;
	b=HpKvXk7amdUfEKWNFCrfvAuwvO+HF/WBogpgWr6gHnnplKTlibXlUUh/aGsiOTXjV9Yk
	 o/h7d0gy+rKMYMHiy4prEgJVftdViHfRCHg+PQeaY9BiLKBMBFRJUOW+dSMR5PdqG9kMD
	 gaM8W2MLGiP15UiY49VA05DSmtWi6QMFWLgkK1dNqmnv7Fxlvvk59h3m/roqTagPbdL69
	 n5JUTEKfDtAPdl32S89in0Jg1gIQYx3pjKaCJdzhIRrKbanwZWT5p1s/ITvvypKKkIMho
	 qz3DvEEE8rD+ivNJ6+EG4TLIEINT36300VGokLryvkHNn5Wxyu/SyuNzjzWnlGeEh9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048294;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qGqWRy6A1yJhlc+dbokX2tejBJSMwXmBgXPLUskZ8YM=;
	b=BiIKBShBpUZSPUMdWwSAIu/GQblFJGYu+kD1UKXDbX5HZqDT+8mN3S6qlqvGVR2oL71B
	 XUVmCO8pzo7gXHTxUg9uky4fAslWc6Vk3dObZGSwjiDN/cfyxmdAmg/ETjyLjJYhcBuxO
	 1DnZXmibKxwWcw2yNAlCfalZ8+04lQUff76ow7NTtGNs+C49E/SxAxbMmCqnw0ftygHgp
	 r8lrpxfNd6G9q5ZsuS60LhhFKuDbvVDrTj8e70PzsaFiqbZ0A9WSBLB5n4IgONkzAngtX
	 EelEVIX2DZ+LPwRkblWQMn4Kf6Yunu+/TCjp97fpveo/JpH7fHcg4cdYRgWhF/tIS7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K9U9jKX6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93877606A31C;
	Thu, 19 Nov 2026 00:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K9U9jKX6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76381F000C4;
	Thu, 19 Nov 2026 00:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048294;
	bh=qGqWRy6A1yJhlc+dbokX2tejBJSMwXmBgXPLUskZ8YM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K9U9jKX6QtVtfmQ/TZo31ToMaT1666u5r8EuaM89GjLlJrjs7UWgXKKpFLM3tryVq
	 MWPWWAHAah+DlrMM0A5L11V+N/i25y9smeCg9LuLHyCG0eson3O3yCMKlADMUAeBtN
	 gg0GwHzxNj3I5uw4pNkN9uSu69jh119d/yusw37M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Nicolas Morey <nmorey@suse.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1941/2857] RDMA/rxe: Use validated num_sge in local buffer
Date: Wed, 18 Nov 2026 15:49:35 +0100
Message-ID: <20261118150311.102222139@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Morey <nmorey@suse.com>

[ Upstream commit a4368022a3ac5324356ae8d88e3a42d115956fd6 ]

For both SRQ and non-SRQ receive paths, the WQE is copied into a local
buffer to provide a kernel-owned, validated copy. While calculating the
memcpy size from the validated num_sge prevents overflow during the
copy, memcpy() itself still copies num_sge from shared memory.

A concurrent userspace modification before or during memcpy() leaves
an unvalidated num_sge in the local buffer, leading to potential
out-of-bounds reads in rxe_resp_check_length() and copy_data() causing:

  BUG: KASAN: slab-out-of-bounds in rxe_receiver+0x8109/0x9ec0 [rdma_rxe]
  Read of size 4 at addr ffff88812c4867f8 by task kworker/u9:6/361
  Workqueue: rxe_wq do_work [rdma_rxe]
  Call Trace:
   rxe_receiver+0x8109/0x9ec0 [rdma_rxe]
   do_work+0x149/0x610 [rdma_rxe]
   process_one_work+0x726/0x10a0

  The buggy address belongs to the object at ffff88812c486000
   which belongs to the cache kmalloc-part-13-2k of size 2048
  The buggy address is located 0 bytes to the right of
   allocated 2040-byte region [ffff88812c486000, ffff88812c4867f8)

Explicitly assign the validated num_sge to the local buffer after the
copy to prevent this race.

Fixes: 22b8fbded65b ("RDMA/rxe: Fix TOCTOU heap overflow in get_srq_wqe")
Fixes: d6ab440240a0 ("RDMA/rxe: Copy WQE to local buffer in non-SRQ receive path")
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Nicolas Morey <nmorey@suse.com>
Link: https://patch.msgid.link/20260909160132.1491248-1-nmorey@suse.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index b933531d9d6d3..3cf214a7b715c 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -324,6 +324,7 @@ static enum resp_states get_srq_wqe(struct rxe_qp *qp)
 	}
 	size = sizeof(*wqe) + num_sge * sizeof(struct rxe_sge);
 	memcpy(&qp->resp.srq_wqe, wqe, size);
+	qp->resp.srq_wqe.wqe.dma.num_sge = num_sge;
 
 	qp->resp.wqe = &qp->resp.srq_wqe.wqe;
 	queue_advance_consumer(q, QUEUE_TYPE_FROM_CLIENT);
@@ -364,6 +365,7 @@ static enum resp_states rxe_get_recv_wqe(struct rxe_qp *qp)
 	}
 	size = sizeof(*wqe) + num_sge * sizeof(struct rxe_sge);
 	memcpy(&qp->resp.srq_wqe, wqe, size);
+	qp->resp.srq_wqe.wqe.dma.num_sge = num_sge;
 
 	qp->resp.wqe = &qp->resp.srq_wqe.wqe;
 	return RESPST_CHK_LENGTH;
-- 
2.53.0



