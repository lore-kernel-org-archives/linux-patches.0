Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61DC13D28F;
	Thu,  5 Sep 2024 10:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530423; cv=none; b=ZlLP7uUmwStZ9RcI3u4fCIiTK9Htof/issDHpV7J6EIPui5qMn4NsKIlUlqVDW0tnBEnOS4rWUZPqYhv56sFuyc7e/ksRmoRkZUnEjEcv9G4jhHQmXET9zzJ2DSgSVMP1O2gOzMKK4QZLZslLH8I9P0vtDeAkld8oaWr9iD7RXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530423; c=relaxed/simple;
	bh=Eo/uLFvV4q8axRMrYUcDsI/alShfErg2ct3Da5+Ah+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MODVMdTL7W/IFv93VqFW/hn2C3fK6S1HWzWeeLy58YtCwkuittYzN0grmFJTnI3U7vH6xulmtSPqSBXfCjeXr6P80v7tYjqWBj6S+3RhvNgTrDJ9PqJJU8l1drmtOGnDsYkzBGMFqRSNgj+lppdO+Kxekpy85pViGA9+cOL/9Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xWWH+tMd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xWWH+tMd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7E0C4CEC3;
	Thu,  5 Sep 2024 10:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530423;
	bh=Eo/uLFvV4q8axRMrYUcDsI/alShfErg2ct3Da5+Ah+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xWWH+tMdDYxztsePnAmxhdi81g6hSjAJciuwegi1sINVgWeYx3Qa8eNUUewqBqtzN
	 IejIAa86kJMkeQs7qyndPtkcyT5wB2XbteHwUbmAmQCHzNWLBofhZJ2QG95D+j/Ell
	 ueh7A2NV7sVP96Z5+TQR4XP1gL0whpz8PNdffYoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/101] scsi: ufs: core: Bypass quick recovery if force reset is needed
Date: Thu,  5 Sep 2024 11:40:34 +0200
Message-ID: <20240905093716.176378159@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bfed5d36fa2e5..d528ee0092bd2 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6307,7 +6307,8 @@ static void ufshcd_err_handler(struct work_struct *work)
 	if (ufshcd_err_handling_should_stop(hba))
 		goto skip_err_handling;
 
-	if (hba->dev_quirks & UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS) {
+	if ((hba->dev_quirks & UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS) &&
+	    !hba->force_reset) {
 		bool ret;
 
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
-- 
2.43.0



