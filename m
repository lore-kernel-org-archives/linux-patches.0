Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E276746F
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1C4C433CD;
	Sun, 17 Sep 2023 20:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982472;
	bh=GRy9kUqjXUS0nN33BgiuzWQkSM1me98uUmQje/eS0S8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xtvCtTQ7ItuNHev2JJh+fXPQT2Dy9mO6YnIzzmMSDIioG5oYdVu7LvZEOmKW19nNW
	 CV3fbWZwmpSOIPB5rc9k1Sydq/uPW/cB567h6+WCDHfaH6rA+f4LyK1Y+D/fBOIRt1
	 vqEdj0aQW7jCnVDDYZsg/FZEqnW3VmLFVoIhZBT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurav Kashyap <skashyap@marvell.com>,
	Rob Evers <revers@redhat.com>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	David Laight <David.Laight@ACULAB.COM>,
	Jozef Bacik <jobacik@redhat.com>,
	Laurence Oberman <loberman@redhat.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	linux-scsi@vger.kernel.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Oleksandr Natalenko <oleksandr@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 261/511] scsi: qedf: Do not touch __user pointer in qedf_dbg_debug_cmd_read() directly
Date: Sun, 17 Sep 2023 21:11:28 +0200
Message-ID: <20230917191120.138650155@linuxfoundation.org>
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

From: Oleksandr Natalenko <oleksandr@redhat.com>

[ Upstream commit 31b5991a9a91ba97237ac9da509d78eec453ff72 ]

The qedf_dbg_debug_cmd_read() function invokes sprintf() directly on a
__user pointer, which may crash the kernel.

Avoid doing that by using a small on-stack buffer for scnprintf() and then
calling simple_read_from_buffer() which does a proper copy_to_user() call.

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Link: https://lore.kernel.org/lkml/20230724120241.40495-1-oleksandr@redhat.com/
Link: https://lore.kernel.org/linux-scsi/20230726101236.11922-1-skashyap@marvell.com/
Cc: Saurav Kashyap <skashyap@marvell.com>
Cc: Rob Evers <revers@redhat.com>
Cc: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Jozef Bacik <jobacik@redhat.com>
Cc: Laurence Oberman <loberman@redhat.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com
Cc: linux-scsi@vger.kernel.org
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Acked-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Oleksandr Natalenko <oleksandr@redhat.com>
Link: https://lore.kernel.org/r/20230731084034.37021-3-oleksandr@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedf/qedf_debugfs.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_debugfs.c b/drivers/scsi/qedf/qedf_debugfs.c
index 3eb4334ac6a32..1c5716540e465 100644
--- a/drivers/scsi/qedf/qedf_debugfs.c
+++ b/drivers/scsi/qedf/qedf_debugfs.c
@@ -138,15 +138,14 @@ qedf_dbg_debug_cmd_read(struct file *filp, char __user *buffer, size_t count,
 			loff_t *ppos)
 {
 	int cnt;
+	char cbuf[32];
 	struct qedf_dbg_ctx *qedf_dbg =
 				(struct qedf_dbg_ctx *)filp->private_data;
 
 	QEDF_INFO(qedf_dbg, QEDF_LOG_DEBUGFS, "debug mask=0x%x\n", qedf_debug);
-	cnt = sprintf(buffer, "debug mask = 0x%x\n", qedf_debug);
+	cnt = scnprintf(cbuf, sizeof(cbuf), "debug mask = 0x%x\n", qedf_debug);
 
-	cnt = min_t(int, count, cnt - *ppos);
-	*ppos += cnt;
-	return cnt;
+	return simple_read_from_buffer(buffer, count, ppos, cbuf, cnt);
 }
 
 static ssize_t
-- 
2.40.1



