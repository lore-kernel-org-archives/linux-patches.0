Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215864;
	b=tLzIV5SytOXYxKXQdVAInzoLz/RLlhjukYJChfVKXPoitXmSgwzdfV5GwjE0KoTbhWxs
	 65/8NPyJjWk509ag3AfWno+h0sdaiVlzI5IEUiYnRYN9bKoLLXJnvKWcp42ZwuA1jvojI
	 Pu/wv1N5GMzB1VWQsUIPqUya3gC0D+pzJZEVQkNBuwVcBEk6ILcz1m/p3s6745lA2NPrX
	 A2XhDkzi46HYx7fNoKBXZnWteKjv4+uufkjLCkkTU/7Zu+l7nPBcYubcmloKgO6svIB4j
	 qHPITSZrAGwkIeGjX+TYSN0EEV4v8hyv775oo0hWFD/8RfWXUhCuQ5fqBnpioHmEhkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215864;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xnIoo2LXuSocElOtx7ZsJHWIINtXWlOYzPDQQI4IVcc=;
	b=5ReZXQedXK/q+WK2Zm5RkWT7CPjv5R5/K7xR61mvfBM5zUoZo/dwDhFj14gHkk08iqoJ
	 xYqcsspDjtQGDXgA/VH6iVw3U60Hwnn8YbQqMM6wOgDv2fqqxKH+5zUWkGhtOiLwBtqvd
	 15OzL46ShvdiCiGnvlUvO3tU/P2Y+OqEBpco8NhbyETG7RSNxEpa3ST9OGJ/c8fs1M5Fb
	 keb6pRWDOfioBPVqJ3SRFQwBqem3IICkSGaDDMbO1bzBftIHieXeR8/+tBI83XUzchlCN
	 p8iQkbcuS3XBT44rVqd9WNoyN24MUWiLGYUsBIDb17wXsgOwnd5BPu+JcKoIs1GfnUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q8su1lwN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B50606A329;
	Wed, 28 Oct 2026 19:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q8su1lwN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1231F031E7;
	Wed, 28 Oct 2026 19:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215864;
	bh=xnIoo2LXuSocElOtx7ZsJHWIINtXWlOYzPDQQI4IVcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q8su1lwNWDu4FiFwxP5dTLJMTHOHzHzPPBvxVwLwEohqttgYCixHZSZzNBke5s0QJ
	 IuHYUwmoBcphP+tqRPB38/+mICO8Hzcfc2WKhlaS/qHH33tdKO1MrgFrbMLNCV6sRf
	 ctJgRM3IcaePN261q0cgBTKk1NV+FL3g+fUMcsLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Ibrahim Hashimov <security@auditcode.ai>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1357/1887] RDMA/rxe: Fix responder UAF on IB_QP_MAX_DEST_RD_ATOMIC modify_qp
Date: Wed, 28 Oct 2026 17:57:33 +0100
Message-ID: <20261028170530.322802541@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Ibrahim Hashimov <security@auditcode.ai>

[ Upstream commit 6f7014237405e7f032b5c53a82d9eccf6161c291 ]

rxe_qp_from_attr() handles IB_QP_MAX_DEST_RD_ATOMIC outside the
IB_QP_STATE path, so it holds no state_lock and runs while the responder
task rxe_receiver() (recv_task on rxe_wq) is live. A modify_qp() setting
only that attribute calls free_rd_atomic_resources() then
alloc_rd_atomic_resources(), swapping qp->resp.resources[] while
rxe_prepare_res()/find_resource() walk it; free_rd_atomic_resources()
also leaves the cached pointer qp->resp.res dangling. A local
unprivileged user can race the free/realloc into a use-after-free in
rxe_receiver() (local DoS).

Drain recv_task around the swap with rxe_disable_task()/rxe_enable_task(),
as rxe_qp_reset() already does when tearing this array down, re-enabling
only after alloc_rd_atomic_resources() succeeds so the responder never
resumes against a NULL qp->resp.resources on the ENOMEM path. Also clear
qp->resp.res in free_rd_atomic_resources(), like the rxe_resp.c
completion paths.

Reproduced under KASAN; the slab-use-after-free in rxe_receiver() is gone.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
Link: https://patch.msgid.link/20260712121720.78001-1-security@auditcode.ai
Assisted-by: AuditCode-AI:2026.07
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_qp.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index ab42bfea92a60..a468e9bdc7364 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -124,6 +124,7 @@ static void free_rd_atomic_resources(struct rxe_qp *qp)
 		}
 		kfree(qp->resp.resources);
 		qp->resp.resources = NULL;
+		qp->resp.res = NULL;
 	}
 }
 
@@ -583,10 +584,18 @@ int rxe_qp_from_attr(struct rxe_qp *qp, struct ib_qp_attr *attr, int mask,
 		int max_dest_rd_atomic = attr->max_dest_rd_atomic ?
 			roundup_pow_of_two(attr->max_dest_rd_atomic) : 0;
 
+		/*
+		 * Not gated by IB_QP_STATE, so the responder task is live.
+		 * Quiesce resp.task like rxe_qp_reset() before swapping the
+		 * rd_atomic array, so rxe_responder() cannot race the free/
+		 * realloc.
+		 */
+		rxe_disable_task(&qp->resp.task);
 		free_rd_atomic_resources(qp);
 
 		qp->attr.max_dest_rd_atomic = max_dest_rd_atomic;
 		err = alloc_rd_atomic_resources(qp, max_dest_rd_atomic);
+		rxe_enable_task(&qp->resp.task);
 		if (err)
 			return err;
 	}
-- 
2.53.0



