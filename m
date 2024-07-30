Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B2E1BA878;
	Tue, 30 Jul 2024 15:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355085; cv=none; b=V71iZPsOnQliDf9jnKdWGcCQH2zXKcFYEktYop10/oJo4tnSSuiOvoZ5cRVXwQDAouDuT4UOOpJK/yw9Pxcdwi49gOaPhEVvsHcmqTc3jO1SnVlub5DBT45PxU0RQRF75WxNuraAxHyzYnhF91vqyvOH1vEtIf8rk5P3GL98jr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355085; c=relaxed/simple;
	bh=59MRUePm4TqHZ6mYR+1fAB0XUnRk1K7haHK2+4vE0yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=snDterO3K6FuNrUiL3Ya/ihuEetmWx/D2YEddrSMgD+jFl14Ys23t6Z7gTUqZ+gRqsYNA2oFZS+nBu5DTHiS/il9n0YrviEEhaYPrSvuRuy9Fon/F8rcfddXw/e6IYnrjBtO1muSGUzwcS1AixAPJ9DEahJH2uOpSQaumjZCO3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=leAClG7H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="leAClG7H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1980C32782;
	Tue, 30 Jul 2024 15:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355085;
	bh=59MRUePm4TqHZ6mYR+1fAB0XUnRk1K7haHK2+4vE0yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=leAClG7HTcIinwUODojJ+APXGrq0djtUEORBxiFYqQ1FDPmXt5F+5QblObfEB4LKI
	 ULJGdILiPqrWoxIOARpVaLIyDYmOdnulmmO4DpEgBoBcyGacIp1hrIpipGZshrFOo3
	 dzomyjvlW8MShdGESAOYh2q/UQSLBc8aPpgqLez0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 018/809] x86/of: Return consistent error type from x86_of_pci_irq_enable()
Date: Tue, 30 Jul 2024 17:38:14 +0200
Message-ID: <20240730151725.379563896@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit ec0b4c4d45cf7cf9a6c9626a494a89cb1ae7c645 ]

x86_of_pci_irq_enable() returns PCIBIOS_* code received from
pci_read_config_byte() directly and also -EINVAL which are not
compatible error types. x86_of_pci_irq_enable() is used as
(*pcibios_enable_irq) function which should not return PCIBIOS_* codes.

Convert the PCIBIOS_* return code from pci_read_config_byte() into
normal errno using pcibios_err_to_errno().

Fixes: 96e0a0797eba ("x86: dtb: Add support for PCI devices backed by dtb nodes")
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20240527125538.13620-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/devicetree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 8e3c53b4d070e..64280879c68c0 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -83,7 +83,7 @@ static int x86_of_pci_irq_enable(struct pci_dev *dev)
 
 	ret = pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
 	if (ret)
-		return ret;
+		return pcibios_err_to_errno(ret);
 	if (!pin)
 		return 0;
 
-- 
2.43.0



