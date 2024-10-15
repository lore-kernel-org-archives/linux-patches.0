Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D361C07DD;
	Tue, 15 Oct 2024 13:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997217; cv=none; b=go1azzeq43GLgJN9SOzw8JNPw7+rUZNc+bDxIzkUtonEYOGzHJC+mTZIVuiL+YyzBATehHea8ivLWYTzbV5UO9Y4f+EXZvyzzi28an6CEZC6vOp21+8R8k7EwhXrbiQosOXcBmafRfkTQ5QMALcsIJwntgAZtnbGQPcolCG9Kk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997217; c=relaxed/simple;
	bh=NAQ410G/T+g01uLGzQvLIG5hT39CCDAYzo8izwh84So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K2AWAIXl8crRbkt1vUn8IHJPUVTreOd+iH3cEEpv7e1SiD8NUSUI6VGOuQBE4eb7v5wFbZd7BYUn66P1pBtkHLz9pGe0NBkeCJxWaT1nDZh5fP3PocKU+PVzrdik766M8JVRi3gXRySV0Snho1q+bsHXcCoJmedo0HrAGK621XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kRA2Hcw+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kRA2Hcw+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14EDDC4CEC6;
	Tue, 15 Oct 2024 13:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997217;
	bh=NAQ410G/T+g01uLGzQvLIG5hT39CCDAYzo8izwh84So=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kRA2Hcw+rhY1Hifyj/kkxoSzO2F0Jkk4fBIhzNXX2nn+uyZWjDu9zjEMIJpHromdS
	 duDNuk4fS8Okqg/IoGvRSr49aBPcALG9l8PtBJCfY9KDdokFaVCeWsk7wsOyo5TgFh
	 OdvZ+wljlPQl2Vdqp9d/BtrS6DgpFd+h+W5cHzpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/518] drm/rockchip: dw_hdmi: Fix reading EDID when using a forced mode
Date: Tue, 15 Oct 2024 14:40:24 +0200
Message-ID: <20241015123921.626654942@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit a5d024541ec466f428e6c514577d511a40779c7b ]

EDID cannot be read on RK3328 until after read_hpd has been called and
correct io voltage has been configured based on connection status.

When a forced mode is used, e.g. video=1920x1080@60e, the connector
detect ops, that in turn normally calls the read_hpd, never gets called.

This result in reading EDID to fail in connector get_modes ops.

Call dw_hdmi_rk3328_read_hpd at end of dw_hdmi_rk3328_setup_hpd to
correct io voltage and allow reading EDID after setup_hpd.

Fixes: 1c53ba8f22a1 ("drm/rockchip: dw_hdmi: add dw-hdmi support for the rk3328")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20240615170417.3134517-5-jonas@kwiboo.se
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c b/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
index 515e6f187dc77..91e28fcdd22e9 100644
--- a/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
@@ -389,6 +389,8 @@ static void dw_hdmi_rk3328_setup_hpd(struct dw_hdmi *dw_hdmi, void *data)
 		HIWORD_UPDATE(RK3328_HDMI_SDAIN_MSK | RK3328_HDMI_SCLIN_MSK,
 			      RK3328_HDMI_SDAIN_MSK | RK3328_HDMI_SCLIN_MSK |
 			      RK3328_HDMI_HPD_IOE));
+
+	dw_hdmi_rk3328_read_hpd(dw_hdmi, data);
 }
 
 static const struct dw_hdmi_phy_ops rk3228_hdmi_phy_ops = {
-- 
2.43.0



