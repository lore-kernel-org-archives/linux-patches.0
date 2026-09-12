Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBD420ED;
	Sat, 12 Sep 2026 15:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225513; cv=none; b=eTtAeZsTy7ylX4nBtGGVAH5saLobvNsmkw/gvfGYYcLAGj3LFj96dhJba/IbBypdTBsOyItczBDrSw3DoElORHIUnoXSntvqmbOmR9mBc8jLdSYPt2p2aTO4Io6VTHMMHy4V9TDU7Yku4hlL1E6Cb4OJkuqtwvs9oX2YYgRk404=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225513; c=relaxed/simple;
	bh=625AIl6iHCVcb4sP9bnZcC+fXIu8y5mogNh4//GL/Io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWs0xxYvJG49KPDeI62Le9iHTLHrCW35g4330/fZ3MvlviUXWTTRVAPZWECCTe3dEA+ZRWlEVKiyr7Kq8q+EkpnMR2hjXLm7JVsHIQcA7ARV5mY8i5e1WiH2uC9FO46yRTIt+M5IQFB9Udn8L+qmhyCudkvyZ3Cb9zpl1eJgx/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mh8NXYt9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mh8NXYt9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCCFF1F000FF;
	Sat, 12 Sep 2026 15:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225511;
	bh=AMVJJLKNAafJTKWqUbqvStStSjlvnTDbPvgxOPbTZ98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mh8NXYt9JWdduZvOWG9Qug9mNHkpbp6w8+WCQPffx3XTipqd7EcPhx2Yr3amSS9QO
	 jSaOwXC2Wa0Oc53aar7h+sCRQikE4CiDXoJ2Rf8wadcZX7gYV9YSDe513ySnkMhyb/
	 GJ2XrwexBAuZEukKLPjJshQv0Tq/hT4h1WXkN+4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurence Oberman <loberman@redhat.com>,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1212/1424] scsi: mpt3sas: Avoid freeing unallocated PCIe SGL buffers
Date: Sat, 12 Sep 2026 09:00:44 +0200
Message-ID: <20260912065634.429371267@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit b9f679dfe629004b593f018df33b330d799bcee4 ]

_base_release_memory_pools() unconditionally frees every
ioc->pcie_sg_lookup[] entry, including ones the setup loop never
allocated after a partial failure, causing a "bad dma" warning on debug
kernels or a NULL pointer dereference otherwise.

Fixes: dbec4c9040ed ("scsi: mpt3sas: lockless command submission")
Reported-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260808151010.185603-1-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index cd00f19670355..3e2e0bc49623d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5863,6 +5863,8 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 
 	if (ioc->pcie_sgl_dma_pool) {
 		for (i = 0; i < ioc->scsiio_depth; i++) {
+			if (!ioc->pcie_sg_lookup[i].pcie_sgl)
+				continue;
 			dma_pool_free(ioc->pcie_sgl_dma_pool,
 					ioc->pcie_sg_lookup[i].pcie_sgl,
 					ioc->pcie_sg_lookup[i].pcie_sgl_dma);
-- 
2.53.0



