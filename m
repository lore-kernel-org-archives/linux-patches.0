Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F98C4CCDC7;
	Fri,  4 Sep 2026 06:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502963; cv=none; b=VldzODfi3M/TUWDYvqLh68rXbQDzJAtPJlqrXPNAnA4ulCS0sCMEFit2kSkxBBdJP1m8obsRzQg2qkhuMB1TfFerKJ/E+oQBIiiZ8m2cYXv3ZEgzNcO1pKAhvh0g0e3MgtwRgJlsv0W6/Twz0Zlp43B4CiiZ4pw8qvkiEJPp2R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502963; c=relaxed/simple;
	bh=OBK980clqJtgLlu8A6VAiPAil0eiBdO/x8mNm7eDLXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S58SByja3/azBR/lqyFvjejgG62TlRfgifXmzowuR4dtUUvW3gW6Z4Z07YvSXtvtdZCbBmQXCahQfHK7jcPMEyUmO5ijq6rVkx/mJVi4EsJiFn5zKy9c5o2ZF9dhLnYnYRMBN2vKpzHwM4k14eihlcPrGDjwPC6+SwE2e7Ir0aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uJYV1W0+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uJYV1W0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819F21F00A3D;
	Fri,  4 Sep 2026 06:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502962;
	bh=d9cY0PCNeYAfzg11Te2tfEimdBMSHGjVV6feI75iIQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uJYV1W0+NTLh9j5+nnFxGN8mYXmNuv++i/gByfLW/hSsf218DZ36yjEx4FEUgvazk
	 p+hMsbmzicXEhpOu87E3HzZxfeliIy9ViDckaduKJn1e9IbA4mcOK+8dEgifHYsDvv
	 Gb2v5m+gjI2AMlLk2uCq9TupmvyINRaEXsY7jMDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.12 391/403] wifi: rtw88: pci: fix resource leak on failed NAPI setup
Date: Fri,  4 Sep 2026 07:03:14 +0200
Message-ID: <20260904045743.679246136@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Dawei Feng <dawei.feng@seu.edu.cn>

commit e779df4806cd29cbcca5c9dc0a1073662c76b889 upstream.

rtw_pci_probe() allocates PCI resources through
rtw_pci_setup_resource() before it sets up NAPI. If
rtw_pci_napi_init() fails, the error path jumps straight to
err_pci_declaim and skips rtw_pci_destroy(), leaving the PCI
resources allocated by rtw_pci_setup_resource() behind.

Add a dedicated cleanup label for the NAPI setup failure path so probe
destroys the PCI resources.

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing current
mainline kernels. The tool is still under development and is not yet
publicly available. Manual inspection confirms that the bug is still
present in v7.1-rc7.

An x86_64 allyesconfig build showed no new warnings. As we do not have a
suitable rtw88 PCI board to test with, no runtime testing was able to be
performed.

Fixes: d0bcb10e7b94 ("wifi: rtw88: Un-embed dummy device")
Cc: stable@vger.kernel.org
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260617013502.114057-1-dawei.feng@seu.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/pci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -1762,7 +1762,7 @@ int rtw_pci_probe(struct pci_dev *pdev,
 	ret = rtw_pci_napi_init(rtwdev);
 	if (ret) {
 		rtw_err(rtwdev, "failed to setup NAPI\n");
-		goto err_pci_declaim;
+		goto err_destroy_rsrc;
 	}
 
 	ret = rtw_chip_info_setup(rtwdev);
@@ -1794,6 +1794,8 @@ int rtw_pci_probe(struct pci_dev *pdev,
 
 err_destroy_pci:
 	rtw_pci_napi_deinit(rtwdev);
+
+err_destroy_rsrc:
 	rtw_pci_destroy(rtwdev, pdev);
 
 err_pci_declaim:


