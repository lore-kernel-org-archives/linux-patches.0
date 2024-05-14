Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F01134CFE;
	Tue, 14 May 2024 10:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682865; cv=none; b=AoabBCwcz2nQUU5zwOqpvBRjFh/YqnypxW+FsiCt6HZw4HWXZldTeb/fGkjSzZPVNTOGkO53NZmqbXmhSWAFeqc7eAVsg0SCPdM3/RtksnL3ZLat3iGFUbfMOcHGfDNX9fiSMcKktRhOgqFsI6JR64VBk8CvkO53EGeqWkZUMc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682865; c=relaxed/simple;
	bh=FvA3XY1LD+JY68OKYbqS+Gojq6B0u+7cOX1A4jpRGpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9w7QsZPD2V3nQIYbb6TaBtLpBEV30wJ9DCIN83h5LS4nzEGJIYe7Quar2p3MxURQ72tsP7DYKBc9+s7OQ0CKLtMj9fEDkEXxPbZ2dAL7LwDo79/ZWGaoGOctC3n+A2fB1UOm10bxww2/XRSGiKUsqebZBd4klK/TzifRPks7jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OcXt5UtB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OcXt5UtB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D4BC2BD10;
	Tue, 14 May 2024 10:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682865;
	bh=FvA3XY1LD+JY68OKYbqS+Gojq6B0u+7cOX1A4jpRGpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OcXt5UtB/FGu9Cndi3PCbQ/AvVmLpbuzvt++2QoeHIN1b7lC4K0QoEmytsN4jPhgD
	 mwc6CiyQ97stJq1KyDnoFaEiUbmfYexKVWgIocsD1SlhyTlVSOKU/sA9fs01j5QVM1
	 b7tfK4tN7Vz+n7D/wAri3vkQXtjQHCII3MPcxPys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 125/336] scsi: ufs: core: Fix MCQ mode dev command timeout
Date: Tue, 14 May 2024 12:15:29 +0200
Message-ID: <20240514101043.322014375@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit 2a26a11e9c258b14be6fd98f8a85f20ac1fff66e ]

When a dev command times out in MCQ mode, a successfully cleared command
should cause a retry. However, because we currently return 0, the caller
considers the command a success which causes the following error to be
logged: "Invalid offset 0x0 in descriptor IDN 0x9, length 0x0".

Retry if clearing the command was successful.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Link: https://lore.kernel.org/r/20240328111244.3599-1-peter.wang@mediatek.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 14a6a100fcdb0..4a07a18cf835d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3172,7 +3172,9 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 
 		/* MCQ mode */
 		if (is_mcq_enabled(hba)) {
-			err = ufshcd_clear_cmd(hba, lrbp->task_tag);
+			/* successfully cleared the command, retry if needed */
+			if (ufshcd_clear_cmd(hba, lrbp->task_tag) == 0)
+				err = -EAGAIN;
 			hba->dev_cmd.complete = NULL;
 			return err;
 		}
-- 
2.43.0



