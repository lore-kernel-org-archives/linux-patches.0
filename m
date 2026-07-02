Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34ED3B774F;
	Thu,  2 Jul 2026 16:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009749; cv=none; b=OvpY8BNDq+8uIrapQ1eudz2fsLDn7atmVrmdQrns/dGOqpWwpwkpLAuRMffx5ty5VZBXIVvlcCAvOQ1GQRoTLWbfip67gu9dfz5aF9tAvRAMAldpX/ABQDT6MZ0VFwiwzSNzObfbW9UPMWMx8feMoCDtCY99cD1OroghsTvSBo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009749; c=relaxed/simple;
	bh=6bRve68fYN634RwoX38/GbUZH6sHbf8HzYvyWQMqu98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rt8pmuvlW/Ya9K0efSgbBpkRGAnzsRus3BO5/ssU40XMw3xq1OuU0hcjZQafuDmsPYNGCLDDGRtjIMhakzIgSLYvQkOkseuv3UjhjzkAn0s7b/JvRD+p9cxaYc5xa03cbm5ekWN0hdEdVa3Rx235lb5oIIxXEd/sTmgKQV9sBJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rozzLrBK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rozzLrBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0457D1F000E9;
	Thu,  2 Jul 2026 16:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009746;
	bh=nuj8OvfkgMpqJFEReku3b6QxFUYpVIRPcbfzkXawarw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rozzLrBKzu6KDq4dtt75BDRHQ8C2Q4yQ9Bin3yffkfNdCYBYLyrukBL5sQtG6K3Cf
	 B85da76PnhLwPyaYPem/BIpWxqGJft7R86phnuMt8/XlQlTN1US5bTRbVow2aNvzEE
	 rWnVV/oZQQrnayPD5Qrx/BNq1OxOC6JMdA53+4n4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [PATCH 5.15 71/95] fpga: region: fix use-after-free in child_regions_with_firmware()
Date: Thu,  2 Jul 2026 18:20:14 +0200
Message-ID: <20260702155110.707192969@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

commit 54f3c5643ec523a04b6ec0e7c19eb10f5ebebdd3 upstream.

Move of_node_put(child_region) after the error print to avoid accessing
freed memory when pr_err() references child_region.

Fixes: 0fa20cdfcc1f ("fpga: fpga-region: device tree control for FPGA")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
[ Yilun: Fix the Fixes tag ]
Reviewed-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/20260408154534.404327-1-vulab@iscas.ac.cn
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/fpga/of-fpga-region.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/fpga/of-fpga-region.c
+++ b/drivers/fpga/of-fpga-region.c
@@ -166,11 +166,10 @@ static int child_regions_with_firmware(s
 						     fpga_region_of_match);
 	}
 
-	of_node_put(child_region);
-
 	if (ret)
 		pr_err("firmware-name not allowed in child FPGA region: %pOF",
 		       child_region);
+	of_node_put(child_region);
 
 	return ret;
 }


