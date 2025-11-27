Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E848A29993F;
	Thu, 27 Nov 2025 14:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764254969; cv=none; b=bQHB6yIh73f475nT5EB78IRcQcMzS392+S3pxVs18PkJu8ueuDH+A0aC/OGasJnQMAT3P7PIKXJdUSmicVHYEuMzHAkPjhs95dFv5JJjNIp4EkpCu4Ib70/AXgtCHIucWsxxzBMPeZblxEw3yguTNc1mpY6YfTEm/9SxjCeerOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764254969; c=relaxed/simple;
	bh=PMmJylXFB6BD1q/K6ChqrWlXfrkXL3dV7S9SquBabl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NsivqInUzYrQTALg3xawJqDI9sVwim1/L7oR+CFUWj3PpEEBTsjiOHSWLfPTShC0z3U8n9WHCn3GMjCPLbabit9cC/POk9eElifoObXkLO1ilIvgihaKF5JQsA7Xl3R7QB73f5NtSxAOszsV55nz5YA81e/fnGOVRwvrC7HeJ+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ILmc2QqQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ILmc2QqQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75001C113D0;
	Thu, 27 Nov 2025 14:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764254968;
	bh=PMmJylXFB6BD1q/K6ChqrWlXfrkXL3dV7S9SquBabl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILmc2QqQxweclqJc/FXcYv8x54GSS6uWNVlOj56LvnOWBFS4uKZbSfWl8yrG4jKj5
	 eXBz6PcqFgX5ub4crgsh0RDveKC0xh0QR0z/zUeC9gv14jbrpM5oAzwlZqQaGULtzL
	 8UzOKiNuAwz633xbooK52KODNFghKezEie0foMZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 48/86] platform/x86/intel/speed_select_if: Convert PCIBIOS_* return codes to errnos
Date: Thu, 27 Nov 2025 15:46:04 +0100
Message-ID: <20251127144029.585565490@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit d8bb447efc5622577994287dc77c684fa8840b30 ]

isst_if_probe() uses pci_read_config_dword() that returns PCIBIOS_*
codes. The return code is returned from the probe function as is but
probe functions should return normal errnos. A proper implementation
can be found in drivers/leds/leds-ss4200.c.

Convert PCIBIOS_* return codes using pcibios_err_to_errno() into
normal errno before returning.

Fixes: d3a23584294c ("platform/x86: ISST: Add Intel Speed Select mmio interface")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20251117033354.132-1-vulab@iscas.ac.cn
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/speed_select_if/isst_if_mmio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel/speed_select_if/isst_if_mmio.c b/drivers/platform/x86/intel/speed_select_if/isst_if_mmio.c
index ff49025ec0856..bb38e5f021a80 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_if_mmio.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_if_mmio.c
@@ -106,11 +106,11 @@ static int isst_if_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	ret = pci_read_config_dword(pdev, 0xD0, &mmio_base);
 	if (ret)
-		return ret;
+		return pcibios_err_to_errno(ret);
 
 	ret = pci_read_config_dword(pdev, 0xFC, &pcu_base);
 	if (ret)
-		return ret;
+		return pcibios_err_to_errno(ret);
 
 	pcu_base &= GENMASK(10, 0);
 	base_addr = (u64)mmio_base << 23 | (u64) pcu_base << 12;
-- 
2.51.0



