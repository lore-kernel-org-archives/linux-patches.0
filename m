Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6827A1E4B1;
	Mon, 15 Apr 2024 14:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191613; cv=none; b=fcfRlX7k8RryuwzGmVi18T2ShWYSE/NACKDrf1gXsfcWexV5uOIM6mJqQmuxy1atgetGlIQkWOd59oYLeB/DyUPnjRl7bqjHZAychL5DtO9jSOO8oey4eYYBzB6tWF2rGcIUeuBZmj3fFZihp7oMfRviVsLHmorY/TEkvoXhJnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191613; c=relaxed/simple;
	bh=qlQL3wp/RHj+x0YN/63soH8fnY7EShzzXDuVSFUpvDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LHCefrm2TtOgfOgb/uArk720iIDE1zpiuHnEZV+Zj3zZyVmyYVsF1TYhZnR6u8bVEIMXOuadOM8c7xIui0mqKkkRZn8TvBbFopUvwMM9YLGF2kr9YD9pyXtbDz8d19kQnMwZk6nagCuI2kPWESLixs+qFbsitAJ0Ddpqyg99bp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1iXUMKXy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1iXUMKXy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A90C2BD10;
	Mon, 15 Apr 2024 14:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191613;
	bh=qlQL3wp/RHj+x0YN/63soH8fnY7EShzzXDuVSFUpvDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1iXUMKXy2U88I11oB6IKtSvgq4fPyZiI0yVBUk/ccuRfaaj9B4hESAvWhg90cntZB
	 XYmMjwdnXzGLXHRx3PsqQZ8DXCdkjHUdeiHm7o1Y4Y7buYBSkconVFQOLyNiEdrrDB
	 JawWYkZTYG7PxN3UmlT/GrvMKbTFTryfEuUVxP9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Danilo Krummrich <dakr@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/122] nouveau: fix function cast warning
Date: Mon, 15 Apr 2024 16:19:53 +0200
Message-ID: <20240415141954.216203747@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 185fdb4697cc9684a02f2fab0530ecdd0c2f15d4 ]

Calling a function through an incompatible pointer type causes breaks
kcfi, so clang warns about the assignment:

drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadowof.c:73:10: error: cast from 'void (*)(const void *)' to 'void (*)(void *)' converts to incompatible function type [-Werror,-Wcast-function-type-strict]
   73 |         .fini = (void(*)(void *))kfree,

Avoid this with a trivial wrapper.

Fixes: c39f472e9f14 ("drm/nouveau: remove symlinks, move core/ to nvkm/ (no code changes)")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Danilo Krummrich <dakr@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240404160234.2923554-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadowof.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadowof.c b/drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadowof.c
index 4bf486b571013..cb05f7f48a98b 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadowof.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadowof.c
@@ -66,11 +66,16 @@ of_init(struct nvkm_bios *bios, const char *name)
 	return ERR_PTR(-EINVAL);
 }
 
+static void of_fini(void *p)
+{
+	kfree(p);
+}
+
 const struct nvbios_source
 nvbios_of = {
 	.name = "OpenFirmware",
 	.init = of_init,
-	.fini = (void(*)(void *))kfree,
+	.fini = of_fini,
 	.read = of_read,
 	.size = of_size,
 	.rw = false,
-- 
2.43.0



