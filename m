Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E242F2A;
	Mon, 12 Sep 2022 14:17:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 582EBC433D6;
	Mon, 12 Sep 2022 14:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1662992244;
	bh=jTbsk7yoEK+AZ3vZc8ogcuLE+gwzEOpP/ZeZUQAejUI=;
	h=From:To:Cc:Subject:Date:From;
	b=N2TPTBsaMrUDjAOP8g3X0PYhgmGhVVWX1TIzIUvPGYLN7AmbGJxb2/Ic7DAZhyk42
	 eFq6z/JznWLmMAZgq1GXf9n9Wg/VGkhgbyHCGWX/007Zwc9Ux8qoBDAP6C23y0ewil
	 y5p02FwkM+hYHeoqwFOG2LkrcWBPDZLMveUnibioOokNllXzjEf6G1eddFSovN6I5K
	 P/cWAszPKXKx60FDqyoqqX4cRMSTPEBiFrEYOIu2SixK90Ad9briXm30zOTsT3Uy09
	 Qlue/SDeCQ2RUUFFdjBTSmNHI6Apo3H5rfm/b+2kpwAuvxDHWq38glaz9yvf0j7TN6
	 TX2iQZrkheScQ==
From: Nathan Chancellor <nathan@kernel.org>
To: Sebastian Reichel <sre@kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Marek Vasut <marex@denx.de>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>,
	linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH -next] power: supply: bq25890: Fix enum conversion in bq25890_power_supply_set_property()
Date: Mon, 12 Sep 2022 07:15:53 -0700
Message-Id: <20220912141553.1743568-1-nathan@kernel.org>
X-Mailer: git-send-email 2.37.3
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clang warns:

  drivers/power/supply/bq25890_charger.c:625:40: error: implicit conversion from enumeration type 'enum bq25890_fields' to different enumeration type 'enum bq25890_table_ids' [-Werror,-Wenum-conversion]
                  lval = bq25890_find_idx(val->intval, F_IINLIM);
                         ~~~~~~~~~~~~~~~~              ^~~~~~~~
  1 error generated.

Use the proper value from the right enumerated type, TBL_IINLIM, so
there is no more implcit conversion. The numerical values of F_IINLIM
and TBL_IINLIM happen to be the same so there is no change in behavior.

Fixes: 4a4748f28b0b ("power: supply: bq25890: Add support for setting IINLIM")
Link: https://github.com/ClangBuiltLinux/linux/issues/1707
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/power/supply/bq25890_charger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/bq25890_charger.c b/drivers/power/supply/bq25890_charger.c
index f5368be32843..e6bd60fef0f6 100644
--- a/drivers/power/supply/bq25890_charger.c
+++ b/drivers/power/supply/bq25890_charger.c
@@ -622,7 +622,7 @@ static int bq25890_power_supply_set_property(struct power_supply *psy,
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_INPUT_CURRENT_LIMIT:
-		lval = bq25890_find_idx(val->intval, F_IINLIM);
+		lval = bq25890_find_idx(val->intval, TBL_IINLIM);
 		return bq25890_field_write(bq, F_IINLIM, lval);
 	default:
 		return -EINVAL;

base-commit: f52c4d5f0bb486bc515b5f8a56130aea69fb29db
-- 
2.37.3

