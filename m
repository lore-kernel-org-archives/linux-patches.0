Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4351586C4;
	Tue,  9 Jul 2024 11:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524595; cv=none; b=P1vM3oS7AZwYUKshFCXGVLByOB/fvsOZBYUD7pCQXFQSap37iRIKCZ4zSSE5qBZUW7v2Y2ADaiESMvTgAJAo+P9GfJAKm+0p3rwD1iG2G/c2coxKQ9QaV3f1gGvXBOJari/BUG91CFkjXN979avV8SWAZOwSaCoEnF9+9XbzYnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524595; c=relaxed/simple;
	bh=wkAiVATAsSevwtGFvyPQ9Y60xdEENiM3OGEMj0Yzv4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D50BNPLuH8Lxa1vE4ZMchiot6ktSomuhaKxGtQNCyqFRlA9Mpssep+wA9AZLwkZwuS5sp9G4DGXZPaOFhDVgqH9sSnElJ+mq5xSzRFIDw4/TXgNit7MlahrC4Agj9ArFaSnuLE+EkIgTizdd2jhjSiGGLDPI1CQboyO49OPObRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pqjoFeEv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pqjoFeEv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72356C3277B;
	Tue,  9 Jul 2024 11:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524594;
	bh=wkAiVATAsSevwtGFvyPQ9Y60xdEENiM3OGEMj0Yzv4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pqjoFeEvrvT4YcGO5VRLxVWAzN+54gWDSBHSNwDnAL6v5UHPlOvqAqAPPV5KeBsyL
	 oJguAHT0YUYo7vrgR3lPUxT102eXeCrcLm1Tb0xnpC6IQpbbUfbHtAUW6t2T2xRcdd
	 b09xaXcpTM4biEBaPm8PJ8N2xomkpfwmfS9O0DDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Henzl <thenzl@redhat.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/102] scsi: mpi3mr: Sanitise num_phys
Date: Tue,  9 Jul 2024 13:09:59 +0200
Message-ID: <20240709110652.778229417@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit 3668651def2c1622904e58b0280ee93121f2b10b ]

Information is stored in mr_sas_port->phy_mask, values larger then size of
this field shouldn't be allowed.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Link: https://lore.kernel.org/r/20240226151013.8653-1-thenzl@redhat.com
Acked-by: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 5748bd9369ff7..fc54844032aa8 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1355,11 +1355,21 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 	mpi3mr_sas_port_sanity_check(mrioc, mr_sas_node,
 	    mr_sas_port->remote_identify.sas_address, hba_port);
 
+	if (mr_sas_node->num_phys > sizeof(mr_sas_port->phy_mask) * 8)
+		ioc_info(mrioc, "max port count %u could be too high\n",
+		    mr_sas_node->num_phys);
+
 	for (i = 0; i < mr_sas_node->num_phys; i++) {
 		if ((mr_sas_node->phy[i].remote_identify.sas_address !=
 		    mr_sas_port->remote_identify.sas_address) ||
 		    (mr_sas_node->phy[i].hba_port != hba_port))
 			continue;
+
+		if (i > sizeof(mr_sas_port->phy_mask) * 8) {
+			ioc_warn(mrioc, "skipping port %u, max allowed value is %lu\n",
+			    i, sizeof(mr_sas_port->phy_mask) * 8);
+			goto out_fail;
+		}
 		list_add_tail(&mr_sas_node->phy[i].port_siblings,
 		    &mr_sas_port->phy_list);
 		mr_sas_port->num_phys++;
-- 
2.43.0



