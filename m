Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E92BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:57:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC84C433EF;
	Tue,  7 Mar 2023 17:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211825;
	bh=NHhv3g9+OSvN9hM9xG0k4ueiKgiEq4qG/nSu1rEjSLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WDVjJp+UaxmhHt3cQyQLY1zZdwuCQhyzs/snQU0Y/ez90rPTY6Ri3WIO+ki8FJD/r
	 g0xZgt7apRWWPubK3Rez78Et6zOCwikTjwpJ4qyzYEhmurnbSJqF0rxtQZ0x/HUcUs
	 c4x1LL7TqWjSY5tNMZ6h76U//cWVAuH/R5PRP5pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quinn Tran <qutran@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.2 0962/1001] scsi: qla2xxx: Fix erroneous link down
Date: Tue,  7 Mar 2023 18:02:14 +0100
Message-Id: <20230307170103.947444130@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

commit 3fbc74feb642deb688cc97f76d40b7287ddd4cb1 upstream.

If after an adapter reset the appearance of link is not recovered, the
devices are not rediscovered.  This is result of a race condition between
adapter reset (abort_isp) and the topology scan.  During adapter reset, the
ABORT_ISP_ACTIVE flag is set.  Topology scan usually occurred after adapter
reset.  In this case, the topology scan came earlier than usual where it
ran into problem due to ABORT_ISP_ACTIVE flag was still set.

kernel: qla2xxx [0000:13:00.0]-1005:1: Cmd 0x6a aborted with timeout since ISP Abort is pending
kernel: qla2xxx [0000:13:00.0]-28a0:1: MBX_GET_PORT_NAME failed, No FL Port.
kernel: qla2xxx [0000:13:00.0]-286b:1: qla2x00_configure_loop: exiting normally. local port wwpn 51402ec0123d9a80 id 012300)
kernel: qla2xxx [0000:13:00.0]-8017:1: ADAPTER RESET SUCCEEDED nexus=1:0:15.

Allow adapter reset to complete before any scan can start.

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_os.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7094,9 +7094,12 @@ qla2x00_do_dpc(void *data)
 			}
 		}
 loop_resync_check:
-		if (test_and_clear_bit(LOOP_RESYNC_NEEDED,
+		if (!qla2x00_reset_active(base_vha) &&
+		    test_and_clear_bit(LOOP_RESYNC_NEEDED,
 		    &base_vha->dpc_flags)) {
-
+			/*
+			 * Allow abort_isp to complete before moving on to scanning.
+			 */
 			ql_dbg(ql_dbg_dpc, base_vha, 0x400f,
 			    "Loop resync scheduled.\n");
 


