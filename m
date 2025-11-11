Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F08F340280;
	Tue, 11 Nov 2025 01:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824032; cv=none; b=KMvepTB33d9TE5/MSRbAI+Auhq/V+4WNma0MFh/n6GVpZoXsT6KeK7dF5MpA/VtuqjJWajV2i3pwVZ7uLKLkfU4Z5Sc/ZF9+h61PbjgNVCkw/9kWKkOPeDak/BSZuzpfiyyZgDn3+fbRQvTvwfL1SAnf6WNCfJQNeAP1fB6q5Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824032; c=relaxed/simple;
	bh=AOqsGG0RtzMTSUGuqsoasdt4t1woHtheLjEiQmxVGb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l83u7xwf4iStxzZWQnndDMTpWhMT3NVnXrrmecHKDq7P8XFrFD09z38pcp2r1VCTweYRm6A7l3CtBXPqeH2KzrgH6daxWwMTk3ZyFxjQDD76G8lbJmTdWCf03cNpBCXiTzwrE9VwBcQsK6H3a2ITWu+YBYbhrOoMzapcxJ5B33U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gdo2BDNj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gdo2BDNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E4CC16AAE;
	Tue, 11 Nov 2025 01:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824031;
	bh=AOqsGG0RtzMTSUGuqsoasdt4t1woHtheLjEiQmxVGb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gdo2BDNjVMIMH5O3AHD4LypOLGXrizhyYaGCx2g4smZgCQzC+4RvMvbXw2ftcv/uj
	 LnG+/E7HNYfj+tSoUv4Age7e87XljwUP17jwD4dXZBwVi0m7wRAL/DRcxPYimIQ+Rc
	 WmDOjBONHl6l5jB7ICb6lR/gRlmrr/mWWGAV4BbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 374/565] scsi: lpfc: Clean up allocated queues when queue setup mbox commands fail
Date: Tue, 11 Nov 2025 09:43:50 +0900
Message-ID: <20251111004535.282758609@linuxfoundation.org>
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

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 803dfd83df33b7565f23aef597d5dd036adfa792 ]

lpfc_sli4_queue_setup() does not allocate memory and is used for
submitting CREATE_QUEUE mailbox commands.  Thus, if such mailbox
commands fail we should clean up by also freeing the memory allocated
for the queues with lpfc_sli4_queue_destroy().  Change the intended
clean up label for the lpfc_sli4_queue_setup() error case to
out_destroy_queue.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Message-ID: <20250915180811.137530-4-justintee8345@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index c4acf594286e5..2a1f2b2017159 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -8811,7 +8811,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 	if (unlikely(rc)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 				"0381 Error %d during queue setup.\n", rc);
-		goto out_stop_timers;
+		goto out_destroy_queue;
 	}
 	/* Initialize the driver internal SLI layer lists. */
 	lpfc_sli4_setup(phba);
@@ -9094,7 +9094,6 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 	lpfc_free_iocb_list(phba);
 out_destroy_queue:
 	lpfc_sli4_queue_destroy(phba);
-out_stop_timers:
 	lpfc_stop_hba_timers(phba);
 out_free_mbox:
 	mempool_free(mboxq, phba->mbox_mem_pool);
-- 
2.51.0



