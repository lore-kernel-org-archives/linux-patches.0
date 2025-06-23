Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBC61F7580;
	Mon, 23 Jun 2025 22:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717082; cv=none; b=JzMOC7kkwD2aHPHz2GfATWphhzd53wYwQkVSUcvtwiaZNxQdP5mR4Bs1tg6WGPWh/he4wsTl+n1qXDbGlqsV5CtcVB6W++GOYg8E4YsxWKvtIAnZmETF7PcJqnkxFkmxNYj7a7JumzrRfnv6sywIb1HoIUjR8KDRG4AW6VFXLUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717082; c=relaxed/simple;
	bh=WaybvoPJsEQ1nWkd19mJ/3YHEiisLmc9toqJYQiaLKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZfNMbM8KDICMV8kplB7lWpi1ZuzqHYkLPCTGFw337AJIpvz+3ubDM9nDimQvUycF7RTJO4GQEbgNuPs0zXatVQedhbXvVztko0BboZzLESPYzc6uQ2KcImx0a8J6ztKYyQw9jfDlJShOIoIOjFDp/oEieuU/vPihYWFC/AemmzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JhNzHuta; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JhNzHuta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD06C4CEEA;
	Mon, 23 Jun 2025 22:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717082;
	bh=WaybvoPJsEQ1nWkd19mJ/3YHEiisLmc9toqJYQiaLKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JhNzHuta1yPsHQp06muqf3EfECecmuJuJozkXrdZcduxzgcmc8xhWPzKXWOSbTR8S
	 1tucxwW3vMPlDYjYhMiYCCOmivpzE661H1YmkhemrFZgK2RiCW9oCcfgw8Ppd5OEIh
	 LUdcYeTwWsgqqO7izN+/yy8DKK1Etla+0g4YsbXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 322/414] platform/x86/intel-uncore-freq: Fail module load when plat_info is NULL
Date: Mon, 23 Jun 2025 15:07:39 +0200
Message-ID: <20250623130650.045051025@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 685f88c72a0c4d12d3bd2ff50286938f14486f85 upstream.

Address a Smatch static checker warning regarding an unchecked
dereference in the function call:
set_cdie_id(i, cluster_info, plat_info)
when plat_info is NULL.

Instead of addressing this one case, in general if plat_info is NULL
then it can cause other issues. For example in a two package system it
will give warning for duplicate sysfs entry as package ID will be always
zero for both packages when creating string for attribute group name.

plat_info is derived from TPMI ID TPMI_BUS_INFO, which is integral to
the core TPMI design. Therefore, it should not be NULL on a production
platform. Consequently, the module should fail to load if plat_info is
NULL.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/platform-driver-x86/aEKvGCLd1qmX04Tc@stanley.mountain/T/#u
Fixes: 8a54e2253e4c ("platform/x86/intel-uncore-freq: Uncore frequency control via TPMI")
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250606205300.2384494-1-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/uncore-frequency/uncore-frequency-tpmi.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-tpmi.c
+++ b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-tpmi.c
@@ -467,10 +467,13 @@ static int uncore_probe(struct auxiliary
 
 	/* Get the package ID from the TPMI core */
 	plat_info = tpmi_get_platform_data(auxdev);
-	if (plat_info)
-		pkg = plat_info->package_id;
-	else
+	if (unlikely(!plat_info)) {
 		dev_info(&auxdev->dev, "Platform information is NULL\n");
+		ret = -ENODEV;
+		goto err_rem_common;
+	}
+
+	pkg = plat_info->package_id;
 
 	for (i = 0; i < num_resources; ++i) {
 		struct tpmi_uncore_power_domain_info *pd_info;


