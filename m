Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E53391512;
	Sat, 17 Oct 2026 17:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256518; cv=none; b=lGNx1OmbM2o5mIX4tRQ0ijonuWFO2saOeQ2llNy35oPRjP5+K3JuDOBZ/wsXozVUCfTEInht9hgtbp/l6DHq35vqlNcGFlmEZr7JY+q+bleeGUsxVRuIwXJirfi0aMgPrxTAHl/kS8+7mojeI7uuftRQPRbFEpCg1li0FIOkC+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256518; c=relaxed/simple;
	bh=xTcbIC3K5ssCvMrwvfVIb/BvgfvuLNJ4yI+BhV41Utc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJqDvuEZ3tX2GOAturXX7nO7womhjcLT/UHgwXBV9Q2M1mC25kUe6x4/XwopEiYsqvCegSlK/4Z6yJfaKYlH4UUjP91qAWo8kphF7OX7fqAWuo7WzjL9XDBI+aKa3yw+LRBx3e5bDSerEGvUK6PAozUxbFeuJ2i01KMsmyUawsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ybelvPQC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ybelvPQC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1941F000C4;
	Sat, 17 Oct 2026 17:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256517;
	bh=1r+guxFREIUVxadKIO5S0FX17zyFfi+/VzQ5//tHE+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ybelvPQCE501oKTcu9VZPJ4R2m+bU6EKPJBtAae6p0R/eje2ZHEqa4Gc3pnIQ6nXs
	 RV/J+lYvivgit1rgE8jweG+Dqd31DiAA13FKUB7kph58A+TGIXSqkP7Cac5kOUg+Zk
	 gKKCRNtwT7heMJNPnz4yC83RDjYtU3ikSlzNeKNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.6 0263/1674] usb: ohci-st: disable controller wakeup on removal
Date: Sat, 17 Oct 2026 17:42:15 +0200
Message-ID: <20261017160437.877652695@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

commit 08b2ccd7eb7e41f77a04a09112ca3edcc588e3f0 upstream.

Probe enables controller wakeup after the OHCI core marks controllers with
RemoteWakeupConnected as wakeup-capable. Removal does not undo this, so the
wakeup source can remain attached after driver unbind.

Disable controller wakeup after removing the HCD.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: d115837259ad ("usb: host: ohci-st: Add OHCI driver support for ST STB devices")
Cc: stable <stable@kernel.org>
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Patrice Chotard <patrice.chotard@foss.st.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260915012011.61874-5-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-st.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/ohci-st.c
+++ b/drivers/usb/host/ohci-st.c
@@ -235,6 +235,7 @@ static void st_ohci_platform_remove(stru
 	int clk;
 
 	usb_remove_hcd(hcd);
+	device_wakeup_disable(hcd->self.controller);
 
 	if (pdata->power_off)
 		pdata->power_off(dev);


