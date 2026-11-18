Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050476;
	b=gu+yU75WLfeTzok+HeLKpJYaKP6mKY0at+gJxQG5UHd2kLBiX2rLfJXjesxaBkyc+NCj
	 ktpWAeqI8SBcmbW8goU5v1ZlsRA19+gZT+yhJloqO/kZYa6/VnLPDyGPyWSDr5iQwH906
	 z4xd5Ndq/dzCxE5HyhdEdRdIt1ZJuy8CwnWuNi1GbUiMQptNEFTCtnBwQHvJUsOJcFHk7
	 X/jNkgOblMhGPR88p0xkVf1RZG6xNhjkT8Sr3xbzcjOiEaNWPc9IQvnUBLJ08O9UAUIz0
	 TNuTdtW3HcvXpt9fNJhCja73Wf1Zko2uc1w9FMBdpEavtjPMZpBM/yDKc1XMFiOpJSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050476;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WOrb8CpH/tLlKT527vPuUb4s6IMadX8pBFCzt7G5fj4=;
	b=1Tfkg+P1UG5kqhIAtOIESNhSd2/U56yB+xdEgdNbaPacov1jrxjbYaKJ2/Ql6hFWk8cD
	 Fijn4/9mThJkEASKSVmAWzrioIsq3xrAHgoanhvUtZ5SUyyyuHxsI/T0Rhr6vT3DnPhmA
	 Js9AsWtvALK3nGDhFfV88sfsVDA2neIpq5GhtMC5fhkYGNTtoYBr7T+SIOCbcCYp8vhgJ
	 RlSWl4aY2w2IK05woUXoWgAm7GNulJoLqmhshn/POyLKZGvrEkWAaljmbMJ/TH95jiu1+
	 gHEx9gLiP3bnOJy48LnIpmCOSKR4g5SgmSZ5IVUo3sKgu3/ECX2gr5uI8zaUEZ4kpbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N1JdUTI5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236C3606A325;
	Thu, 19 Nov 2026 01:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N1JdUTI5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BAE1F000C4;
	Thu, 19 Nov 2026 01:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050475;
	bh=WOrb8CpH/tLlKT527vPuUb4s6IMadX8pBFCzt7G5fj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N1JdUTI5d2zxL6BBD/lh42oWxGmGvLDdM2AaokbWoL85yNfa+4FwrYUBw6hZQ0vRV
	 jAHoQ81dygjbuSxgSx9sXq85He+aHxlW2fIbQiI3Uz0FFhp6Bvk5ybHybICL6GSSka
	 ALDwNbVLuWd/97hnczDwCgOVXyZMVAPmpMqtXQ3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Daniel Wagner <dwagner@suse.de>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2722/2857] scsi: elx: libefc: Fix resource leak in efcport_init() error path
Date: Wed, 18 Nov 2026 16:02:36 +0100
Message-ID: <20261118150339.622118431@linuxfoundation.org>
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



