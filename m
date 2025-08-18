Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C9719E82A;
	Mon, 18 Aug 2025 13:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524292; cv=none; b=XArHBZNERP8zsk4OHMXCWEa1huerQ0dA95K0a4AbFjt9g1T7VdXetmbwwSHEQ+Y7n/V5U/VqZDQBb3xeyv4CbKtXI2rUGDGPVgJT6V68vsuwRpPv91a5VeKg7Fs5wkKEvMTtTQOlOYJ2QTgEQRTvairTV+raTyT2RYeVLTpGE3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524292; c=relaxed/simple;
	bh=Cd4RgV+2L3Nhi7dqGlCmJ+w2Ss71CuDYzmr21CzsIYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ym69Nh7UAQTu+fR9oN8M+A21ggKHO8Z7KU+1937yuOgTt+bInZymugOylnU+6L/ejrOTIMBgA+jD++7FE11kmZwEzejN3WPhtZauPYKfki2jY+AVIGaOUy9Wufask7gmsxjwR4RY6t8MLhF20woyvaTm+SBd7wH4KOkVDZH/nkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZV12a7fh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZV12a7fh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8B9C113D0;
	Mon, 18 Aug 2025 13:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524292;
	bh=Cd4RgV+2L3Nhi7dqGlCmJ+w2Ss71CuDYzmr21CzsIYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZV12a7fh+r7VmqUUxFhtOl/qt7cdf1fDp5hbpxaVppiTfEkXXvznWEJhLhVGvpk10
	 2uAoKFK8J0vhqz5ot0MenIicjUlljOJJo99ix/K/4YKOki06Fpuy3bNv1rKdoeJWRN
	 rVvdsivbinEDDUA6Ic076dWe7ru0K4WzaHA9Z4tE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 426/515] ASoC: Intel: avs: Fix uninitialized pointer error in probe()
Date: Mon, 18 Aug 2025 14:46:52 +0200
Message-ID: <20250818124514.821093558@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 11f74f48c14c1f4fe16541900ea5944c42e30ccf ]

If pcim_request_all_regions() fails, error path operates on
uninitialized 'bus' pointer. Found out by Coverity static analyzer.

Reviewed-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20250730124906.351798-1-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/intel/avs/core.c b/sound/soc/intel/avs/core.c
index cbbc656fcc3f..6ef49f10e19f 100644
--- a/sound/soc/intel/avs/core.c
+++ b/sound/soc/intel/avs/core.c
@@ -446,6 +446,8 @@ static int avs_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	adev = devm_kzalloc(dev, sizeof(*adev), GFP_KERNEL);
 	if (!adev)
 		return -ENOMEM;
+	bus = &adev->base.core;
+
 	ret = avs_bus_init(adev, pci, id);
 	if (ret < 0) {
 		dev_err(dev, "failed to init avs bus: %d\n", ret);
@@ -456,7 +458,6 @@ static int avs_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	if (ret < 0)
 		return ret;
 
-	bus = &adev->base.core;
 	bus->addr = pci_resource_start(pci, 0);
 	bus->remap_addr = pci_ioremap_bar(pci, 0);
 	if (!bus->remap_addr) {
-- 
2.39.5



