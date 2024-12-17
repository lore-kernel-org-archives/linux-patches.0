Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3A7140E38;
	Tue, 17 Dec 2024 17:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456372; cv=none; b=hOGKWY5lBOO7mGh7uxuLZcwdBc48J5PfARTLzjH4oi1SNmoUbV0mzkvxXjPP4qlYLjpjIx+5gwKCalnpwEozPe6B8c47P85DNqrZ8VT31l2MLefeywOBKDH6kXtBdpdqXUqCNGQyO1VZeqUGqWgjk/n8OfSRJ2AAvutJB3JsmJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456372; c=relaxed/simple;
	bh=iIme/Q8s/dDU/W3a9RcxZblvckhmin7jH/uZjQK40Hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AsJvOoAeIPjiQ/5d31cPDJssaOHHCay7L26ztTXC6SPoMjaeUgNU18yg84kNaTiXkc7odq/SRcvhnEHgY7gPxwuvQhiYijQj4+OmvmfBXtLSgk9qryuBT8SaNeJS4Cw7a2i4jcx0PEqbHeJuyxCAao5RUMQj163Sr5y+8BTNhyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hlvc9bzN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hlvc9bzN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07DBC4CED3;
	Tue, 17 Dec 2024 17:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456372;
	bh=iIme/Q8s/dDU/W3a9RcxZblvckhmin7jH/uZjQK40Hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hlvc9bzNX8DyRAZ0abs0jdv2OdKL5lwBT/b5CvkggUtzsnB2tgf0WqRXX9r7aeN+x
	 x5jOlCON6fQVQk3TIxS+jhqzu8ZqlGNzQpGOYTONead9K+dD2ebsA6cIFxze4FJb+3
	 f9j43p2W1l5L0JChK7BOuJddq4b+88kkKg3Fud1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 6.12 038/172] usb: core: hcd: only check primary hcd skip_phy_initialization
Date: Tue, 17 Dec 2024 18:06:34 +0100
Message-ID: <20241217170547.841618563@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Xu Yang <xu.yang_2@nxp.com>

commit d2ec94fbc431cc77ed53d4480bdc856669c2b5aa upstream.

Before commit 53a2d95df836 ("usb: core: add phy notify connect and
disconnect"), phy initialization will be skipped even when shared hcd
doesn't set skip_phy_initialization flag. However, the situation is
changed after the commit. The hcd.c will initialize phy when add shared
hcd. This behavior is unexpected for some platforms which will handle phy
initialization by themselves. To avoid the issue, this will only check
skip_phy_initialization flag of primary hcd since shared hcd normally
follow primary hcd setting.

Fixes: 53a2d95df836 ("usb: core: add phy notify connect and disconnect")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20241105090120.2438366-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hcd.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2794,8 +2794,14 @@ int usb_add_hcd(struct usb_hcd *hcd,
 	int retval;
 	struct usb_device *rhdev;
 	struct usb_hcd *shared_hcd;
+	int skip_phy_initialization;
 
-	if (!hcd->skip_phy_initialization) {
+	if (usb_hcd_is_primary_hcd(hcd))
+		skip_phy_initialization = hcd->skip_phy_initialization;
+	else
+		skip_phy_initialization = hcd->primary_hcd->skip_phy_initialization;
+
+	if (!skip_phy_initialization) {
 		if (usb_hcd_is_primary_hcd(hcd)) {
 			hcd->phy_roothub = usb_phy_roothub_alloc(hcd->self.sysdev);
 			if (IS_ERR(hcd->phy_roothub))


