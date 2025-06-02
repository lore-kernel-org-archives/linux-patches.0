Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A451F4165;
	Mon,  2 Jun 2025 15:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877248; cv=none; b=pcUBiSIdkpowcvqGtJNTyjxoCuE1hkH7864msd68md1Dweb8iYD6YNqgKn40DVz7YNRgoXiajgSafe76vLc5xiGlANocsYPd/OPYmi6i9b8Zn0shHXZL/wGvsYI11x7Qvx09T176I+K7KrUt/O4TnHeK/SI/Wa75Rze908W6OQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877248; c=relaxed/simple;
	bh=eRso0C3IfI3+Na2FSINWF60ZwuGE61jWbWjso7L020U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/a2PAICza9VZjcOaiGJZqc/o5gsnE3uNdbHciw15y3/OgBvVf0hdLRPr5G4bOQWRfQdsJxLQ0bzt9w9imdofH0GggKBP2HfNzreRLEDMkwdOHovnrGPJKAB9/e1fCy3+uR9l9ZWpJevMNTv/jBeRV3i+5w8TMHmW1Q67IwA4/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FtV31CiH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FtV31CiH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA13C4CEEE;
	Mon,  2 Jun 2025 15:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877247;
	bh=eRso0C3IfI3+Na2FSINWF60ZwuGE61jWbWjso7L020U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FtV31CiHHzGArq/zIN5sEfVciQqdUEI8hfI69KcHdqYnl7dw1+HCWvsFH70n1ndHw
	 ggjCwjpAdVsPRXKUci/S2LKTZQA1o3D1lUBbD5eSuVlb5AdeuRmWyTG02tIG9E3a6U
	 DyGCeNCC7rokdKt/zJxF1vxK+QeTn5TSEdedBkwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 218/325] drm/panel-edp: Add Starry 116KHD024006
Date: Mon,  2 Jun 2025 15:48:14 +0200
Message-ID: <20250602134328.649779425@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 749b5b279e5636cdcef51e15d67b77162cca6caa ]

We have a few reports of sc7180-trogdor-pompom devices that have a
panel in them that IDs as STA 0x0004 and has the following raw EDID:

  00 ff ff ff ff ff ff 00  4e 81 04 00 00 00 00 00
  10 20 01 04 a5 1a 0e 78  0a dc dd 96 5b 5b 91 28
  1f 52 54 00 00 00 01 01  01 01 01 01 01 01 01 01
  01 01 01 01 01 01 8e 1c  56 a0 50 00 1e 30 28 20
  55 00 00 90 10 00 00 18  00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 fe
  00 31 31 36 4b 48 44 30  32 34 30 30 36 0a 00 e6

We've been unable to locate a datasheet for this panel and our partner
has not been responsive, but all Starry eDP datasheets that we can
find agree on the same timing (delay_100_500_e200) so it should be
safe to use that here instead of the super conservative timings. We'll
still go a little extra conservative and allow `hpd_absent` of 200
instead of 100 because that won't add any real-world delay in most
cases.

We'll associate the string from the EDID ("116KHD024006") with this
panel. Given that the ID is the suspicious value of 0x0004 it seems
likely that Starry doesn't always update their IDs but the string will
still work to differentiate if we ever need to in the future.

Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20250109142853.1.Ibcc3009933fd19507cc9c713ad0c99c7a9e4fe17@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-edp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index 2c14779a39e88..1ef1b4c966d2e 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -1944,6 +1944,7 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('S', 'H', 'P', 0x1523, &sharp_lq140m1jw46.delay, "LQ140M1JW46"),
 	EDP_PANEL_ENTRY('S', 'H', 'P', 0x154c, &delay_200_500_p2e100, "LQ116M1JW10"),
 
+	EDP_PANEL_ENTRY('S', 'T', 'A', 0x0004, &delay_200_500_e200, "116KHD024006"),
 	EDP_PANEL_ENTRY('S', 'T', 'A', 0x0100, &delay_100_500_e200, "2081116HHD028001-51D"),
 
 	{ /* sentinal */ }
-- 
2.39.5



