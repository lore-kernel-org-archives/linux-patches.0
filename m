Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F893B27FB;
	Mon, 31 Aug 2026 13:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184769; cv=none; b=HmgCs5jpEwL0aX90sRkYfM+BZqNie6AkJrVXM6Fr0ZdQocxn09s/u8a/Rc0NZjF/ECP0Vo7PaYnaryRK+W4Y4SA0QNjSlsc3ByhgpBHYAmxW5bn1T0E6Ehc9t9E6EhKbljSSgaOxtHA/nsJang6x9Veh1KdFVY3lReKl9W0SDHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184769; c=relaxed/simple;
	bh=O8pDfdLCGgo84MZtsrgM9jC2rNNLZBu8owQ6Mt9PDHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YC+mAg08SfXnN1BqxojmAm1tWlPbNl5PqelDJW6oktrMnAzGf5EC51tXebIRUAaCMdy37Z1QV/w0dNyeihrKUkbaYRE6XKubDSTrH7FEmIRIqCPhh137hKnwg6lnxSpfK1X+/2uItFCywbaQZnRcdbNP9jHvqKAZ5UNWOqiPyZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g8zTk0o2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g8zTk0o2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740991F000E9;
	Mon, 31 Aug 2026 13:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184768;
	bh=LneQUBB/h7V3M6i/djMITxAfnHLcf5ApMFzrzEhPBfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g8zTk0o2tNiMHw0/aeDfVdkyMX7ZXbG/trmWTTuuQ2U5inycvctKviG5R8uN/genG
	 sjZBjyH6y8tiiPhcmVRgC+yQEKiUZFCODxl48k/pVthT/JBB4H5vv0wNC3JD0vHSCk
	 QcS2TNGbSRqh4PKEsF3J64+ho3Wqemz4K4+SHU/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 32/92] Revert "mtd: maps: vmu-flash: fix fault in unaligned fixup"
Date: Mon, 31 Aug 2026 15:34:30 +0200
Message-ID: <20260831133401.358335331@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 90494884cd9f02c38b4eafb0ed3b0e1a4410e2ac.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/maps/vmu-flash.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/maps/vmu-flash.c b/drivers/mtd/maps/vmu-flash.c
index ad10f7887dfa0..f96a165fccc7c 100644
--- a/drivers/mtd/maps/vmu-flash.c
+++ b/drivers/mtd/maps/vmu-flash.c
@@ -610,7 +610,7 @@ static int vmu_connect(struct maple_device *mdev)
 
 	basic_flash_data = be32_to_cpu(mdev->devinfo.function_data[c - 1]);
 
-	card = kzalloc_obj(struct memcard);
+	card = kmalloc(sizeof(struct memcard), GFP_KERNEL);
 	if (!card) {
 		error = -ENOMEM;
 		goto fail_nomem;
@@ -628,13 +628,15 @@ static int vmu_connect(struct maple_device *mdev)
 	* Not sure there are actually any multi-partition devices in the
 	* real world, but the hardware supports them, so, so will we
 	*/
-	card->parts = kzalloc_objs(struct vmupart, card->partitions);
+	card->parts = kmalloc_array(card->partitions, sizeof(struct vmupart),
+				    GFP_KERNEL);
 	if (!card->parts) {
 		error = -ENOMEM;
 		goto fail_partitions;
 	}
 
-	card->mtd = kzalloc_objs(struct mtd_info, card->partitions);
+	card->mtd = kmalloc_array(card->partitions, sizeof(struct mtd_info),
+				  GFP_KERNEL);
 	if (!card->mtd) {
 		error = -ENOMEM;
 		goto fail_mtd_info;
-- 
2.53.0



