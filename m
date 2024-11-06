Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABAB1D5AD7;
	Wed,  6 Nov 2024 12:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895124; cv=none; b=uaDlpt/VpLgcz56AfAYIwGJ1pACVFk67+jP9GAHFwA5jg68xSeFcQOe0+eXORbHZfXokNaU0vYHRhmi3GDr+jbyunlxE3l/SiU2eZdqdtMIbxbidIXrXJqU45OrlzwYD35cqUi2XHAuH5ujtbCpK7OaUr3S13cyJyQLgnavN4Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895124; c=relaxed/simple;
	bh=mdwZRjLW8IFRxTk/91pWmq92/dQwcFoJy+zAVUMGgXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPqTEEh4htk3697Kk7sNCEwK/rgABM8egDxg+qsVm1owVKw90ZDZE7muABtmSYwDI3aOe4sInGMW7sEO0wEMKc4uQaTUED6p2Q78ms151gDuSHIbpwBLQv6/l0p3Zn2l4Skpt/6nJV8khC1VtJcjjesNBqrCc10gRfnPMlNPg8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=piDo8LhZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="piDo8LhZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B39C4CECD;
	Wed,  6 Nov 2024 12:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895124;
	bh=mdwZRjLW8IFRxTk/91pWmq92/dQwcFoJy+zAVUMGgXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=piDo8LhZQKn8ruf4HN5j9Ugb0SPyBXklN1DerquawCZ1c9yJtf3uZC2+myiD3u70c
	 MPaWRYMCoQUEo1sqZY/dw3atfNC6VfniL3Xcd/6NrQ30CPXClNqPwzzDVCrruRVuE0
	 z4LLK2pEj9gUQ6L07yUwwj3A+tsJBdGIb2fBOqMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiu-ji Chen <chenqiuji666@gmail.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.19 113/350] drbd: Fix atomicity violation in drbd_uuid_set_bm()
Date: Wed,  6 Nov 2024 13:00:41 +0100
Message-ID: <20241106120323.693164869@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3499,10 +3499,12 @@ void drbd_uuid_new_current(struct drbd_d
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


