Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CD035BDA6;
	Fri,  9 Jan 2026 12:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962382; cv=none; b=GJrbnuXJS8g7dSmyS2nX++57JqAgtY9z+0QBrXpleWpbOyqYE/8/+LDfiNI9H4MVRPOyyLlLLgnpMs0eoEpzPBScnqV5IQY2V3f6oLC+KO7BFIZAMab4N5TUjQdzeJY3FWHWfbsrikik4KhfTq8E5WQnF9LtJjtbbTmVXo9/ddg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962382; c=relaxed/simple;
	bh=wC4a9zBT5YxMSKjNj7qvF32btG86D56MvP7yOsxFkRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbUcL7le7zyQVxScDDwjOxn+AarHrm8nSp1td5M5+gXGjxeNDmafdMTm83W6XqMIOD05QaOBM+WmICWwCdtpQ4mteXYwOwvBnOaX/qt7itci+2/w0DbdUg2aDFJ09QUUmRsgrusceu0czDiba4UHQnX1ZUWrxJ+YqqpPKVF2c1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gbcg+owW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gbcg+owW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53047C4CEF1;
	Fri,  9 Jan 2026 12:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962382;
	bh=wC4a9zBT5YxMSKjNj7qvF32btG86D56MvP7yOsxFkRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gbcg+owWPBkO1fHcZ4oBvsstNZ39TlZfuGIgCvqvicp7bGfbpmh8sVsCLzNBYlwhm
	 R2Ljw0wTTzVnI/HXVFv+d3O5qI67gAhGfHilYtL1dTGsDDYP6Nd0V8bYRSCsTIvjWk
	 ps2lMS6Bb2WpVqw77s9GzD/xqmIGuraPy0tcoTMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 6.1 344/634] cpufreq: nforce2: fix reference count leak in nforce2
Date: Fri,  9 Jan 2026 12:40:22 +0100
Message-ID: <20260109112130.467875974@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Miaoqian Lin <linmq006@gmail.com>

commit 9600156bb99852c216a2128cdf9f114eb67c350f upstream.

There are two reference count leaks in this driver:

1. In nforce2_fsb_read(): pci_get_subsys() increases the reference count
   of the PCI device, but pci_dev_put() is never called to release it,
   thus leaking the reference.

2. In nforce2_detect_chipset(): pci_get_subsys() gets a reference to the
   nforce2_dev which is stored in a global variable, but the reference
   is never released when the module is unloaded.

Fix both by:
- Adding pci_dev_put(nforce2_sub5) in nforce2_fsb_read() after reading
  the configuration.
- Adding pci_dev_put(nforce2_dev) in nforce2_exit() to release the
  global device reference.

Found via static analysis.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/cpufreq-nforce2.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/cpufreq/cpufreq-nforce2.c
+++ b/drivers/cpufreq/cpufreq-nforce2.c
@@ -145,6 +145,8 @@ static unsigned int nforce2_fsb_read(int
 	pci_read_config_dword(nforce2_sub5, NFORCE2_BOOTFSB, &fsb);
 	fsb /= 1000000;
 
+	pci_dev_put(nforce2_sub5);
+
 	/* Check if PLL register is already set */
 	pci_read_config_byte(nforce2_dev, NFORCE2_PLLENABLE, (u8 *)&temp);
 
@@ -432,6 +434,7 @@ static int __init nforce2_init(void)
 static void __exit nforce2_exit(void)
 {
 	cpufreq_unregister_driver(&nforce2_driver);
+	pci_dev_put(nforce2_dev);
 }
 
 module_init(nforce2_init);


