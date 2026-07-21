Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A7446DFF5;
	Tue, 21 Jul 2026 18:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658821; cv=none; b=ZC6VrdPveIq8N2KzeQfQgtCa3XjwbaRTJHhE8/i3uKIt8otVqrVRSFIu0OxV+Tn4/JPlclh7KNV/g7dvf+MLMte5WA1VSqUD3WE+Q5K4XVqNnxmaRQli1pqVsVfmsiWkNdwRC4u9vaWYGRCshKM+ZgcUxkVZVvpTDNsvqHlrxdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658821; c=relaxed/simple;
	bh=CPdRMOf0bk7FrydD57mlcq/TFqS5VlueTNfGGMCc3I0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JdZ9X3nkx7JOjDbNlPooPl50zHIxQqCBTtV/fEIpQkXmdMklJdF0C65s+aIAikivU7zXi9JZ5u9/Dnt2MEIWJqbWY6NwqdV7T/j9gTLYTdZ4BHSC5gWR1RKAq5LDW5UAW/VgQ6OWth43hG7uNpziCawmsQooRe4o9t+f+dBATEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g5sofTRs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g5sofTRs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B5A41F000E9;
	Tue, 21 Jul 2026 18:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658820;
	bh=BCltebscwHZnpvUMAY+AOt+y+LyYhBa3BIrp1xNuGCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g5sofTRsnqJX+cIlnjTjIMio/HQB1o2gI9iD9qK63z3YCn7Q/XDGNzyXdl/Nb2DBz
	 lZNJzbGNH5ObK63ez5lYyx+TTFB3IPNiCRqVcBWi6sqFoV6ZRxvpvitDuoTNg5svM6
	 afL+emgESZDKuF/07NodUIvS76wHJb6Xukvym1Ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.18 1287/1611] mtd: maps: vmu-flash: fix NULL pointer dereference in initialization
Date: Tue, 21 Jul 2026 17:23:23 +0200
Message-ID: <20260721152544.393145455@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fuchs <fuchsfl@gmail.com>

commit 357e3b8e3a8769ba36eb8ec5e053e4825f1a9329 upstream.

The mtd_info contains a struct device, which must be linked to its
parent. Without this, the initialization of the MTD fails with a NULL
pointer dereference.

Fixes: 47a72688fae7 ("mtd: flash mapping support for Dreamcast VMU.")
Cc: stable@vger.kernel.org
Signed-off-by: Florian Fuchs <fuchsfl@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/maps/vmu-flash.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mtd/maps/vmu-flash.c
+++ b/drivers/mtd/maps/vmu-flash.c
@@ -547,6 +547,7 @@ static void vmu_queryblocks(struct maple
 	mpart->partition = card->partition;
 	mtd_cur->priv = mpart;
 	mtd_cur->owner = THIS_MODULE;
+	mtd_cur->dev.parent = &mdev->dev;
 
 	pcache = kzalloc(sizeof(struct vmu_cache), GFP_KERNEL);
 	if (!pcache)


