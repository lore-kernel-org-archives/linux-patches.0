Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74597303A1C;
	Tue, 11 Nov 2025 01:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824800; cv=none; b=dP3v+WaNKNeqQZRhSQufnp8RejGvdujIqnXmduf/Vg2Mz86lUnkg+UlQF8PAYCiK/hOcLX0vkpeW6LJhmGE5lB1nbTyiKDcB5NT5nGhhRP2V9Pi3YhlfN2dNA20rOjwrDlv5JYRFxPWJiCM9ZFSovE6QagCmrnPmJ3Xy/Kee4f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824800; c=relaxed/simple;
	bh=qDHnagYyZYxn2tZVLjml829WOO77W50iNUYPatwMW84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nhcGh3QKoSIsejvb1dYyLrdtcjin4c49p5KpaizB6VTJnPi7J0B/Yw7yPDKxZzMTWcqV0RjyPqDTf9gP/jm5EhJYb3xk51cuATB49IsaZF59DGDZf8U9yW/PCoU5HzcW2WM8xUxTqJCkD643Eu0yQLar0z7dPlgEXwvf63yvEHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8OGAzK6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8OGAzK6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E96C116D0;
	Tue, 11 Nov 2025 01:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824800;
	bh=qDHnagYyZYxn2tZVLjml829WOO77W50iNUYPatwMW84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d8OGAzK65/Eql1s1SgFQDIhq7We9Y4nDfO4xBOHcmFDlQ6f7sR8DzT8aJub9DNkI5
	 9ZCilA+084C2dkbpdce1A4tTOE+tf7PjmSA0zPHDbmTW5xPTcvfFH2gPgKel0++ADb
	 DUUppsQ3wISMQ/FSyW7PC5yXCmTKCXdbpWGxvhus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 572/849] scsi: lpfc: Clean up allocated queues when queue setup mbox commands fail
Date: Tue, 11 Nov 2025 09:42:22 +0900
Message-ID: <20251111004550.245934883@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index a8fbdf7119d88..d82ea9df098b8 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -8820,7 +8820,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 	if (unlikely(rc)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 				"0381 Error %d during queue setup.\n", rc);
-		goto out_stop_timers;
+		goto out_destroy_queue;
 	}
 	/* Initialize the driver internal SLI layer lists. */
 	lpfc_sli4_setup(phba);
@@ -9103,7 +9103,6 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 	lpfc_free_iocb_list(phba);
 out_destroy_queue:
 	lpfc_sli4_queue_destroy(phba);
-out_stop_timers:
 	lpfc_stop_hba_timers(phba);
 out_free_mbox:
 	mempool_free(mboxq, phba->mbox_mem_pool);
-- 
2.51.0



