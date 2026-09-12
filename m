Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFA03264F5;
	Sat, 12 Sep 2026 13:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221583; cv=none; b=D3xVHx6hsz46v0E+raeCPqhrblaBhOpou1r10krDL5wUp/7aU3D50vtEZkJVI6MHnfvraRUPrsQHuolbS/m2OwUiMJWSIf+H1tlftaglfZdbvTUvtzu8iWv0ZehdMM3dK60J+lvdpZEonDczZ6YfILGuAkb1CG8qaoqjWLo10dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221583; c=relaxed/simple;
	bh=D+eEjWCf/93s90csjhJzsLWR7m4UsurVjBE0R+npW7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4iiPfbFAPXkDIMheUpsOLfyBzekDaDfMcTQyiM4ibrSharqBxKmg6+ZaguW3f6KbMUoFtxof8QfQKpU+hM9EEATVBLMzDg33n5GO1RFYBMQ8g9y0Nz4Ty/LF+axHFzS4tVQvX3v31cTfPzQx45lt7IizhANHEOww75R5GyRxmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SiTGUjpr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SiTGUjpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F200D1F00893;
	Sat, 12 Sep 2026 13:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221577;
	bh=yT7AeVJDbKF9yU2uiNXYRCo0CDcBmIVcYHvFf2+jXc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SiTGUjprjbFbiG4TuGQRQv4ZaJ1AD98WqUXmWyW8lJTOPFaFu1ZhY8COIBNEvP/Vc
	 q/m9bQ/9ypChZTXjBtMz6KRhyBkrePgvSRtDpGO6DA+sEXEb2qq/93j2MQ2UZdDoIk
	 Xzfi2EMCiRGCHdAiSS7N2Mklh1lagAdNTWPx1bDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 0411/1424] AsoC: intel: sst: fix PCI device reference leak on probe failure
Date: Sat, 12 Sep 2026 08:47:23 +0200
Message-ID: <20260912065616.486529877@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


