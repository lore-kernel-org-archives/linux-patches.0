Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055343;
	b=g85ShboL/1jQQNH/A65/01x1p7tTNJPDjOHQnRdLUjirHJ1YbIRyPOYBsHL+gknQ6x5N
	 6f9pfgMLlks5siZlJ2icEiqa051XKcAFy16vLQ17G6pKp+tBHPCVpyb97fTgXKLhGeeT6
	 pIrcS6w7vzghGVx+FoQ03Ypu2Gr4fJ3PT3Jn1GAuiQ42+TNbUoQa2s0wiYeqfaxHiQ2aL
	 FWm+Jn09F5dQAclurAgs3DcnY41OJjq1pvFnbUK6+NFl/bwASMv4neLoCkLg7aqd0Jobn
	 YzzikkRkFk9jMdmBl6SF3LzHYfGOchyNxbsUcmWbBKRoZKtWtv74D6o6YevpJjIzqbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055343;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YRYQclvFOP2DYqZ+Gr/oYLrjRwQ1vKZPVKOe/HjiSBA=;
	b=KStSFwlw+oZ4kYbfB0fpjxHTho5ubbxzrA5j+8i+dA7dFGb+8tbXTJLHT2uYKP60YQa6
	 b5xVuQsfG2BWVZdx3AdRtdIW/rjccOLrVdixcK1r7P91sRFg9/wUxYcb3c6BZ+BKPs34U
	 G6XwSfj1kAKJ/rqBDj0dHuEV+H/3RgCSqAop3Y8p4ohwDOMt/Dd9US8k2MxSEE2GrPAXG
	 pIwtk2L3yfMsH3HEIOBTPbQ/MyGlIlLdP5Dy2ZfqRcdkNibwJIsJdaL8XqpkA8nYnnEmY
	 YrXMpUBt64s2b2CHoD3ryxjlHtxrdzacHvzGXG+vMRdpoQ1OSNZnucnFHPhI/MhA88g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YhmCP0v3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0DC606A325;
	Thu, 19 Nov 2026 02:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YhmCP0v3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B19B1F000C4;
	Thu, 19 Nov 2026 02:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055343;
	bh=YRYQclvFOP2DYqZ+Gr/oYLrjRwQ1vKZPVKOe/HjiSBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YhmCP0v3DXsT65/KmjUOJ0WUf03xXg6ta7WUbNp0dg3BR7amLi0j4vf9hu5SjCvFw
	 V4E4taz25Mv8678SsyMuf1vgd8Kp6HAKaDAe071fz1MLId8KqA1vhKeGBLtLZcvMFw
	 sy+s2ljvN/D/FIvpgSZ3MJHIXjDF6n6Zv2LZS9bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1557/2214] RDMA/mlx5: Fix RQ resource reference leak in mlx5_ib_wq_event()
Date: Wed, 18 Nov 2026 15:53:53 +0100
Message-ID: <20261118150114.376730584@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 65f3eab431944415bbe5e3af1bbb2736d4bb1523 ]

Since commit 312b8f79eb05 ("RDMA/mlx: Calling qp event handler in
workqueue context") rsc_event_notifier() expects the event handler to
drop the resource reference taken by mlx5_get_rsc().  mlx5_ib_wq_event()
was missed by that conversion, so every RQ event leaks one reference,
which keeps destroy_resource_common() waiting on the completion.

Put the resource reference on all exits of the handler.

Fixes: 312b8f79eb05 ("RDMA/mlx: Calling qp event handler in workqueue context")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260916183921.2092821-1-vulab@iscas.ac.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 3df6fb5edbf34..8caded8c3b324 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -5121,11 +5121,14 @@ static void mlx5_ib_wq_event(struct mlx5_core_qp *core_qp, int type)
 			break;
 		default:
 			mlx5_ib_warn(dev, "Unexpected event type %d on WQ %06x\n", type, core_qp->qpn);
-			return;
+			goto out;
 		}
 
 		rwq->ibwq.event_handler(&event, rwq->ibwq.wq_context);
 	}
+
+out:
+	mlx5_core_res_put(&core_qp->common);
 }
 
 static int set_delay_drop(struct mlx5_ib_dev *dev)
-- 
2.53.0



