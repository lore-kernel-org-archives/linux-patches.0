Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC23C36B
	for <patches@lists.linux.dev>; Thu,  3 Mar 2022 19:17:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6CAC340EF;
	Thu,  3 Mar 2022 19:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1646335073;
	bh=Bn6yM2yCazQaD8A1n65vFEXUE6/ICsJ38pFbK9aUJgI=;
	h=From:To:Cc:Subject:Date:From;
	b=iTjVwt4UqIgbxWTLRvkngGpAVSCYS4YNcN0Ygvp+LrmbbiXUrG8GPGRTpIQ/nZiAk
	 d1MHXXwqxSwpd06CmwvYhhRsGXr4aa23ggt+UPFlEHqD/F8sSsig79trxNwADEJadw
	 3sTzXVZHAQBK44KrEXduhJmsotTNW2XEPMXawuYAhbT4Z5D2hlj/qysTU2cxAOZ/+G
	 YipNczILWzwjJOGKUw0F+xtrAOOIpvBhQ3TVH2kNWlrl4zyYejm+UdiIA0m7F19JZq
	 1lwrQkKP/x9lryPXAnhl9wG/IBQHWellN4WMcAQ8Lv5/2R3DOw8d1PQFGT6uTWmdgq
	 d0VT82ezc9Gfw==
From: Nathan Chancellor <nathan@kernel.org>
To: Wolfram Sang <wsa@kernel.org>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Jan Dabros <jsd@semihalf.com>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-i2c@vger.kernel.org,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH -next] i2c: designware: Mark dw_i2c_plat_{suspend,resume}() as __maybe_unused
Date: Thu,  3 Mar 2022 12:17:13 -0700
Message-Id: <20220303191713.2402461-1-nathan@kernel.org>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When CONFIG_PM is set but CONFIG_PM_SLEEP is not, two compiler warnings
appear:

  drivers/i2c/busses/i2c-designware-platdrv.c:444:12: error: unused function 'dw_i2c_plat_suspend' [-Werror,-Wunused-function]
  static int dw_i2c_plat_suspend(struct device *dev)
             ^
  drivers/i2c/busses/i2c-designware-platdrv.c:465:12: error: unused function 'dw_i2c_plat_resume' [-Werror,-Wunused-function]
  static int dw_i2c_plat_resume(struct device *dev)
             ^
  2 errors generated.

These functions are only used in SET_LATE_SYSTEM_SLEEP_PM_OPS(), which
is defined as empty when CONFIG_PM_SLEEP is not defined. Mark the
functions as __maybe_unused to make it clear that these functions might
be unused in this configuration.

Fixes: c57813b8b288 ("i2c: designware: Lock the adapter while setting the suspended flag")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/i2c/busses/i2c-designware-platdrv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 116a297d1f6b..70ade5306e45 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -441,7 +441,7 @@ static int dw_i2c_plat_runtime_suspend(struct device *dev)
 	return 0;
 }
 
-static int dw_i2c_plat_suspend(struct device *dev)
+static int __maybe_unused dw_i2c_plat_suspend(struct device *dev)
 {
 	struct dw_i2c_dev *i_dev = dev_get_drvdata(dev);
 
@@ -462,7 +462,7 @@ static int dw_i2c_plat_runtime_resume(struct device *dev)
 	return 0;
 }
 
-static int dw_i2c_plat_resume(struct device *dev)
+static int __maybe_unused dw_i2c_plat_resume(struct device *dev)
 {
 	struct dw_i2c_dev *i_dev = dev_get_drvdata(dev);
 

base-commit: 1d366c2f9df8279df2adbb60471f86fc40a1c39e
-- 
2.35.1

