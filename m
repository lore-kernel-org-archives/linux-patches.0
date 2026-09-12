Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38DD1481224;
	Sat, 12 Sep 2026 13:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218322; cv=none; b=pgQXe9UK8xBgCUDXKqgBM5Sn276Ds6o1Dwmfvqp+RBdbr5qmGMQQwDzPXz99KiHc8lYE6ZKNLBsuX8Uc9O7IImg3e5w5MKU0VJyZpM0siWEBOmq0qLc5a62oQAI6bvwG+USJfv92dY+v9AEAQbnLN06nzmSOF6vhxxfAWP1N1Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218322; c=relaxed/simple;
	bh=cLm/eS9Ydjlyv5NDPMPGs0iIQeo9SSzzuCocn5q/gOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gWqrC1nT4vk9FKCR4zf+L0OFsc0gbuZ0MGBlQk7QAux1ruDqOCZ4H+Oumc0s+JG7zS0lkEIt5jBuZz4Lk3ufi7i9bgYZil+osRdGmQqyekYiNbr2skiihhf5NCog/owl2iYZzT2N9/4x8mYOxPfKWW7H8lmWJ5ilEx+hZWPknLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LWN1XAVh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LWN1XAVh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23C31F00893;
	Sat, 12 Sep 2026 13:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218317;
	bh=xUtFvlsqnjgKNlaStW1FiiIahHcMqlzz+H1ka+lQTEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LWN1XAVhxI0Ys9KQx+TsttxXlQ5LAObBBxrxXUAvQueVDCv7srsXTci+cL8oT/IDj
	 bffL6wWCmQQb6rq6ruZIYCcQRRPyeTPRwszCn9jYMBc2Dv3QnsRWmoeV/I8pDJ2BJi
	 tE9xS78ucifxY5jq2Q2J+yRJaHSyk71jz2D9J6Dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurence Oberman <loberman@redhat.com>,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1121/1376] scsi: mpt3sas: Avoid freeing unallocated PCIe SGL buffers
Date: Sat, 12 Sep 2026 08:59:07 +0200
Message-ID: <20260912065632.548422279@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c1d8f2c91a5e5..0d78e9dbf641c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5854,6 +5854,8 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 
 	if (ioc->pcie_sgl_dma_pool) {
 		for (i = 0; i < ioc->scsiio_depth; i++) {
+			if (!ioc->pcie_sg_lookup[i].pcie_sgl)
+				continue;
 			dma_pool_free(ioc->pcie_sgl_dma_pool,
 					ioc->pcie_sg_lookup[i].pcie_sgl,
 					ioc->pcie_sg_lookup[i].pcie_sgl_dma);
-- 
2.53.0



