Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555C1347C6;
	Mon, 29 Dec 2025 16:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025701; cv=none; b=u8GVB9nFXEXh/aakvO6SfGrlt+R8apfx8IOsur23Qvy8eNdqmrzImAoJCz0gS6CPB4jaw1mSATP9wrWuxtO0xmXIiTERKj1lzUX4CfrYTKHprQELx26WTJXI/HGbUbMATgKblAe4+uFGdCgHO9mXSK8MNNSrwvHAUcWCFiELqs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025701; c=relaxed/simple;
	bh=63/+nqtiOHuObLSjuWVx/EtDJLx6k5kxSvn/dy49RcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ms8jds8gFEeFBz6t6a7Zg0w3JyUDqYrm1ULkUS4bpvkhURfl6x2V3Gbhad1FHTgaC6+0MuyZNG2gaNy/0yY3K11803/V2/Z7MSYpyrx3k1b3fRTdcY4Vm5xpx8ZFdV/AQDcfxd/T+BRBerqWOJScm3w4YsxB6je7sfcqp6XRO4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ww1kpckk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ww1kpckk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5CC3C4CEF7;
	Mon, 29 Dec 2025 16:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025701;
	bh=63/+nqtiOHuObLSjuWVx/EtDJLx6k5kxSvn/dy49RcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ww1kpckk7mSappjjrp/euLrfn6CgQMuXOyej1yZV4o3MreAKnVpPRRmua9duoP/f9
	 jJKdLGFY7SEnyXkqyOFjRJbWHepd8R8Y6wJTuIX09xF0OtmGBPzc4xsJj+OnC/RdAz
	 7nbiHXh2NmWayGfVueFGQIGp1ouFvbF/LdgJ85WM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 6.18 305/430] cpufreq: nforce2: fix reference count leak in nforce2
Date: Mon, 29 Dec 2025 17:11:47 +0100
Message-ID: <20251229160735.559168438@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


