Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032813;
	b=iz8m/dn5Hf00OkBj+nm4+peDASQvjMO2umqxeyd8idIfWOOfT6PtIbNmB92Cz3X8ITBK
	 K4vDBpRH8gZ4fYLoItS1X0apSauNmpD5t5GD/HFKrNG+oxYwG8sSV7cPLbsRzY7Ms4+6K
	 CCsmbK5pXeAH/lseDta/3JlFUCFuIR+dG+rwQZSKo3j8epbrxKIeo7rnqoeK8p29gsSh6
	 qlWp2cvboJI1T9O8EWJO8wgkdXVCfRoYukrVVoyzpJQwrMhCs51c6F0LA2S/u5t8sXtUQ
	 NGyM/WLgYqyRnrHFzv1Ho8+fnnkBOzNRKodnXMys7NJEN4deZOYFN2TqUcNG4sTpd+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032813;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zWlcsy1e682tKtkttfc6Utvnvl9ke7xG//m84FsWG2w=;
	b=MOiDD0Kz/sIEUM5dT+r3LzwZ8dpnsGErP1s3oB9Ysxkvf+nAmU5GxdnqPM4QFN7kyru5
	 9G2TTxD8etkBCwt7nxfVPNU6X94jLGCJVjN3CrRxWCesU94qq+vno9PPDR7tdXsKRUmR6
	 77N4z0osqc6Yl6Ct7WJGPx9Oe8EvVOVj/D1VWlsb/s3RrSGYyT/ew7fbt8iaCFvNjkF5R
	 5AKG3/eRih9fvX+cTwLQ40SZ72pxw9IE+Gxj0AsDD1djmVA27Ob6SOnCD88oCylt1CEo0
	 0dX4lA8WyKzUKVS4l1W31G6pVPKQNerD62h2bEdjufNemUkrKH1KAqdMcX7hDEZ+RbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P8nQovAP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D583C606A325;
	Wed, 18 Nov 2026 20:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P8nQovAP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366971F000C4;
	Wed, 18 Nov 2026 20:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032813;
	bh=zWlcsy1e682tKtkttfc6Utvnvl9ke7xG//m84FsWG2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P8nQovAP3mfjES16Ba6Xe5n5ExA7T2uoCk9JYUlbUOI1Oz03EXjmrg0ajKb1pFnX9
	 kplhr0fGuihNijK40IoiO9QMRM9LRQDtKnyFGTY204HDL4CKWvyppd1g665FKCYWTc
	 RVVrLKDi12Y3JBWtXg77hQ85LTdVr655WdAiTCTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Daniel Wagner <dwagner@suse.de>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1544/1756] scsi: elx: libefc: Fix resource leak in efcport_init() error path
Date: Wed, 18 Nov 2026 16:01:11 +0100
Message-ID: <20261118150110.398298693@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



