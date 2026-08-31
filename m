Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6995C489885;
	Mon, 31 Aug 2026 14:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184991; cv=none; b=EyVbob0I7sFYQqEet9KhDXB7K6y2GQY8bNcgtn1Xipe6Hwh9Qh09tgvuvA4Wi8WdqoMjPqUcF2AT3bFebaJwq2pdRXjW+GF/SYXX2a1z6LzBybR2fQM9pv75dnVPN2RRxLgFZ0/m40UyJE76APt83oV0dC7G/a1ITwByjKTt5F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184991; c=relaxed/simple;
	bh=UifxciB0s9QMdlG42UFGF8EG3GEGxuRKGqFQz/X9ec4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIr2+vSDyx3wqIOJ6BTo48dtNM8VTEqOTcamf8NHdU4kfReR0hgy9nbBl/rrhZ9FI/5rOLxdEaJFSlwPDC8y7hdNuQsjAPmlzfg70dL3+3vy4Q55GdgpoSnjxsPfJkeO0wNlexgF1usw0/EGnxFstRRIPlCvK1jJZThFTCvxrV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VpKNjr4F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VpKNjr4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53251F000E9;
	Mon, 31 Aug 2026 14:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184990;
	bh=sHcQ1VQaawqt4C7GUWSLPklTzST3tgQFNqPCKkpLyts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VpKNjr4F1Li/nie+Naj2PWBIYZnGCm4durtriueRQ6joAiOmTOJmFNvk/rSxViXnC
	 10A9xTiRuJO5jJwREDFOSz00ukCFU93sgUwuHclQ4tr/HES3pp8Kyf0iu/R7D/oKpX
	 6m/ZyJnzYlvYhGFnsGEdbkLcQszYCbdZde+YBgrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 16/69] Revert "mtd: maps: vmu-flash: fix fault in unaligned fixup"
Date: Mon, 31 Aug 2026 15:34:49 +0200
Message-ID: <20260831133359.284960785@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
References: <20260831133358.601894154@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 631edc934e476991a04723d3283e6628d077f8c1.

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



