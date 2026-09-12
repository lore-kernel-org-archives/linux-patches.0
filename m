Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A306522A7F6;
	Sat, 12 Sep 2026 15:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225527; cv=none; b=IY3Gk0pukQOuCqHzTmoT0j5Y8vPgN8wZP+wmLbotPs1u3JgqxaLMNSL/dphjhWIRDh8mv3awGAGXLjL8KDnczmHhn0o5zE7rgX+nB3IKMkpsHEk0/15FLB/0RLboAibID9spubtdD+jydyHHaBeQb9tlxOkaAb3PyK/la7YMv4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225527; c=relaxed/simple;
	bh=HOGbgsM7y5No/kRVKTrmpnfaG7larevPi2jRPViQCr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XmfkACx2CRpTCBoq3c7PrtuXXZH0a9Ifbm18hhgWn4bI9cnu2SsGi7LEDdTzP0Pf/FUPl4nxcUopBb4FjDF5xT8f9sQYWHc2FhWQeQf6hAURtuEGpUG8cKDGCubCXcl0PncnoeVgVxhQDmxHGc3iUlhQTCfcEsJsQomrak3XHvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rz4h9k1a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rz4h9k1a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 434101F000FF;
	Sat, 12 Sep 2026 15:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225526;
	bh=eiVrc3wQxtL1oxOqN4ZxGUpcPm5EDVx15bPK5Qk4vjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rz4h9k1aZmcf/c3T3N4eaZFdJBiDLJ8GeJqA+l7PfjZztDSyzjM1p+bvIjxxhW4n3
	 aMYdeD7QrAK5U4N9CQE34ChYc7YQF1Kr/GHQruktyax60az5WGnK9T0mYY2h8rxEdo
	 VJWrUN7Dt/YlszaJX9qOqTaJg4HItEpoKtY5laKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Sashiko <sashiko-bot@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1215/1424] scsi: ufs: core: Set task state before io_schedule_timeout()
Date: Sat, 12 Sep 2026 09:00:47 +0200
Message-ID: <20260912065634.495720357@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 720d8b2f2457f4962ca353dd90395e2660d9a10d ]

Set the task state to TASK_UNINTERRUPTIBLE before calling
io_schedule_timeout() in ufshcd_wait_for_pending_cmds().  Without
setting the task state, io_schedule_timeout() returns immediately
because the task state remains TASK_RUNNING. This results in a busy loop
that wastes CPU cycles.

Fixes: 2000bc309703 ("scsi: ufs: core: Reduce the clock scaling latency")
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/8fe4526ce272811b28e99048b42358dd8f7c48af.1786142946.git.bvanassche@acm.org
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index a3a8ba38b13b4..368459dd8b3ff 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1234,6 +1234,7 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 			break;
 		}
 
+		__set_current_state(TASK_UNINTERRUPTIBLE);
 		io_schedule_timeout(msecs_to_jiffies(20));
 		if (ktime_to_us(ktime_sub(ktime_get(), start)) >
 		    wait_timeout_us) {
-- 
2.53.0



