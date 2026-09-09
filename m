Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85AD583ACA;
	Wed,  9 Sep 2026 14:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963700; cv=none; b=ag0Pkh0SsQtbV8PUUIsk/jXMrs0K6AU2D5gwa+LD+trjLojMNko1dLBTd2RwarcMEcl5wzz7O6KFfnifzl3PfreLQZ8suvDzT7228kLSsEV5R9Z/6OKIh0AeDuNM4ZplUKgqFKJ1/9PryYt0tZ7sw6eF7TUshbaCBei79u9fGJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963700; c=relaxed/simple;
	bh=wuOnV7xTe/qHTQSY+MZoci/z+z4t//2HKgFqmIH/IjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G1f7hNibcqwuNf194SGcJ34XvHpMLrPif/o2XPURYvdx+8uIpP7qfb7Kj/aQQWBMzb0NUSl/vG+/FMUxM9iHhx9IKvhHZP/v3fnE+4AslbLHjWIs17/bODkuvFeJbKvhMuKCETb9Tg36LJJly/P7MuXcdEtkwgVrt1PfvvuLxx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SuBV45rj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SuBV45rj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36031F00A3A;
	Wed,  9 Sep 2026 14:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963699;
	bh=gFCkY/dOfZPY+t395iQ/HxyKhJ6+eUWYx+v4dSQDZL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SuBV45rjtk6SuRKdL7TBfYMoUZE4dEL0gYrHD+NCCyjsqIOadjU3hDH6G6YhCpXys
	 WHo0tvdsYQJQcirfPnxBFrwnIiwyXlfxWrDHSdVmi381ac24+7B16qWctg/eyZ8S+7
	 yP9zZCsg9s1mhqq5m6egDX9nJpc9scuARSx4LoCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 166/583] AsoC: intel: sst: fix PCI device reference leak on probe failure
Date: Wed,  9 Sep 2026 15:37:31 +0200
Message-ID: <20260909134243.951842268@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 016f29997ebd29d6ab59c8162ce0e7f73bd1e517 upstream.

intel_sst_probe() takes a reference to the PCI device with pci_dev_get().
If sst_platform_get_resources() fails afterwards, the probe error path
cleans up the driver context but does not drop the PCI device reference.

Add a pci_dev_put() error path for failures after pci_dev_get().

Fixes: f533a035e4da ("ASoC: Intel: mrfld - create separate module for pci part")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Link: https://patch.msgid.link/20260622091620.897478-1-haoxiang_li2024@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/atom/sst/sst_pci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/soc/intel/atom/sst/sst_pci.c
+++ b/sound/soc/intel/atom/sst/sst_pci.c
@@ -130,13 +130,15 @@ static int intel_sst_probe(struct pci_de
 	sst_drv_ctx->pci = pci_dev_get(pci);
 	ret = sst_platform_get_resources(sst_drv_ctx);
 	if (ret < 0)
-		goto do_free_drv_ctx;
+		goto do_put_pci;
 
 	pci_set_drvdata(pci, sst_drv_ctx);
 	sst_configure_runtime_pm(sst_drv_ctx);
 
 	return ret;
 
+do_put_pci:
+	pci_dev_put(sst_drv_ctx->pci);
 do_free_drv_ctx:
 	sst_context_cleanup(sst_drv_ctx);
 	dev_err(sst_drv_ctx->dev, "Probe failed with %d\n", ret);


