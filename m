Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E12D78B61;
	Tue, 27 Feb 2024 13:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041224; cv=none; b=jzYWod45IGmlQ0XMhX+qrUHEVKoyij3ez28woXQEy9hFVaWzPRDzZInLUvfwE9ZtIGsh+UcBvFqwwwMdbjnanwMtPr1s5MeJSpfUceJFTn5MCheZwUk1DmtNGMWw+U7S26xoKmzZIYUAvoywgDRKdVWLS3KBWcZse6NwFHmjBE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041224; c=relaxed/simple;
	bh=zOdP6bGX8AeB5y0WdSl6EyvLwOpPeHw8Z5tjpFgBV/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BNcMX5qFoRx2ANC+6+r9i7f2YCq76bi0wGSmaDYEMNwtII/4hFXuO0NVJ+W1j7ysABPcrPLgBoUveuClOsqyP8XWREEwtliJ0EqsV9jXBaSDy2hQ3wjapoQ8bNUnC52iZY7quszv5/TRLVLKoR7jEuMEwscvJFjQS3k7t45VJKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iVcofxEd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iVcofxEd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4ECAC433C7;
	Tue, 27 Feb 2024 13:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041223;
	bh=zOdP6bGX8AeB5y0WdSl6EyvLwOpPeHw8Z5tjpFgBV/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iVcofxEdwEl+hEUu/9jw9qhRAKtiLfgtoys2uNTJ2OasGprV3wjo9nU9DgygInJjp
	 LHIlCzzjTpxpK4dRU4lRwO+xhF1wTRUfGZQl8AhKho66rXwMAQFXehEv4lbgx51cQK
	 cuoGziNdpB2Wdhb1zm76T3umjwOCIdtrF8Ocu6as=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Danilo Krummrich <dakr@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 264/334] nouveau: fix function cast warnings
Date: Tue, 27 Feb 2024 14:22:02 +0100
Message-ID: <20240227131639.478531248@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 0affdba22aca5573f9d989bcb1d71d32a6a03efe ]

clang-16 warns about casting between incompatible function types:

drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadow.c:161:10: error: cast from 'void (*)(const struct firmware *)' to 'void (*)(void *)' converts to incompatible function type [-Werror,-Wcast-function-type-strict]
  161 |         .fini = (void(*)(void *))release_firmware,

This one was done to use the generic shadow_fw_release() function as a
callback for struct nvbios_source. Change it to use the same prototype
as the other five instances, with a trivial helper function that actually
calls release_firmware.

Fixes: 70c0f263cc2e ("drm/nouveau/bios: pull in basic vbios subdev, more to come later")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Danilo Krummrich <dakr@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240213095753.455062-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadow.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadow.c b/drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadow.c
index 19188683c8fca..8c2bf1c16f2a9 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadow.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadow.c
@@ -154,11 +154,17 @@ shadow_fw_init(struct nvkm_bios *bios, const char *name)
 	return (void *)fw;
 }
 
+static void
+shadow_fw_release(void *fw)
+{
+	release_firmware(fw);
+}
+
 static const struct nvbios_source
 shadow_fw = {
 	.name = "firmware",
 	.init = shadow_fw_init,
-	.fini = (void(*)(void *))release_firmware,
+	.fini = shadow_fw_release,
 	.read = shadow_fw_read,
 	.rw = false,
 };
-- 
2.43.0



