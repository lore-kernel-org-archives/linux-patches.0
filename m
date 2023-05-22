Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7115E168D1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1323C4339B;
	Mon, 22 May 2023 19:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783541;
	bh=f84D5WyFdSwh29Ao5yQKxvAWap/3U4GPVj/72rrimQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gv4SppWxn/ZT9AimRTnD8uGknv2ggyJahRDlePPP6YuqjPW2BonLOMCezRoYguw26
	 CDLOVOwI6DFTZjId0iE0E5hVk8LAzSy1thYeae8KYSfpdqtibBGGh8ugk7pcF5gYzI
	 XNHwGu2q1PTqWvAxAaeBRPCdgujSzGlMed/IaFrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 078/292] scsi: lpfc: Prevent lpfc_debugfs_lockstat_write() buffer overflow
Date: Mon, 22 May 2023 20:07:15 +0100
Message-Id: <20230522190407.920755489@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit c6087b82a9146826564a55c5ca0164cac40348f5 ]

A static code analysis tool flagged the possibility of buffer overflow when
using copy_from_user() for a debugfs entry.

Currently, it is possible that copy_from_user() copies more bytes than what
would fit in the mybuf char array.  Add a min() restriction check between
sizeof(mybuf) - 1 and nbytes passed from the userspace buffer to protect
against buffer overflow.

Link: https://lore.kernel.org/r/20230301231626.9621-2-justintee8345@gmail.com
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index f5252e45a48a2..3e365e5e194a2 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -2157,10 +2157,13 @@ lpfc_debugfs_lockstat_write(struct file *file, const char __user *buf,
 	char mybuf[64];
 	char *pbuf;
 	int i;
+	size_t bsize;
 
 	memset(mybuf, 0, sizeof(mybuf));
 
-	if (copy_from_user(mybuf, buf, nbytes))
+	bsize = min(nbytes, (sizeof(mybuf) - 1));
+
+	if (copy_from_user(mybuf, buf, bsize))
 		return -EFAULT;
 	pbuf = &mybuf[0];
 
@@ -2181,7 +2184,7 @@ lpfc_debugfs_lockstat_write(struct file *file, const char __user *buf,
 			qp->lock_conflict.wq_access = 0;
 		}
 	}
-	return nbytes;
+	return bsize;
 }
 #endif
 
-- 
2.39.2



