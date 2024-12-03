Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C001F130D;
	Tue,  3 Dec 2024 15:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238258; cv=none; b=Lx0YBsr0rqq0f564X8jCIgNE8kdEi5sWLr2pd1+3fwkFyROeVY6WLz1LpnqZ7HNDzLoSXhMJIzN5H4jF6yCzwP3cD/UMj2jMqENkhTKrZUVKT22TiyLu1c4h+7qC96RT/mhho88eHgJxqrxM9KzQWdE/HniIgY4hCuH2HX6xfXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238258; c=relaxed/simple;
	bh=2mbjagy09GIXLjf5+Av2x120t1IFgzlqoHNIW3Gd1t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IDk5DwhjmIPPCYPJ2FxEi3vroLqqnS54pqCcGRMO+KXyjTW7Z2pBSVGZO2PnA/4a04GNFiv/br68FgBrWtpFblR3/9BItbruSd793AE5+wyNsKlViQBgSOCibejgT7LzR4YUzjHAo5b0ISEuibHQq67l5FFc7FCwtXaa9b/m72c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=niCYNKxT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="niCYNKxT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFBF9C4CECF;
	Tue,  3 Dec 2024 15:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238258;
	bh=2mbjagy09GIXLjf5+Av2x120t1IFgzlqoHNIW3Gd1t8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=niCYNKxTWRjjkTnCLlmDo5XibxKjUlLQ39Udrh5plI+Z6hPvnb/pdQpBK/etIKFun
	 m18wSSX8HO5jU0kw/yfg+Z1jFzst3dyVAb/NV3cVJfkVolRGfHlAggbp0dpfsVtS7c
	 SvMco1DN3R7TieZ1gSt4gWzWhituue1o2yMvLu3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 217/817] drm/vc4: hvs: Dont write gamma luts on 2711
Date: Tue,  3 Dec 2024 15:36:29 +0100
Message-ID: <20241203144004.220086916@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 04af672caacb1..1ac55c19197cb 100644
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



