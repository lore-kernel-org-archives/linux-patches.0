Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0943A3191D8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300941; cv=none; b=tEUnkq9mrk4hofW/VcrwkZiK33BDlfTLNN6L44v/CGvn+0xf1PuPn5OmjhDOPAiqUs6/+g86VT44P/+6ByP+W9M5b58T4gLnQ+tKGZVtokrLlq0cQpHV6Ejfy+zOt93D/TyF/G4BGTDR/ugfNVvvHi3Rz9PcM+shrrUm1v0BpJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300941; c=relaxed/simple;
	bh=+VJ9E4IPW+H1Ss+kYh6Qf7/4XPNtDvd7uOF3V6tOdq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdtnGRkPatBgtUH9/X22asvEybATjHQaRpyr/1zGHqW50D5gyUP/RF4Xl3qx0u8SUFhRxqttcgncf0RnEiNN/CVTTj72DpvW+kRnwHU5k3Bpq75wINqUo7ZSpfnDRqfxivR9+ryTPTezkinafgxIkA6/oqKEsYN0PSabNbWtIxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jRHVspj3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jRHVspj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE5EC116D0;
	Sat, 28 Feb 2026 17:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300940;
	bh=+VJ9E4IPW+H1Ss+kYh6Qf7/4XPNtDvd7uOF3V6tOdq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jRHVspj3+tNVNzv+0/HtVQvs5Eaxx1ihGqXcdftVfn910LZsvz1v4MlfCVrEM5qrN
	 5coPSK72UrBx7GXFZq1CplPJojRrsZNnpUiDb3L5DsoeH/iAzVyXKzy/1etySHNzx4
	 rCg184ucoacuLAmYoWc9/SETODrrIwSJizUPv/MUl1Zx2kF75jTaeloLyIuHXzCXxa
	 +/K5U5Zr/7re1Ebu91JKtTQP8ZQvvhOPpoIc9RISXgIZSz8YZfIQv7uJU6bhFFao2t
	 tXosQUto/7Cietq3ImW7GLFCWDd6OKapNPy2hCfWpmivdWLe8JR8ecQCZskWoNRlv8
	 6+29cq6kh9p6A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Heinz Mauelshagen <heinzm@redhat.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 062/752] md raid: fix hang when stopping arrays with metadata through dm-raid
Date: Sat, 28 Feb 2026 12:36:13 -0500
Message-ID: <20260228174750.1542406-62-sashal@kernel.org>
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

From: Heinz Mauelshagen <heinzm@redhat.com>

[ Upstream commit cefcb9297fbdb6d94b61787b4f8d84f55b741470 ]

When using device-mapper's dm-raid target, stopping a RAID array can cause
the system to hang under specific conditions.

This occurs when:

- A dm-raid managed device tree is suspended from top to bottom
   (the top-level RAID device is suspended first, followed by its
    underlying metadata and data devices)

- The top-level RAID device is then removed

Removing the top-level device triggers a hang in the following sequence:
the dm-raid destructor calls md_stop(), which tries to flush the
write-intent bitmap by writing to the metadata sub-devices. However, these
devices are already suspended, making them unable to complete the write-intent
operations and causing an indefinite block.

Fix:

- Prevent bitmap flushing when md_stop() is called from dm-raid
destructor context
  and avoid a quiescing/unquescing cycle which could also cause I/O

- Still allow write-intent bitmap flushing when called from dm-raid
suspend context

This ensures that RAID array teardown can complete successfully even when the
underlying devices are in a suspended state.

This second patch uses md_is_rdwr() to distinguish between suspend and
destructor paths as elaborated on above.

Link: https://lore.kernel.org/linux-raid/CAM23VxqYrwkhKEBeQrZeZwQudbiNey2_8B_SEOLqug=pXxaFrA@mail.gmail.com
Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e04ddcb03981c..92ec4be20db85 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6716,13 +6716,15 @@ static void __md_stop_writes(struct mddev *mddev)
 {
 	timer_delete_sync(&mddev->safemode_timer);
 
-	if (mddev->pers && mddev->pers->quiesce) {
-		mddev->pers->quiesce(mddev, 1);
-		mddev->pers->quiesce(mddev, 0);
-	}
+	if (md_is_rdwr(mddev) || !mddev_is_dm(mddev)) {
+		if (mddev->pers && mddev->pers->quiesce) {
+			mddev->pers->quiesce(mddev, 1);
+			mddev->pers->quiesce(mddev, 0);
+		}
 
-	if (md_bitmap_enabled(mddev, true))
-		mddev->bitmap_ops->flush(mddev);
+		if (md_bitmap_enabled(mddev, true))
+			mddev->bitmap_ops->flush(mddev);
+	}
 
 	if (md_is_rdwr(mddev) &&
 	    ((!mddev->in_sync && !mddev_is_clustered(mddev)) ||
-- 
2.51.0

