Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B4A47CA88;
	Thu, 20 Aug 2026 16:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243491; cv=none; b=VM353GGFDxdd7dUfieFTyK9A3OpjvimM9Ibp4DYMJGd23TxNMgwjPYPmJZqgMzXbIXTTdChSPEao99gs3zM1LGXO0viP6t1F6UA+MZNfpycPxRp/FoUZUDAdELSlqlzt3dvwBeB4sH5q+7EtHdf7M9meGWD+flnEPHQKAuMfPjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243491; c=relaxed/simple;
	bh=ck15bjkEAHeJS7AOkGP2Mk0eMfeN8lK18aj6OViQdlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lHfF+vd8JPPrsuNqIy7qg+kZgRBw7lApb82FGf5ORPvxfZOGH7YfBshYKU/vmw6HnuOiisnk2Uoh4rvx0PMXorB8vV5RuiABzx6nyvNmVNYZcg40uWDw9lMSTzHWFpSyNELIKsMxo4szstWxXPUFnxwel1sr8McH9wQlOFUGPqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iHEbh54f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iHEbh54f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5771F000E9;
	Thu, 20 Aug 2026 16:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243489;
	bh=LUb+94Z5eg6m0ZEdmK9O/AyJfuWmY93TcMvjmMhew28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iHEbh54faSfhkUKMSxbkEbf8e9d1GXCL8cQID042coz08HyHc0aFomykq9WH0S13D
	 GtUA8fJ0ktH5samM2NDaEKXKA56AD5pjp2GO0+IBPdUuNCk0XH1dy+F44A8m0kgmz4
	 32IvfeUoUIoC35Tlprt62vwXZNlmwlCtWj1/aPz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 111/272] mtd: maps: vmu-flash: fix fault in unaligned fixup
Date: Thu, 20 Aug 2026 16:54:55 +0200
Message-ID: <20260820145234.598655383@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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


