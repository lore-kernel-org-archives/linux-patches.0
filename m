Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4E340B6D8;
	Fri, 15 May 2026 16:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861156; cv=none; b=df0OxO/torAbKigK8fj/NNUG4X3QKiTXwa5cz5ngeCpAn01s+30W6iGnu6TJAz+zx3hswjhrHT5zLHffoJChokYdvUbcQxBNrdhZlpsZTTYKqLtTtEALc13mRl0JzBbVec0gohMgeC6ClY/Igcsy8CNknF05/qrfD9A2aCiZ0QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861156; c=relaxed/simple;
	bh=58zopqvSoIPHsYad4SWPWshajkk4ZcwrQ0s9Sp2/voM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtXbPkOgWiZRrhGW4r3ieB11NR6AlmZm9CO9daRxtWUMNk1jkTUVM11h6W9EnyzdYAqCIcymjl65u13nNiXrG/W+wKDOStII1khQcCRecStkITR2UssKCOAt2Dr6eEK/bfSF3BhnpW8DVQtqrOBdRiwoA7gdLg2MTrXIooKeiQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R4z+RXXv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R4z+RXXv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41FA8C2BCC7;
	Fri, 15 May 2026 16:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861156;
	bh=58zopqvSoIPHsYad4SWPWshajkk4ZcwrQ0s9Sp2/voM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R4z+RXXv7r1Y6axtbV4j4H3hTg5bhIIeqc379Zk4h56XrE5WaYeopN3ByEW59IpI4
	 2Oqoqmk/59eARWQPIf+1trF0Y9fC3sQ03v9iarGxBLMtA7BUmQnT8D8TK6KCtc8SMx
	 TeWb6zeEBOY/AZb2U/14rkqmcyT3/oflzaoj/jZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 220/474] net: libwx: fix VF illegal register access
Date: Fri, 15 May 2026 17:45:29 +0200
Message-ID: <20260515154719.768397065@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: Jiawen Wu <jiawenwu@trustnetic.com>

commit 694de316f607fe2473d52ca0707e3918e72c1562 upstream.

Register WX_CFG_PORT_ST is a PF restricted register. When a VF is
initialized, attempting to read this register triggers an illegal
register access, which lead to a system hang.

When the device is VF, the bus function ID can be obtained directly from
the PCI_FUNC(pdev->devfn).

Fixes: a04ea57aae37 ("net: libwx: fix device bus LAN ID")
Cc: stable@vger.kernel.org
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Link: https://patch.msgid.link/4D1F4452D21DE107+20260429083743.88961-1-jiawenwu@trustnetic.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_hw.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
@@ -1667,8 +1667,11 @@ int wx_sw_init(struct wx *wx)
 	wx->oem_svid = pdev->subsystem_vendor;
 	wx->oem_ssid = pdev->subsystem_device;
 	wx->bus.device = PCI_SLOT(pdev->devfn);
-	wx->bus.func = FIELD_GET(WX_CFG_PORT_ST_LANID,
-				 rd32(wx, WX_CFG_PORT_ST));
+	if (pdev->is_virtfn)
+		wx->bus.func = PCI_FUNC(pdev->devfn);
+	else
+		wx->bus.func = FIELD_GET(WX_CFG_PORT_ST_LANID,
+					 rd32(wx, WX_CFG_PORT_ST));
 
 	if (wx->oem_svid == PCI_VENDOR_ID_WANGXUN) {
 		wx->subsystem_vendor_id = pdev->subsystem_vendor;


