Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD392C21E3;
	Tue, 12 Aug 2025 18:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024635; cv=none; b=MW0H69hMG6LRoRyPlfe8KsyWPeD9E51K3vk78AAs/QwuvSnWwDxjsbTJYw6p0ALQ+ru2a3Is+NCxi6OuoisIdS4ulYvV1+IOyyfabgV4X5A5zcNYnVCGjYWlyP/IP95KAj90nC8pbtVXlSR70ccBdtO1NoiEmtoF0qKM77hvqEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024635; c=relaxed/simple;
	bh=Xa29d9ymu0rsuNZiREMKMFysm61xcdP/ZQU2l4n9d+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LwJQm66VwesKuA96eaaUnW/0RNySH+0/HWByU5LjFIBjGaubijhuIkPRAoGZYxJbOOAFuuRn+xFVNk0NINOqZWiYeRH1W4m6NIgtlxhgT0XrHNdobPalMZrPCy0mQZ/Y+BJ5k8wsBIYM6S2mQisx6tfEh2qPPo/oSU2oIO15Jgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ngBShAZF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ngBShAZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA6FC4CEF1;
	Tue, 12 Aug 2025 18:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024635;
	bh=Xa29d9ymu0rsuNZiREMKMFysm61xcdP/ZQU2l4n9d+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ngBShAZFaK/SysM7VWhvtqxxewsE3fbbRorhSRP/zQDwOn9dDthIXEmVYf8rAaqVX
	 dr+7GA0pscN2c82cOUJxqa5JXN5IrqHNe2ob8Yl+S7n3pY2Bexr1pK1HcEMqPY8Umr
	 TnJwGXOZLa18LRrLhIpLyUcpMO2FPy1RlXwHtDmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 432/627] drm/xe/configfs: Fix pci_dev reference leak
Date: Tue, 12 Aug 2025 19:32:07 +0200
Message-ID: <20250812173435.711202890@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit 942ac8da6388c25fe62b2792c78715e0ea6e649b ]

We are using pci_get_domain_bus_and_slot() function to verify if
the given config directory name matches any existing PCI device,
but we missed to call matching pci_dev_put() to release reference.

While around, also change error code in case of no device match,
to make it more specific than generic formatting error.

Fixes: 16280ded45fb ("drm/xe: Add configfs to enable survivability mode")
Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Link: https://lore.kernel.org/r/20250722141059.30707-2-michal.wajdeczko@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 0bdd05c2a82bbf2419415d012fd4f5faeca7f1af)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_configfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_configfs.c b/drivers/gpu/drm/xe/xe_configfs.c
index cb9f175c89a1..9a2b96b111ef 100644
--- a/drivers/gpu/drm/xe/xe_configfs.c
+++ b/drivers/gpu/drm/xe/xe_configfs.c
@@ -133,7 +133,8 @@ static struct config_group *xe_config_make_device_group(struct config_group *gro
 
 	pdev = pci_get_domain_bus_and_slot(domain, bus, PCI_DEVFN(slot, function));
 	if (!pdev)
-		return ERR_PTR(-EINVAL);
+		return ERR_PTR(-ENODEV);
+	pci_dev_put(pdev);
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev)
-- 
2.39.5



