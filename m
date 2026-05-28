Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2075F309F1D;
	Thu, 28 May 2026 20:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001544; cv=none; b=CSE4Uqe5Ch9onZgCPERMNgynfM4F56UxvFezrEtzGGQU2LLIdCa/LoS1IHLZYX7hhuW9FH1aaLqCZ/hWe7NZD4/RzVlggg6tQgRwwdvQzYyRv9SdBFVG/2W3Fz0y2ruRKZbX9nesJL6sJpXbsMNJucJZa5aM+Xqu/p141ltlxus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001544; c=relaxed/simple;
	bh=EEgEWlBOxgANTc2UP4Dt4qA0aa3jGkucnG4a5IFpe/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWPSqNwgexjzMZbMuzUPm+MgemtRd1Rr2icWWwilCnRT671tOk9kd74v9lnmHR3JrZQJ5xpQV+RQ/p1O2pDPotacU1NYOAmODa2e27JLoVciQdgLzg98dTGhF5ohFw5KSWpJBfzyB2IvWd6RqkU2ipBJxTTRcNlI7qYVvRxioKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mSIleKfd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mSIleKfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3DE1F00A3C;
	Thu, 28 May 2026 20:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001543;
	bh=+jK8UK2ryXynSCIfyfcBhzGp74VnFU6H3l5+mhaNsiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mSIleKfd4tnxc3e2YRZiN3ogdhZGyPyKM7LnEbf0pEVzqstUHUKKh0bn7hm6LioOp
	 Jfnoc30h+PSGfePB5z5qRRcL+nCksXcakWTj1cHYA0LsqkgPhhiG1YsONx9W7LTs/a
	 EAlsgzS7wuk2rC4lgzvfEyiKtTtn16k4fXM2+Uyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 165/186] pds_core: fix error handling in pdsc_devcmd_wait
Date: Thu, 28 May 2026 21:50:45 +0200
Message-ID: <20260528194933.418686649@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikhil P. Rao <nikhil.rao@amd.com>

[ Upstream commit 0e46b6635b03d29807f810c3b415c4755a3f958d ]

Fix two cases where pdsc_devcmd_wait() returns stale success from
the completion register instead of an error:

1. FW crash: If firmware stops running, the wait loop breaks early with
   running=false. The condition "if ((!done || timeout) && running)" is
   false, so error handling is bypassed and stale status is returned.
   Check !running first and return -ENXIO.

2. Timeout: If a command times out, err is set to -ETIMEDOUT but then
   overwritten by pdsc_err_to_errno(status) which reads stale status.
   Return -ETIMEDOUT immediately after cleaning up.

Both errors now propagate to pdsc_devcmd_locked() which queues
health_work for recovery.

Fixes: 45d76f492938 ("pds_core: set up device and adminq")
Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>
Link: https://patch.msgid.link/20260515212907.998028-1-nikhil.rao@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/dev.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/dev.c b/drivers/net/ethernet/amd/pds_core/dev.c
index e65a1632df505..0e9398503a04d 100644
--- a/drivers/net/ethernet/amd/pds_core/dev.c
+++ b/drivers/net/ethernet/amd/pds_core/dev.c
@@ -162,12 +162,19 @@ static int pdsc_devcmd_wait(struct pdsc *pdsc, u8 opcode, int max_seconds)
 		dev_dbg(dev, "DEVCMD %d %s after %ld secs\n",
 			opcode, pdsc_devcmd_str(opcode), duration / HZ);
 
-	if ((!done || timeout) && running) {
+	if (!running) {
+		dev_err(dev, "DEVCMD %d %s fw not running\n",
+			opcode, pdsc_devcmd_str(opcode));
+		pdsc_devcmd_clean(pdsc);
+		return -ENXIO;
+	}
+
+	if (!done || timeout) {
 		dev_err(dev, "DEVCMD %d %s timeout, done %d timeout %d max_seconds=%d\n",
 			opcode, pdsc_devcmd_str(opcode), done, timeout,
 			max_seconds);
-		err = -ETIMEDOUT;
 		pdsc_devcmd_clean(pdsc);
+		return -ETIMEDOUT;
 	}
 
 	status = pdsc_devcmd_status(pdsc);
-- 
2.53.0



