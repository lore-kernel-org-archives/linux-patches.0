Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C335D139579;
	Tue, 27 May 2025 17:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365832; cv=none; b=TYsU6p+UYNxt88x00ZSsW6WlsS2r3I0FqjqYjYfHI3XgKv27M3r46mJleTPJlwOnvgoohMZT7SJsgToGM+3kcIC1ZccTXZIn9kzvR5MAqLoE+HWfcBoNGqHb62xcLIE+1SonglVxuyDIBCWEpBz5s1xaheRztVUtg09bdcjNvtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365832; c=relaxed/simple;
	bh=FfEqjFSURMZtBteaKGgq2vnouXRPTSQ/0Rfi947Q8Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=glsncDA7z+Bb/8w899YreF6LBzkrZSVkK1NF6TeuBWTk2u6wFZya0V9W+Lt4Nm4Ww3b8ywBLSX/7mRK1S+O5IQyazK6GRpo1OvhikTA0w6aMUe1DF7AmWFQysc5YxUzk+xSJP9H80NAyhx1RqAuTheJ/QQP5csnq8q6Idq0MzPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vIY8Yr9O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vIY8Yr9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C544C4CEE9;
	Tue, 27 May 2025 17:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365832;
	bh=FfEqjFSURMZtBteaKGgq2vnouXRPTSQ/0Rfi947Q8Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vIY8Yr9Otb4wKmE7QjStjfUlyKOpWVYgbhnpTzKUsYkuuyiibCvnINoWKhiFKrkGu
	 Hd+xG40lbwGQjWbe5Qeq5mZ192D3TUjOvtcnivQAvl8i+UJxj+Qmw6LNudHOuGZWUb
	 kUzMek/mzVeKVRSNzGpckgIqlcaw8PRCQwyPIyvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 503/626] drm/panel-edp: Add Starry 116KHD024006
Date: Tue, 27 May 2025 18:26:36 +0200
Message-ID: <20250527162505.410488881@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 767e47a2b0c14..663af985d1b38 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -1983,6 +1983,7 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('S', 'H', 'P', 0x153a, &delay_200_500_e50, "LQ140T1JH01"),
 	EDP_PANEL_ENTRY('S', 'H', 'P', 0x154c, &delay_200_500_p2e100, "LQ116M1JW10"),
 
+	EDP_PANEL_ENTRY('S', 'T', 'A', 0x0004, &delay_200_500_e200, "116KHD024006"),
 	EDP_PANEL_ENTRY('S', 'T', 'A', 0x0100, &delay_100_500_e200, "2081116HHD028001-51D"),
 
 	{ /* sentinal */ }
-- 
2.39.5



