Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D127D1F9422;
	Wed,  6 Nov 2024 13:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898307; cv=none; b=jr5dLEbz0f8+oY6lPCnvTLGlc92RoD9AT68kCe9lqx6kSnHXYpaDm4ogXWyfwtTF+EGT6YuF3wPe+zu0zkdLu7NJofXDiJpWElDfGVPtcwsDxxEVOAKSgWMWi7PmI5dabPZCjEIcfVrGh6hB05wmmFwUVuPH5FqTVDqHpim7kNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898307; c=relaxed/simple;
	bh=PbAQ502crNQxzM1H5eMmCnKhj6fnco+pzhKzLFBvQE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YNWWx7zdDpaYfTENvMOTuH8PL9TZT+sWynJbSavvBboSLp+m3nx/QuP9zJU0fSmY5KtpYrOusxQBrqhZqaOB2FCS1GrIJ/oGOpr2su3NJBQ3SVvTGVTD/jdV7aaO4a6F7LOqwJ7RXJE0wCO4jMyZ3uRF1N93pJSnv4ut1K8A5RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gKgr1BYF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gKgr1BYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E074C4CECD;
	Wed,  6 Nov 2024 13:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898307;
	bh=PbAQ502crNQxzM1H5eMmCnKhj6fnco+pzhKzLFBvQE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gKgr1BYFhEc9KIq0FPKdpbfa+b1t1RsnTfb6QN7Vq9WPk0miNUpeOWGlfi9+2p7wY
	 8Qy+F8JNXpnBXMlm/rWQRVP/+hzq4HGCOiM3xz7HxuJfG7CAwa4NBt5oFBqBhX1/G/
	 h00jhRe0vFm4oWezCA7wEWLCXXYG706gAc5W/p1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiu-ji Chen <chenqiuji666@gmail.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 147/462] drbd: Fix atomicity violation in drbd_uuid_set_bm()
Date: Wed,  6 Nov 2024 13:00:40 +0100
Message-ID: <20241106120335.142812965@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3509,10 +3509,12 @@ void drbd_uuid_new_current(struct drbd_d
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


