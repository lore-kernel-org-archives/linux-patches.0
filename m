Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F891A6192;
	Tue, 30 Jul 2024 16:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357665; cv=none; b=aYoZhEuMwvcyTzAedAs1RC3AJHUJUtVtnpX28g1RWGEYdoFLNrDDIqC+xAgaGiMNcLcSQCTGyLU5XpK8t6nRuPZndq6ru42g6oHpoHZOXEYXlT9vXKg2LaalKQ8TySIbV2GR9b3Lxs7X7GD6wfkw9y8Ga+t9RAMywiepAXnX2P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357665; c=relaxed/simple;
	bh=1v+GZLxUcF5DpCPPZT3MAn5jjw2fR7unnsYkhJsnLn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W4bDgLvJdRYcvxSQzIfLHbMEZUZnvtIgvQeAM3uzVdUyBwA4U9usz3bO02d1an+MVLawpdnCuWzmUuWb2NSSZ7TKnICQl72wVXFTFpIYP4VWYFPz5ExSz5Ht3IduXswHuhWiqRGlPvsgWfgoSZMadXyOX3yuTiIAgi5tMpiJpeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j/bszulR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j/bszulR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1824EC32782;
	Tue, 30 Jul 2024 16:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357665;
	bh=1v+GZLxUcF5DpCPPZT3MAn5jjw2fR7unnsYkhJsnLn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j/bszulRRsZYM3RHJvwixhZHS8O9tM8Kq+cNe2tV/WXXsDn4wTLcEwX+HJh0UA8xG
	 IonkvsK1PRXoA/R5ZPcHbn0lJc99vgTxOI/BrVeMN3zGb8b0I5cHRZ6O04dvDLxKT9
	 d/gb88n6Fw/LzTzyAMhcMoPEJCxPOm9g4GzJdyO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 277/809] drm/panel: himax-hx8394: Handle errors from mipi_dsi_dcs_set_display_on() better
Date: Tue, 30 Jul 2024 17:42:33 +0200
Message-ID: <20240730151735.534552007@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit cc2db2ef8d9eebc0df03808ac0dadbdb96733499 ]

If mipi_dsi_dcs_set_display_on() returned an error then we'd store
that in the "ret" variable and jump to error handling. We'd then
attempt an orderly poweroff. Unfortunately we then blew away the value
stored in "ret". That means that if the orderly poweroff actually
worked then we're return 0 (no error) from hx8394_enable() even though
the panel wasn't enabled.

Fix this by not blowing away "ret".

Found by code inspection.

Fixes: 65dc9360f741 ("drm: panel: Add Himax HX8394 panel controller driver")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20240517143643.1.I0a6836fffd8d7620f353becb3df2370d2898f803@changeid
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240517143643.1.I0a6836fffd8d7620f353becb3df2370d2898f803@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-himax-hx8394.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-himax-hx8394.c b/drivers/gpu/drm/panel/panel-himax-hx8394.c
index ff0dc08b98297..cb9f46e853de4 100644
--- a/drivers/gpu/drm/panel/panel-himax-hx8394.c
+++ b/drivers/gpu/drm/panel/panel-himax-hx8394.c
@@ -370,8 +370,7 @@ static int hx8394_enable(struct drm_panel *panel)
 
 sleep_in:
 	/* This will probably fail, but let's try orderly power off anyway. */
-	ret = mipi_dsi_dcs_enter_sleep_mode(dsi);
-	if (!ret)
+	if (!mipi_dsi_dcs_enter_sleep_mode(dsi))
 		msleep(50);
 
 	return ret;
-- 
2.43.0



