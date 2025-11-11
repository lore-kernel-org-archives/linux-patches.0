Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C073B4C97;
	Tue, 11 Nov 2025 00:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822169; cv=none; b=MUFjmT8y0WO/8z1eI1nucfgh2PFqePH9Ohg6mi7qsPZRcqFqHldbkYQZ+FL8fNRg98Icy/gFNNTtJJxsqoS2eIDIKulxLGlLuSy3A7AC7klRN+5EPzZhx/kMYKhUD0KvJe0yYfJv93gggC31NPk9+SNr4GJaR3e/Arj9PwJJk+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822169; c=relaxed/simple;
	bh=GyEZoAIeC63Hx7/YDN26ap1jxpQcwLI0BlX0p0/WzLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QwAXvSdjXSFh+1cq5yHA4tlaIjaPUDdGYln0X99iHIk7D9LE9jDk9odxTwJHYTlW61h36e3bt7oKZ+LDzrZcZBTThgkR5SLzv+oUiwjwciRPFYG9xcR68Ef3IMWx5jSUj2Q45Rgj4hxHiwEDg4Fp14M8bNyaRav1egnr5fX6zQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zSMoRZPL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zSMoRZPL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D610C16AAE;
	Tue, 11 Nov 2025 00:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822169;
	bh=GyEZoAIeC63Hx7/YDN26ap1jxpQcwLI0BlX0p0/WzLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zSMoRZPLpNtxnL4yNoPmjri8++Yp3DUywYNnCqfR8EkR0QB5zCB6fvJPUWwB16PgR
	 1I9dVQrycUxCwN1MDLUTFkv2FnNj/j/MUAJLcBdVrshCdslEAEu+tuJl5Hz/BqGLAZ
	 0c3rtkbBp2pVzzaqJA5Lu2VKdkyNELk47Wz4v0xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	Bart Van Assche <bvanassche@acm.org>,
	"Ewan D. Milne" <emilne@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 045/849] scsi: core: Fix the unit attention counter implementation
Date: Tue, 11 Nov 2025 09:33:35 +0900
Message-ID: <20251111004537.531026178@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit d54c676d4fe0543d1642ab7a68ffdd31e8639a5d ]

scsi_decide_disposition() may call scsi_check_sense().
scsi_decide_disposition() calls are not serialized. Hence, counter
updates by scsi_check_sense() must be serialized. Hence this patch that
makes the counters updated by scsi_check_sense() atomic.

Cc: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Fixes: a5d518cd4e3e ("scsi: core: Add counters for New Media and Power On/Reset UNIT ATTENTIONs")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Link: https://patch.msgid.link/20251014220244.3689508-1-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_error.c  |  4 ++--
 include/scsi/scsi_device.h | 10 ++++------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 746ff6a1f309a..1c13812a3f035 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -554,9 +554,9 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 		 * happened, even if someone else gets the sense data.
 		 */
 		if (sshdr.asc == 0x28)
-			scmd->device->ua_new_media_ctr++;
+			atomic_inc(&sdev->ua_new_media_ctr);
 		else if (sshdr.asc == 0x29)
-			scmd->device->ua_por_ctr++;
+			atomic_inc(&sdev->ua_por_ctr);
 	}
 
 	if (scsi_sense_is_deferred(&sshdr))
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 6d6500148c4b7..993008cdea65f 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -252,8 +252,8 @@ struct scsi_device {
 	unsigned int queue_stopped;	/* request queue is quiesced */
 	bool offline_already;		/* Device offline message logged */
 
-	unsigned int ua_new_media_ctr;	/* Counter for New Media UNIT ATTENTIONs */
-	unsigned int ua_por_ctr;	/* Counter for Power On / Reset UAs */
+	atomic_t ua_new_media_ctr;	/* Counter for New Media UNIT ATTENTIONs */
+	atomic_t ua_por_ctr;		/* Counter for Power On / Reset UAs */
 
 	atomic_t disk_events_disable_depth; /* disable depth for disk events */
 
@@ -693,10 +693,8 @@ static inline int scsi_device_busy(struct scsi_device *sdev)
 }
 
 /* Macros to access the UNIT ATTENTION counters */
-#define scsi_get_ua_new_media_ctr(sdev) \
-	((const unsigned int)(sdev->ua_new_media_ctr))
-#define scsi_get_ua_por_ctr(sdev) \
-	((const unsigned int)(sdev->ua_por_ctr))
+#define scsi_get_ua_new_media_ctr(sdev)	atomic_read(&sdev->ua_new_media_ctr)
+#define scsi_get_ua_por_ctr(sdev)	atomic_read(&sdev->ua_por_ctr)
 
 #define MODULE_ALIAS_SCSI_DEVICE(type) \
 	MODULE_ALIAS("scsi:t-" __stringify(type) "*")
-- 
2.51.0



