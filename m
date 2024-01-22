Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090B81420A7;
	Tue, 23 Jan 2024 00:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969443; cv=none; b=BzCAG+FJake8Bic8aheVf0Uq+J/SLchznGvv2pAFt8m2eDsG8sVoDAQK015EuH6gSvpJc5luz4sTWyK3ODl1TUkhuIpPOiP/jw/CsPL03IbdInvbWzwu/rSxFheRorSbq+Pl5hqWH7HKZtMFPFu1BvOHq9EnsqqNNsQZ/pcBl7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969443; c=relaxed/simple;
	bh=NWYKlE7Wf+xMY4AkbaHxa8EruIogKEaCuU7h8RI9ezE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUk0U7iIFGIqA7VhQLwaXw2N+kd9NxBMk6jZD2kLYJYwWqN1jGhhtaFVMe77VS/jcfWtXHkoCupZ4kZm8RL/WEwI0uW1eWuC11YgGd8HvUBs6OcdaxLuDbDj8C/aijGb5/lfDFuuuZZg9eMCpldJFy5rYfBlDW6AoTbxywhLep4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v9WJf1K3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v9WJf1K3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60108C43390;
	Tue, 23 Jan 2024 00:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969442;
	bh=NWYKlE7Wf+xMY4AkbaHxa8EruIogKEaCuU7h8RI9ezE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v9WJf1K3iSCrWTmZeeOPg/mKCX4CDB+3WENOD3Knz7ABthqxe1N/hnmf1xL8w+tNA
	 jY+MQRt+jGwwIxU6PODrEiTKIRULhqFRlhaMCL7fBnr3aCWBOM2ohHXcEES+Zn1P/e
	 vv/uYSYucVoTCo61ZmelkZCUDKN/+abJDn8sU6oY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Morgan <macromorgan@hotmail.com>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 249/641] drm/panel: nv3051d: Hold panel in reset for unprepare
Date: Mon, 22 Jan 2024 15:52:33 -0800
Message-ID: <20240122235825.710225389@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 79de6c886292..c44c6945662f 100644
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



