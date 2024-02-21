Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD3376C82;
	Wed, 21 Feb 2024 13:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523086; cv=none; b=ETSVlcKcjwP4y01agq2AOOcp9GiR2qRQmPkplgQX5XNDnYOKpF9TrljVG/bOTLY00Adrwul8lm7x0z0HRAVuTfV9rcwqKXeGcHjBGsf45jczvHaVKoC3Wva7EjhmxfUC2tneWKt+KxDuGO5x12f2y287w9VbFuvOEx9f9KDbn2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523086; c=relaxed/simple;
	bh=x+6J/iv78tond7fd6rSL0100EHf37CNrX7AcVVL29WQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eGu7PnSigW2T85dxh0gwZpx6xA2XHdP+6vRbfhK9B9PzHON+WaKTP1pMMHyBE3X4erEJ9MQvSJ7URrzIdkWb9OPlIh68F6TaWQkGI1RLohpwRyP7MIiYLVhoK9i/zfTWVMVuJW2H+Gl77cWvgBqH1Fv7gSZB8qgCMWhkhxQKaq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vlqKrdgG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vlqKrdgG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B826FC433C7;
	Wed, 21 Feb 2024 13:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523086;
	bh=x+6J/iv78tond7fd6rSL0100EHf37CNrX7AcVVL29WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vlqKrdgGwKFRcZMQ9E2Zxp+2xH3lZGcxJJrqwSBbhCOyWEqwr6JbDF9MwYAK4IARJ
	 kpAiuQjWyXPTxZKHN0EZTrhKAZWZSil4aEJ6Xq/TB3W0BuxvKLPY1JLjN+ZrdvKjNA
	 3OPhCyZZcuRcW9CPCBXjGeJWxyGr+vPaDQER9fvE=
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
Subject: [PATCH 5.15 327/476] scsi: core: Move scsi_host_busy() out of host lock if it is for per-command
Date: Wed, 21 Feb 2024 14:06:18 +0100
Message-ID: <20240221130020.118648566@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ffd3d8df3d82..2d5dc488f511 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -276,11 +276,12 @@ static void scsi_eh_inc_host_failed(struct rcu_head *head)
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
index e9ab87335115..0389bf281f4b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -281,9 +281,11 @@ static void scsi_dec_host_busy(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
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



