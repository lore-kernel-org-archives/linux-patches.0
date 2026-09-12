Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E2B2931FB;
	Sat, 12 Sep 2026 08:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200086; cv=none; b=NVT+yHbppquJmowX/XtM49aPUgnmBNtiYxyW4rHKWv9pRGUEiGKQ/2kvdP3wTwkj0+eY6+ymqgQNZ6xPSY/FO6ktHlGEzdHlqbyUGbfpP7AflTeiAryuNa4WRwO1kr0LY9sfuZT0e5e8FXa5sxgS3D5AnZKFqrI9uUEekCBtEkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200086; c=relaxed/simple;
	bh=NfAV4kJWXLOs/nRbowTNPan7qC6QWxPm0cKJsg9m28A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vm6jFKyEETEbQhM2vMtQsfEsyKa8bMpUGqJ/jv0ta+SXcgPP90GMYiVHuhLSA4D2ACKlMkR8gQiy/tbi2kzAWD57V62TEbuYOhBd9+ovFgv7nOYQNhHU9Spa+/28tR7AsjI0TiEn1XQCy0cgwflrbAE/V6v07tFifM5A6RElFA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fKactDqi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fKactDqi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5952C1F000FF;
	Sat, 12 Sep 2026 08:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200085;
	bh=iFTMXjoXuzjpHyHpjCLvMi3OJsVzXmqXxxrcJ6slYVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fKactDqixwH/Hmkd8YNEiCSEICDPGeDFjKNAyaFQCroshLfL4lQKW4lIGw1LxsvBD
	 J4S2V7IbjUzEq/CTOfWKOTpPF+lSsRWoVfgvuQyUQjW9CvvJbAsHEq1rlZ0hT6rU2H
	 TgTd8Ct8NMtNh6vcRiCElk7t517x9Phz/2GviFUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0717/1815] clk: palmas: Manage external-control prepare with devm
Date: Sat, 12 Sep 2026 08:41:07 +0200
Message-ID: <20260912065705.730392648@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit ccda84fcbf3a972973f772384935928f41817b3a ]

palmas_clks_init_configure() prepares the clock when an external control
pin is configured. The current driver only drops that prepare reference
when external control configuration fails.

If provider registration fails after that point, or if the driver is later
removed, the prepare reference remains held.

Register a device-managed action after clk_prepare() succeeds. This
balances the prepare reference on subsequent probe failure and driver
removal.

Fixes: 942d1d674931 ("clk: Add driver for Palmas clk32kg and clk32kgaudio clocks")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-palmas.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/clk-palmas.c b/drivers/clk/clk-palmas.c
index 39049f62dbbb3..86a51edac8272 100644
--- a/drivers/clk/clk-palmas.c
+++ b/drivers/clk/clk-palmas.c
@@ -194,6 +194,13 @@ static void palmas_clks_get_clk_data(struct platform_device *pdev,
 	cinfo->ext_control_pin = prop;
 }
 
+static void palmas_clks_unprepare_ext_control(void *data)
+{
+	struct palmas_clock_info *cinfo = data;
+
+	clk_unprepare(cinfo->hw.clk);
+}
+
 static int palmas_clks_init_configure(struct palmas_clock_info *cinfo)
 {
 	int ret;
@@ -214,13 +221,18 @@ static int palmas_clks_init_configure(struct palmas_clock_info *cinfo)
 			return ret;
 		}
 
+		ret = devm_add_action_or_reset(cinfo->dev,
+					       palmas_clks_unprepare_ext_control,
+					       cinfo);
+		if (ret)
+			return ret;
+
 		ret = palmas_ext_control_req_config(cinfo->palmas,
 					cinfo->clk_desc->sleep_reqstr_id,
 					cinfo->ext_control_pin, true);
 		if (ret < 0) {
 			dev_err(cinfo->dev, "Ext config for %s failed, %d\n",
 				cinfo->clk_desc->clk_name, ret);
-			clk_unprepare(cinfo->hw.clk);
 			return ret;
 		}
 	}
-- 
2.53.0



