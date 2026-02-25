Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB84C18B0A;
	Wed, 25 Feb 2026 01:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983282; cv=none; b=b2nN+91beJrh2o2BR5BXl/8Z3jKTBV9Va7ts1vp3CqBQsGYoJ2CmPgnEH+eEyIwnhWqWQblSpKmmc/5vk3Pb4pTOyCdJCA/QqwQZ+gbrNGjRFXNSIGeSmxxfI2zYRXCBzdJ0s7rcX4nZ5WjeZURkTClywlcWRPLiG7gy6olx5Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983282; c=relaxed/simple;
	bh=gUcfE9QGTc31Y7Lw3OFI4W1PwI6Z9Mo7HpMgWazU4UA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rADIgVhLx6vBeIF16rnN/TA7c0ErOyZoBTUYC0+lqW+W4FlaoAZ004prHtjdYZYDMM+/1MztY5I0Gk1Lq7KrZGzPNj213i08zDMRKJGh1YNdBOT6jW0Zvvxy764Fu/Vbpq9RdEaaisQotBaoSXzFMg7LV6s/xBFyaoVc/TJdnLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E8+0Yp2U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E8+0Yp2U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B831C116D0;
	Wed, 25 Feb 2026 01:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983282;
	bh=gUcfE9QGTc31Y7Lw3OFI4W1PwI6Z9Mo7HpMgWazU4UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E8+0Yp2UHlCwQ43L8QdPkp7vP2QbxkvaRVzsLKOvifd6OhvfStjGt4cQ1XtSMcbO9
	 l5lMFp7Jd9QM0RL9yaYG5P5RjXNqQPy1Dvf2qpstUSSmM6wwIV+nOXKBi2PwuZAiR6
	 oOqSzee9ZomLxeb/pG7HuO2MN7KnZu9pJ0FyEWf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 420/781] PCI: rzg3s-host: Fix device node reference leak in rzg3s_pcie_host_parse_port()
Date: Tue, 24 Feb 2026 17:18:49 -0800
Message-ID: <20260225012410.000182219@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit e43e2aa557040bbcc5de0eaa1c59ee3ae9e31793 ]

In rzg3s_pcie_host_parse_port(), of_get_next_child() returns a device node
with an incremented reference count that must be released with
of_node_put(). The current code fails to call of_node_put() which causes a
reference leak.

Use the __free(device_node) attribute to ensure automatic cleanup when the
variable goes out of scope.

Fixes: 7ef502fb35b2 ("PCI: Add Renesas RZ/G3S host controller driver")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Acked-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20260204-rzg3s-v1-1-142bc81c3312@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rzg3s-host.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pcie-rzg3s-host.c b/drivers/pci/controller/pcie-rzg3s-host.c
index ae6d9c7dc2c12..1bea8360f8944 100644
--- a/drivers/pci/controller/pcie-rzg3s-host.c
+++ b/drivers/pci/controller/pcie-rzg3s-host.c
@@ -1143,7 +1143,8 @@ static int rzg3s_pcie_resets_prepare_and_get(struct rzg3s_pcie_host *host)
 
 static int rzg3s_pcie_host_parse_port(struct rzg3s_pcie_host *host)
 {
-	struct device_node *of_port = of_get_next_child(host->dev->of_node, NULL);
+	struct device_node *of_port __free(device_node) =
+		of_get_next_child(host->dev->of_node, NULL);
 	struct rzg3s_pcie_port *port = &host->port;
 	int ret;
 
-- 
2.51.0



