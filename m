Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8917B143C7E;
	Tue, 23 Apr 2024 21:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908575; cv=none; b=SKzVfqmfN0t0bu8RInb/SDaIsp9/KMB5U7yh9PEzdktXdGirMPfRH+7KeE4rc7i//kk1IMLi9e7QI6i1gqRy/C7XPp6EG1tdFxVqfBFpy8F2rdg08fhXDsdht/dkp/L2+PbL3tJMpbK4IcN3YuS/zb6qkyl73oRQuiqrk2TePOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908575; c=relaxed/simple;
	bh=5hLOuSHJOKMyKg/KuimfLSsxVuKpq3g1vMgYTIFGK6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KLanQNGuw50hvScitNSfW7MxCJkSjYUI/HxVBRG89ptf/DLv1hp+7L5YMWPJ92YM9g4YxWY+pry1RlIJsemEENhxteg9i4TkDJfCIcjp5FTLJYL3hfCbQnDnOFHr4l2EAdwO3zM1/qnDspY90cacO8hktIOPk0DGg0aPStl9FEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kffLNFuj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kffLNFuj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE85C3277B;
	Tue, 23 Apr 2024 21:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908575;
	bh=5hLOuSHJOKMyKg/KuimfLSsxVuKpq3g1vMgYTIFGK6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kffLNFujEdj4gd0U73jrxNwLJZLWostqfmnQeQI0T49s6SflIeMQhk4MWh4mt2g6x
	 mCbYb+p8BkqZt/PelGDS0ZUMkiBFmsarg4VX82RklcGBabLSQcCTtY6Qn+A13QUooq
	 6qUkH/iydX9y+bKJFwxKuXUi/c2ElU9ctfJSF0FU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 028/158] scsi: core: Fix handling of SCMD_FAIL_IF_RECOVERING
Date: Tue, 23 Apr 2024 14:37:45 -0700
Message-ID: <20240423213856.657014228@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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


