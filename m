Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFAD3815F8;
	Sat, 12 Sep 2026 19:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242886; cv=none; b=Bds5YgXcKP7ZEAWkcxRgpLZGvY4+Hdh+oL6iMi5nqmzMbNBOhccNqAQ52wVl1mY1Y/Pwq0JQXuxkkdqlLx7rTNK8NBquJ8ycR8EHCA+/1/sy8zrdZq1PM5G1v1O1PVSRuO3XMeXanYo41dvz9sQYIXBmWK9OXUTNmoNggWxiXPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242886; c=relaxed/simple;
	bh=Llg1zI6N/3Aiz6WwJD9xIWdAEfqHyZ7bltdiTUbSu+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cMChk0J2yq4oMOUTxwYAiNtYjBx+22bApoSoV/0kDgGTnvCxYm7YJg2w97+havyvpg+cn2f9NVJhz/OZdMxyQNR77f3Ur+q4D4Sf05rSD8rUr10NFTMhEoJajFHoHcfwO85PVJGGzx1j1odKx0SAgBQYGaREmccIQceMiEN4roI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vSak63CO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vSak63CO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 486881F000FF;
	Sat, 12 Sep 2026 19:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242884;
	bh=krNKT3mTvnyMG8Y2/zrKIiSloK5Y9dscofxrC7fvBZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vSak63COl4xue/miZrh839FESO+nUrgeCn/nJzQUmp7zqsKwQhgQCBadbJpSE8avz
	 Sh04TlU7ExBv983ZDypwB2IMJ4F1U6uy/N9WEA9OZL1AvvT1sv0oCEBEU7wmseRvhL
	 83vPeTz8ltuzUACrsajyVbFl2joAJOckJPwxhX+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 530/798] clk: palmas: Manage external-control prepare with devm
Date: Sat, 12 Sep 2026 09:02:38 +0200
Message-ID: <20260912065529.279769450@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e41a3a9f7528f..8197dc4f46f90 100644
--- a/drivers/clk/clk-palmas.c
+++ b/drivers/clk/clk-palmas.c
@@ -203,6 +203,13 @@ static void palmas_clks_get_clk_data(struct platform_device *pdev,
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
@@ -223,13 +230,18 @@ static int palmas_clks_init_configure(struct palmas_clock_info *cinfo)
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



