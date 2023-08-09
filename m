Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22D717AAD
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:39:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E43C433C7;
	Wed,  9 Aug 2023 11:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691581145;
	bh=Tz8SRu9b178wK6V6K8z/pO22Pjl4cWBSHdkzZutPjvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AM3hKmT/UZ032JwEg6IQwdw0R1JhNZ39pqHjsaIGQRskpOCQf7Fo/6lFnyuiETLVN
	 rPy7lhehSUq/z+A+0RJi9IuIRS72OALoEJCB2se01OqZvBySASuh1xJgGjKjTK4NCM
	 N1NLtnVYLrhU9rK4iorpq4fqqWgB4njWZMLQ/TWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 081/201] Revert "usb: xhci: tegra: Fix error check"
Date: Wed,  9 Aug 2023 12:41:23 +0200
Message-ID: <20230809103646.510990498@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
References: <20230809103643.799166053@linuxfoundation.org>
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

commit 288b4fa1798e3637a9304c6e90a93d900e02369c upstream.

This reverts commit 18fc7c435be3f17ea26a21b2e2312fcb9088e01f.

The reverted commit was based on static analysis and a misunderstanding
of how PTR_ERR() and NULLs are supposed to work.  When a function
returns both pointer errors and NULL then normally the NULL means
"continue operating without a feature because it was deliberately
turned off".  The NULL should not be treated as a failure.  If a driver
cannot work when that feature is disabled then the KConfig should
enforce that the function cannot return NULL.  We should not need to
test for it.

In this code, the patch means that certain tegra_xusb_probe() will
fail if the firmware supports power-domains but CONFIG_PM is disabled.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: 18fc7c435be3 ("usb: xhci: tegra: Fix error check")
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/8baace8d-fb4b-41a4-ad5f-848ae643a23b@moroto.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-tegra.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/host/xhci-tegra.c
+++ b/drivers/usb/host/xhci-tegra.c
@@ -1042,15 +1042,15 @@ static int tegra_xusb_powerdomain_init(s
 	int err;
 
 	tegra->genpd_dev_host = dev_pm_domain_attach_by_name(dev, "xusb_host");
-	if (IS_ERR_OR_NULL(tegra->genpd_dev_host)) {
-		err = PTR_ERR(tegra->genpd_dev_host) ? : -ENODATA;
+	if (IS_ERR(tegra->genpd_dev_host)) {
+		err = PTR_ERR(tegra->genpd_dev_host);
 		dev_err(dev, "failed to get host pm-domain: %d\n", err);
 		return err;
 	}
 
 	tegra->genpd_dev_ss = dev_pm_domain_attach_by_name(dev, "xusb_ss");
-	if (IS_ERR_OR_NULL(tegra->genpd_dev_ss)) {
-		err = PTR_ERR(tegra->genpd_dev_ss) ? : -ENODATA;
+	if (IS_ERR(tegra->genpd_dev_ss)) {
+		err = PTR_ERR(tegra->genpd_dev_ss);
 		dev_err(dev, "failed to get superspeed pm-domain: %d\n", err);
 		return err;
 	}


