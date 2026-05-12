Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B102D060B;
	Tue, 12 May 2026 18:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609344; cv=none; b=paMjaXmdhoh62coBvjplXpYvjagtUPFlGSNjR8upjN2I6/nF8lNQ67B9pyWL61mGryZ8gxPM3+wVRaWqUEEmiAzq+ITS4mlTCNI27lWEE8tdm+LeuFm6eZjYLlUZAynUgDBRQhhfqF/lLNZDP8kEVaRzIv/5JDXPbTnf1O4M5ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609344; c=relaxed/simple;
	bh=kBfXiYiXmwS+sjVvFaSqbxTgn7Qv3COV7iT1VJpU3ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZ/HiPQrcu9XxOTY17bcGncLcZVm2NPYVMDbAuKnA/ep9xv7wY1PDOe8l9ERUavD6M0jk1Yg7Rc8jdFpQBOqBmeboHGLQvROWbOx0CYjUvTJFm54e6MN14VKJRGEwksqIpo6EtxRjRteRcOkrpbh2vfnaSjNVacxCM4k0ZwFQzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pwej5q57; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pwej5q57"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E80EC2BCB0;
	Tue, 12 May 2026 18:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609344;
	bh=kBfXiYiXmwS+sjVvFaSqbxTgn7Qv3COV7iT1VJpU3ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pwej5q57YyK/rC8LZM/txEcZMaRUO2kh0HCRJsW0SspvmsRpC5nXGFkBXpO4zDmSm
	 dP6StSzPppbhftrkmFwmXNihUlagISuhByvnHMf2Vr9nbu+9s0Xme7QHB1MD00gdzj
	 K9o6rjyUL4waGjE9HxBAy/PYEUnilK+3URfkFfVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 117/307] net: libwx: fix VF illegal register access
Date: Tue, 12 May 2026 19:38:32 +0200
Message-ID: <20260512173942.595416135@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2480,8 +2480,11 @@ int wx_sw_init(struct wx *wx)
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


