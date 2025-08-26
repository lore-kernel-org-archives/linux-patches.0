Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C591917ED;
	Tue, 26 Aug 2025 13:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214685; cv=none; b=L5usPPTs98truxThxukJ+l+Tu6zIzEjmQPSUdiRar2mJbO1bDQo8H2Mwc1P1giT/aVUEQZYpYXv430ngeMgT8Cz7CmhMvxZxCwfTvDOOLqrG27gs1DJpxfFPEfzR4lHinprSBUXgKpHVmYQFd9fDmdZheDvVnlNNZssbUE1ClZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214685; c=relaxed/simple;
	bh=KKpi9HyuXuG7qgJWplfV1YD///ENxRFFVi6yOyebra0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aKYRYwpNgJyzqHZ1SZm5YVH8wEaYwOQARiwcRL8gvRmULp+Au721tB/OmOBM/3kvbI3GcDHLx5D2HJWeAGfh5CEAOU0kSunzkxgwk9gWVmYWw/qg7FTZ6soWE7x98MuZBg+vmV7TWABwSVSpom2Anci6WRPNb9x2aUvh4WifJUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nwRK1TBU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nwRK1TBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C19C4CEF1;
	Tue, 26 Aug 2025 13:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214685;
	bh=KKpi9HyuXuG7qgJWplfV1YD///ENxRFFVi6yOyebra0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nwRK1TBUIcITGPD3u7VA7/qIGW8SbWXn34JiHdaxusIwn6xJDMmw5iY6cBoGwmbxJ
	 eWNxh2Y4gH/TvZyprL9Y6DpePP6UX/Vjc6+1d3g8E4VL29G+LPLx7qdNlv6CX190WS
	 xTD0V092EHDbEohdsBfZX37tS0MHptEC5uBQVwVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 231/482] ASoC: Intel: avs: Fix uninitialized pointer error in probe()
Date: Tue, 26 Aug 2025 13:08:04 +0200
Message-ID: <20250826110936.480588387@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5bb3eee2f783..04d0099adb8f 100644
--- a/sound/soc/intel/avs/core.c
+++ b/sound/soc/intel/avs/core.c
@@ -410,6 +410,8 @@ static int avs_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	adev = devm_kzalloc(dev, sizeof(*adev), GFP_KERNEL);
 	if (!adev)
 		return -ENOMEM;
+	bus = &adev->base.core;
+
 	ret = avs_bus_init(adev, pci, id);
 	if (ret < 0) {
 		dev_err(dev, "failed to init avs bus: %d\n", ret);
@@ -420,7 +422,6 @@ static int avs_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	if (ret < 0)
 		return ret;
 
-	bus = &adev->base.core;
 	bus->addr = pci_resource_start(pci, 0);
 	bus->remap_addr = pci_ioremap_bar(pci, 0);
 	if (!bus->remap_addr) {
-- 
2.39.5



