Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E6D44C51B;
	Thu, 20 Aug 2026 17:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248147; cv=none; b=asAWUhQ6T618D7HbJxyvtRbxEKHB4z6UiXvjW94zN7z6HRcwGN3OdDdF7kaDfYJdYYnztiSqattlk/LnUC01l0Xo/3iLYEB4tqdzTvlL8dGFM8vmWmMCP6uVjh2ZP6WZQqpESQTEvChnXcQkwT0A7R9CGo2xFgHEyPTF9CwjaNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248147; c=relaxed/simple;
	bh=3m5xEbXoFC+o5a5efeUCRPkES/8AoEKl4bKwAVnfyIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TPkrof1lhRIlPxg7iHijop0mWOgDoZt4WiLF+NRtvSScyrStDYtXZ1nWxWjpqOflrxDLW+Ty9Qni1F67PJRPao0TWI81T9FAWEMf8fR0hgmpAQJ70SKgoYBXb2fFUj6SlNwtynSw6AIYw4FEvl4O/2uG69CBHCgdgdQhTf9qYIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HT6eWre1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HT6eWre1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3301A1F000E9;
	Thu, 20 Aug 2026 17:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248145;
	bh=EkUWy8O2ZO68g9fvvG5n4MjMqqMMFcMS0n4Z2tFzuLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HT6eWre118VMmxinNR4SAZD+ETL21E1uqZ2fdXQvThbChzsMa1PqNpXYiCV0ZA3Mw
	 HXQM4lYaEhce7zR4tHkS2QDcoUTGhL9UF2QdNzuOs+BJ/wp8XtuOvr+XHWh2tW3pKa
	 FR/4VsdXFIj0It2B1WT6RtJR08d9xKaj7VyuDGkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 126/303] mtd: maps: vmu-flash: fix fault in unaligned fixup
Date: Thu, 20 Aug 2026 16:54:22 +0200
Message-ID: <20260820145257.064320041@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

From: Florian Fuchs <fuchsfl@gmail.com>

[ Upstream commit 79d1661502c6e4b6f626185cef72cf2fa78116e1 ]

Use kzalloc_obj() / kzalloc_objs() to allocate the memcard structs,
instead of kmalloc_obj() / kmalloc_objs() to prevent access to
uninitialized data.

Fixes runtime error: Fault in unaligned fixup: 0000 [#1] at
mtd_get_fact_prot_info.

Fixes: 47a72688fae7 ("mtd: flash mapping support for Dreamcast VMU.")
Cc: stable@vger.kernel.org
Signed-off-by: Florian Fuchs <fuchsfl@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/maps/vmu-flash.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/mtd/maps/vmu-flash.c
+++ b/drivers/mtd/maps/vmu-flash.c
@@ -610,7 +610,7 @@ static int vmu_connect(struct maple_devi
 
 	basic_flash_data = be32_to_cpu(mdev->devinfo.function_data[c - 1]);
 
-	card = kmalloc(sizeof(struct memcard), GFP_KERNEL);
+	card = kzalloc_obj(struct memcard);
 	if (!card) {
 		error = -ENOMEM;
 		goto fail_nomem;
@@ -628,15 +628,13 @@ static int vmu_connect(struct maple_devi
 	* Not sure there are actually any multi-partition devices in the
 	* real world, but the hardware supports them, so, so will we
 	*/
-	card->parts = kmalloc_array(card->partitions, sizeof(struct vmupart),
-				    GFP_KERNEL);
+	card->parts = kzalloc_objs(struct vmupart, card->partitions);
 	if (!card->parts) {
 		error = -ENOMEM;
 		goto fail_partitions;
 	}
 
-	card->mtd = kmalloc_array(card->partitions, sizeof(struct mtd_info),
-				  GFP_KERNEL);
+	card->mtd = kzalloc_objs(struct mtd_info, card->partitions);
 	if (!card->mtd) {
 		error = -ENOMEM;
 		goto fail_mtd_info;


