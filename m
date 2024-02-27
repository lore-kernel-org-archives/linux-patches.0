Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8460213B2B4;
	Tue, 27 Feb 2024 14:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044275; cv=none; b=LtpHKoIHARGlw09Wa7yxkVm/NGy9xTZK7tVOufzzU8rH1hRFRGtL2vjuJZV6kvSTE8dwag0OAMZQfweFFgmg5nRdGMeFVHrjCKmV3UYqLSrhwZMWnLkEou/uPA9DJl1sJb8VPdB8fASM3g1HACyQQxwxSkwlP5ypie8OZolDmyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044275; c=relaxed/simple;
	bh=HY2BaqhEcCYCU1XFKNpiSb+N4lKY/lYF3MhgFzHpYSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rb83fdkixa++2pGARQ21xgB7vU1HETbMg+C/v0O5u7Jmdcu7pfjbBHO9qK77ZaY1nENWG1fyxr9zg1MIO1Luc+PxPgJSXnnWpp1cBFUSsx99idbubR1g5znNcx0PUcuCi//ljNW7x8FRFWu330735GvBLpQo+oJfkEGoLUlMWGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LthCPs7I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LthCPs7I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C36C433F1;
	Tue, 27 Feb 2024 14:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044275;
	bh=HY2BaqhEcCYCU1XFKNpiSb+N4lKY/lYF3MhgFzHpYSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LthCPs7IghnWq3Sj4mJfgUvfjkEU0Q6kym/sOZ2/etXjeM6ioUW1D8ruJNrNzbc4H
	 iNxpADI62ycpau3wNwglcI97IamqWCm39km2qAsvylfHRVuIejuzKHKGWP+V4NcSJB
	 qRgteBFn2bsbHdWJtvBfiOFOt08jnwX/zrHlZEpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Danilo Krummrich <dakr@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 104/122] nouveau: fix function cast warnings
Date: Tue, 27 Feb 2024 14:27:45 +0100
Message-ID: <20240227131602.109701214@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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
index 4b571cc6bc70f..6597def18627e 100644
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



