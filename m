Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C65F1F8930;
	Tue,  3 Dec 2024 15:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240602; cv=none; b=t3yFqCf5hqVmdCA/rlv3MOWo9oE1cY1LifdTRkjZz8+onGgb21oWC/ueE8X2DJ0l961vmzA5BpgnfGn7nspibuNJWhVlPf5Mz8xTT5mgJPsnLJ+WM1KZ9jv2jWx6zwNa9rCBtbaGT6pppa3c+rXxl4DiB7jNl+jCR2fWT3lsujo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240602; c=relaxed/simple;
	bh=B5cwMB8hJicCu7XHE6s7rxp6YSSBgbu+fOmxmVQWtVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eL/6uBEk0v5YlWuivspTFyTyJrTQhCxSwPeTauTEN2kIphq2VATHl5tlk+v+0mR6SKfI/oZ1G4v37HN06Pf+tnp5SnJYoi4o7g3xKgV3Zb9IR1CuiJSh+Jtl00+WgcixaN/tIpnU2MAcD9ag4g64fy9jwFyEWSqfP8BQWSHQTEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ttHGewe4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ttHGewe4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3629C4CECF;
	Tue,  3 Dec 2024 15:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240602;
	bh=B5cwMB8hJicCu7XHE6s7rxp6YSSBgbu+fOmxmVQWtVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ttHGewe4IvlF8WSykdD40bUS6gA4baGjUdc1LfcasOUu8Ve5nMRVaOhh2ZK/hWrQs
	 8RLMovxxy9hKyrfb+mnZ+xcesTTu+eM3Gpz+wn9p36mB02GDa9EDKSc0l5eO9q8XgP
	 x3AQPqi/4lFHsJsaJ7moMyZPbHuILn7C8OVGHwKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 184/826] drm/vc4: hvs: Dont write gamma luts on 2711
Date: Tue,  3 Dec 2024 15:38:31 +0100
Message-ID: <20241203144750.919694232@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 52efe364d1968ee3e3ed45eb44eb924b63635315 ]

The gamma block has changed in 2711, therefore writing the lut
in vc4_hvs_lut_load is incorrect.

Whilst the gamma property isn't created for 2711, it is called
from vc4_hvs_init_channel, so abort if attempted.

Fixes: c54619b0bfb3 ("drm/vc4: Add support for the BCM2711 HVS5")
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240621152055.4180873-15-dave.stevenson@raspberrypi.com
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hvs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/vc4/vc4_hvs.c b/drivers/gpu/drm/vc4/vc4_hvs.c
index 2a835a5cff9dd..ac112dc3d592d 100644
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -222,6 +222,9 @@ static void vc4_hvs_lut_load(struct vc4_hvs *hvs,
 	if (!drm_dev_enter(drm, &idx))
 		return;
 
+	if (hvs->vc4->is_vc5)
+		return;
+
 	/* The LUT memory is laid out with each HVS channel in order,
 	 * each of which takes 256 writes for R, 256 for G, then 256
 	 * for B.
-- 
2.43.0



