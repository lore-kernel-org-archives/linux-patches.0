Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E985042188D;
	Wed,  4 Feb 2026 15:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217845; cv=none; b=M9ilMyf2QeXFR9swj/bzym6qrvqCzajXoTFqDHUfLqxYFSe9nxxd+gi/ocEvvSPjL0FMnuEryfJqRALVmdoifqv7DWx2yfgngjvZwMR4e+KNGFM0eK5BhUdv2aIEf6KH8b5mK7AS33Vp+1XZ/MbqATlsBKLFKeXicfz/wIkzjt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217845; c=relaxed/simple;
	bh=1oV9tYE9HrP2MCJFq6Ph1CW04PGDddNHUpbIp9P1+QQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHAD1vKyCnVKvZ5bc8Irhjhvx//ZPpVM6FzC1S7Zw+sg9Ydl7GxXhg17nXvb/X6hMGFgDmabL+fHm8rg+9596Z07Irdl4/5fSQNUDGFkkKoLLQEOh7R8q4PXgl62c/4GP8zOKIay8WX3XB2a8bQlYvqxrs5BweN22YuVcYYWhg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HOnOdid1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HOnOdid1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB27C4CEF7;
	Wed,  4 Feb 2026 15:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217844;
	bh=1oV9tYE9HrP2MCJFq6Ph1CW04PGDddNHUpbIp9P1+QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HOnOdid1aCIEILwvV/aWVGGNbeeg0idDd0rRubKC/bSVaqDze+9TWJkhVqqyuOa+L
	 6HtobgGzQGxws3lAxc3N9vVhrwJw5QmzjRA9Jxm1mBOdAoaVMAH/yQ477zTpEtYfRY
	 O4SNIzYiAP4WvPECnsve9MxBnWia5JaNvjFbwm8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jeffery <djeffery@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 137/280] scsi: core: Wake up the error handler when final completions race against each other
Date: Wed,  4 Feb 2026 15:38:31 +0100
Message-ID: <20260204143914.569968751@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Jeffery <djeffery@redhat.com>

[ Upstream commit fe2f8ad6f0999db3b318359a01ee0108c703a8c3 ]

The fragile ordering between marking commands completed or failed so
that the error handler only wakes when the last running command
completes or times out has race conditions. These race conditions can
cause the SCSI layer to fail to wake the error handler, leaving I/O
through the SCSI host stuck as the error state cannot advance.

First, there is an memory ordering issue within scsi_dec_host_busy().
The write which clears SCMD_STATE_INFLIGHT may be reordered with reads
counting in scsi_host_busy(). While the local CPU will see its own
write, reordering can allow other CPUs in scsi_dec_host_busy() or
scsi_eh_inc_host_failed() to see a raised busy count, causing no CPU to
see a host busy equal to the host_failed count.

This race condition can be prevented with a memory barrier on the error
path to force the write to be visible before counting host busy
commands.

Second, there is a general ordering issue with scsi_eh_inc_host_failed(). By
counting busy commands before incrementing host_failed, it can race with a
final command in scsi_dec_host_busy(), such that scsi_dec_host_busy() does
not see host_failed incremented but scsi_eh_inc_host_failed() counts busy
commands before SCMD_STATE_INFLIGHT is cleared by scsi_dec_host_busy(),
resulting in neither waking the error handler task.

This needs the call to scsi_host_busy() to be moved after host_failed is
incremented to close the race condition.

Fixes: 6eb045e092ef ("scsi: core: avoid host-wide host_busy counter for scsi_mq")
Signed-off-by: David Jeffery <djeffery@redhat.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260113161036.6730-1-djeffery@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_error.c | 11 ++++++++++-
 drivers/scsi/scsi_lib.c   |  8 ++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c1a454b3bbbf1..79dc157661ce9 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -277,11 +277,20 @@ static void scsi_eh_inc_host_failed(struct rcu_head *head)
 {
 	struct scsi_cmnd *scmd = container_of(head, typeof(*scmd), rcu);
 	struct Scsi_Host *shost = scmd->device->host;
-	unsigned int busy = scsi_host_busy(shost);
+	unsigned int busy;
 	unsigned long flags;
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	shost->host_failed++;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	/*
+	 * The counting of busy requests needs to occur after adding to
+	 * host_failed or after the lock acquire for adding to host_failed
+	 * to prevent a race with host unbusy and missing an eh wakeup.
+	 */
+	busy = scsi_host_busy(shost);
+
+	spin_lock_irqsave(shost->host_lock, flags);
 	scsi_eh_wakeup(shost, busy);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index df61d7b906653..ddc986ff51615 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -280,6 +280,14 @@ static void scsi_dec_host_busy(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 	rcu_read_lock();
 	__clear_bit(SCMD_STATE_INFLIGHT, &cmd->state);
 	if (unlikely(scsi_host_in_recovery(shost))) {
+		/*
+		 * Ensure the clear of SCMD_STATE_INFLIGHT is visible to
+		 * other CPUs before counting busy requests. Otherwise,
+		 * reordering can cause CPUs to race and miss an eh wakeup
+		 * when no CPU sees all busy requests as done or timed out.
+		 */
+		smp_mb();
+
 		unsigned int busy = scsi_host_busy(shost);
 
 		spin_lock_irqsave(shost->host_lock, flags);
-- 
2.51.0



