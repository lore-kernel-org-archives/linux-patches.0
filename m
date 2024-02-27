Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F0013AA2F;
	Tue, 27 Feb 2024 13:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041057; cv=none; b=T6obVaRL+Z59Jujrq/R48tVN3IkyIlZVEjLjBZIvvWiObRE9Sh/EN2NjX/363ERLXjylExJN9lfLngTGN0tpcXlTR91nBkjk7gEkDWGNLcHS5c1jYsmcBOqEOq/LV1Z4bTQmiavPns3l22VMOQq0LFMGt4G6GrQOIgSBSV1l2hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041057; c=relaxed/simple;
	bh=Y5n7DDqrLGue1nWoFrxiaAuD196s55tFp5Yd8685+Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0O1/ZjIeSHNLAklhzO1pZzbMaRC89BtWsbAQR3PD5xH50m5w/wttPBRwIu09wFHNwi6r94VDLJOLtrHKuwqpHOuovdsgJ3QAR94DAhnYTmcMoeHXX0+C7BGecW1V/quwwh/wp3DRiWxwMxP4YcCaDmATZSahyhp7jmxkeQ7mO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cquPXbSs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cquPXbSs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA2FC433C7;
	Tue, 27 Feb 2024 13:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041057;
	bh=Y5n7DDqrLGue1nWoFrxiaAuD196s55tFp5Yd8685+Gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cquPXbSsGQKuulnX40Je7iMccxFdqYk7c79xswaqDimx32u5bIW8HhNgEqaNjRJ1D
	 bkrYm6o9PjszSSJlFrCtAxpzyq74Y3Ec5uFGB+4zOCgJVB8ejsYZOnlZpQqdAggAXm
	 ihX6QdFDku4GCTY87hH82D1c5abJtcdDyP79XG50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.7 204/334] usb: dwc3: gadget: Dont disconnect if not started
Date: Tue, 27 Feb 2024 14:21:02 +0100
Message-ID: <20240227131637.326131731@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit b191a18cb5c47109ca696370a74a5062a70adfd0 upstream.

Don't go through soft-disconnection sequence if the controller hasn't
started. Otherwise, there will be timeout and warning reports from the
soft-disconnection flow.

Cc: stable@vger.kernel.org
Fixes: 61a348857e86 ("usb: dwc3: gadget: Fix NULL pointer dereference in dwc3_gadget_suspend")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Closes: https://lore.kernel.org/linux-usb/20240215233536.7yejlj3zzkl23vjd@synopsys.com/T/#mb0661cd5f9272602af390c18392b9a36da4f96e6
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/e3be9b929934e0680a6f4b8f6eb11b18ae9c7e07.1708043922.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2650,6 +2650,11 @@ static int dwc3_gadget_soft_disconnect(s
 	int ret;
 
 	spin_lock_irqsave(&dwc->lock, flags);
+	if (!dwc->pullups_connected) {
+		spin_unlock_irqrestore(&dwc->lock, flags);
+		return 0;
+	}
+
 	dwc->connected = false;
 
 	/*


