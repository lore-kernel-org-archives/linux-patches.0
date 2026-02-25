Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171A418DB2A;
	Wed, 25 Feb 2026 01:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983246; cv=none; b=Mi/I2XbWcKrtj/qVGREkd/VJeqD3au8DMQqgISs1idLssfkSszp96ECNuFFl3nZYK8Vp268b+k8VmDA8GD/nQ+vA5MNPVtdnHYmyqzfvPTKwrrxnmr9sZcYgCfQoNqhEDA+nXeAVenpkRXHbOIJRK1bj6IjCr94QE/1XLJrHDYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983246; c=relaxed/simple;
	bh=ZKQ8ZkFx6FutijuCxO5gCogGqRju2X5DjbJVa3/VMZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVRKV64XlRLXy3Caag4gFBsB+gtL/kRaWpJPsRW/LKmwxB+qdDtrc6/+CUPLaCSTDXzvmRkSpzTlNAGbiohbGHzWCECs6ugc99xn59B7JiPUfG2pUaA35pLa03d2btV4VTLJmen6jKmKDE7+ifX6pJoi+VBXSbaOLgiQmvFnzq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aM1elSZP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aM1elSZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCBD3C116D0;
	Wed, 25 Feb 2026 01:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983246;
	bh=ZKQ8ZkFx6FutijuCxO5gCogGqRju2X5DjbJVa3/VMZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aM1elSZP8KytUcXiEoozemeVlgDGrnKH+ymRETrGK6YR0C+NI85jP0EaOFDzEGTF7
	 Vvbmw0yfZjzsdr4US+xefR4rfh+j1RD9IyeSlM0DWKC6Koo4RRbJjkYucL/WcTKJP9
	 E45DfOPte4QnVzlzbz/uyIztkTSpeBblPj+8J1EY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 386/781] PCI: s32g: Skip Root Port removal during success
Date: Tue, 24 Feb 2026 17:18:15 -0800
Message-ID: <20260225012409.164505206@linuxfoundation.org>
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

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit b79e0875fe8144fcb09e4fc1cf386cb3b2262480 ]

Currently, s32g_pcie_parse_ports() exercises the 'err_port' path even
during the success case. This results in ports getting deleted after
successful parsing of Root Ports.

Hence, skip the removal of Root Ports during success.

Fixes: 5cbc7d3e316e ("PCI: s32g: Add NXP S32G PCIe controller driver (RC)")
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
[mani: reworded subject and description]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20260202151050.1446165-1-vincent.guittot@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-nxp-s32g.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-nxp-s32g.c b/drivers/pci/controller/dwc/pcie-nxp-s32g.c
index 47745749f75c3..b3ec38099fa38 100644
--- a/drivers/pci/controller/dwc/pcie-nxp-s32g.c
+++ b/drivers/pci/controller/dwc/pcie-nxp-s32g.c
@@ -282,12 +282,12 @@ static int s32g_pcie_parse_ports(struct device *dev, struct s32g_pcie *s32g_pp)
 
 		ret = s32g_pcie_parse_port(s32g_pp, of_port);
 		if (ret)
-			goto err_port;
+			break;
 	}
 
-err_port:
-	list_for_each_entry_safe(port, tmp, &s32g_pp->ports, list)
-		list_del(&port->list);
+	if (ret)
+		list_for_each_entry_safe(port, tmp, &s32g_pp->ports, list)
+			list_del(&port->list);
 
 	return ret;
 }
-- 
2.51.0



