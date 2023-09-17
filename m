Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA586FB5
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:34:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EABDC433C8;
	Sun, 17 Sep 2023 20:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982888;
	bh=MnC638qkiLvcdOAJ2ufXxqF+65DxUE3xhsSPjPoikQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=prCr2FNG3zhhZVfiNN3qmYCYK9FF4NoJE4Lnc3kcMR5/jTNNR4Fgy4b4ot2/gVMfC
	 TG0gALks3QmXHM11EraU2/qzo6PbLOuf59xDqBHITC8+Mt4G/pmHk5eG3mEn1HLYwN
	 0bXZDZA6p2ws/urBokwNSiWLc4Yx8RAgoxAO/61c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quinn Tran <qutran@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 383/511] scsi: qla2xxx: Fix session hang in gnl
Date: Sun, 17 Sep 2023 21:13:30 +0200
Message-ID: <20230917191123.047774681@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quinn Tran <qutran@marvell.com>

commit 39d22740712c7563a2e18c08f033deeacdaf66e7 upstream.

Connection does not resume after a host reset / chip reset. The cause of
the blockage is due to the FCF_ASYNC_ACTIVE left on. The gnl command was
interrupted by the chip reset. On exiting the command, this flag should be
turn off to allow relogin to reoccur. Clear this flag to prevent blockage.

Cc: stable@vger.kernel.org
Fixes: 17e64648aa47 ("scsi: qla2xxx: Correct fcport flags handling")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20230714070104.40052-7-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_init.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1136,7 +1136,7 @@ int qla24xx_async_gnl(struct scsi_qla_ho
 	u16 *mb;
 
 	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
-		return rval;
+		goto done;
 
 	ql_dbg(ql_dbg_disc, vha, 0x20d9,
 	    "Async-gnlist WWPN %8phC \n", fcport->port_name);
@@ -1190,8 +1190,9 @@ int qla24xx_async_gnl(struct scsi_qla_ho
 done_free_sp:
 	/* ref: INIT */
 	kref_put(&sp->cmd_kref, qla2x00_sp_release);
+	fcport->flags &= ~(FCF_ASYNC_SENT);
 done:
-	fcport->flags &= ~(FCF_ASYNC_ACTIVE | FCF_ASYNC_SENT);
+	fcport->flags &= ~(FCF_ASYNC_ACTIVE);
 	return rval;
 }
 


