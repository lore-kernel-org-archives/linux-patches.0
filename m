Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215461;
	b=D9NfW/Zu3w7s44qiS+9cImbpkDXHI7aRyGSx35xhLH/2UPTqjLxCSuS6+Si57Z0P4OHn
	 iv51bVwQLGUI4w+vdesvf9Vy5Y52g2HUuVXx3vqSPflR8ZGnJIvyxoYKEH2+/OUpfpO4W
	 VVfO3EQdV9W6Fy6h2HYjCnkrp2L8KDrbyRvoDBmw7kmZUHc4g52fYOsydqQg83a3+sJ4/
	 aJml7I7TByBjpjlnjN1JDD95o/aUuTEA8wYeU9j/WTD801fPTcxyo93zdGDP54r/5vnY0
	 9GTL0f4d3M5P5ZXEluDIoiXPrtBQQYZJ2EUPAUsJ4tM12UKyVYFuTG6YvNuikoXMsuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215461;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GsrYDNpMiwQCux4KCCdKRGeEOMdNK2BKHTPxPtoZSGo=;
	b=Lm0SmVrV07OjGd+kb7TOoT8IHIHoEcvaDhNf/glEiOIws6Dk1k7DMxuZvI27VXjfQMet
	 wHb7j/6PL3jMkEq7fpFTPv6d8BLyP57qjmKtX4XcokPePL2YxpjKqY0FvOb+19ttQeau2
	 w/sjTE1GwhaJ5ytiWWAs3NtapzJ3yzrxyuopPbQ71H+Iec4ev3/n59XuqX/kqk3GDS8Df
	 Nn49C0D8Fi1skEMCvb4Tc52cegD4CnJBzqfBLYKAEFZ8HAcDjvEZEmY2ZfnAysJDsPpKE
	 DIAQakSvsidQqXVEYweqt4oAK+YYtItW77GscchgSSWE1GBL1nK/bBROSQxhjnb4d5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2AuOggVy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789E2606A31D;
	Wed, 28 Oct 2026 19:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2AuOggVy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 001941F01825;
	Wed, 28 Oct 2026 19:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215461;
	bh=GsrYDNpMiwQCux4KCCdKRGeEOMdNK2BKHTPxPtoZSGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2AuOggVy0FyFgjygYDGcbePVM2rpFzUq80eYqz7RU+7qSmQ2d8CTnQtRpfmFlvDJ5
	 BEfFQH9iP1Q63JDUXvqHwaYtUKWhKanbKr/Hjn0r4iOe7bQyM2yxgVxlc8BLv84rLl
	 djuQs7p0bOaCXLvUKCbUdkMYqKSaoFDJ52vG5sro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1218/1887] mtd: maps: vmu-flash: fix fault in unaligned fixup
Date: Wed, 28 Oct 2026 17:55:14 +0100
Message-ID: <20261028170527.126036429@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
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
---
 drivers/mtd/maps/vmu-flash.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/maps/vmu-flash.c b/drivers/mtd/maps/vmu-flash.c
index 3667faefe6c58..7ae5ecd01ff0d 100644
--- a/drivers/mtd/maps/vmu-flash.c
+++ b/drivers/mtd/maps/vmu-flash.c
@@ -610,7 +610,7 @@ static int vmu_connect(struct maple_device *mdev)
 
 	basic_flash_data = be32_to_cpu(mdev->devinfo.function_data[c - 1]);
 
-	card = kmalloc(sizeof(struct memcard), GFP_KERNEL);
+	card = kzalloc(sizeof(struct memcard), GFP_KERNEL);
 	if (!card) {
 		error = -ENOMEM;
 		goto fail_nomem;
@@ -628,15 +628,15 @@ static int vmu_connect(struct maple_device *mdev)
 	* Not sure there are actually any multi-partition devices in the
 	* real world, but the hardware supports them, so, so will we
 	*/
-	card->parts = kmalloc_array(card->partitions, sizeof(struct vmupart),
-				    GFP_KERNEL);
+	card->parts = kcalloc(card->partitions, sizeof(struct vmupart),
+				GFP_KERNEL);
 	if (!card->parts) {
 		error = -ENOMEM;
 		goto fail_partitions;
 	}
 
-	card->mtd = kmalloc_array(card->partitions, sizeof(struct mtd_info),
-				  GFP_KERNEL);
+	card->mtd = kcalloc(card->partitions, sizeof(struct mtd_info),
+			      GFP_KERNEL);
 	if (!card->mtd) {
 		error = -ENOMEM;
 		goto fail_mtd_info;
-- 
2.53.0



