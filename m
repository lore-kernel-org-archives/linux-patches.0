Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB583232;
	Wed,  2 Oct 2024 14:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878826; cv=none; b=EzLJlyhL+/y2Lt3mDlJ2jOI+emC1DCvcvzZWN6xbBD/hg/znDWAO5hfQP8cTpom5cinpP8LxmjhAobBrIuFpcKiPrJfkHClBvgQQbvyI9N2VH5HLeoHg1OPEYU/V4eyZGqIQw3oW6V66f7PCyn2SxUpdRtf+kwcV+vNkKLfFT4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878826; c=relaxed/simple;
	bh=i/6NrFGgk4MFWVKSB+S7vPSJBNQQfZfMZCwHKb1mLn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rcAKuKUNDR2tO9dWMnFGa+4LIgJoOwh9Vprm+kXCMOBVIBU3F2sTD0dC+xnaifkAwv7rn6pgd0+TrGFOsWizjZhuAEMUMRc954RG+iZzXHS8iU8tDApdaUIyN+AJ0xEyyBw/Br0I66NFOthC7VzPTZpY0Yeij7UbQl6jxgMOw6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g5yrfjFd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g5yrfjFd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3FDC4CEC2;
	Wed,  2 Oct 2024 14:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878826;
	bh=i/6NrFGgk4MFWVKSB+S7vPSJBNQQfZfMZCwHKb1mLn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g5yrfjFdLG1cranKHR6AavxO97am8rZV8id6Zw5xy2bf2zj7Wzymi12bBek3vCcBp
	 W7uVps45/GGs1fK0iDKsWrtb7bATJoMNpaHfnx5WXSgIOVfpFOrb/W0IcmtMiL7Q/f
	 Kgi8tL9eEHB+FGZw0fMXzjf0ih6651g7C/cT/jAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiu-ji Chen <chenqiuji666@gmail.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.10 538/634] drbd: Fix atomicity violation in drbd_uuid_set_bm()
Date: Wed,  2 Oct 2024 15:00:38 +0200
Message-ID: <20241002125832.344399179@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3399,10 +3399,12 @@ void drbd_uuid_new_current(struct drbd_d
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


