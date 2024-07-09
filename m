Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F52158872;
	Tue,  9 Jul 2024 11:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524190; cv=none; b=d9/gHdGHq0ExhgzLPpth3ZxRJ6gRxuvGqGFsTujC2BZ2Cq3EoJVogKtOuiKFjiMPVgggWLCi6YjBHdv2mXNvrxlyKMxv4J0csPIr3h2a3pEsYgBqvstJy8AxZuNy6pnnZW2SE/HHpA8TBghI9OO4RE3DoiFIfpzfdSvFUcoOUxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524190; c=relaxed/simple;
	bh=ULrp4yKLmoBKep5NOLDz79kQln+ztT3hmuA/0fE9/x4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0EFXsS18UdLwL7kbox05Om3i13/rE40Ua0DNZpcqc2W9Z1Q2sG70M6qZzUjrS7SJ+6CP/JF/PT+h4BISIMWu4hWT1X4uowDG36ujrebwTLl/+Kop8voUFnTHN86yN171j3AY+i2Unh/URK0O1bX/4axGhR4xNrzVPJRciFcbfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H8le6l8r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H8le6l8r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B5BC3277B;
	Tue,  9 Jul 2024 11:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524190;
	bh=ULrp4yKLmoBKep5NOLDz79kQln+ztT3hmuA/0fE9/x4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H8le6l8ryrtAbejvNA/4H1a6Cl3E+JO0Mpw5Y9ltwI9XBbSpFxmxS55ITsIxZ9q5z
	 PcASpkLZ+z69EKe/mVMzEiskhNB2arxCkEbNqi2xBnaIx0thd7ER1i71fwISwSXiUi
	 dbOLvLTXrA0/VogCudyIvcKf4+3xnd1IZksWYb2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Henzl <thenzl@redhat.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 069/197] scsi: mpi3mr: Sanitise num_phys
Date: Tue,  9 Jul 2024 13:08:43 +0200
Message-ID: <20240709110711.632333195@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index d32ad46318cb0..7ca9a7c2709cf 100644
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



