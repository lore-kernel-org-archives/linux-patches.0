Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704A31ED4F
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7187C433C8;
	Tue, 25 Jul 2023 11:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285147;
	bh=JPhPJMEqpI3yAdGNr/D7ak29afTLkdrdAudnZxzZafg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ryRtL/P3UNEKbPNAbhp+JEE54EOHFhoUV87gN5A8snukjypxeHdrgydv5e22r9XQV
	 jvsnOrSm8rxxlHSdeeuUI6YVkMT9bnF1sfMM9EDX3UCCyIul1g7wZ8AQFEcnObpAPK
	 FC9M4Ptqe713pUB1LTSHiwv7kTIRs5TchRuI9HWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 101/313] pinctrl: cherryview: Return correct value if pin in push-pull mode
Date: Tue, 25 Jul 2023 12:44:14 +0200
Message-ID: <20230725104525.340481640@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 5835196a17be5cfdcad0b617f90cf4abe16951a4 ]

Currently the getter returns ENOTSUPP on pin configured in
the push-pull mode. Fix this by adding the missed switch case.

Fixes: ccdf81d08dbe ("pinctrl: cherryview: add option to set open-drain pin config")
Fixes: 6e08d6bbebeb ("pinctrl: Add Intel Cherryview/Braswell pin controller support")
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-cherryview.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/intel/pinctrl-cherryview.c b/drivers/pinctrl/intel/pinctrl-cherryview.c
index 8f06445a8e39c..2b48901f1b2af 100644
--- a/drivers/pinctrl/intel/pinctrl-cherryview.c
+++ b/drivers/pinctrl/intel/pinctrl-cherryview.c
@@ -1021,11 +1021,6 @@ static int chv_config_get(struct pinctrl_dev *pctldev, unsigned int pin,
 
 		break;
 
-	case PIN_CONFIG_DRIVE_OPEN_DRAIN:
-		if (!(ctrl1 & CHV_PADCTRL1_ODEN))
-			return -EINVAL;
-		break;
-
 	case PIN_CONFIG_BIAS_HIGH_IMPEDANCE: {
 		u32 cfg;
 
@@ -1035,6 +1030,16 @@ static int chv_config_get(struct pinctrl_dev *pctldev, unsigned int pin,
 			return -EINVAL;
 
 		break;
+
+	case PIN_CONFIG_DRIVE_PUSH_PULL:
+		if (ctrl1 & CHV_PADCTRL1_ODEN)
+			return -EINVAL;
+		break;
+
+	case PIN_CONFIG_DRIVE_OPEN_DRAIN:
+		if (!(ctrl1 & CHV_PADCTRL1_ODEN))
+			return -EINVAL;
+		break;
 	}
 
 	default:
-- 
2.39.2



