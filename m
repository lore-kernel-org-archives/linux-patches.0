Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042393;
	b=ibWpKWCCOTe9Wb9X3X35YyWyJNDZofzR3yYWl/m0PbB0CQtmOdKK+V/zI5dd9AWUndpC
	 Qa3rLyesw7V1guV9EKt8hpiAApkuaFkZAl6Bt1rtO/ixTiC+s76t3qzV2SXf+c5VRV2gJ
	 CIagX8ajIfYAfZ39jUpi9s14UmrZipaBxIj8+BkDN4JJW1AzfHurcYCh3tiuob0kwv0v/
	 rPrvkl10Wc7CPoZPnR+gClc6i7+Mop/Fu+pW27UalPkK85Yt74rLf1LbPoiCGrjmxdGos
	 s6YyfN6CdQj9FG3ZIBYJegJPhsNX10450U80RU+2xWKDOuxDgv/GeOM8SXZRkkxfYfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042393;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DPHiJwLpLqcr3zSr+HuvKvXSpaNTZSWWnq1QxUaNC60=;
	b=EmhCBLxI2N65pHc2b8AZonACrmorRnnR1PbRC1oZHUQ6i6Uyt4vpe14dkYakCG+GkuAQ
	 j2s6fCyrhZiXGQGaVEjvN4kw7mYyOBvrmBeWt4tVmQAsZmK6yr68Y0M+QGrg8Gg9aiMB7
	 7I+a1cBW7O0ORktThQXMDPRscF5AcrrNNl0dyxKzoMZ3QvS+ZUJk06t79u/Oi3gyX+fMW
	 u//lO8J5B0VzQuE0O+yiv1NHdCouq4ByuFOIhBeTev5JF+DCsrGYm8INJbqVeY+qlVw18
	 0Ja9lFoShf1spbbTSNpxgDLIxZlHfLL9VTIhxWH/UAlfA2UZBJFgF8Zt6qVO4zdW+rA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZTtBYjdQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6040606A320;
	Wed, 18 Nov 2026 22:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZTtBYjdQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36DF1F000C4;
	Wed, 18 Nov 2026 22:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042393;
	bh=DPHiJwLpLqcr3zSr+HuvKvXSpaNTZSWWnq1QxUaNC60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZTtBYjdQ3my7MtE4nbCeldi7CCb78P5t1ETAqxs2DUep8nvUwCM7VG4saNlQAhdtf
	 peWY9KDfW0MnPusuKHE+8VrY6QluXsk8O3Z5i1GrD0Ui/zZHmFTjnfO3h9fGYip2Go
	 Pj7HnQcFAoqz4JTEaHaREnzE5WCLgYeHNULv0V90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Daniel Wagner <dwagner@suse.de>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3153/3318] scsi: elx: libefc: Fix resource leak in efcport_init() error path
Date: Wed, 18 Nov 2026 16:02:55 +0100
Message-ID: <20261118150454.449933657@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit b4bd078b78c248d4263a1da7033cbe7a74ce0e12 ]

efcport_init() creates efc->node_pool and efc->node_dma_pool before
allocating efc->els_io_pool. When the latter allocation fails it returns
-ENOMEM without releasing the node dma pool or the node pool, leaking
both. The caller efct_efclib_config() only logs the error and
efct_device_attach() failure path never calls efcport_destroy(), so the
resources are never freed.

Destroy node_dma_pool and node_pool before returning from the
els_io_pool allocation failure path.

Fixes: d7b71fd2195e ("scsi: elx: libefc: Emulex FC discovery library APIs and definitions")
Assisted-by: DeepSeek-V4.1-Flash
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Link: https://patch.msgid.link/20261008185403.2791781-1-vulab@iscas.ac.cn
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/elx/libefc/efclib.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/elx/libefc/efclib.c b/drivers/scsi/elx/libefc/efclib.c
index dd3e3d0a47614..ceec0e2a0266a 100644
--- a/drivers/scsi/elx/libefc/efclib.c
+++ b/drivers/scsi/elx/libefc/efclib.c
@@ -50,6 +50,8 @@ int efcport_init(struct efc *efc)
 						sizeof(struct efc_els_io_req));
 	if (!efc->els_io_pool) {
 		efc_log_err(efc, "Can't allocate els io pool\n");
+		dma_pool_destroy(efc->node_dma_pool);
+		mempool_destroy(efc->node_pool);
 		return -ENOMEM;
 	}
 
-- 
2.53.0



