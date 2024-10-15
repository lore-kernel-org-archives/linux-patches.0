Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB931C07DB;
	Tue, 15 Oct 2024 13:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997606; cv=none; b=gFZz5X/bjSO1U+iS6bGRmpWqOUm3xOjL8whKhTfhBF0dNdI0TMby9no+ox9hQzZd2M5mI6nUYSMpSRJYIdEhyvxcnq6L4pJaPL816Pt2m5WMBRrTIE8yF0gtxkC4awYKbs8k4AEXZo4dpJXmzWrFeP/v1+rj+OU7A9MFAIc2tvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997606; c=relaxed/simple;
	bh=CLSG7hdzWoA594QAz6lvogqIC+LS6KLd6dHIBMBpWRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dm+zwyQv7NAGxtN154hBLsVT77IGi9qlf3tvBBRMxqiSGaS4rW8PfnGgZo4C9+XPJw8NbJ03yzTpcd9nTJJkkw1UTMpF+uW6Zk88NtG/nrE7HAM5NT7lffm/Lii7ELDVgWF2HPIfNFust70oIVKQM1cNxZDwFsduL/Hz98gRL3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ajw1219x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ajw1219x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9387CC4CEC6;
	Tue, 15 Oct 2024 13:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997606;
	bh=CLSG7hdzWoA594QAz6lvogqIC+LS6KLd6dHIBMBpWRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ajw1219xd84euhh0LPf0u4nUXNofVlmSjqB4hPHM+Af/CINkwcdl/9lfGBHetA65z
	 Wn7LFLjoAstM6aifYezcWIukyUpYrbnXlihz6WhaQLxe7OYvIrKfytnKQX6nGqrlUw
	 RdmRxGevBk0vDhCT29rRgHcYEU/iG0acj80qJMqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiu-ji Chen <chenqiuji666@gmail.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 231/518] drbd: Fix atomicity violation in drbd_uuid_set_bm()
Date: Tue, 15 Oct 2024 14:42:15 +0200
Message-ID: <20241015123925.909586084@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiu-ji Chen <chenqiuji666@gmail.com>

commit 2f02b5af3a4482b216e6a466edecf6ba8450fa45 upstream.

The violation of atomicity occurs when the drbd_uuid_set_bm function is
executed simultaneously with modifying the value of
device->ldev->md.uuid[UI_BITMAP]. Consider a scenario where, while
device->ldev->md.uuid[UI_BITMAP] passes the validity check when its
value is not zero, the value of device->ldev->md.uuid[UI_BITMAP] is
written to zero. In this case, the check in drbd_uuid_set_bm might refer
to the old value of device->ldev->md.uuid[UI_BITMAP] (before locking),
which allows an invalid value to pass the validity check, resulting in
inconsistency.

To address this issue, it is recommended to include the data validity
check within the locked section of the function. This modification
ensures that the value of device->ldev->md.uuid[UI_BITMAP] does not
change during the validation process, thereby maintaining its integrity.

This possible bug is found by an experimental static analysis tool
developed by our team. This tool analyzes the locking APIs to extract
function pairs that can be concurrently executed, and then analyzes the
instructions in the paired functions to identify possible concurrency
bugs including data races and atomicity violations.

Fixes: 9f2247bb9b75 ("drbd: Protect accesses to the uuid set with a spinlock")
Cc: stable@vger.kernel.org
Signed-off-by: Qiu-ji Chen <chenqiuji666@gmail.com>
Reviewed-by: Philipp Reisner <philipp.reisner@linbit.com>
Link: https://lore.kernel.org/r/20240913083504.10549-1-chenqiuji666@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/drbd/drbd_main.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -3429,10 +3429,12 @@ void drbd_uuid_new_current(struct drbd_d
 void drbd_uuid_set_bm(struct drbd_device *device, u64 val) __must_hold(local)
 {
 	unsigned long flags;
-	if (device->ldev->md.uuid[UI_BITMAP] == 0 && val == 0)
+	spin_lock_irqsave(&device->ldev->md.uuid_lock, flags);
+	if (device->ldev->md.uuid[UI_BITMAP] == 0 && val == 0) {
+		spin_unlock_irqrestore(&device->ldev->md.uuid_lock, flags);
 		return;
+	}
 
-	spin_lock_irqsave(&device->ldev->md.uuid_lock, flags);
 	if (val == 0) {
 		drbd_uuid_move_history(device);
 		device->ldev->md.uuid[UI_HISTORY_START] = device->ldev->md.uuid[UI_BITMAP];


