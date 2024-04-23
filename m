Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7B6143890;
	Tue, 23 Apr 2024 21:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908467; cv=none; b=JqS1O1G5Dph+jG9g2iB904rwTP9BwjksB6JwWqQEyuhxZ1a1BAHhVr1fJLmHfR/C6sVQR/2z8Xv8vXteVLFqw162za0c4xtA4Ot+4qIqKgpbm8tq1A9D4tTU6GzbqtVMSZatxTMPcdzq7r3kkbPetCLO+c4CDXTmLPSBjbrQ8LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908467; c=relaxed/simple;
	bh=3rYUHZtKwxbVROFCr5O1eOoes2rwalcigOlFeLCL8+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XIh+XQUm1MfmLrW/1lwcv3QNAHLaHYeBG16mfjNsyycbaXthtxC3z32F85KWya1Idmh1x6cqR3EOdDq91Mxkd1jqzINcfV33OIUTX5hQpfiqbGzOauWIdB7orJpLQYxS/+hRVPs4Em4ucg8iX5laubxfNHDa35TRswOHkIuYFWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cBz9U1BG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cBz9U1BG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10ED9C3277B;
	Tue, 23 Apr 2024 21:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908467;
	bh=3rYUHZtKwxbVROFCr5O1eOoes2rwalcigOlFeLCL8+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cBz9U1BGSZYJEt/PJ7TpgqYVszbPh4W5LK+xEIXO5fYf78V7r8VBeYDn1K60jGOQe
	 Z9RQhPC4tKA/XH5+cLosLFImWKVzhr8URnH8fleszyorTsbAF7W8HAREXwU6liqseN
	 geAwdaz/1SNEUkXu3sXsHJ3fbzFXMCn7TNkQ80LI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.8 007/158] scsi: core: Fix handling of SCMD_FAIL_IF_RECOVERING
Date: Tue, 23 Apr 2024 14:37:09 -0700
Message-ID: <20240423213856.076960819@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

From: Bart Van Assche <bvanassche@acm.org>

commit ca91259b775f6fd98ae5d23bb4eec101d468ba8d upstream.

There is code in the SCSI core that sets the SCMD_FAIL_IF_RECOVERING
flag but there is no code that clears this flag. Instead of only clearing
SCMD_INITIALIZED in scsi_end_request(), clear all flags. It is never
necessary to preserve any command flags inside scsi_end_request().

Cc: stable@vger.kernel.org
Fixes: 310bcaef6d7e ("scsi: core: Support failing requests while recovering")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20240325224417.1477135-1-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_lib.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -543,10 +543,9 @@ static bool scsi_end_request(struct requ
 	if (blk_queue_add_random(q))
 		add_disk_randomness(req->q->disk);
 
-	if (!blk_rq_is_passthrough(req)) {
-		WARN_ON_ONCE(!(cmd->flags & SCMD_INITIALIZED));
-		cmd->flags &= ~SCMD_INITIALIZED;
-	}
+	WARN_ON_ONCE(!blk_rq_is_passthrough(req) &&
+		     !(cmd->flags & SCMD_INITIALIZED));
+	cmd->flags = 0;
 
 	/*
 	 * Calling rcu_barrier() is not necessary here because the


