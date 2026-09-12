Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54F1274B46;
	Sat, 12 Sep 2026 18:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237595; cv=none; b=bnvV1DgJv3sWAqVt8JtJrzopwPdh/ZE+Q/yd84rk0L9xnBsYOro5hl5KVSkx/ezpCwBqC58Ufi81k4CESMU4xlukMdhQkxEDUFyHHuPIY/kxxETnyl9061SBuQGxqeu8ZACJeb7TF6NWSj31kxe2jzKHwX8e539Pq6oCHHvNrq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237595; c=relaxed/simple;
	bh=iAJKeA7vJqgnujsZV3tlB8w/6UHy5pEucaA/d3bbS/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFNXuhHyGanSobMFJlnjNh4rP9MApYivb/jH6T2rysbVX0cANJ73IiT5Tqa/HCphZF8YRLDCFL8DhIMKm13m9BgjSmAg0Kz2wJmGpfrx+Q8dq4gcouFF+RwCFOyo3wsaJH6i/zBIHlilcoHhjPHk9l+NRhVCftFlK/tkaLMB/l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PdW6rOUZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PdW6rOUZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA88F1F000FF;
	Sat, 12 Sep 2026 18:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237594;
	bh=L5RlVYoCYKkq2e/U3gmg7cyEcdX/IZj43mEwQj68rxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PdW6rOUZyL/xTCrhF5kc8Zf7A1XUvJttipWh3W+A4YmaM2npcA8S+kg3GmWBgfaZb
	 x/z2NggP5J7kKd5HWWW6GP4tej0MaSa1TIMWcmXtGknESSXYPZs0lLVyhQogJPeHv2
	 ogoonQJUhmHQYrCtXXvfyXrjWRlbhu9QbfUanpWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 289/935] AsoC: intel: sst: fix PCI device reference leak on probe failure
Date: Sat, 12 Sep 2026 08:55:19 +0200
Message-ID: <20260912065533.441462858@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -141,13 +141,15 @@ static int intel_sst_probe(struct pci_de
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


