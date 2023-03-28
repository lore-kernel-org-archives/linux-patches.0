Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89CE8BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:01:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A0BC433D2;
	Tue, 28 Mar 2023 15:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015681;
	bh=kJGtXW913NxR9ujPQ1lLDOeN/nx0QlYnPK/7s7dsaZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A61hQwwusojqyFMWT/ifn/SZlOK8NY1v9OcM3Oq/2pjiRDtQZiuycbDABVrJs8kxu
	 dZ64B7hyq6NQJRgiLbr4Rq/GCjQGmUHBFv+IjLlsZU3yyMITEcU4n1Uinj4Ugz9U5f
	 vFtBslwcg2BO5bVjjmDnSH/gQPj6fAqvCOHAa9f8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 136/224] scsi: mpi3mr: Driver unload crashes host when enhanced logging is enabled
Date: Tue, 28 Mar 2023 16:42:12 +0200
Message-Id: <20230328142623.059757541@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit 5b06a7169c59ce0c77ef8b9c82aa07c478f82aac ]

Prevent driver from trying to dereference a NULL pointer in a debug print
while removing a device during driver unload.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Link: https://lore.kernel.org/r/20230228140835.4075-3-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 50263ba4f8428..90f61a0a8f4ef 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1549,7 +1549,8 @@ static void mpi3mr_sas_port_remove(struct mpi3mr_ioc *mrioc, u64 sas_address,
 
 	list_for_each_entry_safe(mr_sas_phy, next_phy,
 	    &mr_sas_port->phy_list, port_siblings) {
-		if ((mrioc->logging_level & MPI3_DEBUG_TRANSPORT_INFO))
+		if ((!mrioc->stop_drv_processing) &&
+		    (mrioc->logging_level & MPI3_DEBUG_TRANSPORT_INFO))
 			dev_info(&mr_sas_port->port->dev,
 			    "remove: sas_address(0x%016llx), phy(%d)\n",
 			    (unsigned long long)
-- 
2.39.2



