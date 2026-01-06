Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FB933D514;
	Tue,  6 Jan 2026 17:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720306; cv=none; b=V1k5q2J9AoU8uzpLddYQ2Re9jNpqpjuNwG79oA2Gn+MSLJizu5xwBBJhplTwtDHCMpfgsfrP8BMpI8Xl8FTJ0Oh2tid6EETPPoklamxb23al1zZ2zStx1wb0K+rbmzpn5y1vMaYy8WOmh/Bcn9zPv1IXbRl3Wq50ke84ofJR3PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720306; c=relaxed/simple;
	bh=IIpSOvZrtAIXq9z2zWFMDEqi8ZMpNc7vSXI0DS4CVqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W2GuRdoKok5PMoE6rpqz6ikYfIvgL/DHFmVtbZGC/dqXQtwCybx7uKYALyG7XVO8oxsZ74AZU8oCmYs10LkjRE738luy9DOcdLgOL12/OsB0VTLFcUMJjBs5RIxK8v5VHRKPmBoRElt2CipMura7N98YuG5P+MBfoFM6EOjvoPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DsMY1e2w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DsMY1e2w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37481C116C6;
	Tue,  6 Jan 2026 17:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720305;
	bh=IIpSOvZrtAIXq9z2zWFMDEqi8ZMpNc7vSXI0DS4CVqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DsMY1e2w8WDBOOqdOcOKpyBrtOPFzoCj8Ehmk1DRW0OxMK1bInedzCiZSGRvlwunH
	 /0gFLX7aGFwemqRWac+ZYnjjDxolZ4p8stqV/xi6MRcVEXoGz2oGRRgKqluuGl+qIg
	 qggf59xDILAR6bbRZKa7v0UC2EeXlAvZdHoDH6zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 6.12 196/567] cpufreq: nforce2: fix reference count leak in nforce2
Date: Tue,  6 Jan 2026 17:59:38 +0100
Message-ID: <20260106170458.574518217@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 
@@ -426,6 +428,7 @@ static int __init nforce2_init(void)
 static void __exit nforce2_exit(void)
 {
 	cpufreq_unregister_driver(&nforce2_driver);
+	pci_dev_put(nforce2_dev);
 }
 
 module_init(nforce2_init);


