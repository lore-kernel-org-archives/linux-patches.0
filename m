Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F9C6FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:01:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C7AC43397;
	Sun, 17 Sep 2023 20:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980896;
	bh=as0J3H/xL5dPfWVrq0kfX/GJJyWMonj+2aUu74eZ/Ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HRj1W4mq4atEU5wTkmPL3QwhcZHDQLP/P/EUu80LkKYqhkS/4DGLa7/xDNuKTr9s2
	 1V7w0H9zvLGMYIHRrkIEvTFBIzPGVtohccVkIHhTs3hGIi4cJOBJzrGuJiScjkjfY2
	 4Su5j8r/ke1jdC7i0I0FpD5K68KvhwTbxP3XBCSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raag Jadav <raag.jadav@intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.1 039/219] pinctrl: cherryview: fix address_space_handler() argument
Date: Sun, 17 Sep 2023 21:12:46 +0200
Message-ID: <20230917191042.409175998@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1698,7 +1698,6 @@ static int chv_pinctrl_probe(struct plat
 	struct intel_community_context *cctx;
 	struct intel_community *community;
 	struct device *dev = &pdev->dev;
-	struct acpi_device *adev = ACPI_COMPANION(dev);
 	struct intel_pinctrl *pctrl;
 	acpi_status status;
 	unsigned int i;
@@ -1766,7 +1765,7 @@ static int chv_pinctrl_probe(struct plat
 	if (ret)
 		return ret;
 
-	status = acpi_install_address_space_handler(adev->handle,
+	status = acpi_install_address_space_handler(ACPI_HANDLE(dev),
 					community->acpi_space_id,
 					chv_pinctrl_mmio_access_handler,
 					NULL, pctrl);
@@ -1783,7 +1782,7 @@ static int chv_pinctrl_remove(struct pla
 	struct intel_pinctrl *pctrl = platform_get_drvdata(pdev);
 	const struct intel_community *community = &pctrl->communities[0];
 
-	acpi_remove_address_space_handler(ACPI_COMPANION(&pdev->dev),
+	acpi_remove_address_space_handler(ACPI_HANDLE(&pdev->dev),
 					  community->acpi_space_id,
 					  chv_pinctrl_mmio_access_handler);
 


