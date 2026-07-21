Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4126E44AB8E;
	Tue, 21 Jul 2026 22:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674309; cv=none; b=aBxyb7uL8yx0cGlBUISsFBGJwtWMssqfJggjZu40dXGjtkj/9GXbvap5tUU3R4YA3hNBQqdtPx3DlDpmYamMm/7ZSpsAGl6XRrWe+HHp1MBxUexD2juZXrPkfyc/XmHf2L/fLi6ebX2y10RcKfU9dtRYhPbuuKp2yhqNO/X0uu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674309; c=relaxed/simple;
	bh=v/QMm4ilkerV0FyYadm9y8QC6BJYzhv0LMPpQ8GWkhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPpzrmN3rveas9m3LvN3WJrc9ZpOFZDdS/C+jJykgXmGg4HbTfFj5Bt591ka+kWzws3zsJwHsa59yRwxmwEVIE0iOIlrISLA3scXKkN3AnJk/LjrLgHVdf/j/gyHIVAcsx97Mwo2VD6EddzcB2mo6GWwJzpXnpU94SQKd6R1RCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aXqgMGI5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aXqgMGI5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480EC1F000E9;
	Tue, 21 Jul 2026 22:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674307;
	bh=qmzyszMC1g8wmdC+oE+uC1EWzhKYoMkv4G6KyUvvLGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aXqgMGI5F2Tia7H+8YetRSmIoG23xXYCI+mXCJ2kd0LPtwn6X9qi6KlOFF1xi45Co
	 Lm7lRTAqN3Humvg+RQX/iqYWDhiXDz7wiRAtWT0T/oJ3E6YKw8RW8gdA8F6qsplJ/G
	 alqI+0SzLSmSTWEgDh+l17BloAohr8Xl+QxGibdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 490/699] mtd: maps: vmu-flash: fix NULL pointer dereference in initialization
Date: Tue, 21 Jul 2026 17:24:09 +0200
Message-ID: <20260721152406.750729252@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


