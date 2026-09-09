Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C372B5678E0;
	Wed,  9 Sep 2026 13:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962256; cv=none; b=pmtmgcfVjIPAkQQ3LBokt4oNQCwKA72/wPR1TJgeRKebfl3N0OykcyNpdRDtdbQgHD68XAq6fnuu7S8lSIifIwWopcunSPAOVuT44EnH1fKDMHhDg3tGfA413dd4b6e1qyNM2zb8YcxBSBRHfFOMbgQ9M4EOqht2oex+EhX8Bkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962256; c=relaxed/simple;
	bh=lrA4MsJjyjHLXfBdOknT9br914Ke1JKBXwZA6TysuY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TW7TUDm/+u0pP67LImj8oxMaTYudIKoLAL+ipjpvuq8QgxG4GGAkMX6qS6d8uja9XJS3GA+yucmJf5BfqVEW7QAVwKFklNW9BTSHaI0TzCjgGZhrnaiZQYX8S+wBmqWIKxhMNQUghzeD1M7ffgdcdMixG1p4l2UUJOhzTURjECI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wyoSPAdA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wyoSPAdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F3D1F00A3A;
	Wed,  9 Sep 2026 13:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962254;
	bh=5CG1xklYLUxMMJkv/4FsCT7/K4EfZ+fBc6FtbEbjypM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wyoSPAdAnel/2nAQWimhf68GVNk0e983QA1wEKp60g8fWLiZKKbJpytii488YVjzN
	 EbAI3WT7Fwp8yR28fo//ON6cugHWzxkuC/37elxEquI8ufdG1cevQCmEYxpsKtRvZv
	 bCufJ0j+TL0FLfqKaM3nfLhrywdnvWjZJDA8YUNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 228/556] AsoC: intel: sst: fix PCI device reference leak on probe failure
Date: Wed,  9 Sep 2026 15:38:28 +0200
Message-ID: <20260909134238.431192584@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


