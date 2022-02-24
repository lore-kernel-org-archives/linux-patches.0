Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6CD1373;
	Thu, 24 Feb 2022 21:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD011C340E9;
	Thu, 24 Feb 2022 21:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1645737052;
	bh=of0dgeyEYw65+FoM0blva960Bmm/NelYeS+8mwZtaRw=;
	h=From:To:Cc:Subject:Date:From;
	b=mgnFTy+/Iw2w+HIhZsZoaHPokVk3nb3ubMC28rB2vt41gH4zN3nUGWXzupmPwlFB4
	 UVcnE1nRRyzORca95Dl7NH1hOmC49WPuJGE3/ysl0rSFj/Dgpw2YWL++MGFlb/SvBH
	 nh5pSRSfYwB8oygB7+2ewJeXeqDlr3g1xZkSNQdS1LAz9kwpPYihiAJR+1HSywvjYj
	 uVD5C2BcmuOeZTRleDeMxYU8XF30foNAyKeflBHSC4afltmMzQ4MFNag5vmDMTIOOZ
	 jcAVLsnjJVuJo2dS/7RyDtgJT8f549o7LTd4ppbVRMCpnFuVSHiLb6QDrG25YhRb3q
	 /FGWrKZ0Q5mXA==
From: Nathan Chancellor <nathan@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>,
	Michael Hennerich <Michael.Hennerich@analog.com>,
	Cosmin Tanislav <cosmin.tanislav@analog.com>,
	Jonathan Cameron <jic23@kernel.org>
Cc: linux-iio@vger.kernel.org,
	patches@lists.linux.dev,
	llvm@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH] iio: accel: adxl367: Fix handled initialization in adxl367_irq_handler()
Date: Thu, 24 Feb 2022 14:10:34 -0700
Message-Id: <20220224211034.625130-1-nathan@kernel.org>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clang warns:

  drivers/iio/accel/adxl367.c:887:2: error: variable 'handled' is uninitialized when used here [-Werror,-Wuninitialized]
          handled |= adxl367_push_event(indio_dev, status);
          ^~~~~~~
  drivers/iio/accel/adxl367.c:879:14: note: initialize the variable 'handled' to silence this warning
          bool handled;
                      ^
                       = 0
  1 error generated.

This should have used '=' instead of '|='; make that change to resolve
the warning.

Fixes: cbab791c5e2a ("iio: accel: add ADXL367 driver")
Link: https://github.com/ClangBuiltLinux/linux/issues/1605
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/iio/accel/adxl367.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/accel/adxl367.c b/drivers/iio/accel/adxl367.c
index b452d74b1d4d..350a89b61179 100644
--- a/drivers/iio/accel/adxl367.c
+++ b/drivers/iio/accel/adxl367.c
@@ -884,7 +884,7 @@ static irqreturn_t adxl367_irq_handler(int irq, void *private)
 	if (ret)
 		return IRQ_NONE;
 
-	handled |= adxl367_push_event(indio_dev, status);
+	handled = adxl367_push_event(indio_dev, status);
 	handled |= adxl367_push_fifo_data(indio_dev, status, fifo_entries);
 
 	return handled ? IRQ_HANDLED : IRQ_NONE;

base-commit: 2be8795a609800e5071d868d459ce29232fce2c8
-- 
2.35.1

