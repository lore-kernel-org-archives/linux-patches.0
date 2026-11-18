Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056808;
	b=p0emIZwZ15XOEEBmPsKlrS4Pf95ykjTZ0vTn9YQhXOVDjk4+fCx4zVzUDfFt6Vohu3yz
	 ubPPqNV7dOYlYiFXz3R19Yv9ziaGRLBUxYuqUbtCiwGPM2P+efXuFF2DVgfxlnEX8qMp3
	 Tal/vo9En/B5zzcn8xOsssZR/3e09ZVkrhONCEe8/UhYRm/7iOdAHWQq+QJo7OQzV1OTP
	 OU5Tt5HhLPV0zQEPkojQqnMouBEJHS2NFksaQ32WKlFAJJ53+CRnEUsTY/NAuFhYLurEZ
	 U4h7UiQb+q18M9IpKNmlsD7iQUCVDgHD0YuRU5NdWsW7xFsK3jb71fnM4K3TbMVsdKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056808;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WBIsAVzjlHeCH65/wPf0VlA06/YHLYuaeR2PbSpcdXA=;
	b=Oa6CKEfzDRiXIY2/0M98XaSd4+HFH0SskcDl28goYepQIiZrEpqCfNxEd4K4gwVvCAZ0
	 PtfGydMgMgByuDj/p9dHTDt/X5pjhm0OSbadxq+rxyK1aSZ7hfeJ360XkA1kPkeZfsfm3
	 qz7YHknE4MxZ0QelntvcUruFDj25tUqL1f9V+g1A/XnINGIi2RnUndFJPOsA2MfAihzeF
	 ze+3iV9CNqp0mofopppT97TRkRQ2J0jXvWaLaheU8lRWUUW1h9vMrV7L06bJBigYeCcnN
	 aUvd3cWOYnI/NC5vEu5jyFFRXgT9DZ9lGdrA7sHDQW9vxKrnSZMxVNujr7c74seq1oQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wSwEeEjW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864AA606A32A;
	Thu, 19 Nov 2026 02:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wSwEeEjW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67BC1F000C4;
	Thu, 19 Nov 2026 02:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056808;
	bh=WBIsAVzjlHeCH65/wPf0VlA06/YHLYuaeR2PbSpcdXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wSwEeEjWqo/UX0WyO/ARAXZw1MGo+HmZiMDHK4si6LmNgLG95nPOiXEbkhen2Cz6H
	 iQrnjUtxK6/wmgo6kjK5EcV1guv9xlIkoBYQrDlW3YAFdIbJVOLSw+3kq07sUEpe6m
	 bb4wsSW7H0cZxbLRQou2SNLKDZ95Sr+v7uDijKw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Daniel Wagner <dwagner@suse.de>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2118/2214] scsi: elx: libefc: Fix resource leak in efcport_init() error path
Date: Wed, 18 Nov 2026 16:03:14 +0100
Message-ID: <20261118150135.315132070@linuxfoundation.org>
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



