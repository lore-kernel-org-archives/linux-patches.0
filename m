Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46155272E7C;
	Tue, 11 Nov 2025 01:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823961; cv=none; b=u2nCeemYujq2Gffzo2ss1VfoS4WBCYNUj8etz1ataG+FVsfP1emOTB2nuMYDz1M6OC4VG8XNAtuD5V4qNB4FZAxmiu1KzzPpaV+mS4B3VcIdjYSXRAD/VTUf/0M69EejpbnwQ2RqN8GZPkO4cjQhJnyvGyJQHL6nniZEx4+zggA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823961; c=relaxed/simple;
	bh=ekX3ODG7w98dyd2A5F9iHRXBIox3VoUZKzhRWv7f9GE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DbDZBavyhGigvrO3gAeDwLWBnmN3uSdqD3ingdT05sx1rWbAXBPQpGK3bxoF0lCxk8eyxb6dCwdeGmdIoJgi2Ie5jDHDijxmeu0g+nWMicpP9ep+kOWUEEY9m1LrT1G8SBSECpDtmr45MnkWwctl8yEUQdTu7VbH01kBJtz2tn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NoivM7jU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NoivM7jU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF62C4AF09;
	Tue, 11 Nov 2025 01:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823961;
	bh=ekX3ODG7w98dyd2A5F9iHRXBIox3VoUZKzhRWv7f9GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NoivM7jUde0W9yfhEebBGLJHFUoXNhkNmw9VBbPtnlXQQ17L9pylKf/Mb0P1hiQJP
	 Mhcuo9ysPncK1TyQVSq76h4GmUwSGFS2haiSSS3D+k356whHBe+OFWNqufO5CG/8Md
	 Kdz34hw8BPAT0jggw5ibmwf3vfZ2ROfnaX9Tveys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 322/565] scsi: ufs: host: mediatek: Enhance recovery on resume failure
Date: Tue, 11 Nov 2025 09:42:58 +0900
Message-ID: <20251111004534.129637046@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit 15ef3f5aa822f32524cba1463422a2c9372443f0 ]

Improve the recovery process for failed resume operations. Log the
device's power status and return 0 if both resume and recovery fail to
prevent I/O hang.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-mediatek.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 2be74662f960b..7d7664f5b72a5 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1564,8 +1564,21 @@ static int ufs_mtk_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	}
 
 	return 0;
+
 fail:
-	return ufshcd_link_recovery(hba);
+	/*
+	 * Check if the platform (parent) device has resumed, and ensure that
+	 * power, clock, and MTCMOS are all turned on.
+	 */
+	err = ufshcd_link_recovery(hba);
+	if (err) {
+		dev_err(hba->dev, "Device PM: req=%d, status:%d, err:%d\n",
+			hba->dev->power.request,
+			hba->dev->power.runtime_status,
+			hba->dev->power.runtime_error);
+	}
+
+	return 0; /* Cannot return a failure, otherwise, the I/O will hang. */
 }
 
 static void ufs_mtk_dbg_register_dump(struct ufs_hba *hba)
-- 
2.51.0



