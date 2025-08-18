Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8744E322DB1;
	Mon, 18 Aug 2025 14:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526111; cv=none; b=Tm6V10Gn/pyBR28afsKgs4L8LmJP6PfpMzKgQRtpJcnIn8W8Q+kweJOq5fqE3QSrW/C594rd1WKTLLivrU2YCcEiuXBc+fKCxcW9YTyQmSqdOqNOgxrYnmIU7DTBbeFzg8FNpTYZUD9LBJrDPXSl7gH3ZzX6ZlOdMQ4AUlk0y0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526111; c=relaxed/simple;
	bh=tRXIIvS5ewBfz5Xd1QvFYstojrk//nuqlZpramjux8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QVCDxIAR4rZa+hHeRrWTDCkmATBIhqSyBi1SFIx9oh7WgmKNWhoBUwdtcTgDkFK26cgNSI2oiqd+xZQnyuIG7LsN2v2VWlMNs7197fSRI8gbAznlJaOw56ozxMXcFOHfvwQbZVwGCPQLvU53aWBe6/fMv5MskvjD5qJvg4OhVXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1vpvT5hH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1vpvT5hH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB675C4CEEB;
	Mon, 18 Aug 2025 14:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526111;
	bh=tRXIIvS5ewBfz5Xd1QvFYstojrk//nuqlZpramjux8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1vpvT5hHHuHOl7+UD1Gr9yTOh/uY7o4GmpgDRZ175V9myv6B1ny5JkTc9RhgkgU4C
	 PQS1YC5Gklu152qY+iuRrPE5ZY0HzcTUELQ3KHS0KjoFlqO7NPFuZctkH3yFIkXCkm
	 EvFggo7VkACY1F/wj7+lRV+WvLQyJMbz1uC5TQ5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 462/570] ASoC: Intel: avs: Fix uninitialized pointer error in probe()
Date: Mon, 18 Aug 2025 14:47:29 +0200
Message-ID: <20250818124523.661856463@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index ec1b3f55cb5c..d45e9279df27 100644
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



