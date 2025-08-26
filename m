Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7881C3314;
	Tue, 26 Aug 2025 13:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215924; cv=none; b=CYii46WJ9zaIrecX9P36kRALEGokwIdF34nWLcSx93dhGo2QBA7J3JKRs4sGfj17KQa7FaAeNzr6l47HN2oGn5wORB+SBRvoi72Pw99qbH99gAKVL0CYnBWWB2ql/8bHkQLeY2D6CEfnH9u2hCsvWRyogadd2hQaWUbAm9yAl0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215924; c=relaxed/simple;
	bh=do78yapjhVG6MXfnLdGDJSHRhZJvm7rojZqM/pR71Lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JofXqPzW7kd8eoFI2jUVUoyzUmai+VaEtQ+NEGtCFB4mPoBeq2BkKkiphvLaIGv/OaQqpR8itVtceURVfFwPughdjuAlTY7DtvCemGx239n+xn0T8xLV1drY27pX6Yt8oSWyjpYg8jUPFsFNkVeUSCdKrQ11XGEt5NfwvD+nqWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HeB336BD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HeB336BD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2400CC4CEF1;
	Tue, 26 Aug 2025 13:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215924;
	bh=do78yapjhVG6MXfnLdGDJSHRhZJvm7rojZqM/pR71Lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HeB336BD3PNTy/pgnThINucWfi+yBUyYvNPQGvsxVBMPE+XzZT2EqmG1xa71/YVZI
	 lCWj1mGlwNp5dY3+LPBFbLdRm77RvE49dypKATmb37cjf2Qr1I1MJTMqE02e93vSzp
	 viIJZ+GG/EBD7Dbco/EsBl3oO0LCRrY2i13blfAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Henzl <thenzl@redhat.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 217/644] scsi: mpt3sas: Fix a fw_event memory leak
Date: Tue, 26 Aug 2025 13:05:08 +0200
Message-ID: <20250826110951.807452711@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit 3e90b38781e3bdd651edaf789585687611638862 ]

In _mpt3sas_fw_work() the fw_event reference is removed, it should also
be freed in all cases.

Fixes: 4318c7347847 ("scsi: mpt3sas: Handle NVMe PCIe device related events generated from firmware.")
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Link: https://lore.kernel.org/r/20250723153018.50518-1-thenzl@redhat.com
Acked-by: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index bbef78608a67..055929021818 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -10806,8 +10806,7 @@ _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 		break;
 	case MPI2_EVENT_PCIE_TOPOLOGY_CHANGE_LIST:
 		_scsih_pcie_topology_change_event(ioc, fw_event);
-		ioc->current_event = NULL;
-		return;
+		break;
 	}
 out:
 	fw_event_work_put(fw_event);
-- 
2.39.5



