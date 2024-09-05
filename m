Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B5C198822;
	Thu,  5 Sep 2024 09:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530013; cv=none; b=XwErSjGBhVmufc86HZ7hcswTb3AXI8kfqQ+ulonC4s/D4WB/gUxVK2B+AePjza00SgHfzOkHavwBJGy5RNfDhBTvc990jsQn6WAEQF86rDu6DIZGJnWhJkn31kg4KljUy1KARZ1u3pN7wyMy1f61NUdoFVmJSQ+cBgrHri/m/+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530013; c=relaxed/simple;
	bh=qFB2KDThUZ1XIHJxgeNddAjbaK/vlxOFJDqwJ1txLC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EV8b5/KX+ML2fF21ctO8aSP14YXjwmSU+6SC+VaiHfiwEz4TImIcGd7td7BDfz7VBmnc/NyVI9g5CfJlDWEWDMzD0zAH9piSMIED/tmfvHkGP9UeQNrPSaQrspjC2aWYgH3ipqSfOb2zbBkKfbOIDrw0LNx7Pnccqy6dPn5DIZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GmnfKuhE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GmnfKuhE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F29FC4CEC3;
	Thu,  5 Sep 2024 09:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530013;
	bh=qFB2KDThUZ1XIHJxgeNddAjbaK/vlxOFJDqwJ1txLC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GmnfKuhE5/bNPH1DdpeURHKpFXt3n1OLSJNXcXnlMEwLYlgk5F8PIFT2GvVBBjvQ8
	 7Vgr0loEXJN/S7Y7i76pO1sYwUrtcTMuAVNPVddlPlXmJUQZ0nMH8yIy+lRx4EtajI
	 LYuVEvH919BMx/m7Uc/Sp+H1+rzgleX40m29wTBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 004/132] scsi: ufs: core: Bypass quick recovery if force reset is needed
Date: Thu,  5 Sep 2024 11:39:51 +0200
Message-ID: <20240905093722.406169380@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bfa9f457f24ea..ad0ef5b6b8cf9 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6467,7 +6467,8 @@ static void ufshcd_err_handler(struct work_struct *work)
 	if (ufshcd_err_handling_should_stop(hba))
 		goto skip_err_handling;
 
-	if (hba->dev_quirks & UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS) {
+	if ((hba->dev_quirks & UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS) &&
+	    !hba->force_reset) {
 		bool ret;
 
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
-- 
2.43.0



