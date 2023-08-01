Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F541FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:46:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97AF0C433C8;
	Tue,  1 Aug 2023 09:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883177;
	bh=7nOIQW1Bo9u7RGf7rS2RJgxnJppbhXjZcscHSDTpTVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ivlyYTtMQN4oneVFeCKUgzt3KNyWhTK0wyC15cIrkaxEXf/6kAKF/yyUlXgmzbZZQ
	 YZPRwx1Oq/mdCxI+CQcIY8ZQ6B6JUkpI0KrGRMSrdnyrTH1wzy6zt4LLYlpxd+BLKG
	 UyAa68XUfQ+XC4vWfGbrMFsFPUNeqh6KA68xAaI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	stable <stable@kernel.org>
Subject: [PATCH 6.4 142/239] Revert "usb: gadget: tegra-xudc: Fix error check in tegra_xudc_powerdomain_init()"
Date: Tue,  1 Aug 2023 11:20:06 +0200
Message-ID: <20230801091930.801099305@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

commit a8291be6b5dd465c22af229483dbac543a91e24e upstream.

This reverts commit f08aa7c80dac27ee00fa6827f447597d2fba5465.

The reverted commit was based on static analysis and a misunderstanding
of how PTR_ERR() and NULLs are supposed to work.  When a function
returns both pointer errors and NULL then normally the NULL means
"continue operating without a feature because it was deliberately
turned off".  The NULL should not be treated as a failure.  If a driver
cannot work when that feature is disabled then the KConfig should
enforce that the function cannot return NULL.  We should not need to
test for it.

In this driver, the bug means that probe cannot succeed when CONFIG_PM
is disabled.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: f08aa7c80dac ("usb: gadget: tegra-xudc: Fix error check in tegra_xudc_powerdomain_init()")
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/ZKQoBa84U/ykEh3C@moroto
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/tegra-xudc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/gadget/udc/tegra-xudc.c
+++ b/drivers/usb/gadget/udc/tegra-xudc.c
@@ -3718,15 +3718,15 @@ static int tegra_xudc_powerdomain_init(s
 	int err;
 
 	xudc->genpd_dev_device = dev_pm_domain_attach_by_name(dev, "dev");
-	if (IS_ERR_OR_NULL(xudc->genpd_dev_device)) {
-		err = PTR_ERR(xudc->genpd_dev_device) ? : -ENODATA;
+	if (IS_ERR(xudc->genpd_dev_device)) {
+		err = PTR_ERR(xudc->genpd_dev_device);
 		dev_err(dev, "failed to get device power domain: %d\n", err);
 		return err;
 	}
 
 	xudc->genpd_dev_ss = dev_pm_domain_attach_by_name(dev, "ss");
-	if (IS_ERR_OR_NULL(xudc->genpd_dev_ss)) {
-		err = PTR_ERR(xudc->genpd_dev_ss) ? : -ENODATA;
+	if (IS_ERR(xudc->genpd_dev_ss)) {
+		err = PTR_ERR(xudc->genpd_dev_ss);
 		dev_err(dev, "failed to get SuperSpeed power domain: %d\n", err);
 		return err;
 	}


