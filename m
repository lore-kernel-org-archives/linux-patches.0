Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2190C1B5839;
	Tue, 30 Jul 2024 15:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354950; cv=none; b=O3MsCuaTTxowXOkBCe0c4ldjKlHGxwCZETcvVd7gNofd7LJw7IZlBOcGFmm6hSyv/y7hzEkn1YJVCmZ/jgehwQu0I8+55A4HQreVfbmOPUVedFfrqiA3UISBc/i7vLpUTvwZUZvN3Xd2Egs9MJImA2VLCRFJhrdMXjqKIco3mQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354950; c=relaxed/simple;
	bh=yEl6OkIskANjQMZZwIid/WEV7lqQEO8Gdj+pRyGTnkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nkVuZUBS3Li74ouuap5XCoxUAECk1QS6Hc3bqUM/fsILFY2ap6zhIprNohrDpxAMQoAVNcSmC2blpxfS9A4iMRiAkAq3Qhl+pb9bhgFxuCoZ0diCBNNPrJGXQYN9ywfv9kYHgerhXpWQDAL5hIOXf6wzkJRYhkYHCKQu4Kmv6Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PfobwK03; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PfobwK03"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9868BC32782;
	Tue, 30 Jul 2024 15:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354950;
	bh=yEl6OkIskANjQMZZwIid/WEV7lqQEO8Gdj+pRyGTnkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PfobwK03hv0NvW454/g478wbK513kH5Ofy2N1S3R6aY9AsNDlO4NCOcAYDk7oCQt4
	 ecFXcn3wqS3HLF7re6Cob9tO8g74DhGirZdHOUNjsT2C3xSuRwgQB3Df99SDuN/ngE
	 zUCbhv/kHLwUZqDjKFmUP/x5jZ3NpCDv/YSm9WAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/568] x86/pci/xen: Fix PCIBIOS_* return code handling
Date: Tue, 30 Jul 2024 17:42:01 +0200
Message-ID: <20240730151640.386545295@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit e9d7b435dfaec58432f4106aaa632bf39f52ce9f ]

xen_pcifront_enable_irq() uses pci_read_config_byte() that returns
PCIBIOS_* codes. The error handling, however, assumes the codes are
normal errnos because it checks for < 0.

xen_pcifront_enable_irq() also returns the PCIBIOS_* code back to the
caller but the function is used as the (*pcibios_enable_irq) function
which should return normal errnos.

Convert the error check to plain non-zero check which works for
PCIBIOS_* return codes and convert the PCIBIOS_* return code using
pcibios_err_to_errno() into normal errno before returning it.

Fixes: 3f2a230caf21 ("xen: handled remapped IRQs when enabling a pcifront PCI device.")
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20240527125538.13620-3-ilpo.jarvinen@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/pci/xen.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 652cd53e77f64..0f2fe524f60dc 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -38,10 +38,10 @@ static int xen_pcifront_enable_irq(struct pci_dev *dev)
 	u8 gsi;
 
 	rc = pci_read_config_byte(dev, PCI_INTERRUPT_LINE, &gsi);
-	if (rc < 0) {
+	if (rc) {
 		dev_warn(&dev->dev, "Xen PCI: failed to read interrupt line: %d\n",
 			 rc);
-		return rc;
+		return pcibios_err_to_errno(rc);
 	}
 	/* In PV DomU the Xen PCI backend puts the PIRQ in the interrupt line.*/
 	pirq = gsi;
-- 
2.43.0



