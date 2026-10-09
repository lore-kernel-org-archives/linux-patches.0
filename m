Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1363F31A045;
	Fri,  9 Oct 2026 14:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556050; cv=none; b=exp4D4TQsAm5d+qRzvrYtq7dQbDcRD7doYCNIu98/Wb7Q/BB+F/tMGWCVW0mjfpAI8mhFUGJFq/Yr+fw21qnXo4Xj6OEbbJfFLRJ59k6adnBLzAEFWGaZ95dSqIuzC30VXCBVr/UUou5K3WlMQE5DxtqAh7rfXVWboiM8ts3F7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556050; c=relaxed/simple;
	bh=6WL4iB2HB66douoBEBcN/cbvAP4uu7Jz5JX5NrnGJFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mOzfMbn099lOxPkW85VP5vFJH0/t0NBHqRHpwLm854K6b/UhiI5eVJsOOeZW+R32C5YYQqUZxAGsUZumfVjkPnsf3Jv1SJD4wQaUwZjCh6vaqmKiMxluFDlQekGBqdTTlhnBfnrRdShdWiVWrJCLgnCXrw/vUxikewvc3bZPqQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VFcpzJXQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VFcpzJXQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD4B1F000FF;
	Fri,  9 Oct 2026 14:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556049;
	bh=UAE4WrgowDc10aRvZGsjIc7lrdMj/vnJlBXB9Q1eBik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VFcpzJXQLNW6R7iiGygnQvH25AXVjB0hoHU6+7Z7gprNz9VG96J2cUlC3kesP/ZOw
	 81kSLIlrExKd89G2Uk1twJpjIhp2FwYOrQp/N1oLYCuavOHn1I4FVZOxVum1R3ql0K
	 h4hVmvdh3k8WJ07gaig7HFxNU33J0K8G9wDcDPpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.18 166/403] usb: ohci-da8xx: disable controller wakeup on cleanup
Date: Fri,  9 Oct 2026 16:08:47 +0200
Message-ID: <20261009140955.981482777@linuxfoundation.org>
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

commit 901197dd4c7dcffbf97426487d4c047555c98554 upstream.

The OHCI core marks controllers with RemoteWakeupConnected as
wakeup-capable. Probe enables wakeup, but neither removal nor a later
notifier registration failure disables it, leaving the wakeup source
attached.

Disable controller wakeup after removing the HCD on both paths.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: a6eeeb9f45b5 ("USB: Update USB default wakeup settings")
Cc: stable <stable@kernel.org>
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260915012011.61874-2-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-da8xx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/host/ohci-da8xx.c
+++ b/drivers/usb/host/ohci-da8xx.c
@@ -464,6 +464,7 @@ static int ohci_da8xx_probe(struct platf
 
 err_remove_hcd:
 	usb_remove_hcd(hcd);
+	device_wakeup_disable(hcd->self.controller);
 err:
 	usb_put_hcd(hcd);
 	return error;
@@ -474,6 +475,7 @@ static void ohci_da8xx_remove(struct pla
 	struct usb_hcd	*hcd = platform_get_drvdata(pdev);
 
 	usb_remove_hcd(hcd);
+	device_wakeup_disable(hcd->self.controller);
 	usb_put_hcd(hcd);
 }
 


