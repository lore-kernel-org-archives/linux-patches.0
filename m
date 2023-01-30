Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84BA3229
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:26:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22446C433D2;
	Mon, 30 Jan 2023 14:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088778;
	bh=LfMbnbYD6mz6JQjrp++urRBLuEcXHS2FlR+VQ6AUfhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MyMyjQKeX29HGri0+SEof3wnLnDy6i0xn/UchJ0d8hsOlUv4eiC3HKoMJX8ahwHT9
	 Ct3gZownS2q4wxlqVuOYiXqrHBOr5mbnOr24w3cnsGCp7tc8XeUw+TfAM2+WyLcjho
	 IL1xKhyGb6Z6f7bVM4mstkRy28ZAXw4WBNXUoKrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lareine Khawaly <lareine@amazon.com>,
	Hanna Hawa <hhhawa@amazon.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 115/143] i2c: designware: use casting of u64 in clock multiplication to avoid overflow
Date: Mon, 30 Jan 2023 14:52:52 +0100
Message-Id: <20230130134311.601486238@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lareine Khawaly <lareine@amazon.com>

[ Upstream commit c8c37bc514514999e62a17e95160ed9ebf75ca8d ]

In functions i2c_dw_scl_lcnt() and i2c_dw_scl_hcnt() may have overflow
by depending on the values of the given parameters including the ic_clk.
For example in our use case where ic_clk is larger than one million,
multiplication of ic_clk * 4700 will result in 32 bit overflow.

Add cast of u64 to the calculation to avoid multiplication overflow, and
use the corresponding define for divide.

Fixes: 2373f6b9744d ("i2c-designware: split of i2c-designware.c into core and bus specific parts")
Signed-off-by: Lareine Khawaly <lareine@amazon.com>
Signed-off-by: Hanna Hawa <hhhawa@amazon.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-common.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-common.c b/drivers/i2c/busses/i2c-designware-common.c
index 73a4ef8130e6..682fffaab2b4 100644
--- a/drivers/i2c/busses/i2c-designware-common.c
+++ b/drivers/i2c/busses/i2c-designware-common.c
@@ -348,7 +348,8 @@ u32 i2c_dw_scl_hcnt(u32 ic_clk, u32 tSYMBOL, u32 tf, int cond, int offset)
 		 *
 		 * If your hardware is free from tHD;STA issue, try this one.
 		 */
-		return DIV_ROUND_CLOSEST(ic_clk * tSYMBOL, MICRO) - 8 + offset;
+		return DIV_ROUND_CLOSEST_ULL((u64)ic_clk * tSYMBOL, MICRO) -
+		       8 + offset;
 	else
 		/*
 		 * Conditional expression:
@@ -364,7 +365,8 @@ u32 i2c_dw_scl_hcnt(u32 ic_clk, u32 tSYMBOL, u32 tf, int cond, int offset)
 		 * The reason why we need to take into account "tf" here,
 		 * is the same as described in i2c_dw_scl_lcnt().
 		 */
-		return DIV_ROUND_CLOSEST(ic_clk * (tSYMBOL + tf), MICRO) - 3 + offset;
+		return DIV_ROUND_CLOSEST_ULL((u64)ic_clk * (tSYMBOL + tf), MICRO) -
+		       3 + offset;
 }
 
 u32 i2c_dw_scl_lcnt(u32 ic_clk, u32 tLOW, u32 tf, int offset)
@@ -380,7 +382,8 @@ u32 i2c_dw_scl_lcnt(u32 ic_clk, u32 tLOW, u32 tf, int offset)
 	 * account the fall time of SCL signal (tf).  Default tf value
 	 * should be 0.3 us, for safety.
 	 */
-	return DIV_ROUND_CLOSEST(ic_clk * (tLOW + tf), MICRO) - 1 + offset;
+	return DIV_ROUND_CLOSEST_ULL((u64)ic_clk * (tLOW + tf), MICRO) -
+	       1 + offset;
 }
 
 int i2c_dw_set_sda_hold(struct dw_i2c_dev *dev)
-- 
2.39.0



