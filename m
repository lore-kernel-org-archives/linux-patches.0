Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894DD3C09F7;
	Tue, 12 May 2026 17:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608489; cv=none; b=s1E1rnu1xnxK49jMlDyqh29Bznk44/16U6qIIFGC6PD++tzZvMII9Dng/O4iMArX93cDxoUCkESYanOiyErqxATbHnxKEy8ZocXL5KHe35QUbSYwV04IZMWIfnwlrfBjcX0crs21UxxHr5giCujy902C7UXW4zYYfsy2ML8Qh3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608489; c=relaxed/simple;
	bh=ZOT4LRbWsTMQbpw2MQvr/XaFNTi/95/ClteFSMwBelw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hOPrDkN6Tm20uiO0teCPpenQt7N2sSQDC2ertnVRbkaAzpDWycqrcyH8mLjdK6odH+hEOVZfgUc6z6EhPh3i7uLNBU1SwJCzAKzh+Qf1IrTc1Ep2j0XX351NGG5W8ypyv0KNJ4zMPDj/lxsZnXHveJDLFxjJTncc742xB9+LL10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fYnheHC/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fYnheHC/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDBCC2BCB0;
	Tue, 12 May 2026 17:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608489;
	bh=ZOT4LRbWsTMQbpw2MQvr/XaFNTi/95/ClteFSMwBelw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fYnheHC/nxhgFn4JaQNXIF+I7k6pFTdJzxUsWH8fxVuLwG5KEfKjiAL+XdFmg+Ldm
	 2bG7oB4aQ7Z2Jgg3YMPqChux1oDl7GGDcyUzsB8MhrPXvTzPyeB67ds/CxuO/wBeMd
	 v/8pwrvNJpQG+A+ujL5Fhah6p/98R5xL1+iJyARY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 099/270] net: libwx: fix VF illegal register access
Date: Tue, 12 May 2026 19:38:20 +0200
Message-ID: <20260512173940.543658175@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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
@@ -2427,8 +2427,11 @@ int wx_sw_init(struct wx *wx)
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
 
 	if (wx->oem_svid == PCI_VENDOR_ID_WANGXUN ||
 	    pdev->is_virtfn) {


