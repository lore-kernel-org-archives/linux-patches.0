Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720B638F89;
	Fri, 27 Oct 2023 16:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RZBfKnMP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358FEC433C8;
	Fri, 27 Oct 2023 16:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698425677;
	bh=/miI3Jk5Lw4dQlveXHkuOwWSER+qZkWRM6gODkNYp+0=;
	h=From:Date:Subject:To:Cc:From;
	b=RZBfKnMP9qhCgwoepEs4Ln3AguyEI+fA1qkhPgKMV1MLx5/hrkGIzZ/qbDM30s/Dv
	 BMFRJ9N2HFlbxSa/3fgoeKKNcf5gLzXQfmFu8jX2pgy+DSQe56LGhZWQb/5Zyn9baW
	 LL1eBphv9X5ncRHqbe40SdsOPp0/9Z5D2xbeURn8QhT07Q9L0ZAPA2Fc4LJC9+qToD
	 lE7IOlaWGrPcSF+bNwv67KwaGR4IuQ0Oqo/C5rvUKpJJVudjSs5GoHcsIXnw5zbKU9
	 VbQpDeep6glP4y5/HGBHEvYy8NtSPMQKhWg2WxwXA7yjZkl/xrswc+8LWonRNd7jJa
	 vD3fZtt5/cGcg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Fri, 27 Oct 2023 09:54:25 -0700
Subject: [PATCH] ASoC: codecs: aw88399: Fix -Wuninitialized in
 aw_dev_set_vcalb()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231027-asoc-aw88399-fix-wuninitialized-v1-1-b1044493e4cd@kernel.org>
X-B4-Tracking: v=1; b=H4sIAEDrO2UC/x2NwQ6CMBAFf4XsmU2gFWz5FeNhhS2+xBTTohgJ/
 27jcZLJzE5ZEzTTUO2U9I2MJRZo64rGu8RZGVNhMo2xbWPOLHkZWTbnrPcc8OHtFRGxQh746sS
 9vXXdKbggXqhUnkmL9T9crsfxA0lzDm5xAAAA
To: broonie@kernel.org, wangweidong.a@awinic.com
Cc: lgirdwood@gmail.com, ndesaulniers@google.com, trix@redhat.com, 
 alsa-devel@alsa-project.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1647; i=nathan@kernel.org;
 h=from:subject:message-id; bh=/miI3Jk5Lw4dQlveXHkuOwWSER+qZkWRM6gODkNYp+0=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDKnWr33m/Hz4jz8nbWpLQUcOozOT3sI94rpb2cI/xcwv7
 zS85HCso5SFQYyDQVZMkaX6sepxQ8M5ZxlvnJoEM4eVCWQIAxenAEzkCxvDLyYHVs2Z7xbenKC7
 dF3B5Wcth7zOMPWkJpbJebyrEw4Kfsvwi5l1G4t/zsxjD1ctEI2/XKZo4sM64c62V//T45LMQ27
 asgEA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns (or errors with CONFIG_WERROR=y):

  sound/soc/codecs/aw88399.c:441:18: error: variable 'vsense_select' is uninitialized when used here [-Werror,-Wuninitialized]
    441 |         vsense_select = vsense_select & (~AW88399_VDSEL_MASK);
        |                         ^~~~~~~~~~~~~
  sound/soc/codecs/aw88399.c:431:28: note: initialize the variable 'vsense_select' to silence this warning
    431 |         unsigned int vsense_select, vsense_value;
        |                                   ^
        |                                    = 0
  1 error generated.

This clearly should have been using the value received from
regmap_read(). Use the correct variable to resolve the warning.

Closes: https://github.com/ClangBuiltLinux/linux/issues/1952
Fixes: 8ade6cc7e261 ("ASoC: codecs: Add aw88399 amplifier driver")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 sound/soc/codecs/aw88399.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/aw88399.c b/sound/soc/codecs/aw88399.c
index ce30bc7cdea9..47fe38d0def5 100644
--- a/sound/soc/codecs/aw88399.c
+++ b/sound/soc/codecs/aw88399.c
@@ -438,7 +438,7 @@ static int aw_dev_set_vcalb(struct aw88399 *aw88399)
 	if (ret)
 		return ret;
 
-	vsense_select = vsense_select & (~AW88399_VDSEL_MASK);
+	vsense_select = vsense_value & (~AW88399_VDSEL_MASK);
 
 	ret = aw88399_dev_get_icalk(aw88399, &icalk);
 	if (ret) {

---
base-commit: 60781d2d5899d6fc5fd173c1bcffaaec39643e17
change-id: 20231027-asoc-aw88399-fix-wuninitialized-63b554f8fa9a

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

