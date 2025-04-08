Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA061267B15;
	Tue,  8 Apr 2025 12:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114325; cv=none; b=aM8iiyw6nCgAQym7HyWT0447CFA6t2snX6RwEyenPNK7dSvSjMBq6iCLNBSvEE+/qS9f/SbmG0y5IsNsWk8SFiXGekiP+UHn4G8nNwSprarfnRm+0hq0ibpZwMFo/OLQmYww11E87ikIZ/c3lok1dBkAcVKwgyFmQvSiiLnZpR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114325; c=relaxed/simple;
	bh=PhbHzJr9Nne0GYDofVuPRmFKO9e0XH2tHdGNUPcACoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m8cHJgPu8WBuQ8bPs/nPifp2miz2cNKewn1lzz2tFAkFRHi1hBpeAdvX8PaNUu3UJ7FhLmgrv3yeG6CDuEPgS8HNn/GBK55UvRFaSzN9ZEmdJz/UZudKMi6gLzCeW6EPke5x2Zdp+Q7todQ6MXnj5gwTwcJTFrbRJc5aGqR4oQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UY7AEzDP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UY7AEzDP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C43C4CEE5;
	Tue,  8 Apr 2025 12:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114325;
	bh=PhbHzJr9Nne0GYDofVuPRmFKO9e0XH2tHdGNUPcACoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UY7AEzDPEHqXZFSgD2yj0UtUVjXBgJfdmcpiNrkzFeVShbFyNh14vieLG+Z0d1vfT
	 E1mrfkzgB8OiOqijJZctSLkg5eG/430JI040onG7DAWDhH8gMVehE9WzWx4eivpRl9
	 syWH1sKPtz6rMsZUdk8OB5nGLnzbHhf3pujnsMfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hermes Wu <Hermes.wu@ite.com.tw>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 065/499] drm/bridge: it6505: fix HDCP V match check is not performed correctly
Date: Tue,  8 Apr 2025 12:44:37 +0200
Message-ID: <20250408104852.852516912@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hermes Wu <Hermes.wu@ite.com.tw>

[ Upstream commit a5072fc77fb9e38fa9fd883642c83c3720049159 ]

Fix a typo where V compare incorrectly compares av[] with av[] itself,
which can result in HDCP failure.

The loop of V compare is expected to iterate for 5 times
which compare V array form av[0][] to av[4][].
It should check loop counter reach the last statement "i == 5"
before return true

Fixes: 0989c02c7a5c ("drm/bridge: it6505: fix HDCP CTS compare V matching")
Signed-off-by: Hermes Wu <Hermes.wu@ite.com.tw>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20250121-fix-hdcp-v-comp-v4-1-185f45c728dc@ite.com.tw
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it6505.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ite-it6505.c b/drivers/gpu/drm/bridge/ite-it6505.c
index faee8e2e82a05..967aa24b7c537 100644
--- a/drivers/gpu/drm/bridge/ite-it6505.c
+++ b/drivers/gpu/drm/bridge/ite-it6505.c
@@ -2042,12 +2042,13 @@ static bool it6505_hdcp_part2_ksvlist_check(struct it6505 *it6505)
 			continue;
 		}
 
-		for (i = 0; i < 5; i++) {
+		for (i = 0; i < 5; i++)
 			if (bv[i][3] != av[i][0] || bv[i][2] != av[i][1] ||
-			    av[i][1] != av[i][2] || bv[i][0] != av[i][3])
+			    bv[i][1] != av[i][2] || bv[i][0] != av[i][3])
 				break;
 
-			DRM_DEV_DEBUG_DRIVER(dev, "V' all match!! %d, %d", retry, i);
+		if (i == 5) {
+			DRM_DEV_DEBUG_DRIVER(dev, "V' all match!! %d", retry);
 			return true;
 		}
 	}
-- 
2.39.5



