Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15141BA86D;
	Tue, 30 Jul 2024 15:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354940; cv=none; b=jUV6gOH65biYIr4nIx1uF3sezZVoouJmaiwMP1ETBGNHpwS0YJhccUN5ckSurV6xJVOFQ5SrVqNZZTtcCpQ1lZQcP5I7vDwuLWV9iBhwPB30Ezv5alVTLvH3FZJlMPNy/LFJGiQzghBNyTJ4exiiMwME49fprHIMsNDRJeTuVmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354940; c=relaxed/simple;
	bh=V8m5bpAmMwJRLyZx30X0BF1n/RBgbCvwg+lXWxD6mlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cysx+JVz89p2ylO94b0uwUc3H45BfctacXPgZ9jU0CIa86K1T828Zfy59SWIB5lytx3NNMp8i9mMDVMnbFreC4xB/drQoJl5LRgJ4ASXEuD4AmbEDtwf8ji1Jr3aeV1v+OElOnWfCUsvKFnx1SMcuhqFCZtUuSmHZP9XmVI2+xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v7JsQ3Oi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v7JsQ3Oi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BCD7C32782;
	Tue, 30 Jul 2024 15:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354940;
	bh=V8m5bpAmMwJRLyZx30X0BF1n/RBgbCvwg+lXWxD6mlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v7JsQ3OiNE4yUIqDTAJKit+e8SQLyajV+S19dtBHzIuwx3Ee+Fqvz3wEpGzIqLrc8
	 319ljXcZZg/44P2EB1KaVp0bIzMzYZETyMgE/9wUGjQMQ73EkRwtr++GBNj1ihruD2
	 e7tqUGh/uSpmqbIdtR0szox9HXS40n1N4JmrPSSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/568] x86/pci/intel_mid_pci: Fix PCIBIOS_* return code handling
Date: Tue, 30 Jul 2024 17:42:00 +0200
Message-ID: <20240730151640.345002514@linuxfoundation.org>
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

[ Upstream commit 724852059e97c48557151b3aa4af424614819752 ]

intel_mid_pci_irq_enable() uses pci_read_config_byte() that returns
PCIBIOS_* codes. The error handling, however, assumes the codes are
normal errnos because it checks for < 0.

intel_mid_pci_irq_enable() also returns the PCIBIOS_* code back to the
caller but the function is used as the (*pcibios_enable_irq) function
which should return normal errnos.

Convert the error check to plain non-zero check which works for
PCIBIOS_* return codes and convert the PCIBIOS_* return code using
pcibios_err_to_errno() into normal errno before returning it.

Fixes: 5b395e2be6c4 ("x86/platform/intel-mid: Make IRQ allocation a bit more flexible")
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20240527125538.13620-2-ilpo.jarvinen@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/pci/intel_mid_pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/intel_mid_pci.c b/arch/x86/pci/intel_mid_pci.c
index 8edd622066044..722a33be08a18 100644
--- a/arch/x86/pci/intel_mid_pci.c
+++ b/arch/x86/pci/intel_mid_pci.c
@@ -233,9 +233,9 @@ static int intel_mid_pci_irq_enable(struct pci_dev *dev)
 		return 0;
 
 	ret = pci_read_config_byte(dev, PCI_INTERRUPT_LINE, &gsi);
-	if (ret < 0) {
+	if (ret) {
 		dev_warn(&dev->dev, "Failed to read interrupt line: %d\n", ret);
-		return ret;
+		return pcibios_err_to_errno(ret);
 	}
 
 	id = x86_match_cpu(intel_mid_cpu_ids);
-- 
2.43.0



