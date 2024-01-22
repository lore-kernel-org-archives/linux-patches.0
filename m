Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BCD67E9E;
	Tue, 23 Jan 2024 02:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975319; cv=none; b=PfEC0O+1SyPLLC9huodZCazV1qTbWq3PTe+H6Ri4AygBIN4TIDnw6GJfZR/EfheoM6PpjTm3PhZw3C6KwBUKfZvFrWPsKqX1Ue8H/njtf/sCN4fPkDU6DNkkCIMwYVa3KtC2Fg/YGK9YE85LLwtlMm+hqCOtL3PKgCByV7ihNds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975319; c=relaxed/simple;
	bh=nNw8oBriiFahdV4mKXFzIQhWGckB/CUDvhCs57oPGUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDvy5LWCqOBYu4le9PuRDVb7U697CThQ/H3Q8pyMHBujObGUvDPn01ABBAnIR20Wi1quzVzB2ZNIQWZDST6X8YnH44j+9vdo7shS51rHeRPoumLTaLndTgA86ty54006D+PP5B6CK3wbCzTjTMeIrwJ5THH/M0ROQ7Zadd8fZbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FwrYnxPq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FwrYnxPq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48CF4C43390;
	Tue, 23 Jan 2024 02:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975318;
	bh=nNw8oBriiFahdV4mKXFzIQhWGckB/CUDvhCs57oPGUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FwrYnxPqRIXn409nLJ6+u5Prsodg0FsJ/708mppcOClMWkf2MOzVrub6JQ54aR28S
	 m3O5UyJbwofV8UqZm7wp5km0K6pNe8bLXNqawIQoFaZ2SKV+GQTd8yz+EpVDih80D7
	 BTCWIxu/yF6tMv9aFDMiXmKu1Kav9mAtpGkpk+Hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Morgan <macromorgan@hotmail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 275/583] drm/panel: st7701: Fix AVCL calculation
Date: Mon, 22 Jan 2024 15:55:26 -0800
Message-ID: <20240122235820.415227980@linuxfoundation.org>
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

[ Upstream commit 799825aa87200ade1ba21db853d1c2ff720dcfe0 ]

The AVCL register, according to the datasheet, comes in increments
of -0.2v between -4.4v (represented by 0x0) to -5.0v (represented
by 0x3). The current calculation is done by adding the defined
AVCL value in mV to -4400 and then dividing by 200 to get the register
value. Unfortunately if I subtract -4400 from -4400 I get -8800, which
divided by 200 gives me -44. If I instead subtract -4400 from -4400
I get 0, which divided by 200 gives me 0. Based on the datasheet this
is the expected register value.

Fixes: 83b7a8e7e88e ("drm/panel/panel-sitronix-st7701: Parametrize voltage and timing")

Signed-off-by: Chris Morgan <macromorgan@hotmail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20231208154847.130615-2-macroalpha82@gmail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20231208154847.130615-2-macroalpha82@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-sitronix-st7701.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-sitronix-st7701.c b/drivers/gpu/drm/panel/panel-sitronix-st7701.c
index 0459965e1b4f..036ac403ed21 100644
--- a/drivers/gpu/drm/panel/panel-sitronix-st7701.c
+++ b/drivers/gpu/drm/panel/panel-sitronix-st7701.c
@@ -288,7 +288,7 @@ static void st7701_init_sequence(struct st7701 *st7701)
 		   FIELD_PREP(DSI_CMD2_BK1_PWRCTRL2_AVDD_MASK,
 			      DIV_ROUND_CLOSEST(desc->avdd_mv - 6200, 200)) |
 		   FIELD_PREP(DSI_CMD2_BK1_PWRCTRL2_AVCL_MASK,
-			      DIV_ROUND_CLOSEST(-4400 + desc->avcl_mv, 200)));
+			      DIV_ROUND_CLOSEST(-4400 - desc->avcl_mv, 200)));
 
 	/* T2D = 0.2us * T2D[3:0] */
 	ST7701_DSI(st7701, DSI_CMD2_BK1_SPD1,
-- 
2.43.0



