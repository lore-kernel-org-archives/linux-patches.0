Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C5B6FC9
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:38:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6205C433C8;
	Sun, 17 Sep 2023 19:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979489;
	bh=Qb4hT307EWXO405y2jaP733m7PyCmSd16DG3mp/NCnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Di0m7gOH21NFzCw1IyQX6qGhwc0ciptclES50R3YcIH16ejEaZreYtYspP1eV5VQp
	 aE3cNk5OMwSX3FXvEw0KGBk/Yy5tS4hPzTljfEmKcIR5uarPVK72Dqai1+minaC5bV
	 MWm+rbny0hXXjJG93qqMniNPCY/5U85QgzwjGRYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raag Jadav <raag.jadav@intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.10 327/406] pinctrl: cherryview: fix address_space_handler() argument
Date: Sun, 17 Sep 2023 21:13:01 +0200
Message-ID: <20230917191109.926573660@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1625,7 +1625,6 @@ static int chv_pinctrl_probe(struct plat
 	const struct intel_pinctrl_soc_data *soc_data;
 	struct intel_community *community;
 	struct device *dev = &pdev->dev;
-	struct acpi_device *adev = ACPI_COMPANION(dev);
 	struct intel_pinctrl *pctrl;
 	acpi_status status;
 	int ret, irq;
@@ -1688,7 +1687,7 @@ static int chv_pinctrl_probe(struct plat
 	if (ret)
 		return ret;
 
-	status = acpi_install_address_space_handler(adev->handle,
+	status = acpi_install_address_space_handler(ACPI_HANDLE(dev),
 					community->acpi_space_id,
 					chv_pinctrl_mmio_access_handler,
 					NULL, pctrl);
@@ -1705,7 +1704,7 @@ static int chv_pinctrl_remove(struct pla
 	struct intel_pinctrl *pctrl = platform_get_drvdata(pdev);
 	const struct intel_community *community = &pctrl->communities[0];
 
-	acpi_remove_address_space_handler(ACPI_COMPANION(&pdev->dev),
+	acpi_remove_address_space_handler(ACPI_HANDLE(&pdev->dev),
 					  community->acpi_space_id,
 					  chv_pinctrl_mmio_access_handler);
 


