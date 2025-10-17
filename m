Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FB13370F7;
	Fri, 17 Oct 2025 15:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714310; cv=none; b=tL3RBrrOdPk27mHMzQS8f2bbS7dsEBNKXb5wX5f2SCf9L5QZw9rYXPIZdGsxsFHOBfVYvw4HrtzDdCA+ezGcSy3B1SFk9pWz2Giwc4Axf1VP9l51UTC3Lpv+D89aBoMEeGO+CJ1tbPakGe9THfzw8qrYfvQSEUi9x2jBG0XrgeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714310; c=relaxed/simple;
	bh=ce8Eh2HGPah8Pv4Jmmqb18+euf6IwC/Kgmg/TlE92JQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ExxyC9RtS0W1WDv4s6LWdXzIf5klDTw7f8ba/sXrzeYNGlPSvQn9eqxD4xZtDQ+zrgwqU2nf+J09+25AtRYUorParlNXwqPEXwIpV+LStQPqgZDv9Qo4a6gWJL2QEABuPmOY6jwc/Fc31dS8ZuHr9NAAAproZQr5JhDcs4H7wek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rfBU64Zj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rfBU64Zj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A3BC4CEE7;
	Fri, 17 Oct 2025 15:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714310;
	bh=ce8Eh2HGPah8Pv4Jmmqb18+euf6IwC/Kgmg/TlE92JQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rfBU64Zj3zbe5b9ZwoYw0kY5Q0h9xumbt4CKmQME7yBsKENq1pYxx/z5cC3eZiR2y
	 K4WghMsS1MgeHRZqTIIOPeX4g904iy6fOWGidVziyhM265KDPVS7UZMhlGWm6gvk6y
	 kzcc0MekocCZf2xrlrUENXg8kz59c2OQdB09fLnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 067/277] mailbox: mtk-cmdq: Switch to pm_runtime_put_autosuspend()
Date: Fri, 17 Oct 2025 16:51:14 +0200
Message-ID: <20251017145149.589172806@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 472f8a3fccbb579cb98c1821da4cb9cbd51ee3e4 ]

__pm_runtime_put_autosuspend() was meant to be used by callers that needed
to put the Runtime PM usage_count without marking the device's last busy
timestamp. It was however seen that the Runtime PM autosuspend related
functions should include that call. Thus switch the driver to
use pm_runtime_put_autosuspend().

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Stable-dep-of: 3f39f5652037 ("mailbox: mtk-cmdq: Remove pm_runtime APIs from cmdq_mbox_send_data()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mtk-cmdq-mailbox.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mailbox/mtk-cmdq-mailbox.c b/drivers/mailbox/mtk-cmdq-mailbox.c
index 4e093b58fb7b5..d24f71819c3d6 100644
--- a/drivers/mailbox/mtk-cmdq-mailbox.c
+++ b/drivers/mailbox/mtk-cmdq-mailbox.c
@@ -390,7 +390,7 @@ static int cmdq_mbox_send_data(struct mbox_chan *chan, void *data)
 
 	task = kzalloc(sizeof(*task), GFP_ATOMIC);
 	if (!task) {
-		__pm_runtime_put_autosuspend(cmdq->mbox.dev);
+		pm_runtime_put_autosuspend(cmdq->mbox.dev);
 		return -ENOMEM;
 	}
 
@@ -440,7 +440,7 @@ static int cmdq_mbox_send_data(struct mbox_chan *chan, void *data)
 	list_move_tail(&task->list_entry, &thread->task_busy_list);
 
 	pm_runtime_mark_last_busy(cmdq->mbox.dev);
-	__pm_runtime_put_autosuspend(cmdq->mbox.dev);
+	pm_runtime_put_autosuspend(cmdq->mbox.dev);
 
 	return 0;
 }
@@ -488,7 +488,7 @@ static void cmdq_mbox_shutdown(struct mbox_chan *chan)
 	spin_unlock_irqrestore(&thread->chan->lock, flags);
 
 	pm_runtime_mark_last_busy(cmdq->mbox.dev);
-	__pm_runtime_put_autosuspend(cmdq->mbox.dev);
+	pm_runtime_put_autosuspend(cmdq->mbox.dev);
 }
 
 static int cmdq_mbox_flush(struct mbox_chan *chan, unsigned long timeout)
@@ -528,7 +528,7 @@ static int cmdq_mbox_flush(struct mbox_chan *chan, unsigned long timeout)
 out:
 	spin_unlock_irqrestore(&thread->chan->lock, flags);
 	pm_runtime_mark_last_busy(cmdq->mbox.dev);
-	__pm_runtime_put_autosuspend(cmdq->mbox.dev);
+	pm_runtime_put_autosuspend(cmdq->mbox.dev);
 
 	return 0;
 
@@ -543,7 +543,7 @@ static int cmdq_mbox_flush(struct mbox_chan *chan, unsigned long timeout)
 		return -EFAULT;
 	}
 	pm_runtime_mark_last_busy(cmdq->mbox.dev);
-	__pm_runtime_put_autosuspend(cmdq->mbox.dev);
+	pm_runtime_put_autosuspend(cmdq->mbox.dev);
 	return 0;
 }
 
-- 
2.51.0



