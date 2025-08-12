Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6352868AF;
	Tue, 12 Aug 2025 17:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021044; cv=none; b=lPPC7gGFhCRWzmecVcH+rDMUMvaLeBp7/wVSU/ST3/p7hB6KaKP3Ubp+dbvSyk/LsHhUQqrG5L2C+62lRcdOZNaLZsdWCzkZlfCIlHt30Ii9ddy6bm660gh37kO3Ov6ik0oKEM0nXgTlIIakxPOUmniQyud/d5OmVwwrf4eG23s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021044; c=relaxed/simple;
	bh=tEnQJ+Y0sm6gPbJEyJRChsTqjJUsv0PEaMj02kQcbA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNxGqYpEjtducnY0WCryu5GoZ5vQak06amKhBnawiedgBcOXp+GZl2+GYIliy48Lq7JbQ5uhwJpTHnJPgyvY8WbLGKIFJRGZwW9lEOCtt6guHtyigj1oJ+INWMdy/zkp3C67Y8bpBHg90Myo5KaEqkovqltYnvK0gnz3B+GW1W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aLRdEwKY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aLRdEwKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0186C4CEF1;
	Tue, 12 Aug 2025 17:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021044;
	bh=tEnQJ+Y0sm6gPbJEyJRChsTqjJUsv0PEaMj02kQcbA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aLRdEwKYM4+fBRkz8kcBBKK3GqeZ6+vgCLJHHHh9AtluKF1q7OUMwLEUMBRMFC00a
	 5iL64MNi3sUi7MTZ7Ql3NSvK6qfuttdSj6W6lh339PrKAp5ATQG8hmbWD08Le/Bb4F
	 ILbVjNuizs7Plg/efgQbd5p8gLfnKhFtryil7ZeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seunghui Lee <sh043.lee@samsung.com>,
	Bean Huo <beanhuo@micron.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 203/253] scsi: ufs: core: Use link recovery when h8 exit fails during runtime resume
Date: Tue, 12 Aug 2025 19:29:51 +0200
Message-ID: <20250812172957.452869869@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Seunghui Lee <sh043.lee@samsung.com>

[ Upstream commit 35dabf4503b94a697bababe94678a8bc989c3223 ]

If the h8 exit fails during runtime resume process, the runtime thread
enters runtime suspend immediately and the error handler operates at the
same time.  It becomes stuck and cannot be recovered through the error
handler.  To fix this, use link recovery instead of the error handler.

Fixes: 4db7a2360597 ("scsi: ufs: Fix concurrency of error handler and other error recovery paths")
Signed-off-by: Seunghui Lee <sh043.lee@samsung.com>
Link: https://lore.kernel.org/r/20250717081213.6811-1-sh043.lee@samsung.com
Reviewed-by: Bean Huo <beanhuo@micron.com>
Acked-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index dc17ae1dfe26..f9adb1106747 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4125,7 +4125,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	hba->uic_async_done = NULL;
 	if (reenable_intr)
 		ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
-	if (ret) {
+	if (ret && !hba->pm_op_in_progress) {
 		ufshcd_set_link_broken(hba);
 		ufshcd_schedule_eh_work(hba);
 	}
@@ -4133,6 +4133,14 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	mutex_unlock(&hba->uic_cmd_mutex);
 
+	/*
+	 * If the h8 exit fails during the runtime resume process, it becomes
+	 * stuck and cannot be recovered through the error handler.  To fix
+	 * this, use link recovery instead of the error handler.
+	 */
+	if (ret && hba->pm_op_in_progress)
+		ret = ufshcd_link_recovery(hba);
+
 	return ret;
 }
 
-- 
2.39.5



