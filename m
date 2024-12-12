Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0B5217640;
	Thu, 12 Dec 2024 15:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019195; cv=none; b=JDT64r650ujEDBjtm2s1hwh8NJd6MCacAn8HGWydF1EaUroQRCD8CESWgDCm4J0/Pb8jj0KJ6SNZVNx3WHPB0tw6oWio5O7C4pS02z7Syz1Mmi/b4k22kTyKXNuLTsZVG8AfhinsUd/hd9Ry13MYbvlz8sz1RhEKq06X2rZAIxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019195; c=relaxed/simple;
	bh=o5xwaTu/1HuC5C+Ju7FgcZihfDzYPp2Ml+WdWvb8p7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/h1ClWDh5R1Myfod5HQvekwLIWwCFEU83D+gDE6x8xPxeC016YSeDplEa3CzOHn5fK0stJUKP/v71ysSdDQq9S7H/C2GnnMY1ZUsSO5uXl74wEoXGx5/gksn0pBDZt9r5nQFOq+TKhEqBHIODo/8aVwOJeQnU5aaymOFy5uf/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJrVYaos; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJrVYaos"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E585C4CECE;
	Thu, 12 Dec 2024 15:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019195;
	bh=o5xwaTu/1HuC5C+Ju7FgcZihfDzYPp2Ml+WdWvb8p7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WJrVYaosBG5s6w8AltwptYebLmzUV4cTHviaQ81/YigL0XnQ/vDvkBGUubCZLbSz6
	 WPAUJkuN2iiMN7CyidzBKOly6sRjeTKtIFK/hpGdxXRPA6qemNZwXLyCRl97iu3ngK
	 4LGJpvuf+HfLfMDMhrk75nuLx1lVnL1wakBxAgqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 126/772] drm/vc4: hvs: Dont write gamma luts on 2711
Date: Thu, 12 Dec 2024 15:51:11 +0100
Message-ID: <20241212144355.134091877@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 47990ecbfc4df..cf017b59114e9 100644
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -220,6 +220,9 @@ static void vc4_hvs_lut_load(struct vc4_hvs *hvs,
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



