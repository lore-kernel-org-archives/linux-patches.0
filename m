Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDB8248F6A;
	Tue, 11 Nov 2025 01:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823097; cv=none; b=PrFnicTik5iEC1sBHOJBsoZDdMEzX2TQKiG9Co2zm4L46TBSo8h+PUqhz1p6AyRbjCS53GqtrsYBiKHADoaTZpgQDTR0mT9Y1mX+pwfJkGGmLakLWDH5ezowverDhJrUJwCZ+nu9++3esP7kprCFCqyzbIrVSgpx7Ercd+B5paI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823097; c=relaxed/simple;
	bh=7Lg7DXcTezBWcxxSqKeEVRtggWoEiYikRvM608lQB30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pMUlwvgORGqrwM16IzhSNABYxtee+MSJAMfnohRYS5vt23AlYh4RfFNaGd5ht1ybYDBZnCxVolm5xdt96QLKlWcnogomAFeG2YLH/yJLttBoEBSsN3JGZh8w0eJO84HQk8b31yNHGA+rM09xoeEpvJVzEmFrFgb7/C9J8nosU+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kuRUHuqi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kuRUHuqi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61BCDC4CEFB;
	Tue, 11 Nov 2025 01:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823096;
	bh=7Lg7DXcTezBWcxxSqKeEVRtggWoEiYikRvM608lQB30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kuRUHuqijKcEKcMLb6/5JUPW92D3uTKLstLzKMjgeWeftEo8SmtSpHzk/70v5rmzy
	 6ul3vwIXgq2K0ELWPVUJZmbm6Nv1etIrPWlNGmeTax19ciBeEA0co73vIIrPTzZgWi
	 DBlNCz3gh5YDr7oPRqkMc932gxkIUgsXAmskhd5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 230/849] drm/xe/configfs: Enforce canonical device names
Date: Tue, 11 Nov 2025 09:36:40 +0900
Message-ID: <20251111004542.003013797@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit 400a6da1e967c4f117e4757412df06dcfaea0e6a ]

While we expect config directory names to match PCI device name,
currently we are only scanning provided names for domain, bus,
device and function numbers, without checking their format.
This would pass slightly broken entries like:

  /sys/kernel/config/xe/
  ├── 0000:00:02.0000000000000
  │   └── ...
  ├── 0000:00:02.0x
  │   └── ...
  ├──  0: 0: 2. 0
  │   └── ...
  └── 0:0:2.0
      └── ...

To avoid such mistakes, check if the name provided exactly matches
the canonical PCI device address format, which we recreated from
the parsed BDF data. Also simplify scanf format as it can't really
catch all formatting errors.

Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://lore.kernel.org/r/20250722141059.30707-3-michal.wajdeczko@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_configfs.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_configfs.c b/drivers/gpu/drm/xe/xe_configfs.c
index 58c1f397c68c9..797508cc6eb17 100644
--- a/drivers/gpu/drm/xe/xe_configfs.c
+++ b/drivers/gpu/drm/xe/xe_configfs.c
@@ -259,12 +259,19 @@ static struct config_group *xe_config_make_device_group(struct config_group *gro
 	unsigned int domain, bus, slot, function;
 	struct xe_config_device *dev;
 	struct pci_dev *pdev;
+	char canonical[16];
 	int ret;
 
-	ret = sscanf(name, "%04x:%02x:%02x.%x", &domain, &bus, &slot, &function);
+	ret = sscanf(name, "%x:%x:%x.%x", &domain, &bus, &slot, &function);
 	if (ret != 4)
 		return ERR_PTR(-EINVAL);
 
+	ret = scnprintf(canonical, sizeof(canonical), "%04x:%02x:%02x.%d", domain, bus,
+			PCI_SLOT(PCI_DEVFN(slot, function)),
+			PCI_FUNC(PCI_DEVFN(slot, function)));
+	if (ret != 12 || strcmp(name, canonical))
+		return ERR_PTR(-EINVAL);
+
 	pdev = pci_get_domain_bus_and_slot(domain, bus, PCI_DEVFN(slot, function));
 	if (!pdev)
 		return ERR_PTR(-ENODEV);
-- 
2.51.0



