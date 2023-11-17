Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F99C1FB0;
	Fri, 17 Nov 2023 01:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Amxnepe/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E5CC433C7;
	Fri, 17 Nov 2023 01:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700185564;
	bh=/T3Fq3sbGsowJP8JXWAK9oXwo0jsSWTX63ohksCMzg4=;
	h=From:Date:Subject:To:Cc:From;
	b=Amxnepe/UgcZ+vO9zUiClmSyUdQmguz5bG98K2CsSt1zCQnWrHU79pMPrOaH/9mIc
	 6fhZ1Xgd7nD5z2SiCpPwhSEZso5cvtDoFA+7SkkR5sjqVq7hahL+tuy92ZUi4QYLQa
	 RT0UBqlXH8F3hJiWa7zQ5PDRJudtew8HAwBzG9RBY2Ev+9EXzTCu29+S7fkxC1v9cx
	 5Z0aTuIqQCvQCKe+E6n3sjOtQCoJaUEHsC0fvyBIqydKn7Gg6DMEEfqB1A3Fi3+q4Z
	 J60rxWy/thg6VwbTG3RIJoPeVBaC44RrPfe7OqES6ishUVf4Y6Diwz/tV/+LRaHP2D
	 21vnQ+DLaKI/w==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 16 Nov 2023 18:46:00 -0700
Subject: [PATCH] mmc: sdhci-of-dwcmshc: Use logical OR instead of bitwise
 OR in dwcmshc_probe()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231116-sdhci-of-dwcmshc-fix-wbitwise-instead-of-logical-v1-1-7e1a7f4ccaab@kernel.org>
X-B4-Tracking: v=1; b=H4sIANfFVmUC/x2NSwrDMAxErxK0rqBO6IdepXRh2XIsSO1ihboQc
 veqXT5m3swGyk1Y4TZs0PgtKrUYuMMAIfsyM0o0hvE4Ts65M2rMQbAmjD08NQdM8sFOsnZRKxd
 d2cdfvtRZgl+Q0jVxvEx0IgKbfTU25X95f+z7F9egyIaCAAAA
To: adrian.hunter@intel.com, ulf.hansson@linaro.org
Cc: dfustini@baylibre.com, linux-mmc@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3363; i=nathan@kernel.org;
 h=from:subject:message-id; bh=/T3Fq3sbGsowJP8JXWAK9oXwo0jsSWTX63ohksCMzg4=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKlhR29XKK076bpRIN3TqtPc7Ib6r+oG58ytdtfSuwqOL
 OdU3JLXUcrCIMbFICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTACZSOInhr/Scix/27HCJMy8p
 82ma3yWoxDdpPVuB4tqOK3GdOksd7BkZFr/a81jg21mlE897rs94Lvvr+0bufdLnyp0cLyX7Pi2
 s4AMA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns (or errors with CONFIG_WERROR=y):

  drivers/mmc/host/sdhci-of-dwcmshc.c:873:7: error: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
    873 |                 if ((device_property_read_bool(dev, "mmc-ddr-1_8v")) |
        |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    874 |                     (device_property_read_bool(dev, "mmc-hs200-1_8v")) |
        |                     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        |                                                                        ||
    875 |                     (device_property_read_bool(dev, "mmc-hs400-1_8v")))
        |                     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  drivers/mmc/host/sdhci-of-dwcmshc.c:873:7: note: cast one or both operands to int to silence this warning
  drivers/mmc/host/sdhci-of-dwcmshc.c:873:7: error: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
    873 |                 if ((device_property_read_bool(dev, "mmc-ddr-1_8v")) |
        |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        |                                                                      ||
    874 |                     (device_property_read_bool(dev, "mmc-hs200-1_8v")) |
        |                     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  drivers/mmc/host/sdhci-of-dwcmshc.c:873:7: note: cast one or both operands to int to silence this warning
  2 errors generated.

There is little reason for this if statement to use bitwise ORs, as the
short circuiting of logical OR does not need to be avoided in this
context; it would be wasteful to call device_property_read_bool() three
times if the first two calls returned true. Switch to logical OR to fix
the warning.

While in the area, the parentheses around the calls to
device_property_read_bool() are not necessary and make the if statement
harder to read, so remove them.

Closes: https://github.com/ClangBuiltLinux/linux/issues/1960
Fixes: aff35fbc7830 ("mmc: sdhci-of-dwcmshc: Add support for T-Head TH1520")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/mmc/host/sdhci-of-dwcmshc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/sdhci-of-dwcmshc.c b/drivers/mmc/host/sdhci-of-dwcmshc.c
index 0eb72544c09e..a1f57af6acfb 100644
--- a/drivers/mmc/host/sdhci-of-dwcmshc.c
+++ b/drivers/mmc/host/sdhci-of-dwcmshc.c
@@ -870,9 +870,9 @@ static int dwcmshc_probe(struct platform_device *pdev)
 	if (pltfm_data == &sdhci_dwcmshc_th1520_pdata) {
 		priv->delay_line = PHY_SDCLKDL_DC_DEFAULT;
 
-		if ((device_property_read_bool(dev, "mmc-ddr-1_8v")) |
-		    (device_property_read_bool(dev, "mmc-hs200-1_8v")) |
-		    (device_property_read_bool(dev, "mmc-hs400-1_8v")))
+		if (device_property_read_bool(dev, "mmc-ddr-1_8v") ||
+		    device_property_read_bool(dev, "mmc-hs200-1_8v") ||
+		    device_property_read_bool(dev, "mmc-hs400-1_8v"))
 			priv->flags |= FLAG_IO_FIXED_1V8;
 		else
 			priv->flags &= ~FLAG_IO_FIXED_1V8;

---
base-commit: 3f00051234f02d0d9d1f63b9a334d0fd4c65b6ca
change-id: 20231116-sdhci-of-dwcmshc-fix-wbitwise-instead-of-logical-bf8fed73b5bb

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

