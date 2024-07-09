Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772E614EC4D;
	Tue,  9 Jul 2024 11:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523707; cv=none; b=kj6jbvknAS5AMdSmQ/OfSP0CrSZa2sW+5Ku4bMYnRS0unMgvFMD8CtxI/w6U40qKz2DROF1tARnBdyYLnRJlS9Y5u/SeJMoWFuEu1dBT3qNayQy2bSNynhAvltqw0sggpd572gN9zkVNSecsiZ8ISeh4OJAdtFK+/GoC2WGB7oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523707; c=relaxed/simple;
	bh=Srrzh3DSqs5cZcK5MtsdJX0MlXxjkitrq1X6/O0w1yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PR4A5nurBAIxe4fwaT44CHWoDuS5SChP//q+KVgAbuX48d4xtUMZP7qmGv6Vptvte/eO3Nb4tVjcRVdZQLzanJb9cpdaYD49jpkSzGCB8wxgNHIs0PoJASJ4QUQEkSj/nle+EUpiVsGkbmEukbMoDpPkl/nUZM8sejj/PIOqp/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Jddb6ye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Jddb6ye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97AF0C3277B;
	Tue,  9 Jul 2024 11:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523707;
	bh=Srrzh3DSqs5cZcK5MtsdJX0MlXxjkitrq1X6/O0w1yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Jddb6yeZoPazk8ENwBgjn9zryXfinIO6JUKpuYoWJofC2fTWrN1fjwYPRNDYpsWM
	 2ciGwjrHSNT9SagPE2WwuH0PVPlaPq/2nYECK1gHE0NOP7yvas5mbD9qSu6H8ejS7q
	 pxY/I4K4RPiBLN1NMzYrh1/W5piOTo8HMTmY7Y/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Henzl <thenzl@redhat.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/139] scsi: mpi3mr: Sanitise num_phys
Date: Tue,  9 Jul 2024 13:09:10 +0200
Message-ID: <20240709110700.102988874@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 82b55e9557304..91c2f667a4c0b 100644
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



