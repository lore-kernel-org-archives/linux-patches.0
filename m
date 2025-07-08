Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306682DEA78;
	Tue,  8 Jul 2025 16:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992139; cv=none; b=aSd7pO1QhVLT8tup12KdK7VGXDNjzTqvm+53MhAlNZ9MQZBOcjCks4Hsyu6Ye2AhzJ7SGDQmZVnTc8GFWPgtbwNu3iN1hA/GO2UhftQ0iNubvV1nFR790oS5LbvCwoCrjpf/+0gLcz2tdBCb5SBRHNKNPg3/HJDTotQCL4JUw6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992139; c=relaxed/simple;
	bh=zLPfmc18zX0Jr0gch/vMDDh//iOebMZZEB7sIm3YdKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o2YHBHBxNI1nRacsLEvRRI8chGjdkF8fmE0l9mJmxl0WB/0sY7l92xgv4qbch56kEhdlANIfyH8V3shLEciS2e4jiaGluWDUYEjpPasZWe3YhRenxez2IHCs+LTJ4qpcoU3IBbKYWxa3rSce/vpa0Onwr6d6/RaN9PNyhAe4gYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=joFyZfAt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="joFyZfAt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE97C4CEED;
	Tue,  8 Jul 2025 16:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992139;
	bh=zLPfmc18zX0Jr0gch/vMDDh//iOebMZZEB7sIm3YdKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=joFyZfAtmuNlDcEwJlsurVgmgesyEjscISbD3rpywbutFLtuyPygswvzC4ZdgGyPP
	 3+Zc0bMnrxzVb6d/TpZRGzHQXQaRhOp5ChTVfoqnUO/+OqwCA534ZaBeKDx9FZitNw
	 v0ZcAxbhbUojOESs8Ia/84Pr4GMJkr0gJeLeuS98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hongyu Xie <xiehongyu1@kylinos.cn>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.1 70/81] xhci: Disable stream for xHC controller with XHCI_BROKEN_STREAMS
Date: Tue,  8 Jul 2025 18:24:02 +0200
Message-ID: <20250708162227.181021454@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162224.795155912@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongyu Xie <xiehongyu1@kylinos.cn>

commit cd65ee81240e8bc3c3119b46db7f60c80864b90b upstream.

Disable stream for platform xHC controller with broken stream.

Fixes: 14aec589327a6 ("storage: accept some UAS devices if streams are unavailable")
Cc: stable <stable@kernel.org>
Signed-off-by: Hongyu Xie <xiehongyu1@kylinos.cn>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250627144127.3889714-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-plat.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -351,7 +351,8 @@ static int xhci_plat_probe(struct platfo
 	}
 
 	usb3_hcd = xhci_get_usb3_hcd(xhci);
-	if (usb3_hcd && HCC_MAX_PSA(xhci->hcc_params) >= 4)
+	if (usb3_hcd && HCC_MAX_PSA(xhci->hcc_params) >= 4 &&
+	    !(xhci->quirks & XHCI_BROKEN_STREAMS))
 		usb3_hcd->can_do_streams = 1;
 
 	if (xhci->shared_hcd) {


