Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D91747CC68;
	Sat, 28 Feb 2026 17:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301301; cv=none; b=hdoTw4kV337BfHna3Cp8AS51SPnSBL6kNCr1SSW+aZok89k2fnm6AE0tU7yno0P8aXa3o8sifiVgFQ8IsgCWUhw/NlYnKOPLwHZc2taJxTZl+3j7vSYITMf8G6fx5octKq/pE+YD0aMe9eMLA/I4iRvIYebKFN/vFHvbhitbsAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301301; c=relaxed/simple;
	bh=GxDXmstvReh/VpnhcvzNewuHYQd1fFD24YPjiqH04vQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CyJZrXeiRQF8uNJivyw/oGE+arHffm8I0KNW058NRpg2SaAz/26Q1fzKqQX+u9YPPix1AbdqH9HHVyx2N74dcNm6WRaCX7joIUBLwH4Vk1Yl16xKjHA8m5XESalhvzy715DVYuko5hFFo+YgyPyrC55mmCDLfJZYEBcO3Sl4sMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aOpBJToO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aOpBJToO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3403C19423;
	Sat, 28 Feb 2026 17:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301301;
	bh=GxDXmstvReh/VpnhcvzNewuHYQd1fFD24YPjiqH04vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aOpBJToOioGce35Yi57tnfx+AueYAJFEceXWSilmpJMeAyCcPM1rMVBUwfRQwL8o6
	 T4/Qs3kFoDisSPvPYInCFEDo2IvVwvoyzp8ND9PKhTSZG8ITcNlErLyDG8zyW0v448
	 5WGr+EemG8FU0gIj79T0umVxRPcuCrZR+smXbpBrMokkRe8WrS6qF+jhNNX6RzTxhW
	 rGCAAgvjuPRiL6HHKS1KSKkyJDqcyvOmihG6pB+9LF4u3ejW8NPze67NptnWiHIdN1
	 Ukid5mSb0SlFxtALCiEnfVOl+SAXyZUAhgqS9P4OXaBAAB2EcDq3EqZoGUxOkutYaH
	 q8nwBNcApaB7A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Xulin Sun <xulin.sun@windriver.com>,
	stable@vger.kernel.org,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 486/752] media: chips-media: wave5: Fix kthread worker destruction in polling mode
Date: Sat, 28 Feb 2026 12:43:17 -0500
Message-ID: <20260228174750.1542406-486-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Xulin Sun <xulin.sun@windriver.com>

[ Upstream commit 5a0c122e834b2f7f029526422c71be922960bf03 ]

Fix the cleanup order in polling mode (irq < 0) to prevent kernel warnings
during module removal. Cancel the hrtimer before destroying the kthread
worker to ensure work queues are empty.

In polling mode, the driver uses hrtimer to periodically trigger
wave5_vpu_timer_callback() which queues work via kthread_queue_work().
The kthread_destroy_worker() function validates that both work queues
are empty with WARN_ON(!list_empty(&worker->work_list)) and
WARN_ON(!list_empty(&worker->delayed_work_list)).

The original code called kthread_destroy_worker() before hrtimer_cancel(),
creating a race condition where the timer could fire during worker
destruction and queue new work, triggering the WARN_ON.

This causes the following warning on every module unload in polling mode:

  ------------[ cut here ]------------
  WARNING: CPU: 2 PID: 1034 at kernel/kthread.c:1430
    kthread_destroy_worker+0x84/0x98
  Modules linked in: wave5(-) rpmsg_ctrl rpmsg_char ...
  Call trace:
   kthread_destroy_worker+0x84/0x98
   wave5_vpu_remove+0xc8/0xe0 [wave5]
   platform_remove+0x30/0x58
  ...
  ---[ end trace 0000000000000000 ]---

Fixes: ed7276ed2fd0 ("media: chips-media: wave5: Add hrtimer based polling support")
Cc: stable@vger.kernel.org
Signed-off-by: Xulin Sun <xulin.sun@windriver.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/chips-media/wave5/wave5-vpu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/chips-media/wave5/wave5-vpu.c b/drivers/media/platform/chips-media/wave5/wave5-vpu.c
index 23aa3ab51a0ef..0bcd48df49d0f 100644
--- a/drivers/media/platform/chips-media/wave5/wave5-vpu.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpu.c
@@ -352,8 +352,9 @@ static void wave5_vpu_remove(struct platform_device *pdev)
 	struct vpu_device *dev = dev_get_drvdata(&pdev->dev);
 
 	if (dev->irq < 0) {
-		kthread_destroy_worker(dev->worker);
 		hrtimer_cancel(&dev->hrtimer);
+		kthread_cancel_work_sync(&dev->work);
+		kthread_destroy_worker(dev->worker);
 	}
 
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
-- 
2.51.0

