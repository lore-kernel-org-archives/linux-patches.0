Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539B347A0A7;
	Sat, 12 Sep 2026 11:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213495; cv=none; b=lorL/MOowAGL0e5rrN6qBuaySlbpbQ/2NinQCcSjMEEA3LYKBJ2yi+C88Wv1W/h/lcjX5F/g7WSCw4H10cPO02iA8myrvXTpEmquSS+/8X+64GYR0zvOYbSf4JOa3UkUH4wW+SIJQC8zBd0NPNc6lSPNjJsXZBnEEzEFDDVLyAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213495; c=relaxed/simple;
	bh=0Y8FxG3WB/O2SvY3HzfhYlx3KpWXs2a//ZgK0LcgR2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3mmKMetWtJCNIQx/DaCGlFHK7tyW/p9KB6joywvUNalMAHmZLgFEB2gv9Mg8+4K+1Rc++RcSX/YO5btB9W25W1YqpZWLYdT/rhnjmZwocYG7DVAl7q5AI4B8QjHQTIxrqd9kmRWY8vwUZnAQeYLTNdjtRhdQSl8+BB1RPmQLhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pegANyLk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pegANyLk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26C51F000FF;
	Sat, 12 Sep 2026 11:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213494;
	bh=Zi6JwMkufawtcs+CpxX/vygc9cV/eODhbYh2zlbh0Cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pegANyLkcfR09JW1nuFU7MLGpHh1Ddq6Un840lbvul7+QWhcprd/WaDCkLyE59e0y
	 1U7U9iHZR38pi+P8tGoR52/yiGrUlO4QbIwwvROaOOAHGT/MidtaxDRVjgdNLKjt+l
	 kgyHj1Ii0MKUrNxSIrDJbrZNUJoT8JwMomSeJiB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 0131/1376] AsoC: intel: sst: fix PCI device reference leak on probe failure
Date: Sat, 12 Sep 2026 08:42:37 +0200
Message-ID: <20260912065610.475649851@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -140,13 +140,15 @@ static int intel_sst_probe(struct pci_de
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


