Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D6565191;
	Tue, 23 Jan 2024 01:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975077; cv=none; b=G8SKyRdUtlE/OVYmD5AT30kwwb88Iv1+TgOskQgWLwYYGPkjvq+nsRS5FmsaIDQLFnimh4zyPcPRCUKPcMrZdfCPd29mojQU3CKJmU7qc5+rGmPzXsPKaUDYbexU9KlPoUDyHwEh6DiRGBBf2uya+X4QuYiy4ZmrbJd5DBeGozE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975077; c=relaxed/simple;
	bh=BBXgBnAk0CqPDhUG9D24wQoy+GROAatm7K6MpCs/ZMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WL2YNG+euuzu/r3EGgFBGb9HHbxgFIKO5E+stJoXUTfaO4z19hm6E9c+GU9aDG6bNn3evxPutsAa2t3VIPXw6sepV9VwEdIHQHY31U8u1+WA6h7zfgeYWsUM12AFnnSeJZALwpjnoskzu9a2B9FMyYWNzq2mKWjgVJhTHREy0kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qfdFMH96; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qfdFMH96"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41AB9C433C7;
	Tue, 23 Jan 2024 01:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975077;
	bh=BBXgBnAk0CqPDhUG9D24wQoy+GROAatm7K6MpCs/ZMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qfdFMH966EOBwtAIVnq/yp7FtkE0UYUFohFQ5obR7VwFpcuGWUq/cC+jGppl/1X0f
	 yIf5vM1+zGSAkksbdSIgp7BC9oreV5Z3T0E61j468qm0VOoPqlz3UAe9DWi5r9TvaO
	 aobwj9pbgRn47P2sd2aL9+xU9DUXbGc21VJCGGHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Morgan <macromorgan@hotmail.com>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 228/583] drm/panel: nv3051d: Hold panel in reset for unprepare
Date: Mon, 22 Jan 2024 15:54:39 -0800
Message-ID: <20240122235818.974795643@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Morgan <macromorgan@hotmail.com>

[ Upstream commit 697ebc319b942403a6fee894607fd2cd47cca069 ]

Improve the panel's ability to restore from suspend by holding the
panel in suspend after unprepare.

Fixes: b1d39f0f4264 ("drm/panel: Add NewVision NV3051D MIPI-DSI LCD panel")
Signed-off-by: Chris Morgan <macromorgan@hotmail.com>
Reviewed-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Link: https://lore.kernel.org/r/20231117202536.1387815-3-macroalpha82@gmail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20231117202536.1387815-3-macroalpha82@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-newvision-nv3051d.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-newvision-nv3051d.c b/drivers/gpu/drm/panel/panel-newvision-nv3051d.c
index ad98dd9322b4..227937afe257 100644
--- a/drivers/gpu/drm/panel/panel-newvision-nv3051d.c
+++ b/drivers/gpu/drm/panel/panel-newvision-nv3051d.c
@@ -261,6 +261,8 @@ static int panel_nv3051d_unprepare(struct drm_panel *panel)
 
 	usleep_range(10000, 15000);
 
+	gpiod_set_value_cansleep(ctx->reset_gpio, 1);
+
 	regulator_disable(ctx->vdd);
 
 	return 0;
-- 
2.43.0



