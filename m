Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72082AF06;
	Mon,  6 Jan 2025 15:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178756; cv=none; b=qSuE4qIijmGzGIjS2hjDIZYVdsidvXRsHhWFFLs9FanUWuqQWxz92k+ZarXgjPJxUg3NAbECOyFntdSi1tDkPhso8vMiubh6J3w47fahpUZs5T2yu/48GWaDwfe1XYn1bEBSAM6CSFfivDt1v62md3FGOjmXH0+N11pBodemqTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178756; c=relaxed/simple;
	bh=Uk5oSrtmuFkIHCMdZEBjtAXxQeKwz33ljstxfSnfL1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/RCN7DksBNjy4C6y1ZgOQVoyrM1YPFK8LCTzZRX86tMSLMVOLDD11BANkMLuLMMa9Lz2FFob1m4ERLzUG6hPMcxIRZMv3S0l5lwIWXAvAWpHNmz5o22EmAIQA+5LepGJLVY71GWP+01wI57NM5nqdudcZ5BZjd5gvbT7GXhA1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w04XkAHy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w04XkAHy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65794C4CED2;
	Mon,  6 Jan 2025 15:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178755;
	bh=Uk5oSrtmuFkIHCMdZEBjtAXxQeKwz33ljstxfSnfL1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w04XkAHyrLuyfgkD6fI2SFYEbu+RyIYcKHs+iKPs+RinkDN3TPzoS8jGKndmBgUv6
	 5wbWjA7Ov+apZV76KSyR7GqZ7wDpNMLB7YLTYIm8m/IJkkivtUXipEbhIFIsqTVIAT
	 gkme2LjXmBHGZYBYXu6kVsyla9gV2MH1pNgWARoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 082/168] scsi: mpt3sas: Diag-Reset when Doorbell-In-Use bit is set during driver load time
Date: Mon,  6 Jan 2025 16:16:30 +0100
Message-ID: <20250106151141.560875528@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit 3f5eb062e8aa335643181c480e6c590c6cedfd22 ]

Issue a Diag-Reset when the "Doorbell-In-Use" bit is set during the
driver load/initialization.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://lore.kernel.org/r/20241110173341.11595-2-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 0fc2c355fc37..0c768c404d3d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -6901,11 +6901,12 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
 	int i;
 	u8 failed;
 	__le32 *mfp;
+	int ret_val;
 
 	/* make sure doorbell is not in use */
 	if ((ioc->base_readl_ext_retry(&ioc->chip->Doorbell) & MPI2_DOORBELL_USED)) {
 		ioc_err(ioc, "doorbell is in use (line=%d)\n", __LINE__);
-		return -EFAULT;
+		goto doorbell_diag_reset;
 	}
 
 	/* clear pending doorbell interrupts from previous state changes */
@@ -6995,6 +6996,10 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
 			    le32_to_cpu(mfp[i]));
 	}
 	return 0;
+
+doorbell_diag_reset:
+	ret_val = _base_diag_reset(ioc);
+	return ret_val;
 }
 
 /**
-- 
2.39.5



