Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EB722968C;
	Thu, 12 Dec 2024 16:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019250; cv=none; b=MbbeA8ZaKJoxzL7o2S3LvhtIhgNsisVaPgeg/GFJXWJmX94S9jCp5efGoYs7FG/REW1Wz0W7fBMk4BaYQCoEelpFly9gCtSWyJUwpkRR8rUF4JlK0RGiqp32B7vjowr6SnKSHEEv7noIpVd7F1FBhbPyOpSiZtiY34/v9TIIIeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019250; c=relaxed/simple;
	bh=CZK/c8WhWprIwTvjLKfDNfBzAkX06DlifeeYUzDinlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQ25WEKSIzvGkrpc//ZUcdA+y0NytuPEygj6vCoUApEdeQpwCSb+kbHxLQcjQ4evArkkZkE7dIsyAjIDms+mtnioFQn7vmnGwJgC41VnN3cxMit6m9ARkWUHk74wbd0y+TO+GJjWkbrdvYJVmXVOr5yIZ3OM2v/kVZUS12pYEqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fGdHV+dk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fGdHV+dk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15878C4CECE;
	Thu, 12 Dec 2024 16:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019250;
	bh=CZK/c8WhWprIwTvjLKfDNfBzAkX06DlifeeYUzDinlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fGdHV+dkCO8CD+qDZQWBcGGZ/jSUtHGz8Gu2Wz8TfdrmaGwVswW+YNDPrkhGBhO1f
	 8z68n3P0W3TkhWtVmTaoNdbVVz7ycWccw3u9K8Tru/Yz8dbHO+fTv2m3xpYyihPHXy
	 kEakdm5HPd1Ux8mLjBPF3lY3VSODTDe2AEf1ZX7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 128/772] drm/vc4: hvs: Fix dlist debug not resetting the next entry pointer
Date: Thu, 12 Dec 2024 15:51:13 +0100
Message-ID: <20241212144355.215250282@linuxfoundation.org>
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

[ Upstream commit 6d5f76e0544b04ec5bdd2a09c19d90aeeb2cd479 ]

The debug function to display the dlists didn't reset next_entry_start
when starting each display, so resulting in not stopping the
list at the correct place.

Fixes: c6dac00340fc ("drm/vc4: hvs: Add debugfs node that dumps the current display lists")
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240621152055.4180873-18-dave.stevenson@raspberrypi.com
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hvs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hvs.c b/drivers/gpu/drm/vc4/vc4_hvs.c
index cf017b59114e9..a049899a17636 100644
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -108,7 +108,7 @@ static int vc4_hvs_debugfs_dlist(struct seq_file *m, void *data)
 	struct vc4_dev *vc4 = to_vc4_dev(dev);
 	struct vc4_hvs *hvs = vc4->hvs;
 	struct drm_printer p = drm_seq_file_printer(m);
-	unsigned int next_entry_start = 0;
+	unsigned int next_entry_start;
 	unsigned int i, j;
 	u32 dlist_word, dispstat;
 
@@ -122,6 +122,7 @@ static int vc4_hvs_debugfs_dlist(struct seq_file *m, void *data)
 		}
 
 		drm_printf(&p, "HVS chan %u:\n", i);
+		next_entry_start = 0;
 
 		for (j = HVS_READ(SCALER_DISPLISTX(i)); j < 256; j++) {
 			dlist_word = readl((u32 __iomem *)vc4->hvs->dlist + j);
-- 
2.43.0



