Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C850E11C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:23:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C3A8C433C8;
	Mon, 28 Aug 2023 10:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218214;
	bh=ni2g2cF3CJwm3D3JEsJs5x/KZzUzW1e4LvUn15GyHPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MmbP5zLhyiOeYOpXCNSXNnCo7X6RNIweIcqlGhDMgCKI8g+PSHnLRgT+O0UMwx7xX
	 COuXiK1o72QUuhnaPp5dIV9bFDOBIkF6QAoZC+et4g0RH0XHmph03v/JigSxjhRYCD
	 7F0OpaCESujvsxnBUGY/7TXRusbRDI4Exq5oCJGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Matt Roper <matthew.d.roper@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>
Subject: [PATCH 6.4 110/129] drm/i915: Fix error handling if driver creation fails during probe
Date: Mon, 28 Aug 2023 12:13:09 +0200
Message-ID: <20230828101201.022287634@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>
References: <20230828101157.383363777@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Roper <matthew.d.roper@intel.com>

commit 718551bbed3ca5308a9f9429305dd074727e8d46 upstream.

If i915_driver_create() fails to create a valid 'i915' object, we
should just disable the PCI device and return immediately without trying
to call i915_probe_error() that relies on a valid i915 pointer.

Fixes: 12e6f6dc78e4 ("drm/i915/display: Handle GMD_ID identification in display code")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/55236f93-dcc5-481e-b788-9f7e95b129d8@kili.mountain/
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230601173804.557756-1-matthew.d.roper@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_driver.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/i915_driver.c
+++ b/drivers/gpu/drm/i915/i915_driver.c
@@ -747,8 +747,8 @@ int i915_driver_probe(struct pci_dev *pd
 
 	i915 = i915_driver_create(pdev, ent);
 	if (IS_ERR(i915)) {
-		ret = PTR_ERR(i915);
-		goto out_pci_disable;
+		pci_disable_device(pdev);
+		return PTR_ERR(i915);
 	}
 
 	ret = i915_driver_early_probe(i915);


