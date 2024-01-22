Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B275B4E1AD;
	Tue, 23 Jan 2024 01:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975080; cv=none; b=VS303BtAQVZY3iTT1tc3iMpbq7DbEn//zhLScHPbVs0+6Y9XIxnyR1W1hrfNJBCZfUSAOkyHjwM3h63KWc52KUj+38ReA8d6thQbmWtHWOrmwBNWrirvEBhPna821YyoW+AIuD5UBw+mWylw12EFYepDRP+WSbDehhwVKK9ccr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975080; c=relaxed/simple;
	bh=Nskk63iczY4wphG6jYoTrzd4wnOMvjI45TaybaKrrAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dceXJtbUeK+aeZTvCAf0EM7iP1TXKP1ciXEX/Fg4j9ddz8z6OksQv8EMpDHVPxFLQaCccdR2NrvgA9bQo1OIvSC2fVkqjwa3x04FquHtOnTdePK25uZmm3t/g9soCfzg93hjhbjpgvlrYdGxtHvtOfnHN5p9mUaBQV4T9BpDvfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MP1lqL1o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MP1lqL1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD6AC433C7;
	Tue, 23 Jan 2024 01:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975080;
	bh=Nskk63iczY4wphG6jYoTrzd4wnOMvjI45TaybaKrrAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MP1lqL1oMHYvDFJKoXo0P3DZ5YgKeksUbvk3hDH4R3lOvTH86USy11dx0P3VmNYym
	 lTei/IEoe40LltUppn72mKaC+QY2Ga+ic6yqzwiuSBKXvftg9ds8Y57T7qSZwg/9N4
	 Ik35td8T+9bfth1gMnARFRIGQf9Cbn7Hh9vQnqbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Morgan <macromorgan@hotmail.com>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 229/583] drm/panel-elida-kd35t133: hold panel in reset for unprepare
Date: Mon, 22 Jan 2024 15:54:40 -0800
Message-ID: <20240122235819.002321503@linuxfoundation.org>
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

[ Upstream commit 03c5b2a5f6c39fe4e090346536cf1c14ee18b61e ]

For devices like the Anbernic RG351M and RG351P the panel is wired to
an always on regulator. When the device suspends and wakes up, there
are some slight artifacts on the screen that go away over time. If
instead we hold the panel in reset status after it is unprepared,
this does not happen.

Fixes: 5b6603360c12 ("drm/panel: add panel driver for Elida KD35T133 panels")
Signed-off-by: Chris Morgan <macromorgan@hotmail.com>
Reviewed-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Link: https://lore.kernel.org/r/20231117194405.1386265-3-macroalpha82@gmail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20231117194405.1386265-3-macroalpha82@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-elida-kd35t133.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-elida-kd35t133.c b/drivers/gpu/drm/panel/panel-elida-kd35t133.c
index e7be15b68102..6de117232346 100644
--- a/drivers/gpu/drm/panel/panel-elida-kd35t133.c
+++ b/drivers/gpu/drm/panel/panel-elida-kd35t133.c
@@ -104,6 +104,8 @@ static int kd35t133_unprepare(struct drm_panel *panel)
 		return ret;
 	}
 
+	gpiod_set_value_cansleep(ctx->reset_gpio, 1);
+
 	regulator_disable(ctx->iovcc);
 	regulator_disable(ctx->vdd);
 
-- 
2.43.0



