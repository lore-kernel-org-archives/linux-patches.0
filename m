Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDA84F0546;
	Tue, 13 Oct 2026 12:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895169; cv=none; b=IpvTaR1ZE5O1snOaccwejpjvz1A/BFtfzcA5IJL9GdA9fOO4EBl0Mb4HPZoV/soFZv7SI4zD9iS54qvXqZIpjcX//LznPlaYeqsQlOd7m0z39N9kRE1QDD7HxpqOdbWQ0sGxxk/I4X939tOld9Fop2hXnW5QV4D733afnJwYc5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895169; c=relaxed/simple;
	bh=JaozE+5wwwfTtR3JKGarpLcLzEvMxlwr4jPDOxnLJ3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4F/XOul+FB0/1vT5+Efbb0lIcJTdng8jO9lpOt98ZqN/ZcafSM1vD1HeLkln4Mf2m18XeGwe3ArU75O+eWfMjtnm6jCydmvjdMf4mF8J9Hqrhc4lKlviLcd2rXZYOk+LclX4cfIMrGF10geMN8QBfF+GNgxiPPieSR+LYqFeIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TSs0rkMn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TSs0rkMn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49BBC1F000FF;
	Tue, 13 Oct 2026 12:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895167;
	bh=sS9KFvYkU7ypfNXrcMYTkE3GqHx2c70RvlWTEWmfqdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TSs0rkMnd7xdA5QSbUdVZjqqkSq1Rr/wFvVlgxJa//wn3M7hla0eCFr15/NEP/Js9
	 lLIkLRAK/Ocd8jNp3unlIk8JUIiA3zAWOG3azASMI7yEV/J/eb5NJWY256AfCjSnXI
	 gtqXlwrZkpcWcxdv8AX3+OQ9CQmZ3bpohD3xuZjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.12 140/497] usb: ohci-s3c2410: disable controller wakeup on removal
Date: Tue, 13 Oct 2026 13:35:07 +0200
Message-ID: <20261013112911.211955432@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit 8dd8451c527e2a723bca20da5a6d724b8592551f upstream.

Probe enables controller wakeup after the OHCI core marks controllers with
RemoteWakeupConnected as wakeup-capable. Removal does not undo this, so the
wakeup source can remain attached after driver unbind.

Disable controller wakeup after removing the HCD.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: a6eeeb9f45b5 ("USB: Update USB default wakeup settings")
Cc: stable <stable@kernel.org>
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260915012011.61874-3-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-s3c2410.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/ohci-s3c2410.c
+++ b/drivers/usb/host/ohci-s3c2410.c
@@ -335,6 +335,7 @@ ohci_hcd_s3c2410_remove(struct platform_
 	struct usb_hcd *hcd = platform_get_drvdata(dev);
 
 	usb_remove_hcd(hcd);
+	device_wakeup_disable(hcd->self.controller);
 	s3c2410_stop_hc(dev);
 	usb_put_hcd(hcd);
 }


