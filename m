Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B78C175BF;
	Mon, 12 May 2025 18:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073027; cv=none; b=lUkZI1aZCXF3e+Kypep8qgdRPc50oMH/3gEt4lTpmx5XamPifmxjyzyEqLlhKU5rQXJIC+2yW+YEMkBP/YxOhwGbi7OEL0XcByQCunT6XCSfz1dH9xz02v6T03mxxb4gBu5nWt4QQFieZ8aqgtngGk9xbs4yjpky6qg8q2pnzNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073027; c=relaxed/simple;
	bh=o3EtQIHMaFEkVwenjfqiClTTFL3iFTc+xQlwwk1YDQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDSY9Qku6btK7Y66CKDeu0YxiU7TNN059b3Tx0CF3GRpLlheKVpUUG6ZlwrANbxQxiT0WjsB2UvPV+cePckKsJ87hXD+NXlcC2sTKHVB2qy6wPWXY4HUonvuguRBYPiOfrOB9YuiKCtUr2ENpddzw6r3UOYnZ0IuHjdRVzNV2+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z4f/Czpy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z4f/Czpy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7087C4CEF2;
	Mon, 12 May 2025 18:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073027;
	bh=o3EtQIHMaFEkVwenjfqiClTTFL3iFTc+xQlwwk1YDQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z4f/CzpyJRzzhSHuyMjVCsvEc85zeW4wA/UsfOTmhj9jSEVy1TjfZyhIWxSLpvS0Q
	 oAk/8h500NmPIfAnpZ1sN3Fcf6QnSZTU0wBl1I28bDPGfYl7dOTyDAF2/ZopQBcQgh
	 SSLvp80LwGMJ8AZZVRCGmOKTmCyo1dgQ0XkfWBMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alexey Charkov <alchark@gmail.com>
Subject: [PATCH 6.12 102/184] usb: uhci-platform: Make the clock really optional
Date: Mon, 12 May 2025 19:45:03 +0200
Message-ID: <20250512172045.978028552@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Charkov <alchark@gmail.com>

commit a5c7973539b010874a37a0e846e62ac6f00553ba upstream.

Device tree bindings state that the clock is optional for UHCI platform
controllers, and some existing device trees don't provide those - such
as those for VIA/WonderMedia devices.

The driver however fails to probe now if no clock is provided, because
devm_clk_get returns an error pointer in such case.

Switch to devm_clk_get_optional instead, so that it could probe again
on those platforms where no clocks are given.

Cc: stable <stable@kernel.org>
Fixes: 26c502701c52 ("usb: uhci: Add clk support to uhci-platform")
Signed-off-by: Alexey Charkov <alchark@gmail.com>
Link: https://lore.kernel.org/r/20250425-uhci-clock-optional-v1-1-a1d462592f29@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/uhci-platform.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/uhci-platform.c
+++ b/drivers/usb/host/uhci-platform.c
@@ -121,7 +121,7 @@ static int uhci_hcd_platform_probe(struc
 	}
 
 	/* Get and enable clock if any specified */
-	uhci->clk = devm_clk_get(&pdev->dev, NULL);
+	uhci->clk = devm_clk_get_optional(&pdev->dev, NULL);
 	if (IS_ERR(uhci->clk)) {
 		ret = PTR_ERR(uhci->clk);
 		goto err_rmr;


