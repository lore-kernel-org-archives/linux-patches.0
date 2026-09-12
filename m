Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E3E3BE175;
	Sat, 12 Sep 2026 09:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203611; cv=none; b=iyrVUohJqu2W4BUs2T5cxlanJlO8FNY0yBnkVjk4d985xTQo9TbAaEHt/BavrHMJ9e+RfGzBCvYOKDwF8A3GUoLDVehyoQCSCm3Yr7Pqm5wg0A0W+IdUnR/lDlwSnw2aTORhPku0t8Q1viqzZvLJbG5QjQQhaWnUEXV8fSI8Ios=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203611; c=relaxed/simple;
	bh=ikNDzoJKwB0/eexAHkICTQ+UP1eK8hkY0lP3S4zSVdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rw6HhibWHv08bEwysfQLvEdpcya04zXDtKM64HnQ7iZV2LNFqusLX8zCez/btxqVauYKR+T3n+XM7Umcwrv2nwo6ixWt7rgAAWf1KNTD1/Agr9syKoDSoje5xaKF+zonAALvPncLvtO7u4+1MU6uMGRDYQmFyxzl5F5xwBS+GGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zB9vDXWi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zB9vDXWi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FABE1F000FF;
	Sat, 12 Sep 2026 09:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203610;
	bh=NvTIqZ1bEWzVARyHWX6RlHUv2ofcbLj5iWiTL1jj+2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zB9vDXWiXlioReZKHVvbbOplu25wAYMDGnNNBKvCZXBOkIo6cKqaQjOz/njiHQLI2
	 q00BubahzdXn7kWJghCUoCPOr9bpis96fYA0+duzqNCIrNquWA1pUkGmJwtT8M3GFp
	 ad05WvtHD02gX/FWG93p0IIBDaP35hvzVOcA0URA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurence Oberman <loberman@redhat.com>,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1443/1815] scsi: mpt3sas: Avoid freeing unallocated PCIe SGL buffers
Date: Sat, 12 Sep 2026 08:53:13 +0200
Message-ID: <20260912065722.892709245@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 79052f2accbd3..11bcb8440e1c8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5870,6 +5870,8 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 
 	if (ioc->pcie_sgl_dma_pool) {
 		for (i = 0; i < ioc->scsiio_depth; i++) {
+			if (!ioc->pcie_sg_lookup[i].pcie_sgl)
+				continue;
 			dma_pool_free(ioc->pcie_sgl_dma_pool,
 					ioc->pcie_sg_lookup[i].pcie_sgl,
 					ioc->pcie_sg_lookup[i].pcie_sgl_dma);
-- 
2.53.0



