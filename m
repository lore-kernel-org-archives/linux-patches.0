Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812641E0083;
	Wed,  6 Nov 2024 13:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898527; cv=none; b=T/NHOtDzTlYiSrUdPNxC6SeuSQp/pBV0/gamMcZh0tIV6F1yUOF9TQzLgUR9xnOgNAPHnmnCYmAAnQCwzZbypIXjAhBddl/G0Xi92nt7ztO2b8y+04LxlevteXi32ZSIln02yLWyrjWYzJsk7Lq5H7mE3/2GoGTRerd5houZ+L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898527; c=relaxed/simple;
	bh=F7y9A0egg9w1vamiNEAjApzHJDqm5mgKof1uaznAYCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KrY/Lmu+qaMz133Ng8+ioJZiyVVc9q6WI04gButpWvGH8Pnx9MjNizASKt/fXk+Sytuh6mREJGWp7wj7s4iFzBFZmR2RHl2mlXyjrMol1ytfCXImMxTwdN3Iwa2WgrZYwu/U2uLQlw3CkI6WflBHlD6TrET27aWDu9q0wix5zwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w/EPLwWy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w/EPLwWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE78C4CED3;
	Wed,  6 Nov 2024 13:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898527;
	bh=F7y9A0egg9w1vamiNEAjApzHJDqm5mgKof1uaznAYCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w/EPLwWygkAAkDzIqtMPvuYfx57zYmVZLhGWBjVuOQ0F91wAv8/AwGicZqtOfmP79
	 2F0HjNoo2fKc+UUvRsZVf9mkvtbbbE3gB+Fqru+lP4iLYAau/vAVy9bAYeZ08O0Pmb
	 OWDx0FqWygKI0E6sSCdOURMFebWa+rRpWmYoq3Ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 231/462] drm/radeon/r100: Handle unknown family in r100_cp_init_microcode()
Date: Wed,  6 Nov 2024 13:02:04 +0100
Message-ID: <20241106120337.228448778@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit c6dbab46324b1742b50dc2fb5c1fee2c28129439 ]

With -Werror:

    In function ‘r100_cp_init_microcode’,
	inlined from ‘r100_cp_init’ at drivers/gpu/drm/radeon/r100.c:1136:7:
    include/linux/printk.h:465:44: error: ‘%s’ directive argument is null [-Werror=format-overflow=]
      465 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
	  |                                            ^
    include/linux/printk.h:437:17: note: in definition of macro ‘printk_index_wrap’
      437 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
	  |                 ^~~~~~~
    include/linux/printk.h:508:9: note: in expansion of macro ‘printk’
      508 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
	  |         ^~~~~~
    drivers/gpu/drm/radeon/r100.c:1062:17: note: in expansion of macro ‘pr_err’
     1062 |                 pr_err("radeon_cp: Failed to load firmware \"%s\"\n", fw_name);
	  |                 ^~~~~~

Fix this by converting the if/else if/... construct into a proper
switch() statement with a default to handle the error case.

As a bonus, the generated code is ca. 100 bytes smaller (with gcc 11.4.0
targeting arm32).

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/r100.c | 70 ++++++++++++++++++++++-------------
 1 file changed, 45 insertions(+), 25 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index 9d2e6112f70ae..a5545403b9601 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -1005,45 +1005,65 @@ static int r100_cp_init_microcode(struct radeon_device *rdev)
 
 	DRM_DEBUG_KMS("\n");
 
-	if ((rdev->family == CHIP_R100) || (rdev->family == CHIP_RV100) ||
-	    (rdev->family == CHIP_RV200) || (rdev->family == CHIP_RS100) ||
-	    (rdev->family == CHIP_RS200)) {
+	switch (rdev->family) {
+	case CHIP_R100:
+	case CHIP_RV100:
+	case CHIP_RV200:
+	case CHIP_RS100:
+	case CHIP_RS200:
 		DRM_INFO("Loading R100 Microcode\n");
 		fw_name = FIRMWARE_R100;
-	} else if ((rdev->family == CHIP_R200) ||
-		   (rdev->family == CHIP_RV250) ||
-		   (rdev->family == CHIP_RV280) ||
-		   (rdev->family == CHIP_RS300)) {
+		break;
+
+	case CHIP_R200:
+	case CHIP_RV250:
+	case CHIP_RV280:
+	case CHIP_RS300:
 		DRM_INFO("Loading R200 Microcode\n");
 		fw_name = FIRMWARE_R200;
-	} else if ((rdev->family == CHIP_R300) ||
-		   (rdev->family == CHIP_R350) ||
-		   (rdev->family == CHIP_RV350) ||
-		   (rdev->family == CHIP_RV380) ||
-		   (rdev->family == CHIP_RS400) ||
-		   (rdev->family == CHIP_RS480)) {
+		break;
+
+	case CHIP_R300:
+	case CHIP_R350:
+	case CHIP_RV350:
+	case CHIP_RV380:
+	case CHIP_RS400:
+	case CHIP_RS480:
 		DRM_INFO("Loading R300 Microcode\n");
 		fw_name = FIRMWARE_R300;
-	} else if ((rdev->family == CHIP_R420) ||
-		   (rdev->family == CHIP_R423) ||
-		   (rdev->family == CHIP_RV410)) {
+		break;
+
+	case CHIP_R420:
+	case CHIP_R423:
+	case CHIP_RV410:
 		DRM_INFO("Loading R400 Microcode\n");
 		fw_name = FIRMWARE_R420;
-	} else if ((rdev->family == CHIP_RS690) ||
-		   (rdev->family == CHIP_RS740)) {
+		break;
+
+	case CHIP_RS690:
+	case CHIP_RS740:
 		DRM_INFO("Loading RS690/RS740 Microcode\n");
 		fw_name = FIRMWARE_RS690;
-	} else if (rdev->family == CHIP_RS600) {
+		break;
+
+	case CHIP_RS600:
 		DRM_INFO("Loading RS600 Microcode\n");
 		fw_name = FIRMWARE_RS600;
-	} else if ((rdev->family == CHIP_RV515) ||
-		   (rdev->family == CHIP_R520) ||
-		   (rdev->family == CHIP_RV530) ||
-		   (rdev->family == CHIP_R580) ||
-		   (rdev->family == CHIP_RV560) ||
-		   (rdev->family == CHIP_RV570)) {
+		break;
+
+	case CHIP_RV515:
+	case CHIP_R520:
+	case CHIP_RV530:
+	case CHIP_R580:
+	case CHIP_RV560:
+	case CHIP_RV570:
 		DRM_INFO("Loading R500 Microcode\n");
 		fw_name = FIRMWARE_R520;
+		break;
+
+	default:
+		DRM_ERROR("Unsupported Radeon family %u\n", rdev->family);
+		return -EINVAL;
 	}
 
 	err = request_firmware(&rdev->me_fw, fw_name, rdev->dev);
-- 
2.43.0



