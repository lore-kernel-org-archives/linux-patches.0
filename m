Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FFB36A033;
	Wed, 30 Sep 2026 17:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791046; cv=none; b=FpJ1ZaBg0Qx9bCyoFP+napygpJEsWSgFWMWD8ZMTpahidMfFbw8qJ63s0k1ecai+a8/SBxNIULcxwVWEU3dJ/sdExWCSY9ef3Tlje6Vc/XaRIrMPK3oUXNA5PsQ+Vr43fi7eT24uS7Ck8rKiKjWpS62pXMdAaE0vrAVo8WwYiGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791046; c=relaxed/simple;
	bh=f80vtidarC0ANpZLaU6kz7IGpD/ixpwD/+F64v1deBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TfVMe0/VASbEu29PXwbyvgF42UltyE2H9VZfXx9WPxunWGS7kd0S7pBhJhneZKl2MwRSLDRknxUGIbd2gByylm8uOfPxusj+CPUX4i22aGLrNsd5vySErqYEAFAJTimDnx/nfBNGKkZHc8ty2SzWQ4g4aPCDo1irBvU+sGfPFnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YPS2a8vN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YPS2a8vN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E741F000FF;
	Wed, 30 Sep 2026 17:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791045;
	bh=GMVuUlUgEQpTBdYiEBroOQ1g1eaSSi6iO9hId012vBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YPS2a8vNAa/W+aLX92rtBz/UjWkXaPUv0uhE4+C9fgz0PAhR0G3lJ0WYQkISnYQJe
	 TEfRVETRCkELf5WdJHqwsklUnzlADYvGObQy5mww7cp2v+cthS2JAwfzI/3jaYWOvr
	 bam3UL1Gx3eJjjbgyB6maaiHB+NUF4GrKBmNYG9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 164/752] PCI: altera: Protect root bus removal with rescan lock
Date: Wed, 30 Sep 2026 17:20:34 +0200
Message-ID: <20260930152401.748477439@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

From: Hans Zhang <18255117159@163.com>

[ Upstream commit a8759c8ac48c0419f5899e95a6ffc611b07c965b ]

Hold the pci_rescan_remove_lock lock while stopping and removing a root bus
to avoid racing with concurrent rescan or hotplug operations triggered via
sysfs.  Such races may lead to use-after-free issues or system crashes.

Signed-off-by: Hans Zhang <18255117159@163.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260521161822.132996-4-18255117159@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-altera.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/pcie-altera.c b/drivers/pci/controller/pcie-altera.c
index 60a51eba0e265..f83b808da192e 100644
--- a/drivers/pci/controller/pcie-altera.c
+++ b/drivers/pci/controller/pcie-altera.c
@@ -835,8 +835,10 @@ static int altera_pcie_remove(struct platform_device *pdev)
 	struct altera_pcie *pcie = platform_get_drvdata(pdev);
 	struct pci_host_bridge *bridge = pci_host_bridge_from_priv(pcie);
 
+	pci_lock_rescan_remove();
 	pci_stop_root_bus(bridge->bus);
 	pci_remove_root_bus(bridge->bus);
+	pci_unlock_rescan_remove();
 	altera_pcie_irq_teardown(pcie);
 
 	return 0;
-- 
2.53.0



