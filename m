Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0502AB29
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:56:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710CCC433C7;
	Wed, 20 Sep 2023 11:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210971;
	bh=fc4kj3Cd/8xnque4OU3OkMHAQSAH1vexi1BLcpXzVM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l1IWMYtms6w/RkKdCQb7TROSH4t4IZMrDOeSm/pj1PTa0dxa1xE8iIgI6p9KilY58
	 TKdREulrUYwP7C5WgHlbCmtshdcJ5KUhFwhoruXGFW/HBpU6A5lZwwKyCIIfl871yj
	 D9DB7aO0ieHUnVsZoBkWrTkRoP2v6TDMcDf8yunc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 060/139] PCI: dwc: Provide deinit callback for i.MX
Date: Wed, 20 Sep 2023 13:29:54 +0200
Message-ID: <20230920112837.932805948@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
References: <20230920112835.549467415@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

[ Upstream commit fc8b24c28bec19fc0621d108b9ee81ddfdedb25a ]

The i.MX integration for the DesignWare PCI controller has a _host_exit()
operation which undoes everything that the _host_init() operation does but
does not wire this up as the host_deinit callback for the core, or call it
in any path other than suspend. This means that if we ever unwind the
initial probe of the device, for example because it fails, the regulator
core complains that the regulators for the device were left enabled:

imx6q-pcie 33800000.pcie: iATU: unroll T, 4 ob, 4 ib, align 64K, limit 16G
imx6q-pcie 33800000.pcie: Phy link never came up
imx6q-pcie 33800000.pcie: Phy link never came up
imx6q-pcie: probe of 33800000.pcie failed with error -110
------------[ cut here ]------------
WARNING: CPU: 2 PID: 46 at drivers/regulator/core.c:2396 _regulator_put+0x110/0x128

Wire up the callback so that the core can clean up after itself.

Link: https://lore.kernel.org/r/20230731-pci-imx-regulator-cleanup-v2-1-fc8fa5c9893d@kernel.org
Tested-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Reviewed-by: Richard Zhu <hongxing.zhu@nxp.com>
Acked-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-imx6.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/dwc/pci-imx6.c b/drivers/pci/controller/dwc/pci-imx6.c
index 47db2d20568ef..388354a8e31cf 100644
--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -999,6 +999,7 @@ static void imx6_pcie_host_exit(struct dw_pcie_rp *pp)
 
 static const struct dw_pcie_host_ops imx6_pcie_host_ops = {
 	.host_init = imx6_pcie_host_init,
+	.host_deinit = imx6_pcie_host_exit,
 };
 
 static const struct dw_pcie_ops dw_pcie_ops = {
-- 
2.40.1



