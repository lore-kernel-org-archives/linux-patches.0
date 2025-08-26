Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C2A350D7F;
	Tue, 26 Aug 2025 14:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218059; cv=none; b=MDoO8++/yhW0FJDXI73f2LSGBOrJuB0qSgVuf5WPAxczvFsbSyaFjhK4FKm+mp0Kv0rJbYXjZR9UbZ5g7En6vWT9GT5A1lkTXzt78u40nOzrmpBl0txOewSGC+C5tTWdWVOu7qJ0RoyzE9/KJy5Tw06uNrYIetge72mJcUT5k7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218059; c=relaxed/simple;
	bh=T+G28X2Qi8hWDk1qvHI5kWRwQJ71GlureO/3B32+JgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rw3/NJm0FiLn/LYHoIQYpVxh7Ma9tfsi2zVnj3WRvMubz2Tr8gcmcoUG/bq2f0MZFHlOqx2Oh5+EVsAj2O8iyHja5GfjLObqmXWkX1/LmZI4HXNw+LVfN7tD8X3DWgO1MHoBVnDN+7ezOFdUmufcruwrv+yc6J1YN6hvu6eAq0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BSF6dQk/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BSF6dQk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A459FC4CEF1;
	Tue, 26 Aug 2025 14:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218059;
	bh=T+G28X2Qi8hWDk1qvHI5kWRwQJ71GlureO/3B32+JgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BSF6dQk/Wt/CJBSJ0km1mOXrCOK8PE/qd2uqHLlcf62JpFc8XcdhL5q+M/deEPttx
	 qB6oYO1LvnK2z53nZNykFQJRBPJIK3XDUmo/Nz4KhAaM8YE3xY3MtHaCTTjRUpIAk5
	 equgRON+xuqKH63ZhyiqZ8pWSp+nYueT0TWBhvQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bingbu Cao <bingbu.cao@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.10 378/523] media: hi556: correct the test pattern configuration
Date: Tue, 26 Aug 2025 13:09:48 +0200
Message-ID: <20250826110933.787659214@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -602,21 +602,23 @@ static int hi556_test_pattern(struct hi5
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


