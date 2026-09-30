Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A9A5172E0;
	Wed, 30 Sep 2026 17:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787866; cv=none; b=OFtoY4yeSUyS0NSGrk1WSSPdrePcVNVfnL6X7zV2XdGAvf/vKQI9oqs/LtUUJOKuDQhi6n5QG3VSPSBmSd0A/QmdFYjkiwkSEVuiGIFIh4ntsRqWMYp/xykUygpS2FPQKISaw4KR4hid4kqeFw8XEMWS8T1yPpokRIVGd6Cu+nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787866; c=relaxed/simple;
	bh=+WpFUA/JE9ICKZvBJpdy2BXExo3Rz2f5lnIFmQihXnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBUFlhC2nIcIAf2MZpdpbwW29DuQs168VeOG9xO90w71HpKeOl9+GkOTDNoCW+F7E1hxIbYdXBrOX/GPmO3mPtLL/5Ry+B9Zk0E+ydSyobbIksgzUoGoDjebf1jr8X1EuLYLEtH3fbfmbxAsIarMcxc3Wlleo0aGdJjs5ubkHCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rygj/uqy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rygj/uqy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7991F00898;
	Wed, 30 Sep 2026 17:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787865;
	bh=HJi/8ATxl+e0Uc5gbKi2h9uz5jGUnQQQwGZZaCVsIYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rygj/uqyx/+hEVDyPLAZLLTZvBSIKNRF5IJw5HxYZF4kKs9Bvc04gGxo8qsKC5Bcz
	 bsxgI+KNrprMrRjkynWXGMR62To5umzBakKNw7XcoT7isrtOsbwmZOjIVZKarnFo+x
	 GzSCoRROldPk0nGvfkWRTqrrcpxK3Fmws7vMnBE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Benjamin Block <bblock@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 7.2 380/457] s390/pci: Report SCLP status on error events when no pdev is associated
Date: Wed, 30 Sep 2026 17:28:05 +0200
Message-ID: <20260930152354.201391787@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit a1120bea9bc8ea9d9ab2f9904a63b9a228bf2ffc upstream.

With commit 4ec6054e7321 ("s390/pci: Report PCI error recovery results
via SCLP") SCLP reports are generated when recovery is performed in
response to an error event. If such an error event arrives but no pdev
is currently associated with the zdev, e.g. because it was removed or
not yet probed, no report is generated. Fix this by generating a report
specific to an error event for a zdev without an associated pdev.

Cc: stable@vger.kernel.org
Fixes: 4ec6054e7321 ("s390/pci: Report PCI error recovery results via SCLP")
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Reviewed-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci_event.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -320,8 +320,10 @@ static void __zpci_event_error(struct zp
 	pr_err("%s: Event 0x%x reports an error for PCI function 0x%x\n",
 	       pdev ? pci_name(pdev) : "n/a", ccdf->pec, ccdf->fid);
 
-	if (!pdev)
+	if (!pdev) {
+		zpci_report_status(zdev, NULL, "error event", "no pdev bound");
 		goto no_pdev;
+	}
 
 	switch (ccdf->pec) {
 	case 0x002a: /* Error event concerns FMB */


