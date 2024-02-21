Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F0C7F48F;
	Wed, 21 Feb 2024 14:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524526; cv=none; b=lVmJ19k7iu6EByvxM+XRDXfE83L3/7JWbFewg+tRRwwZff7pwf9TZtQND0vCUvTixvPceFE6m2utT96CvtmGTfpvxzFXJ8HDsdcJRc057NY3C9WyP3r5dpsdK4bh46jjGzBgkgjuLEthgAv7GoG4nb7KXfi9W/ERJM0dajhMkR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524526; c=relaxed/simple;
	bh=wZA23Bj4jV3AVMBNEBrCjqTzQob7BKFuBMIvNPOdhpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E22T+AeFkDgcXBA36z+xd9QnjVVQOE8rYxewjT0sm77TtXRZqMZNOFYbQh23sAfbdTJraeR578pI6TncrOaO/ggQv7vxsbzQ8ZClavjYX5qae0LgnKC9jNG0BCrIavdGGIVq/XafM6CC9+rf04Wer6Zfsp6FOAJZDWy8Pk7ahCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=04G1VN4B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="04G1VN4B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE500C433C7;
	Wed, 21 Feb 2024 14:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524526;
	bh=wZA23Bj4jV3AVMBNEBrCjqTzQob7BKFuBMIvNPOdhpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=04G1VN4BDMnRYFjjzT/zqD7rpbnGhbeDHbqwgK3MEgQswCWQAqB0FmilkrtKEE+R5
	 IBtS34V5UgPAJB5VneJZA5Mynqhi6Fd3AJyEJI+uVcDd2CyLAUcUUSB1ITScfiEsU+
	 Ve39ZDsb75FOz56cVHTpTpt92D0MzYG6UDa2/xo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathya Prakash Veerichetty <safhya.prakash@broadcom.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Ewan D. Milne" <emilne@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 271/379] scsi: core: Move scsi_host_busy() out of host lock if it is for per-command
Date: Wed, 21 Feb 2024 14:07:30 +0100
Message-ID: <20240221130002.925505622@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 4e6c9011990726f4d175e2cdfebe5b0b8cce4839 ]

Commit 4373534a9850 ("scsi: core: Move scsi_host_busy() out of host lock
for waking up EH handler") intended to fix a hard lockup issue triggered by
EH. The core idea was to move scsi_host_busy() out of the host lock when
processing individual commands for EH. However, a suggested style change
inadvertently caused scsi_host_busy() to remain under the host lock. Fix
this by calling scsi_host_busy() outside the lock.

Fixes: 4373534a9850 ("scsi: core: Move scsi_host_busy() out of host lock for waking up EH handler")
Cc: Sathya Prakash Veerichetty <safhya.prakash@broadcom.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20240203024521.2006455-1-ming.lei@redhat.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_error.c | 3 ++-
 drivers/scsi/scsi_lib.c   | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 7618a31358e6..ffc6f3031e82 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -241,11 +241,12 @@ static void scsi_eh_inc_host_failed(struct rcu_head *head)
 {
 	struct scsi_cmnd *scmd = container_of(head, typeof(*scmd), rcu);
 	struct Scsi_Host *shost = scmd->device->host;
+	unsigned int busy = scsi_host_busy(shost);
 	unsigned long flags;
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	shost->host_failed++;
-	scsi_eh_wakeup(shost, scsi_host_busy(shost));
+	scsi_eh_wakeup(shost, busy);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 625d1c2015d6..14dec86ff749 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -310,9 +310,11 @@ static void scsi_dec_host_busy(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 	rcu_read_lock();
 	__clear_bit(SCMD_STATE_INFLIGHT, &cmd->state);
 	if (unlikely(scsi_host_in_recovery(shost))) {
+		unsigned int busy = scsi_host_busy(shost);
+
 		spin_lock_irqsave(shost->host_lock, flags);
 		if (shost->host_failed || shost->host_eh_scheduled)
-			scsi_eh_wakeup(shost, scsi_host_busy(shost));
+			scsi_eh_wakeup(shost, busy);
 		spin_unlock_irqrestore(shost->host_lock, flags);
 	}
 	rcu_read_unlock();
-- 
2.43.0



