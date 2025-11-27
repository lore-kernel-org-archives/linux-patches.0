Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02DD333755;
	Thu, 27 Nov 2025 14:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255278; cv=none; b=o2KYFYkxFitsRaJI0cRoo5z4Msp05ScA/QGS1JbTH2HPa4mIPX5MaNAZKybpTg/D4/wC93hOPWsC4XKvPwMHBps/Hg+Sf8bEKTQ6MOFEBKZFuHEerO860DMUjZd4Dz3BBgsQeZM20pv5IVEdFQBUKKKAxjaspyDqwbh3pSfrvEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255278; c=relaxed/simple;
	bh=C4xecJ3F+n2xr6bFOX3oOFRDDSL5GpYXmsLtdOshKEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LJzVJpNg0fcj9eAZsXCK3Js65rfqQdn6ZRPWzSAJ1h3RZp4FzmHIKp6p3KmNWAqrvzhOgUcIXGYAaxXa6dxA+w1f6pS9JEI/9dbFXNesWlBU12PHAnYppuey6uoIXxSxGJlakn2MIEWrnqWf3o8F0M4g0W4dzYuYk+BnYe8YMkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lEn/bIpb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lEn/bIpb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEADC113D0;
	Thu, 27 Nov 2025 14:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255278;
	bh=C4xecJ3F+n2xr6bFOX3oOFRDDSL5GpYXmsLtdOshKEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lEn/bIpbuSzuwBvSqTYbkzlJuoZO6iltXC5bz/mUfb+PJZFWRVfW4avA0ttLDIwE0
	 hH5HAH4pGhZP3wvYyQ9fQURZfto40rJTDoSYqA7QMY5xPYNKohgRfx/75P7zzDTcof
	 Hy7D2uAzHoVVLLIvta8w+Mid/WmT40rNEVfLUzmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/112] platform/x86/intel/speed_select_if: Convert PCIBIOS_* return codes to errnos
Date: Thu, 27 Nov 2025 15:46:12 +0100
Message-ID: <20251127144035.403740013@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3f4343147dadb..950ede5eab769 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_if_mmio.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_if_mmio.c
@@ -108,11 +108,11 @@ static int isst_if_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
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



