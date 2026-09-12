Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDD0356744;
	Sat, 12 Sep 2026 11:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211207; cv=none; b=cDtbYmz7YkpKoEG3kR2xrGTPtZN8NWVdQ1CBn0mXCsXtB/IV3I5b2WkK02aw7/yB5J4u2KkFQrf3zMvq6JuK8paXg5CeMuH7VQ5fnrMPqUGBIh1WSe1p0U+SDXdM5wk5A2EKnmN+Q5uN4kxa0LYw6cyRTuemOMr9fznHMLW+0N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211207; c=relaxed/simple;
	bh=9jzpPaPD/9YKaxTyPGFWWaA8vhz7RJYoUDVoHlt3lfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bjHmxJRBSai+PLd31LA9FsHRxvXdl69gIoBwLuL8I7nob5suFq317iXu5/5I0Ap8ps0XHUUqfwr+TX3nP1vNDPPJCXEFmeBYYTBWkG4VXeyp0fLYzOEBRVy+nTs5RAYjtFiqxxk3XGQOo/YIa/mkDsL0ELvXn9Ywu8xUT3CoHRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yvrhTBZk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yvrhTBZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA8C1F000FF;
	Sat, 12 Sep 2026 11:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211205;
	bh=uZ7ZHn4pL5ync2SZ/Ohx2DwvVUHZCHTa+uIE7gtcVV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yvrhTBZkP7DWwi41J3yXTQyVXRBskAumlp1Sl0zz/OUQI07WMEnkLj9FrQcEf+rUd
	 WlzTJUszYHfmCeuaUAC0ugjdveXgHjG970XVRZN0u1IWViI4TQVp8d/yh6YJWL8CxS
	 09f3gH4/wCWpAhbVe6xPHCgyuMYDd6+E/82FX6/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurence Oberman <loberman@redhat.com>,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1182/1518] scsi: mpt3sas: Avoid freeing unallocated PCIe SGL buffers
Date: Sat, 12 Sep 2026 08:55:51 +0200
Message-ID: <20260912065650.216171251@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0d652db8fe249..55888ac6ed3a5 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5871,6 +5871,8 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 
 	if (ioc->pcie_sgl_dma_pool) {
 		for (i = 0; i < ioc->scsiio_depth; i++) {
+			if (!ioc->pcie_sg_lookup[i].pcie_sgl)
+				continue;
 			dma_pool_free(ioc->pcie_sgl_dma_pool,
 					ioc->pcie_sg_lookup[i].pcie_sgl,
 					ioc->pcie_sg_lookup[i].pcie_sgl_dma);
-- 
2.53.0



