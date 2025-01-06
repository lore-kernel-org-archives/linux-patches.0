Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD21318A6C1;
	Mon,  6 Jan 2025 15:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177148; cv=none; b=krvM6FWMXXojNhqnXLs6qlOTJZbzmvXY/rX4FjaKEOxXKt5WucmLM4LR2/VX0+EvaJ16Z2HMe+yFcbHPPEjmByKtdzVle5NLElS7wF17h2Ky9DXhyhyHX9aL9uejfOQDssc9kRHuG/RiwvxJon3gjo3Mbb23hKSnANpxdDn0F54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177148; c=relaxed/simple;
	bh=Urc6ynmAmOtQLoLuWWhcgYYnvHa7Stpnu7NxEQYZ4v8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPEM4ZGW1EilDq2lIEShLYYDnqGY600w5FL781QEwzz+p1KHFeqW3nfGuw86ClpTPZR8FxSw4ZuKGgCg+MnGhbd/a2vM8HPF2NIELczfw/8o4t2BonoFjr6wngGs2azm4tSl8kjVhLFAuXsAB9u/iJR9G0UngcxXVRUMLa4tsDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZX5I4B2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZX5I4B2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6BAC4CED2;
	Mon,  6 Jan 2025 15:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177148;
	bh=Urc6ynmAmOtQLoLuWWhcgYYnvHa7Stpnu7NxEQYZ4v8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XZX5I4B2CWPKrdaZxijF7BCRdQvThlXF99HiqjUaTGRemv2S6PqiRA+u5PuM/sGVs
	 8NHDxx5NT4f+kILL1KhOCCBeE1XER1SSBVFq+j8cPpQdddKdEGOo91NSwkvSq6iZpq
	 55VD59HixGaMuGAZZWUpucyC51Ms8dQGlxlCttpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/222] nvme: use helper nvme_ctrl_state in nvme_keep_alive_finish function
Date: Mon,  6 Jan 2025 16:14:32 +0100
Message-ID: <20250106151153.179664139@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Nilay Shroff <nilay@linux.ibm.com>

[ Upstream commit 599d9f3a10eec69ef28a90161763e4bd7c9c02bf ]

We no more need acquiring ctrl->lock before accessing the
NVMe controller state and instead we can now use the helper
nvme_ctrl_state. So replace the use of ctrl->lock from
nvme_keep_alive_finish function with nvme_ctrl_state call.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 84488282166d ("Revert "nvme: make keep-alive synchronous operation"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 5b6a6bd4e6e8..ae494c799fc5 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1181,10 +1181,9 @@ static void nvme_queue_keep_alive_work(struct nvme_ctrl *ctrl)
 static void nvme_keep_alive_finish(struct request *rq,
 		blk_status_t status, struct nvme_ctrl *ctrl)
 {
-	unsigned long flags;
-	bool startka = false;
 	unsigned long rtt = jiffies - (rq->deadline - rq->timeout);
 	unsigned long delay = nvme_keep_alive_work_period(ctrl);
+	enum nvme_ctrl_state state = nvme_ctrl_state(ctrl);
 
 	/*
 	 * Subtract off the keepalive RTT so nvme_keep_alive_work runs
@@ -1207,12 +1206,7 @@ static void nvme_keep_alive_finish(struct request *rq,
 
 	ctrl->ka_last_check_time = jiffies;
 	ctrl->comp_seen = false;
-	spin_lock_irqsave(&ctrl->lock, flags);
-	if (ctrl->state == NVME_CTRL_LIVE ||
-	    ctrl->state == NVME_CTRL_CONNECTING)
-		startka = true;
-	spin_unlock_irqrestore(&ctrl->lock, flags);
-	if (startka)
+	if (state == NVME_CTRL_LIVE || state == NVME_CTRL_CONNECTING)
 		queue_delayed_work(nvme_wq, &ctrl->ka_work, delay);
 }
 
-- 
2.39.5



