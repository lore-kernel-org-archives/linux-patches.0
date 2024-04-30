Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9337464;
	Tue, 30 Apr 2024 11:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474805; cv=none; b=amjK+gaLfMmrwZUsf82S1ub5cpz/+R/aohQARfY5kc7yzHrbhBbBkrCsWwZRc+tPtpGKUBvZLtG+ARiNhByJlCs9C0yMD31Fogd0TkdMD35dFJnfkjIrsbIgUJLUga6d2ANd2S/wfWBNmR0XipQz7h6fYIVpM2Yqjd6C02DCneo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474805; c=relaxed/simple;
	bh=aloawWbRN9/PG+xuNmWdEnIGNr2wLlMXGy9C0MoPyao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+qAiwO8nSmCOxbYkwKCsr0nHQ6cV1m6t/TdoJGQfsoffn0htPK5Tq6THvMU/a1a6HWpUhndO0OkqRm+RwZFuyG7iocLHH4m893jc3qSnnr/b8MI3/QNHrbwm5KObKTL0A96t7f+Zt2/6OhuPXaTI6uPwcoRliQZbV19raNC7tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i48PLySH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i48PLySH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA55C2BBFC;
	Tue, 30 Apr 2024 11:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474804;
	bh=aloawWbRN9/PG+xuNmWdEnIGNr2wLlMXGy9C0MoPyao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i48PLySHnZDebEGkd7fPyFI3UeF+PSh4w+y+KjzQ2NTBKg1PJqkpl18r+rGGSie9l
	 azBVofKo6MUmQlH4Q9siypAtiv/Yt7pEqsXDFuWVEET84aKxb2RrSW6qNg2vDE3/OD
	 1igeP7LfCS65Ighu0CxbF3ckrXfC2dkN1oUAA+tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Danilo Krummrich <dakr@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 004/138] nouveau: fix function cast warning
Date: Tue, 30 Apr 2024 12:38:09 +0200
Message-ID: <20240430103049.555464669@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



