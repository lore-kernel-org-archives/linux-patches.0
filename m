Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60263145B0D;
	Thu, 11 Apr 2024 10:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830075; cv=none; b=UlGg8n1bSLO0khsXFjrf5pNYVGdXLaDwTb0/Q+XQRu8BSUMBGoAFrheronTN5neuwl7Dgejg8HlIH507/tbxC5VUl5cGaKgVX3VdP3ANa7dSscrkuHaKGRiQF55J5NHV1t0JT67sJFsw7vle3YFHpgZkgsJNxdp32VMFE4H8qPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830075; c=relaxed/simple;
	bh=M1GxeVaw6d7pZByn0uWCm3Fd5DDkDNCUV7Uqok1ExQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E2klslvP90JoBeDbe5BIwymNXZsUL5JYbqciLV9JVp5lgQjJcoFFau+DRGe3CjKlNZs3WkqoyJWzy6xWLjGAFTnnTKlYrfL9TVLc32wVQs//4/+oWWR+R8FLfMlUn5zBOtZ6XEgayL7mqHh0eYB1JEeKBtA8X/SpHJOC9y+oYrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=duwR0q9b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="duwR0q9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6657C433C7;
	Thu, 11 Apr 2024 10:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830075;
	bh=M1GxeVaw6d7pZByn0uWCm3Fd5DDkDNCUV7Uqok1ExQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=duwR0q9bPC0sPz8iIBHwy8Xjg2k5wct3mi+HGfbvxlpNhW9uaiQapiiXfdZbTkUa/
	 bXoQLQDwao1zmu0fkjSgXaLCMw/Q6tGXyUnlX7gf4ojE634tnQA7utqWxzkn7WtbgY
	 Dfah1eIUtXy9+ITJ7+xJVbyKiuNkG7W5xY+IB83Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Jacky Bai <ping.bai@nxp.com>,
	Sandor Yu <Sandor.yu@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 027/143] pmdomain: imx8mp-blk-ctrl: imx8mp_blk: Add fdcc clock to hdmimix domain
Date: Thu, 11 Apr 2024 11:54:55 +0200
Message-ID: <20240411095421.729506918@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 697624ee8ad557ab5417f985d2c804241a7ad30d ]

According to i.MX8MP RM and HDMI ADD, the fdcc clock is part of
hdmi rx verification IP that should not enable for HDMI TX.
But actually if the clock is disabled before HDMI/LCDIF probe,
LCDIF will not get pixel clock from HDMI PHY and print the error
logs:

[CRTC:39:crtc-2] vblank wait timed out
WARNING: CPU: 2 PID: 9 at drivers/gpu/drm/drm_atomic_helper.c:1634 drm_atomic_helper_wait_for_vblanks.part.0+0x23c/0x260

Add fdcc clock to LCDIF and HDMI TX power domains to fix the issue.

Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Sandor Yu <Sandor.yu@nxp.com>
Link: https://lore.kernel.org/r/20240203165307.7806-5-aford173@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pmdomain/imx/imx8mp-blk-ctrl.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/pmdomain/imx/imx8mp-blk-ctrl.c b/drivers/pmdomain/imx/imx8mp-blk-ctrl.c
index e3203eb6a0229..a56f7f92d0915 100644
--- a/drivers/pmdomain/imx/imx8mp-blk-ctrl.c
+++ b/drivers/pmdomain/imx/imx8mp-blk-ctrl.c
@@ -55,7 +55,7 @@ struct imx8mp_blk_ctrl_domain_data {
 	const char *gpc_name;
 };
 
-#define DOMAIN_MAX_CLKS 2
+#define DOMAIN_MAX_CLKS 3
 #define DOMAIN_MAX_PATHS 3
 
 struct imx8mp_blk_ctrl_domain {
@@ -457,8 +457,8 @@ static const struct imx8mp_blk_ctrl_domain_data imx8mp_hdmi_domain_data[] = {
 	},
 	[IMX8MP_HDMIBLK_PD_LCDIF] = {
 		.name = "hdmiblk-lcdif",
-		.clk_names = (const char *[]){ "axi", "apb" },
-		.num_clks = 2,
+		.clk_names = (const char *[]){ "axi", "apb", "fdcc" },
+		.num_clks = 3,
 		.gpc_name = "lcdif",
 		.path_names = (const char *[]){"lcdif-hdmi"},
 		.num_paths = 1,
@@ -483,8 +483,8 @@ static const struct imx8mp_blk_ctrl_domain_data imx8mp_hdmi_domain_data[] = {
 	},
 	[IMX8MP_HDMIBLK_PD_HDMI_TX] = {
 		.name = "hdmiblk-hdmi-tx",
-		.clk_names = (const char *[]){ "apb", "ref_266m" },
-		.num_clks = 2,
+		.clk_names = (const char *[]){ "apb", "ref_266m", "fdcc" },
+		.num_clks = 3,
 		.gpc_name = "hdmi-tx",
 	},
 	[IMX8MP_HDMIBLK_PD_HDMI_TX_PHY] = {
-- 
2.43.0



