Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDF21C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:08:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29AFC433EF;
	Mon, 20 Mar 2023 15:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324909;
	bh=w/EVluFcOFBdtYa+rB/fHuaoQlj8JQPiqBjehzQCaek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DGa4WQ/su2lR3CX0RRHjAyLW3QSCJVOp1fab9CCr01ATniksOCgzqZAU4sNxFbGL6
	 W7pTdzl0xaVGUo/5GqyBTFUCzrCy6SNCRjuVqK3JN1MhqkOM8jWHTtF05nyiTY6vuM
	 Vybluqt+mecX/cPCqptv8035zAEUzpMq/3ceFJRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Henzl <thenzl@redhat.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 019/198] scsi: mpi3mr: Fix sas_hba.phy memory leak in mpi3mr_remove()
Date: Mon, 20 Mar 2023 15:52:37 +0100
Message-Id: <20230320145508.308156701@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit d4caa1a4255cc44be56bcab3db2c97c632e6cc10 ]

Free mrioc->sas_hba.phy at .remove.

Fixes: 42fc9fee116f ("scsi: mpi3mr: Add helper functions to manage device's port")
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Link: https://lore.kernel.org/r/20230302234336.25456-5-thenzl@redhat.com
Acked-by: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 5032b0b5186d4..5698e7b90f852 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5127,6 +5127,12 @@ static void mpi3mr_remove(struct pci_dev *pdev)
 	}
 	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
 
+	if (mrioc->sas_hba.num_phys) {
+		kfree(mrioc->sas_hba.phy);
+		mrioc->sas_hba.phy = NULL;
+		mrioc->sas_hba.num_phys = 0;
+	}
+
 	spin_lock(&mrioc_list_lock);
 	list_del(&mrioc->list);
 	spin_unlock(&mrioc_list_lock);
-- 
2.39.2



