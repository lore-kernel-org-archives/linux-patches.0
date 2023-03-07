Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDEFBA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:32:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15D44C433EF;
	Tue,  7 Mar 2023 18:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213965;
	bh=F5++bf1knmKNFFjaAgCOOaiVC6PFMqAWS6Z0gfR4DFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EtB8OQKyWPmZgtQxmvNeqMgWxQ1YZNrOUmyR8u7sxneZKpitfTxmR2ixa4b+M5Vo6
	 /hUpPFxTwm/hbcU1mnVLx1zOiQy7GYvvGVbRak7G/UyA5TAmTipSr8RQN0szRQuze2
	 NKzHGF3IRa4Mf5jmAirDY+UPYLCz/URzaAdojk3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 678/885] scsi: mpi3mr: Fix missing mrioc->evtack_cmds initialization
Date: Tue,  7 Mar 2023 18:00:12 +0100
Message-Id: <20230307170031.577799713@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

commit e39ea831ebad4ab15c4748cb62a397a8abcca36e upstream.

Commit c1af985d27da ("scsi: mpi3mr: Add Event acknowledgment logic")
introduced an array mrioc->evtack_cmds but initialization of the array
elements was missed. They are just zero cleared. The function
mpi3mr_complete_evt_ack() refers host_tag field of the elements. Due to the
zero value of the host_tag field, the function calls clear_bit() for
mrico->evtack_cmds_bitmap with wrong bit index. This results in memory
access to invalid address and "BUG: KASAN: use-after-free". This BUG was
observed at eHBA-9600 firmware update to version 8.3.1.0. To fix it, add
the missing initialization of mrioc->evtack_cmds.

Link: https://lore.kernel.org/r/20230214005019.1897251-5-shinichiro.kawasaki@wdc.com
Cc: stable@vger.kernel.org
Fixes: c1af985d27da ("scsi: mpi3mr: Add Event acknowledgment logic")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Acked-by: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -4952,6 +4952,10 @@ mpi3mr_probe(struct pci_dev *pdev, const
 		mpi3mr_init_drv_cmd(&mrioc->dev_rmhs_cmds[i],
 		    MPI3MR_HOSTTAG_DEVRMCMD_MIN + i);
 
+	for (i = 0; i < MPI3MR_NUM_EVTACKCMD; i++)
+		mpi3mr_init_drv_cmd(&mrioc->evtack_cmds[i],
+				    MPI3MR_HOSTTAG_EVTACKCMD_MIN + i);
+
 	if (pdev->revision)
 		mrioc->enable_segqueue = true;
 


