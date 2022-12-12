Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5521E2585
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:13:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA57BC433D2;
	Mon, 12 Dec 2022 13:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670850795;
	bh=a9yD27hB8J9i9xJNi10InmAk03XmKiVd6Gpnb/UCcWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CVBExHWPqH1f4UaICSC3GSDumdYVaiNpXVxFb8jfXF/n943gqxBvWNoNGiXjYRGPn
	 zmF9rCxzbQuw5LFrgO00W1srhB2ni7telu3qcFUCibZmRyuznaR1OSKwYVoMRm72Pb
	 XlmkJ8mQ9+2v0hU4BFV1KZ6VDoozFZYJk8ugFtMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Kemnade <andreas@kemnade.info>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 022/106] regulator: twl6030: fix get status of twl6032 regulators
Date: Mon, 12 Dec 2022 14:09:25 +0100
Message-Id: <20221212130925.829552988@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andreas Kemnade <andreas@kemnade.info>

[ Upstream commit 31a6297b89aabc81b274c093a308a7f5b55081a7 ]

Status is reported as always off in the 6032 case. Status
reporting now matches the logic in the setters. Once of
the differences to the 6030 is that there are no groups,
therefore the state needs to be read out in the lower bits.

Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://lore.kernel.org/r/20221120221208.3093727-3-andreas@kemnade.info
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/twl6030-regulator.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/twl6030-regulator.c b/drivers/regulator/twl6030-regulator.c
index 7c7e3648ea4b..f3856750944f 100644
--- a/drivers/regulator/twl6030-regulator.c
+++ b/drivers/regulator/twl6030-regulator.c
@@ -67,6 +67,7 @@ struct twlreg_info {
 #define TWL6030_CFG_STATE_SLEEP	0x03
 #define TWL6030_CFG_STATE_GRP_SHIFT	5
 #define TWL6030_CFG_STATE_APP_SHIFT	2
+#define TWL6030_CFG_STATE_MASK		0x03
 #define TWL6030_CFG_STATE_APP_MASK	(0x03 << TWL6030_CFG_STATE_APP_SHIFT)
 #define TWL6030_CFG_STATE_APP(v)	(((v) & TWL6030_CFG_STATE_APP_MASK) >>\
 						TWL6030_CFG_STATE_APP_SHIFT)
@@ -128,13 +129,14 @@ static int twl6030reg_is_enabled(struct regulator_dev *rdev)
 		if (grp < 0)
 			return grp;
 		grp &= P1_GRP_6030;
+		val = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_STATE);
+		val = TWL6030_CFG_STATE_APP(val);
 	} else {
+		val = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_STATE);
+		val &= TWL6030_CFG_STATE_MASK;
 		grp = 1;
 	}
 
-	val = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_STATE);
-	val = TWL6030_CFG_STATE_APP(val);
-
 	return grp && (val == TWL6030_CFG_STATE_ON);
 }
 
@@ -187,7 +189,12 @@ static int twl6030reg_get_status(struct regulator_dev *rdev)
 
 	val = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_STATE);
 
-	switch (TWL6030_CFG_STATE_APP(val)) {
+	if (info->features & TWL6032_SUBCLASS)
+		val &= TWL6030_CFG_STATE_MASK;
+	else
+		val = TWL6030_CFG_STATE_APP(val);
+
+	switch (val) {
 	case TWL6030_CFG_STATE_ON:
 		return REGULATOR_STATUS_NORMAL;
 
-- 
2.35.1



