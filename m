Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C57BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:41:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9AC6C433D2;
	Tue,  7 Mar 2023 18:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214504;
	bh=vjZ31sDsRcgXFQ4FDRQUHViLyzADXzSFw+T/NB9LhyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RycpOahb2Yz2rUgKjqgPWvO1msOOdn3HT4b/rxL/GY6ck72RWAn62Q+8tv3VIEizW
	 F9lo8MtxyiN5jvrpJyHacctut0qDHPCl+j7Cv7nLdEqnlx7aLnR9KQxTvRbXdwh5+i
	 9wvPjmcSaQpAqAPFIcUQBvFTD8G+ddYnNa6THjH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quinn Tran <qutran@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 845/885] scsi: qla2xxx: Fix link failure in NPIV environment
Date: Tue,  7 Mar 2023 18:02:59 +0100
Message-Id: <20230307170038.532410612@linuxfoundation.org>
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

From: Quinn Tran <qutran@marvell.com>

commit b1ae65c082f74536ec292b15766f2846f0238373 upstream.

User experienced symptoms of adapter failure in NPIV environment. NPIV
hosts were allowed to trigger chip reset back to back due to NPIV link
state being slow to come online.

Fix link failure in NPIV environment by removing NPIV host from directly
being able to perform chip reset.

 kernel: qla2xxx [0000:04:00.1]-6009:261: Loop down - aborting ISP.
 kernel: qla2xxx [0000:04:00.1]-6009:262: Loop down - aborting ISP.
 kernel: qla2xxx [0000:04:00.1]-6009:281: Loop down - aborting ISP.
 kernel: qla2xxx [0000:04:00.1]-6009:285: Loop down - aborting ISP

Fixes: 0d6e61bc6a4f ("[SCSI] qla2xxx: Correct various NPIV issues.")
Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7448,7 +7448,7 @@ qla2x00_timer(struct timer_list *t)
 
 		/* if the loop has been down for 4 minutes, reinit adapter */
 		if (atomic_dec_and_test(&vha->loop_down_timer) != 0) {
-			if (!(vha->device_flags & DFLG_NO_CABLE)) {
+			if (!(vha->device_flags & DFLG_NO_CABLE) && !vha->vp_idx) {
 				ql_log(ql_log_warn, vha, 0x6009,
 				    "Loop down - aborting ISP.\n");
 


