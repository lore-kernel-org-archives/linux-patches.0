Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDE323B628;
	Tue, 26 Aug 2025 11:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208408; cv=none; b=jsMXsUwQgQhOHuJ+qil758HElGhcLjM5x50tzOb4pXF7/pJtydAk8AUz+go4spa/s2/LD7587f6JWqfJ/SUUqbtTj/izL6CddbzG0BTDJ7VDQdeMfV7mE9WJNPgCGEdgoZi9uuYHooo/rt58iW7P46QAP/nYCrcPMhgv+awb0Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208408; c=relaxed/simple;
	bh=LucJMRUjMxQO4kbVwwZmn3o6SYTEI0QfnNG9U6e7j4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rPmQVROqjix7BSNSZ188kZ5ENZJRWU0b7J/9bdOMeRFU+V/R6eAo83Dio+KeWVscm5aMu/LAuhfe5yZt9Ss6dl0o9IgsM4fp2jMkJ0MAkhiwC3rbuM50ly468iihV6GJENSwogVkNVSwf3zwNvx46JudwkwFIbSpStdrgKgdQYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DFuYf3Jw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DFuYf3Jw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760D8C4CEF1;
	Tue, 26 Aug 2025 11:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208407;
	bh=LucJMRUjMxQO4kbVwwZmn3o6SYTEI0QfnNG9U6e7j4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DFuYf3JwFVE2SCQ1hPaeOyxU5A2oawDYagSjbqpBtkQOPfNWIRCTDzI2pxJPwqA1J
	 t7vTD0j4uP94WlhbZYRRC6AOFiomUUnbfdyiDVihRNsKM+ggmJWKzWJR2l1DJtNlIS
	 wF0/0SH3bvkfWH/Cm2uOYCegCNTPGIFI+SZd5Id0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bingbu Cao <bingbu.cao@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 099/322] media: hi556: correct the test pattern configuration
Date: Tue, 26 Aug 2025 13:08:34 +0200
Message-ID: <20250826110918.147754950@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -756,21 +756,23 @@ static int hi556_test_pattern(struct hi5
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


