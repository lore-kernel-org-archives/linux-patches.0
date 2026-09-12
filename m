Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04245303A35;
	Sat, 12 Sep 2026 16:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231490; cv=none; b=CsbcLsLc+mNgZtd4pY628Gkqb/1rGURjkIpVC7skfrRvQz9j76E8LX3X2BIJRmTp47xvAkNI4bh00egDgewXPtbFpZFynmKwAM+knjM3FX/O9lTbVuutSIgfJLECpKIQu0eOuibJPKsNocTqIenA4Jf85wH/U7r9FZmE3JZ8WHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231490; c=relaxed/simple;
	bh=lgdFLQ3uB2eegReF2ztPnA7KXl2f2Pl3XkLPas0Kd6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sv8Q9uYTY7/I5MsK36GKXWKuPA/45/A7MJ7HNf2KXQTZr6hNYbin1fLDv75H7i4yAib0pB6U/nQ7pIeAHo9QmcgoNSlY3S0OWUYdcSsQzFxLtBeGwAC/6UoYkhFRINAerafaUh4FAZz6OkFqxQGr3RdZyw/9djEGY3GgqqgKlNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UDxRPO0+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UDxRPO0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81061F000FF;
	Sat, 12 Sep 2026 16:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231488;
	bh=8YsFGOORGCdEyGdI2flrlPR0ns/5vvHPaBDWLEXv26I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UDxRPO0++LzajxGQwnEMQpjOw/J3EWpfWZneAn61is5nWiFoM3cVEv5l5BbpGNiBL
	 1OBVPmQaiTwCReM2sUElKpaNuQ/YK7Aukpcsp33ymQBm1ik8F95w5tc4QmcTH242gw
	 xSahdQtb+1ZtXNNrrQJvG/NRYAPpUxy2fx2MK31Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurence Oberman <loberman@redhat.com>,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1007/1191] scsi: mpt3sas: Avoid freeing unallocated PCIe SGL buffers
Date: Sat, 12 Sep 2026 09:02:15 +0200
Message-ID: <20260912065610.813530086@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b5a3694bfe7f2..479682770ee51 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5874,6 +5874,8 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 
 	if (ioc->pcie_sgl_dma_pool) {
 		for (i = 0; i < ioc->scsiio_depth; i++) {
+			if (!ioc->pcie_sg_lookup[i].pcie_sgl)
+				continue;
 			dma_pool_free(ioc->pcie_sgl_dma_pool,
 					ioc->pcie_sg_lookup[i].pcie_sgl,
 					ioc->pcie_sg_lookup[i].pcie_sgl_dma);
-- 
2.53.0



