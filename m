Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7DE364EA6;
	Tue, 16 Dec 2025 12:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887002; cv=none; b=qVWO0vgs3tE0/M6ySWRnHMXTiN8YNABtwtSCo0lOD8Od8E5tcF2RI5pvXsjQ9PX0uP7bGExWvjKyYkkUUgIjDGqNaNxk7WHU6ABnExxlhQ5jSSc/N2hnE/frGEcNJcLbcpSnRtD3uHVnrq5RnkQKNJ7P88R+WEwdQTO95GsTpb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887002; c=relaxed/simple;
	bh=UZ34C9PkORKS2ff3c6K6tDTg3CnUihwG+Kp7EEUefsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ayULXGo0HhQnZC/t8OFUX7zjcGiKnqXai2uubh73Tgk9/LndNTQ6QyE1bZ07O9WsY6XpuyFOrbx4FmULjYz9r5fvpSyo8PE8qRCYVnyaAnW02oc8UppRmim8+3JplZRbMjYxHocZIJl+VdUe11IuQtcVdx2NVRIwFjz1lrQ2aZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DOEE0eIT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DOEE0eIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F18EC4CEF1;
	Tue, 16 Dec 2025 12:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887002;
	bh=UZ34C9PkORKS2ff3c6K6tDTg3CnUihwG+Kp7EEUefsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DOEE0eIThcTPOgHCPvLyrP0c5VBl+bEd/PckxrRGOvSbfCH4rHw2lU89qf8pI8Kpe
	 Gica4orwSqErhWYOW+jDOoWrR+WLGZGRakgsFLIxXMJRkucNeYDDZTBu0OhgcyAAbD
	 SPhulVbbJkKaGmqRSxWCWcfs3uBYPK9S7UsSJWE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Chen Wang <unicorn_wang@outlook.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 064/614] PCI: sg2042: Fix a reference count issue in sg2042_pcie_remove()
Date: Tue, 16 Dec 2025 12:07:11 +0100
Message-ID: <20251216111403.632111025@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 932ec9dff6da40382ee63049a11a6ff047bdc259 ]

devm_pm_runtime_enable() is used in the probe, so pm_runtime_disable()
should not be called explicitly in the remove function.

Fixes: 1c72774df028 ("PCI: sg2042: Add Sophgo SG2042 PCIe driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Tested-by: Chen Wang <unicorn_wang@outlook.com> # on Pioneerbox.
Acked-by: Chen Wang <unicorn_wang@outlook.com>
Link: https://patch.msgid.link/242eca0ff6601de7966a53706e9950fbcb10aac8.1759169586.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/cadence/pcie-sg2042.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/pci/controller/cadence/pcie-sg2042.c b/drivers/pci/controller/cadence/pcie-sg2042.c
index a077b28d48949..0c50c74d03eeb 100644
--- a/drivers/pci/controller/cadence/pcie-sg2042.c
+++ b/drivers/pci/controller/cadence/pcie-sg2042.c
@@ -74,15 +74,12 @@ static int sg2042_pcie_probe(struct platform_device *pdev)
 static void sg2042_pcie_remove(struct platform_device *pdev)
 {
 	struct cdns_pcie *pcie = platform_get_drvdata(pdev);
-	struct device *dev = &pdev->dev;
 	struct cdns_pcie_rc *rc;
 
 	rc = container_of(pcie, struct cdns_pcie_rc, pcie);
 	cdns_pcie_host_disable(rc);
 
 	cdns_pcie_disable_phy(pcie);
-
-	pm_runtime_disable(dev);
 }
 
 static int sg2042_pcie_suspend_noirq(struct device *dev)
-- 
2.51.0



