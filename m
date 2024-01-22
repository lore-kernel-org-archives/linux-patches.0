Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FAB114A4C6;
	Tue, 23 Jan 2024 00:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969216; cv=none; b=LH6k/3eRkFE6Q3732IuwuvNYxuHOxILHay2D+W/6I3VYOQqoNk+fwUnUfdiJk5CDDURUHWll/6qidhXf8k/pPiVDi0ucsDa0naVa9X/mLBS5tLnekJbaMB7VIs9XE+8YK2ZcelUnsCelCwWPS9/9wJceBKROUcdmrDAOqMA0ZdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969216; c=relaxed/simple;
	bh=BEAfPGmCWuzIdTzstsbrX1WK9lxGfu57cczCaFriGNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dgkoozwqTotNmwNNn/iKqcVswO/fygRFy88rragUMtLQFmupDj08FRYfQ11gT8kN+dp3qDzvM7gQsmGGEblhlhMpO6OVw7soSXte8t8blgEn7UW1fYkB7oBcKgpuCo2cZscGr8qOXHhX9H/q6LXPJiDWXtNsad6u5gnV7d6mCfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u5dfz6bB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u5dfz6bB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C331FC433F1;
	Tue, 23 Jan 2024 00:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969215;
	bh=BEAfPGmCWuzIdTzstsbrX1WK9lxGfu57cczCaFriGNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u5dfz6bBMBXagzFyt+Km0jCOlcr79BlTOTugsabQk7m8V6IBg9EEwhHtvZRD9dHl0
	 pc9aUC+nkuNL6b/+PjSFplEysnBBWXx5P3vOnojF2/czydTN1S3vRjJaT6x0x1BB9k
	 qA0ZijlE/KjEnVCqzt8MZagAiW83Q22OTBG0JRBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Justin Tee <justin.tee@broadcom.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 104/641] scsi: lpfc: Fix list_entry null check warning in lpfc_cmpl_els_plogi()
Date: Mon, 22 Jan 2024 15:50:08 -0800
Message-ID: <20240122235821.295185059@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 1dec1311b9b6cc9c5fd26a77b936f542f03c51d1 ]

Smatch called out a warning for null checking a ptr that is assigned by
list_entry(). list_entry() does not return null and, if the list is empty,
can return an invalid ptr. Thus, the !psrp check does not execute properly.

 drivers/scsi/lpfc/lpfc_els.c:2133 lpfc_cmpl_els_plogi()
 warn: list_entry() does not return NULL 'prsp'

Replace list_entry() with list_get_first(), which does a list_empty() check
before returning the first entry.

Fixes: a3c3c0a806f1 ("scsi: lpfc: Validate ELS LS_ACC completion payload")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-scsi/01b7568f-4ab4-4d56-bfa6-9ecc5fc261fe@moroto.mountain/
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20231031191224.150862-4-justintee8345@gmail.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index f9627eddab08..0829fe6ddff8 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2128,8 +2128,8 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 						NLP_EVT_DEVICE_RM);
 	} else {
 		/* Good status, call state machine */
-		prsp = list_entry(cmdiocb->cmd_dmabuf->list.next,
-				  struct lpfc_dmabuf, list);
+		prsp = list_get_first(&cmdiocb->cmd_dmabuf->list,
+				      struct lpfc_dmabuf, list);
 		if (!prsp)
 			goto out;
 		if (!lpfc_is_els_acc_rsp(prsp))
-- 
2.43.0



