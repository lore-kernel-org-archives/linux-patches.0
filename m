Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B13C194A60;
	Thu,  5 Sep 2024 09:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529409; cv=none; b=WIprg/EV+KVr9w0DEpZDiHxQau6rbACPTAPItT7AgrOMW3IhJtSBsqptmWaNiUtofVS0zR8Sfm6l8/a+kv+8Hoqh9z9k8m1VjNczP9KatHT2eg2jMrHCyPetstRa4SqJslstwWn7+IkIXr5+iG3mtuWZBDZYbQZVNd6XLFNUnqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529409; c=relaxed/simple;
	bh=BlOWywFfkU2AI7BrMR8MuzORiJ3rcywimgS98E9eWlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o4XtHOy1gE0E9n61NaD2jcvG6mezvvlDxBPPuxfNwnxzMbvaVgZEV5wELYZ5fXE7I3zoxSEQn7caHiV4/3DmrQAhDuLhXJi4DLhD4M6QT6q67VIAOXv0RP4UOmgiT0Jz4AGKG1/mzxLiGxllJdDbe1eUiq3z4GCBqDSEhzIYqbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BXTMn5h8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BXTMn5h8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC69C4CEC3;
	Thu,  5 Sep 2024 09:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529409;
	bh=BlOWywFfkU2AI7BrMR8MuzORiJ3rcywimgS98E9eWlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BXTMn5h8BCZPGn469OIiobQWAp8sRgj1acOyF8CGcoG2FRi/89Bu3MUA3ZM/DguDu
	 +yMnqCJLjqsqKWF5v0UUxVsPMgOIEMcbidsiPrK/hVkuskpOIerhJbMg64h6e6mdpo
	 ArU/Eu5/q+/ztJEUDniQYU6FxUaqigpa2VC95zlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 004/184] scsi: ufs: core: Bypass quick recovery if force reset is needed
Date: Thu,  5 Sep 2024 11:38:37 +0200
Message-ID: <20240905093732.415104744@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit 022587d8aec3da1d1698ddae9fb8cfe35f3ad49c ]

If force_reset is true, bypass quick recovery.  This will shorten error
recovery time.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Link: https://lore.kernel.org/r/20240712094506.11284-1-peter.wang@mediatek.com
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index aab8db54a3141..91bfdc17eedb3 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6560,7 +6560,8 @@ static void ufshcd_err_handler(struct work_struct *work)
 	if (ufshcd_err_handling_should_stop(hba))
 		goto skip_err_handling;
 
-	if (hba->dev_quirks & UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS) {
+	if ((hba->dev_quirks & UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS) &&
+	    !hba->force_reset) {
 		bool ret;
 
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
-- 
2.43.0



