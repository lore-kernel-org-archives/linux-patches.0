Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55256FC9
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:45:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA8EC433CC;
	Sun, 17 Sep 2023 19:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979908;
	bh=mdJiD3+ihnpddKCFG7X+9IZmYl/O25XQemgZIZSsUwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ffYkuOPNvoue+wouplePDG+2gP0/tkz5eAmKF1K+6wCkEoO94EYwgoEP09qrmtVcl
	 6FQzmqzwmcE8C5QGKtCGmfXI1GPavM4TLP5kBvas5aFRoRPX4cjS8rTshwBYWyQDko
	 yhi7fRZpAcW3w52IdrPr38sdwjVjUZSh4YDMTwBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raag Jadav <raag.jadav@intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.5 042/285] pinctrl: cherryview: fix address_space_handler() argument
Date: Sun, 17 Sep 2023 21:10:42 +0200
Message-ID: <20230917191053.131102804@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raag Jadav <raag.jadav@intel.com>

commit d5301c90716a8e20bc961a348182daca00c8e8f0 upstream.

First argument of acpi_*_address_space_handler() APIs is acpi_handle of
the device, which is incorrectly passed in driver ->remove() path here.
Fix it by passing the appropriate argument and while at it, make both
API calls consistent using ACPI_HANDLE().

Fixes: a0b028597d59 ("pinctrl: cherryview: Add support for GMMR GPIO opregion")
Cc: stable@vger.kernel.org
Signed-off-by: Raag Jadav <raag.jadav@intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/intel/pinctrl-cherryview.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/pinctrl/intel/pinctrl-cherryview.c
+++ b/drivers/pinctrl/intel/pinctrl-cherryview.c
@@ -1701,7 +1701,6 @@ static int chv_pinctrl_probe(struct plat
 	struct intel_community_context *cctx;
 	struct intel_community *community;
 	struct device *dev = &pdev->dev;
-	struct acpi_device *adev = ACPI_COMPANION(dev);
 	struct intel_pinctrl *pctrl;
 	acpi_status status;
 	unsigned int i;
@@ -1769,7 +1768,7 @@ static int chv_pinctrl_probe(struct plat
 	if (ret)
 		return ret;
 
-	status = acpi_install_address_space_handler(adev->handle,
+	status = acpi_install_address_space_handler(ACPI_HANDLE(dev),
 					community->acpi_space_id,
 					chv_pinctrl_mmio_access_handler,
 					NULL, pctrl);
@@ -1786,7 +1785,7 @@ static int chv_pinctrl_remove(struct pla
 	struct intel_pinctrl *pctrl = platform_get_drvdata(pdev);
 	const struct intel_community *community = &pctrl->communities[0];
 
-	acpi_remove_address_space_handler(ACPI_COMPANION(&pdev->dev),
+	acpi_remove_address_space_handler(ACPI_HANDLE(&pdev->dev),
 					  community->acpi_space_id,
 					  chv_pinctrl_mmio_access_handler);
 


