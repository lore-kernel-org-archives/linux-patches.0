Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1621AC8BB;
	Thu, 15 Aug 2024 14:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731907; cv=none; b=U9LE/m3N2GGfhz1cF8VmSFnTaQF85tCO0QEwt6lRQqmJWUrrd9A0tl/xGcCpBbqdcamjQViSWmdXummw41vB8R0pj4IdH7ySdqjk68FMlwrloqevMSiWcvLitit6Jsb7hd2E/4eIQCErvsRn9jVtvhDFlLoVLZYYttZZ0mUsgDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731907; c=relaxed/simple;
	bh=b8b24U9ClZwnpCXQMKCwhuL4kcrhTUfIfzY3aOIDaHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YshvUQmvOkn+Ptd00e/2H6lyGWNswoSMdB31FWxABlSCaeA4TuvUlWm4meFl1lrM9c4YAuo2OjkQiXmwXQal7Fx521T0CL+DCtckGIgtpa2BZUUY6YFt7OAjujX3jChJU6cy4E8gb1j3os+65tVlBSg1XrKP1pK8/kG21alOiQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zc/jXVQg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zc/jXVQg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B72C32786;
	Thu, 15 Aug 2024 14:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731906;
	bh=b8b24U9ClZwnpCXQMKCwhuL4kcrhTUfIfzY3aOIDaHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zc/jXVQg1M2fmJchoCecO4tR5HlnD6uYEFrF26bf+QKyGwE5qMj2SixNRIGRAC+Q2
	 mhyWH0zzJq8AieiGCGLY08iUP15WzR7F4QKsZGqDSgO1XpgcMxlQLFqttx/sdQ70Sn
	 31v4QgjA/WbQWLqCvBrQbhmCSL0tA0IKm73s//so=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 006/352] x86/pci/intel_mid_pci: Fix PCIBIOS_* return code handling
Date: Thu, 15 Aug 2024 15:21:12 +0200
Message-ID: <20240815131919.451944038@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 24ca4ee2802fb..3399dcdd526c6 100644
--- a/arch/x86/pci/intel_mid_pci.c
+++ b/arch/x86/pci/intel_mid_pci.c
@@ -223,9 +223,9 @@ static int intel_mid_pci_irq_enable(struct pci_dev *dev)
 		return 0;
 
 	ret = pci_read_config_byte(dev, PCI_INTERRUPT_LINE, &gsi);
-	if (ret < 0) {
+	if (ret) {
 		dev_warn(&dev->dev, "Failed to read interrupt line: %d\n", ret);
-		return ret;
+		return pcibios_err_to_errno(ret);
 	}
 
 	switch (intel_mid_identify_cpu()) {
-- 
2.43.0



