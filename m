Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B6A377A92;
	Sat, 17 Oct 2026 16:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253849; cv=none; b=VY8eGTmONvgEDEGqAOt/0Fk2VIwrLSBRYE9epyJ09tTidQJ4QtZFmo51mjgSnt+qoIxs+/VEb7mYHH60PIJtpYTh95a0Ix8fQF0hkYPUm7/qFtWV/Y1b1DwnDnkf4LG+Z0HifF7uy4lk69BlrNS2Nw60RiQ74qr81Al+e23kpO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253849; c=relaxed/simple;
	bh=3w4XWKWXydLFT27mUOWFBQKeMUM0jdQLa/M8OaKdmo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dPKqi04M68yRwuAbQG/Y6daKu6PUaT72B4PLGVF+ucHAfJbMrQqOEhLOSccz5ju2zRBuyxjyPGDij/AljlzY+8EQ/uwDJkVXrQZYjpzMqR4YHBVrDeIbszd8KZKprh6JBDrsvKUIwHQirg98erET+G4tUm9P9U3+RePLq6+yjtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MyG8OXW6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MyG8OXW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776D41F000C4;
	Sat, 17 Oct 2026 16:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253848;
	bh=ckILJFL2MQQ2v1HWni3+dTA/yhAelXtCD55x2/iLr7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MyG8OXW6upNjzgwhnFa+WulGm30mB0OnR0939C4C3cr3LCmDqUtb36kYkAGuQNy5n
	 4tnjyip+SwFBtugsAlfSFEAJb0H6r6GvYYXzod7m53cyHcTRoPGILtcASFZEKVJ4L5
	 JemJ+YmA92TJG151sXdMkNiJ41ArIFZw/LaJEbZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 254/869] md raid: fix hang when stopping arrays with metadata through dm-raid
Date: Sat, 17 Oct 2026 17:51:35 +0200
Message-ID: <20261017160043.570018333@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
 drivers/md/md.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index a6f71253511cf..55632055196f0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6484,12 +6484,14 @@ static void __md_stop_writes(struct mddev *mddev)
 {
 	del_timer_sync(&mddev->safemode_timer);
 
-	if (mddev->pers && mddev->pers->quiesce) {
-		mddev->pers->quiesce(mddev, 1);
-		mddev->pers->quiesce(mddev, 0);
-	}
+	if (md_is_rdwr(mddev) || !mddev_is_dm(mddev)) {
+		if (mddev->pers && mddev->pers->quiesce) {
+			mddev->pers->quiesce(mddev, 1);
+			mddev->pers->quiesce(mddev, 0);
+		}
 
-	mddev->bitmap_ops->flush(mddev);
+		mddev->bitmap_ops->flush(mddev);
+	}
 
 	if (md_is_rdwr(mddev) &&
 	    ((!mddev->in_sync && !mddev_is_clustered(mddev)) ||
-- 
2.53.0



