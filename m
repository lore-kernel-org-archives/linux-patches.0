Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF633B71C0;
	Tue, 13 Oct 2026 12:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895037; cv=none; b=PoL8W8PHeKTDgbUotuUwnXviKLQwQ780F9PbMgQFBzAmNfUn3T7FW7RSwOevlliGCzMV6wQxhzEkd65wQvLRwp8nb679Tuxb+9jbRj62KSiEvWk8pHUUFTvkGixb8j9WdsuZpYGpdFVq+xBDxbcJ15U2/M4/lLwkqN+kdphOtjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895037; c=relaxed/simple;
	bh=Kv1gqzK3bIoucGK/mFMpc/On1KM1oNHSm2tVYpZd1As=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SWMSC9dYnFzHAgdgIAdH5otQ8pHVNFFzs9BFn3x9Ts6/mKbax92fqtdpe80IRadsSmHHCPhC15mAGcVz6mM35o20ZYZUXsUGtgo2FLG4mqJpmR1/Frcf4ZBB0YrgqEOD3u7mBazZAGs1ohdNvx1cXC1GNyx3H0KvUvICoPaTKvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oz+5gjQn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oz+5gjQn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED8D1F000FF;
	Tue, 13 Oct 2026 12:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895036;
	bh=1leJV9b/aV6YOqGzy5LuqSCOtomppiahgMRA8ZARQE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oz+5gjQnznI2cUzF2NAQ/lvlCsvqwtKS9+ZxIlbZz1GDu1WAAhIofxo7TDrLzU8jJ
	 PtntaRYIQZbnVFmTlfVuLoLi5mU9op/RsG4MebVkvn5+FpgIwDLY1IcsC7HRrcRJXF
	 e0EPitMHhNjqG7RgXTW55U1KgUJtkG2Jp/CjMvag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.12 141/497] usb: ohci-st: disable controller wakeup on removal
Date: Tue, 13 Oct 2026 13:35:08 +0200
Message-ID: <20261013112911.235710155@linuxfoundation.org>
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


