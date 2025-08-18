Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821CA28399;
	Mon, 18 Aug 2025 13:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522648; cv=none; b=WiUBw4qvsgu9Rgh7Dc9lsfrCEHnDc7c5AWDmJZJrNrckOgLXzw8gmw95LwmroZ53w4RX256eKFjSDZK8q6iivOXWPr07d3KeUjr9yf6rfzVBca7GFF8OQPV73CNbgyRPRJwgjNX7Pu1IkoQT7TmJVlEFzux5yXR/a4IPF0BYAGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522648; c=relaxed/simple;
	bh=/flobvYht8fc3lH8TAZFa3fKG3qI6otwHwYcVHR5zfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gUxD37ucqkeQJhrebAQ2RaUEVibNpI/mKrqk3Kei7FqQ5R4YhlsPZMVJnzBnrAQf1vWqHcJz3r6KlqJ2RX2eIMKrD/9rmtANSMqO8i2Psrjru164uVw6Z2tBipQcjE0u7dBC737D/aOqEL6wm2fjVOak47NBR+KP3fWSGQm+E7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QUdgaYUB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QUdgaYUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26DCC4CEEB;
	Mon, 18 Aug 2025 13:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522648;
	bh=/flobvYht8fc3lH8TAZFa3fKG3qI6otwHwYcVHR5zfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QUdgaYUBooffjt+9nsdM87QsssUD4XIbKGJ7MnUmrwgyYF2iiY9JhwUojTz3Xolob
	 ZG3289ley8n6yVMYosGgPCMf0J8FxRuBdSimAeL3QS24RNeoINM3+kyMzTfzycH3o6
	 VMPhArzH9d6ssoZSjBi50jTpA+bt08hKcfSyB7xE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 361/444] ASoC: Intel: avs: Fix uninitialized pointer error in probe()
Date: Mon, 18 Aug 2025 14:46:27 +0200
Message-ID: <20250818124502.443333707@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 82839d0994ee..80b526554bbf 100644
--- a/sound/soc/intel/avs/core.c
+++ b/sound/soc/intel/avs/core.c
@@ -439,6 +439,8 @@ static int avs_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	adev = devm_kzalloc(dev, sizeof(*adev), GFP_KERNEL);
 	if (!adev)
 		return -ENOMEM;
+	bus = &adev->base.core;
+
 	ret = avs_bus_init(adev, pci, id);
 	if (ret < 0) {
 		dev_err(dev, "failed to init avs bus: %d\n", ret);
@@ -449,7 +451,6 @@ static int avs_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	if (ret < 0)
 		return ret;
 
-	bus = &adev->base.core;
 	bus->addr = pci_resource_start(pci, 0);
 	bus->remap_addr = pci_ioremap_bar(pci, 0);
 	if (!bus->remap_addr) {
-- 
2.39.5



