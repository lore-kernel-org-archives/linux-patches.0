Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5157B;
	Wed,  8 Jun 2022 15:28:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4CA4C34116;
	Wed,  8 Jun 2022 15:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1654702111;
	bh=xNLY7igwqhkEdX0LdFwkeYns5vg4pARM/9a9j++CR8Y=;
	h=From:To:Cc:Subject:Date:From;
	b=oIW5WJ1BJbIWgXH9K9gQyrMXg6UQZ+S78zAn3pGiCraQDI2d21f7n3ducnWT6Jsb2
	 Ezq/+xFsTFXe7Qn0ZuspuTXzbTehxaiQLN3Kb7NuJP6XNRWOAP1mJpAJ0qU6I7xtvD
	 pjutZYEk66mXFu9qdTe2f7i/9q5xNcB4rW7vWg06yINH9sfyrrCL81BLRoejmkCqxG
	 91lPAEtLqx5AhyvnW6r3EbQEpnZYhujYqU1EzsZIf5EUCmQodWKQ/VbUmrOMsHxTzv
	 owjfjejJSw3RmcuDKOph3ntVkVeo2a6LlrOBL3Om5ymxBpMulyBwmk1nvvNlYUaGCi
	 IPSCVCd68vpIw==
From: Nathan Chancellor <nathan@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>,
	Al Cooper <alcooperx@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Kamal Dasu <kdasu.kdev@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>
Cc: bcm-kernel-feedback-list@broadcom.com,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>,
	Justin Stitt <jstitt007@gmail.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	linux-mmc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	llvm@lists.linux.dev,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH] mmc: sdhci-brcmstb: Initialize base_clk to NULL in sdhci_brcmstb_probe()
Date: Wed,  8 Jun 2022 08:27:57 -0700
Message-Id: <20220608152757.82529-1-nathan@kernel.org>
X-Mailer: git-send-email 2.36.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clang warns a few times along the lines of:

  drivers/mmc/host/sdhci-brcmstb.c:302:6: warning: variable 'base_clk' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
          if (res)
              ^~~
  drivers/mmc/host/sdhci-brcmstb.c:376:24: note: uninitialized use occurs here
          clk_disable_unprepare(base_clk);
                                ^~~~~~~~

base_clk is used in the error path before it is initialized. Initialize
it to NULL, as clk_disable_unprepare() calls clk_disable() and
clk_unprepare(), which both handle NULL pointers gracefully.

Fixes: 2cecaac1b21c ("mmc: sdhci-brcmstb: Add ability to increase max clock rate for 72116b0")
Link: https://github.com/ClangBuiltLinux/linux/issues/1650
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/mmc/host/sdhci-brcmstb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-brcmstb.c b/drivers/mmc/host/sdhci-brcmstb.c
index f8dff8537920..28e9cf995c41 100644
--- a/drivers/mmc/host/sdhci-brcmstb.c
+++ b/drivers/mmc/host/sdhci-brcmstb.c
@@ -256,7 +256,7 @@ static int sdhci_brcmstb_probe(struct platform_device *pdev)
 	struct sdhci_host *host;
 	struct resource *iomem;
 	struct clk *clk;
-	struct clk *base_clk;
+	struct clk *base_clk = NULL;
 	int res;
 
 	match = of_match_node(sdhci_brcm_of_match, pdev->dev.of_node);

base-commit: 10980053142d8a3e86eb4d3014574424b42b7a45
-- 
2.36.1

