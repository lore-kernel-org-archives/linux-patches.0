Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5DF76C76;
	Mon, 15 Apr 2024 14:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191124; cv=none; b=C/bBYA4jLpjwXo+lleg9zjcROLT4MpfIm9goaZuhCAQTwdIzC51wmEE9wIMoxdd2rhtleoqjXsgOFr9Chs9rqv5ddCebzPZH0AFsC6LtUrFHPm5ic8nUZBrEwhJDgJrp2ma/+w2wbxvAAW1wL2174ZSGFrWHdlectMHAB1e9WeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191124; c=relaxed/simple;
	bh=GJypxR0MI+M4YlWkTghBtIQ9Ec31c76fThjPgMsvnT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+XmO+7mDSUr9pv9LpBz8JX7hsDQbd07tW8Cdhx0ROF4iQCj9hf6YuZtD+7/cFGZhLrJCV+DPTBnpG2kMub9ao6Wn2vjJMX9oFnVnuRGw7taleNNigQt6Baco3OZAXX7eBFnYQaZ2+6vW4kuk2kRdVciANpOHCh+b1aLRrL//CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jJc1x7/1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jJc1x7/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA11C2BD10;
	Mon, 15 Apr 2024 14:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191124;
	bh=GJypxR0MI+M4YlWkTghBtIQ9Ec31c76fThjPgMsvnT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jJc1x7/1VhMYXKGtOeQqNfgjxK0W1l44yanS/8z/guCL3kDnOIT4sP9gCusa3iKgh
	 Mpmbf2MQnKTojGwnaHFw6SNIXxSyqlqcYhysoEN/u+X5VYbon6WZMMVocTZhsIYoS0
	 42ZBAT+f2ZxqEUCTzfzuaAiQozmCrktFp4cJ5zWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Danilo Krummrich <dakr@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 039/172] nouveau: fix function cast warning
Date: Mon, 15 Apr 2024 16:18:58 +0200
Message-ID: <20240415142001.613221801@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



