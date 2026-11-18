Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021663;
	b=WxUJ9pB8ep2J6r/ulVJ1VMO/wqraypa5zr0asyCb7M9IWDFEw7bSxJmknIfYTZh11o9V
	 47JcWDn0bb5ySsLcaN2dbSynjQCnCQZDRuJgSiqk14Os0jAZPqCTM2ptxlibuxHjbl3hU
	 IXRvgPrg/RCQSjCQ0B0ye5Db5C9uXjgS79oy3P1hpkyYfUXwTMvujwOLj84rzM1AhKnsd
	 saoBkpBYNXSR2OXIuoZtTgXwPazWJr+hNM0coBf7RSV8LU79wx0Y96DCqLMSRF16HFtR9
	 QOLFWty2NjFgkRxxMrLqLz67/5/e8H9Wpnz//RjR3jocC5BcwUqmjtDHcWFdeEEUJnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021663;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3H2GI7crse1tDC7J12NMFIo+vDueIcxGqsF4jqeWMFw=;
	b=nO6L6eKylvfUT6r1HG/3XM2hdGc/fZzYK60xj/DRO2rAghpKy7GKPSmABFSNDiNRPD1L
	 BSdYtAd3WuEDZXn4pEjQbN6fPs0KKlgfpPhimslmFBNO5hFblwqyDbp4bmwYVDXcbCUZ+
	 WtiBcNFtSZuYw/nVsE8EhKKMMJNrePrhXDYsFC6cCtrY0Vt7stkFsOQqEt0O5IoNjyRib
	 el1K+sKKt0ygstxzSPU7w/4TgDYKst/8j3c0qGdWHtHa/NkJsqbGy5SxL2acHxe7Fndow
	 oCEfamYMOsBftUtzl79hoOZZO4yV388aGJzf7uILUL1FmhgTtdf8aBBBkFlA9oQFuVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kwvYIlGE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0100C606A31C;
	Wed, 18 Nov 2026 17:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kwvYIlGE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173251F000C5;
	Wed, 18 Nov 2026 17:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021662;
	bh=3H2GI7crse1tDC7J12NMFIo+vDueIcxGqsF4jqeWMFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kwvYIlGEe7AtlZxGV6WDeFctSG5lXPFCp7DXXJQdCdogGG0DYoKPepxuweB9migIP
	 eIGpeeuAsw4vt2rzKNL1fLaXDbt/urxuxFBIq2fGqxKCaK2HPiQaashr6/RTQkaBLv
	 NFcMoxzHpXDXMBh0u1TwawSqTvJIKWpYHuxvuNCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Daniel Wagner <dwagner@suse.de>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2387/2651] scsi: elx: libefc: Fix resource leak in efcport_init() error path
Date: Wed, 18 Nov 2026 16:00:27 +0100
Message-ID: <20261118150411.350323986@linuxfoundation.org>
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



