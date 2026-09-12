Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357B92AD03;
	Sat, 12 Sep 2026 19:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242008; cv=none; b=RDFs/OyUFTXORSx09hPjQ3M8EKGW5utx2zfh4Zsv0lNepfJ5XHDvspSbngL8vJvV6dwYChcDcZc5rwNAa13G6BlmTpovkOjVoS8SphjPiWkYA3EntgxaYUcOzIK8Y4utj2dNCRLwCIiXMW5hgvqUHu3WloBP1TlLnAkxrCxHwnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242008; c=relaxed/simple;
	bh=4Kl/bB4VFvCe+TfCZ1yhvPs5GERgs3FrUNa+omNokko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SAYCPh5rG7X7Umt3lI0oMJ2Q58eV46nNmdZHLiKtVOJsI9MueLd3LmtzfhcQNdRkwbWofOea5Bg9KYWKFYPOR7xC2F0IicQhn0sxxwj7Z5LSNgHxRA41IbFJWIkyRe80yv+Ie1KMFy2jbAyIjnAsxxoU6r+VQIe8nlQOPperIY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kPCjhQ4L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kPCjhQ4L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538B11F000FF;
	Sat, 12 Sep 2026 19:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242007;
	bh=cqP5W4Yv0mq1xnjH6sGo7PcLMFEnuPz5zXUCqaSAGDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kPCjhQ4La69Brp5D0D1wvMYC2DzHDeR4jBZ8PiRfjsO5J59YxbjA1MURXcyBfG7wM
	 C+K84xRGu7Df/4kiEqi6Ksq/zU0r34HOv3tqxFsbpEM4E8J3rOwxpVmMMuCeiRXnnD
	 Re1lj9+yvrOP8zUvfNXK9xZJ5zn4576eP5QvCnpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 254/798] AsoC: intel: sst: fix PCI device reference leak on probe failure
Date: Sat, 12 Sep 2026 08:58:02 +0200
Message-ID: <20260912065522.981440434@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


