Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039998;
	b=RKqH+PmNx88a89AsxL5SBoDUGkTkCjdV+cLFuKYnIbgE8pgJrMWnJeSfjnBCnk0l62Bt
	 oPXjecZOIm7rccOd2nqhjc5+ZhjfW2wep14evfaSn7jayHoaRIRdHprw6iiMCHZvhLask
	 V8Aiqqy8UtqNRmAPWtxv2nw5i1BR0xh0nZitCWizGSTuxJs9PW8CPxlnF1bwUSq2IIfYI
	 TRQRG8qyCZrZBQeQk1e6lAmYJCjFx4DzLwZONoeawILQSBBp/NTa4SR6Q36iaQYMbbQ5b
	 S+YNdgvKHStC0l2qSwZnmlIhATgAtZtMd0r+8gyrmIuN+kEGCl7GuMh/uMNfDpITqHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039998;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6SrC1+zomdRy8QGoCIDyGR0JPr7hoWs1sU3wpSSGstA=;
	b=RHqvkUEGmR1eUX56YOsYhSQx6QswA5ap8Z9bCns4mrNS7Eg1UGY/HQONwLY0Vaba9fm2
	 yaBzNeubYRmphEEy/AUy9aJVlWvf8pLhWNbQa49RPOTOaTmW6FwaEI8z3+YsWxFHngOPn
	 RukoRtSXpYi3wXqCeTI+GENcPKV06jaas0+FJwjy446Y52S/Jn8IWHml/T2DlpMaKFucj
	 F4XCpRbJ2NlMW919TGy/g7HSQ8FqR2s9g/4lQ0uzsZwq+iERu+jSQTI2BWmolj2kuwiFt
	 BpIWxkojND/UmOBP1p2v9uFKst9BAGpI+ztqabqIRCE2rtvIttpiTuGug9R3/sXlp7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bUqlXpTT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9CA606A325;
	Wed, 18 Nov 2026 22:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bUqlXpTT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8278A1F000C4;
	Wed, 18 Nov 2026 22:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039998;
	bh=6SrC1+zomdRy8QGoCIDyGR0JPr7hoWs1sU3wpSSGstA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bUqlXpTTOsCQKNIaqRsrv+TXR7Uu7SYLnAVAX6xUskr4aptQe50OFSW3fcep+MDNX
	 pGxTBtT4dKKkVMzyrKNlSCAUR3uQLtjQslZaMhUzGIkgM1f/z1XfBErGxvZ+EFl4Mn
	 3cMDSAHIQNJKinE+vYYklvtBEQqEWVPnvHNQ7X4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2300/3318] RDMA/mlx5: Fix RQ resource reference leak in mlx5_ib_wq_event()
Date: Wed, 18 Nov 2026 15:48:42 +0100
Message-ID: <20261118150430.716878904@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 83661a393136c..6bfd1e6f26b44 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -5182,11 +5182,14 @@ static void mlx5_ib_wq_event(struct mlx5_core_qp *core_qp, int type)
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



