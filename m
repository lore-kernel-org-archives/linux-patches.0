Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787C581ACD;
	Fri,  9 Oct 2026 14:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556071; cv=none; b=ebuEzA+r7emJnOxPuR0cZVMzhPJP7dtDinVOD6EBuePridW3+7afemsaHk1wz9+5re9Z+LwKfYiDqa72/rx1twXWDKDOKyfM1J+pswco/IZ9RVXYDN/ksTaLPDnMT39vJdpwBf6KgwF2pSUwxrFSCuXHGBsYKuP7CSlGXmOp7W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556071; c=relaxed/simple;
	bh=iBToyhiFCE3KuXPUIWO1cXC3iiw3l91GCZdpFHo3LjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FCGvvhtDFAenGdJ9Xv8JctWBWRhCmvYAAwMQDYjS/Bt/YtgB1qG3nC08OszIO+ePvtbE0pmVCnun8Wq3P380LbSzIVe3c6djjAAxKciip95oPHipo993HTAw/aRnm7VYy8FE6g6Eqv8m1nDOPqTKzt+7x5/dVSJj1GMAFQsKD1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yqy0KnYc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yqy0KnYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BC21F000FF;
	Fri,  9 Oct 2026 14:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556070;
	bh=mczAr3Ll8xfnKqy2DwtSk3C6asCpqzx7ueSXFxPGFoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yqy0KnYcskHF/BQGxKSZZbyaf+Dda/9uFbQNmXnwP3HPJXX8gyGhknihfOwTFlAPf
	 0Aks3h5eFrdWzXjtcBLf7P5OLvt7n76i1pFBXYH6KFSvhe8qUdmTFwrVge0yJUlKI8
	 OCIbQMlMNrKh+X+Lyka5u9AIdGmw/BVPWOwtjOn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.18 169/403] usb: ohci-st: disable controller wakeup on removal
Date: Fri,  9 Oct 2026 16:08:50 +0200
Message-ID: <20261009140956.058197400@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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


