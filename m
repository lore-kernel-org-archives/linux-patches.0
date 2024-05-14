Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7AE13AD16;
	Tue, 14 May 2024 11:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685018; cv=none; b=Hbi74S14OxFCNupeq2WbibJQYZ8QbQaRTXnE17bH1mx7ro0+SBtd0/SBbVU0sXT4eDR7nMfAPLcITi1CrWtNgD3m2d5GRaQcI22Wk+G3Xbi9w26QP3ErJ6nPGadWrEHwZTsfwZKJIqQpFXRuXOkxw9ZB4ZvaFH6HaCCneMqna+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685018; c=relaxed/simple;
	bh=HvzTGwpkIsPYSUamkNtNMFpn7w+dLvK9BavdEgAN7rM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3QaXjv6N0/AQbmlTwJvY7GtjbqL6HC1gugjlXOF7LDo+bvFtglzdKAwajsiL016DQFPYb1uWjIY60glFcgE2O+Rp5ZkchSbtGTR7+UPy1h4ACwp4jqLN9cxIjKEV1oWTNZU60X+GOs1NfbqAF3XvcjxWekJekxi6hvMhQmM0Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RhuwHGDn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RhuwHGDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1820C2BD10;
	Tue, 14 May 2024 11:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685018;
	bh=HvzTGwpkIsPYSUamkNtNMFpn7w+dLvK9BavdEgAN7rM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RhuwHGDnIIyaSyibuVpf/jSo3l/F9TpI9OkQQ3r0vXKXsT1tP2+74uJrZ4LT/fQ8A
	 kwKAwejMAXYxWZuA7vALVUw33G3wnTvvHQC+eEgcJbGCsoLvuEmlRZbXbudSbV4FQU
	 6Rfc4YfC2IJOwEpW17prX14vBdq0hi77bqRZXdtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 122/301] scsi: ufs: core: Fix MCQ mode dev command timeout
Date: Tue, 14 May 2024 12:16:33 +0200
Message-ID: <20240514101036.856288081@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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
index 8005373e20bae..344806330be16 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3064,7 +3064,9 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 
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



