Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A60D40315B;
	Tue, 21 Jul 2026 17:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654600; cv=none; b=HXVyvRPwrBvw/aYFn0SviWJtC+vEarPUYM5GnlRqSkJ+XYyr5SSHqVUvgs9eSbQbu89EXl931O9THfdCyVnM+G9C5avOpdEjejDK+U9TLUDNCyBbf0N3CJMNoEbxnFLOWnev0LNfLRncZRGlDtPtArBrW0LBx3G11lk9ZFhJh+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654600; c=relaxed/simple;
	bh=sztT3c0On9m20jAv/FzkC5F0QIBTWoKvFboQac0yfkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipUDsnJSdHhafBh70ONvwoe3pD3UaxvPif9D1fvNadORRvM7OXYU0uIiMvtMWfmxuqdNxVJYpZoPFgRPNyQC2NkVarEa4MAQwYKzINAGoPIDMLlpq7gO6S2uDLcqm9PEnfvVuiSabHh7afS4hTIDe7ZQMJZ+Rp2qsUVD7xcMWVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NXHeYw5z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NXHeYw5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D071F000E9;
	Tue, 21 Jul 2026 17:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654599;
	bh=7cQu5wM3maRug7dQ4hTDiNnF5rfvUQlVvgkO/pI8R98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NXHeYw5z7W0/cNWhCAQ/RCLQmFiYCDhvn70+7GC/gqIz8c87crBpO00j0uVEoUtnr
	 gtuUeOXV+qbsAFQnKCS51vylkciekPae+Q6cIAkMDzH9+mng3/5S38GTMwr3sc6+Zq
	 /YpcMYzQt3wZOQdISVWA5XT6u1h/+l+kxf8g+mRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 7.1 1767/2077] mtd: maps: vmu-flash: fix NULL pointer dereference in initialization
Date: Tue, 21 Jul 2026 17:24:00 +0200
Message-ID: <20260721152634.423457917@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 
 	pcache = kzalloc_obj(struct vmu_cache);
 	if (!pcache)


