Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DAF355026;
	Tue, 16 Dec 2025 11:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885844; cv=none; b=ZJdRcXvxYgyHT8RBEw0Sa5ADFVYxY1WOsMe+P/rCJkVE6ORetT3/XnROXA+7QyCTiROH8GIg/md3roydo4op47a0r3PSA3kWXDWI8OxyhKJ5Ghc9ojEtcCOwcxVLPIUp0LcHaUyrofs7HgRMEamVMOvvzGLUj9MtL5JS4d8jCto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885844; c=relaxed/simple;
	bh=FrUbSom7Z0WMLXdlAatOLADiVPmI3f4bUGZHxia1oK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CcC2MEh1P+jXgBk+eOAd7eWwca2FZASVZsv0eDe0ju00pyE9ALOMj/q6yw4u7iE8xBygvwhRjuEfMfFGtY7ApsXr/LoOzY1GeymFXvnQ9quVNa18bXIPm1AKlWDnqXIOHjjsU4Vn/91e+KNv7sQpHhaNkbIyyzpNsdCou5GU3X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qbq10O5l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qbq10O5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B155CC4CEF1;
	Tue, 16 Dec 2025 11:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885844;
	bh=FrUbSom7Z0WMLXdlAatOLADiVPmI3f4bUGZHxia1oK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qbq10O5lyno30tNxHsyYByo0DRokiy7eijGr4Rv042uAnOO8JrZfl3JJxzHsMkT4/
	 9vxaX7UL/R3ir0PcFVhBb7PxOUBEoghT/oFM2rSdhEtU2ir7FsYw5Ck6U7jM0L3NpI
	 4fzmTQibb4TCrlZpx6hacGFXQBqyQ+m7WJYsUR7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 261/507] drm/msm/a2xx: stop over-complaining about the legacy firmware
Date: Tue, 16 Dec 2025 12:11:42 +0100
Message-ID: <20251216111354.943949423@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit a3a22373fce576560757f5616eb48dbf85891d9c ]

If the rootfs have a legacy A200 firmware, currently the driver will
complain each time the hw is reinited (which can happen a lot). E.g.
with GL testsuite the hw is reinited after each test, spamming the
console.

Make sure that the message is printed only once: when we detect the
firmware that doesn't support protection.

Fixes: 302295070d3c ("drm/msm/a2xx: support loading legacy (iMX) firmware")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/688098/
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a2xx_gpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a2xx_gpu.c b/drivers/gpu/drm/msm/adreno/a2xx_gpu.c
index ec38db45d8a36..963c0f669ee50 100644
--- a/drivers/gpu/drm/msm/adreno/a2xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a2xx_gpu.c
@@ -234,7 +234,7 @@ static int a2xx_hw_init(struct msm_gpu *gpu)
 	 * word (0x20xxxx for A200, 0x220xxx for A220, 0x225xxx for A225).
 	 * Older firmware files, which lack protection support, have 0 instead.
 	 */
-	if (ptr[1] == 0) {
+	if (ptr[1] == 0 && !a2xx_gpu->protection_disabled) {
 		dev_warn(gpu->dev->dev,
 			 "Legacy firmware detected, disabling protection support\n");
 		a2xx_gpu->protection_disabled = true;
-- 
2.51.0



