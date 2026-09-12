Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0497E35AC3E;
	Sat, 12 Sep 2026 10:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208429; cv=none; b=Z5rgaxNn1TNIDa3gz1Y5ThP2jWHVhe7tqC+W1AKWGZOtzZ5D8ez0F3rMfOG9TAoP+v/SpM/5Kob3fTNGG/zIEdss7Wuj0RZQqWSJ5aAEvh4luWGCsmel8KXFwwKe+NERwycNDHoLhFf2dTkodVg6mgLX349R7KO37Aw4Scn1Lyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208429; c=relaxed/simple;
	bh=u+dz9yJWRZ+SG3TU0axdaaoq9a2ImNeDuXb2TrAPH5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5XX3EszNld+UFWQXJduNlw0eXFBKlZWLpAAWRbgAxQdI5UdxPwcLPWj8tIiXPxutGiC+OhtkLWkufcAYxSJpY+miaul6NInkjxJWrP5TQ0rJQGpXkMNEKPIuvBYCJzq0aLJXlWmM1Rr8i41sYeHpePr46sUOsn9ujo6H9XGCFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dGUB/Z4H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dGUB/Z4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09AB81F000FF;
	Sat, 12 Sep 2026 10:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208427;
	bh=D7oM+sSVsyHYgks7YhZ7OvkZhm1zTewVj+Fe+qX5JCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dGUB/Z4HwHumDpPLvkt6tSZhiQU8uaPp7MNxWQJ6U/yQ2SzUW8XozQGujCbEjcSHr
	 HlhKqtNxTOL9vW2dIIz0YoBfU1TTG7Gvnosb/X0SZEBAXaeFw6/rthSTTWXllvSgJo
	 SQOEqbUEwYDVHYyjMemX9zgNpZ7U8OCF8y+qR6tE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0616/1518] clk: palmas: Manage external-control prepare with devm
Date: Sat, 12 Sep 2026 08:46:25 +0200
Message-ID: <20260912065637.361752207@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



