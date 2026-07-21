Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD593B47E3;
	Tue, 21 Jul 2026 22:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672532; cv=none; b=sr/C+f3ipooL9sI1ppkpqh0l8wHHhh+DaJamK2x36K+eEUGa0tNmBlPNybQCfnktxltNgZOI7W9lyzbvzPBGPGSBe/u6hRqBrKAZUlUk5lHlSsqMOPFkPKZiKdt6zmfO6xto9jsjpqZjw3uzskoR6kZu6X5bTtKsAKcVqkvaZ0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672532; c=relaxed/simple;
	bh=Fb8kxadSrub3oYykpdfKFqW65EmCza+0DBvaYTkmBKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEGqNci9Lt4Tb+BATBq5SZWr7oCT/RWU0Qb6EpqRKKRjgtPIrZ6B21jUroYJ67ngciVx6AC+KlqMy+2XDmNrihc7eziSIhSeBMljXcXG47056jDwL2w/6dfbArtTIGtVSuJm2dZVedyBhyacycStRa2ScBk9jPV6hmJwpE2NCaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W9J5lzPP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W9J5lzPP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289121F000E9;
	Tue, 21 Jul 2026 22:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672531;
	bh=2VZWubn5zreKlrGms9ORYReFGVHDlePKcx7/CU+EMlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W9J5lzPPnzpZT+R/aL/oC/b2T23/9VTe4yDo2AeiO+mKL8sAQ/l0dzErjp3wimu8Y
	 Cy33LEJkkrnMnNma/M06/bAJ6h9qpDZyc2a19F8xXdyKm26n9dVvGrn8dWsXZVcphl
	 1GvfjfyxZfdNhPwVoURrbpsZKC+DnCDPiKU9kV2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 633/843] mtd: maps: vmu-flash: fix NULL pointer dereference in initialization
Date: Tue, 21 Jul 2026 17:24:28 +0200
Message-ID: <20260721152420.302626372@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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


