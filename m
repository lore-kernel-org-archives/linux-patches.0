Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016884;
	b=T0z9WGP1bOzl5DRFSltQWWuY/vdfrew6A+QvudZ3s8nNz9xY2QN9FvrVXANrizGSIdg0
	 QqjpPaOIKYkBnZ/dxQYYIRuhgMM4p/SSog+7WYbQ15PPf+A+GfZ1IFzSDWUmYUpxiny4r
	 QvYMImTtbWdRzPXPNEYAGQR4xWV+/vJXPpayt+2EEBTI4X2vBAWRpcqBZwk2HAbaUmhil
	 CBSt+Db1AKVlCiMb2ZcAF9jUJu9Nl+Za3iTTZ8Ct4KAbHRUpw/FqCmnbabh8UD0pU9MxX
	 eewYJziIAfRbOiMXYMrr6s6L6+Q8JqW9Pap30jSmUeAxoITrOuGFED8M9hKqxb9pECQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016884;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mqdnAb3q3+hUF16lK4aXlOc9lsLfBm/gGuGLEOgOE6w=;
	b=DUf58PNwTQlMGoGXOaqANhIA5Egh79nxETxgu63h6iJGthrHb9DwpVcN0OpZ4nkiqL5p
	 WLYli7r61e2H0uSeWSDd/PvOEAjBgejouMsnTAGGKGotzWvYsEBPvWAJLlpEmU/omk3rw
	 RSJNWbT19PN8Y99mY2PI3+MS5xQr/HRPuh1wLGMc8r43eNggmvadFd4dicY4gGmHOBz5g
	 tJXODbgv2VmdZB9bt0tJLRrVTrYCMkyA58bvJTo0OyUVkQ9ByW1UBXdmBpCTHp3gWj6Oa
	 5acRNUtVCeItxiM7zhuLh7qxbM8KUSeXZ758DEyDbsrVb/n7+jgVwXbL5fpOGazzw/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xbVIvJii;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE8D606A32A;
	Wed, 18 Nov 2026 15:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xbVIvJii
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6F41F000C4;
	Wed, 18 Nov 2026 15:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016884;
	bh=mqdnAb3q3+hUF16lK4aXlOc9lsLfBm/gGuGLEOgOE6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xbVIvJiiCq3l6cPzA8xsolutsy6TbqlxQIPa8lFRfQl0ebhdB4q5qZRByy8dtibkc
	 cKujRyYNDb/hKwP6YqtO3ZiF159xhkqm4rbfdUac+khXwsLiTntbvLeNrCobJiO7eP
	 PitWOhlF4VSoI+osL9jOeuOpSVRaduJ8bBGc1qbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0686/2651] RDMA/mlx5: Fix RQ resource reference leak in mlx5_ib_wq_event()
Date: Wed, 18 Nov 2026 15:32:06 +0100
Message-ID: <20261118150312.551790657@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 0d4f8b109ad2a..fdc33fe589fdb 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -5344,11 +5344,14 @@ static void mlx5_ib_wq_event(struct mlx5_core_qp *core_qp, int type)
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



