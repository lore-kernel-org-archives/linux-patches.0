Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE46340A47
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301017; cv=none; b=A0ZxDCQxkIF40uMstYwTtCyfjTZ+AAEDhJcxoNBSv+/W7fyAzBdqn998YyJzBPphV0rkbicm0y+nIhRh9ZV7WpBTB1VGAu615BJyRkgxqP+OOxcBJsU08xaD/CFaYOWtkaZO2WFuPYay+n5omQw1yTm8OPCouMKCi3nkCy61n0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301017; c=relaxed/simple;
	bh=jpKIwh4BedLUAcItD23Wa7pLpbf3RV8K9IItLA6XWio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=myS9qkJCgY2370xArhn8rzjluQsQn6B2FbxG4J5P0qr+rFFxQwPVbZCKUeGDDeiLJbCzBUlM4lvJGstzHeGU1r0w8O7AYTgFwAt3EEqWxNUahikGDchj1AwKTt/FOSWOSYQhzD8TMdMEyqm8tn6A+QgvWuk/1IKG/sLhHbnT8y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KW6gXn80; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KW6gXn80"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE223C116D0;
	Sat, 28 Feb 2026 17:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301017;
	bh=jpKIwh4BedLUAcItD23Wa7pLpbf3RV8K9IItLA6XWio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KW6gXn80Gjjt1FMjz4aEhYN7auS8akjwNJ/kNJaxntUwnUJPlvz1aEDPUkuD2myxT
	 iW8nNXW6v69TBcm77wm+3098pxd9HvLtmwCLveS9M/s17DF5G4g9FYzXR7AoJBWUla
	 DA0OEufHgsPe9UwK9ZBvZ3SpUAHsl2Xh422gHsFeTMDbz3ixYBohqwtf7/RD5IPADX
	 /Ifa2ubhSvXZH/qGoduSU84EL1ssNEzisz1Czmd9CQfAUheuKfooJQXzKbDp66bAC5
	 80ff/deZ154OrK3dvb5zNXldxxZ6xkTdaPUjA+ZSm77ZHlAfV0dW3pnf3+CXQook+4
	 uhpAWG32tIYjA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Tuo Li <islituo@gmail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 153/752] drm/panel: Fix a possible null-pointer dereference in jdi_panel_dsi_remove()
Date: Sat, 28 Feb 2026 12:37:44 -0500
Message-ID: <20260228174750.1542406-153-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Tuo Li <islituo@gmail.com>

[ Upstream commit 95eed73b871111123a8b1d31cb1fce7e902e49ea ]

In jdi_panel_dsi_remove(), jdi is explicitly checked, indicating that it
may be NULL:

  if (!jdi)
    mipi_dsi_detach(dsi);

However, when jdi is NULL, the function does not return and continues by
calling jdi_panel_disable():

  err = jdi_panel_disable(&jdi->base);

Inside jdi_panel_disable(), jdi is dereferenced unconditionally, which can
lead to a NULL-pointer dereference:

  struct jdi_panel *jdi = to_panel_jdi(panel);
  backlight_disable(jdi->backlight);

To prevent such a potential NULL-pointer dereference, return early from
jdi_panel_dsi_remove() when jdi is NULL.

Signed-off-by: Tuo Li <islituo@gmail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20251218120955.11185-1-islituo@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-jdi-lpm102a188a.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-jdi-lpm102a188a.c b/drivers/gpu/drm/panel/panel-jdi-lpm102a188a.c
index 23462065d726b..ea975170fafff 100644
--- a/drivers/gpu/drm/panel/panel-jdi-lpm102a188a.c
+++ b/drivers/gpu/drm/panel/panel-jdi-lpm102a188a.c
@@ -434,8 +434,10 @@ static void jdi_panel_dsi_remove(struct mipi_dsi_device *dsi)
 	int err;
 
 	/* only detach from host for the DSI-LINK2 interface */
-	if (!jdi)
+	if (!jdi) {
 		mipi_dsi_detach(dsi);
+		return;
+	}
 
 	err = jdi_panel_disable(&jdi->base);
 	if (err < 0)
-- 
2.51.0

