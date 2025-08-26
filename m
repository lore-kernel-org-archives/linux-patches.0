Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7609233EAF9;
	Tue, 26 Aug 2025 13:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215006; cv=none; b=bKhePP9N7wVPZjOmDwSHi+5ZwlESWfHgIcylUNyxz1NDquoIam3J7MjBGeoeXwoYvpI1EMhAK49+kl+oyFqbIcJWun56rj627wBwvPxjey/GAQbClatbSGqtiECTss/7nn5RczJKAD57wPSzm73ovzW/WTgfyYAnzFlHpphfTGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215006; c=relaxed/simple;
	bh=dLjjpO2J6B+TH/4QIlpNE3VAOxWSE1D+baM1g4UL4pY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdATDPB5AbM1xaAMrNUAXnYxowKCjkCCcrlA8uRFTLolwzYat/FLNcGeSpi7WIeFhNAmAvd6iDs9MItJnPS3cYlY5kdGUULL/JDynm062j3Uk3ONO8ieaGyu6T1UTjNz/L9q9Yr3a7q0lhKWgbt6A6bFCY+Fki2OqaMDmn5BwEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZCOKH1V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZCOKH1V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03267C4CEF1;
	Tue, 26 Aug 2025 13:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215006;
	bh=dLjjpO2J6B+TH/4QIlpNE3VAOxWSE1D+baM1g4UL4pY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZCOKH1V3q+H+Ao8bG9TWjmpiry4w9JehuIZBcNeRaAuZIQspVzFHx82loHzZFVQs
	 xqUpC4Y0qWRhZXwfZuyaSPL+LiTj3AG0Bz53yakcpl5zN/JhHKHe2LG3bxzpGuK3n+
	 yCb8ue8X327RtwgiF5HdF+RuiGoBQOJx1Pc040Ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bingbu Cao <bingbu.cao@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.1 320/482] media: hi556: correct the test pattern configuration
Date: Tue, 26 Aug 2025 13:09:33 +0200
Message-ID: <20250826110938.713135919@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bingbu Cao <bingbu.cao@intel.com>

commit 020f602b068c9ce18d5056d02c8302199377d98d upstream.

Hynix hi556 support 8 test pattern modes:
hi556_test_pattern_menu[] = {
{
	"Disabled",
	"Solid Colour",
	"100% Colour Bars",
	"Fade To Grey Colour Bars",
	"PN9",
	"Gradient Horizontal",
	"Gradient Vertical",
	"Check Board",
	"Slant Pattern",
}

The test pattern is set by a 8-bit register according to the
specification.
+--------+-------------------------------+
| BIT[0] |  Solid color                  |
+--------+-------------------------------+
| BIT[1] |  Color bar                    |
+--------+-------------------------------+
| BIT[2] |  Fade to grey color bar       |
+--------+-------------------------------+
| BIT[3] |  PN9                          |
+--------+-------------------------------+
| BIT[4] |  Gradient horizontal          |
+--------+-------------------------------+
| BIT[5] |  Gradient vertical            |
+--------+-------------------------------+
| BIT[6] |  Check board                  |
+--------+-------------------------------+
| BIT[7] |  Slant pattern                |
+--------+-------------------------------+
Based on function above, current test pattern programming is wrong.
This patch fixes it by 'BIT(pattern - 1)'. If pattern is 0, driver
will disable the test pattern generation and set the pattern to 0.

Fixes: e62138403a84 ("media: hi556: Add support for Hi-556 sensor")
Cc: stable@vger.kernel.org
Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/hi556.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

--- a/drivers/media/i2c/hi556.c
+++ b/drivers/media/i2c/hi556.c
@@ -605,21 +605,23 @@ static int hi556_test_pattern(struct hi5
 	int ret;
 	u32 val;
 
-	if (pattern) {
-		ret = hi556_read_reg(hi556, HI556_REG_ISP,
-				     HI556_REG_VALUE_08BIT, &val);
-		if (ret)
-			return ret;
-
-		ret = hi556_write_reg(hi556, HI556_REG_ISP,
-				      HI556_REG_VALUE_08BIT,
-				      val | HI556_REG_ISP_TPG_EN);
-		if (ret)
-			return ret;
-	}
+	ret = hi556_read_reg(hi556, HI556_REG_ISP,
+			     HI556_REG_VALUE_08BIT, &val);
+	if (ret)
+		return ret;
+
+	val = pattern ? (val | HI556_REG_ISP_TPG_EN) :
+		(val & ~HI556_REG_ISP_TPG_EN);
+
+	ret = hi556_write_reg(hi556, HI556_REG_ISP,
+			      HI556_REG_VALUE_08BIT, val);
+	if (ret)
+		return ret;
+
+	val = pattern ? BIT(pattern - 1) : 0;
 
 	return hi556_write_reg(hi556, HI556_REG_TEST_PATTERN,
-			       HI556_REG_VALUE_08BIT, pattern);
+			       HI556_REG_VALUE_08BIT, val);
 }
 
 static int hi556_set_ctrl(struct v4l2_ctrl *ctrl)


