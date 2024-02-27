Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BA413B7AA;
	Tue, 27 Feb 2024 13:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042132; cv=none; b=c7B/mX+TSSnU9C1bPQh7/hB1dp93O0tOLAVZXbt/Jq0d+x2sjgI8+NFBi5OTuDHTsKu6qY2+6jtbXtwP6x6BvzAWHrKk2HJOiXKHDCkiuFsGzJkt80Cfuw0UrEtxSvB+sfprUgvthwK3hQzyC+KNUk54Hhmt+nf9cteo6VzhGNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042132; c=relaxed/simple;
	bh=LBqCPe7ZzmOdvYqRzpabzK1lBAWn0SkGQuUh40cg+Cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ac34LnucOkxzTqRPWIP3gvayQKGTLboUQKz0giFmKJQTXqtKGRCqDNb58xr4yYbR7sqO3e/ltTG4FoTKpEpwQTflj0GWjaU0M1dFmTG+2tzp7qtn5eWYY/xCRcAauhgBbu5gkGuOwHEuHDckMqdCGls3EIayFbD/Ix2a0Xr9fKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nQxxcyin; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nQxxcyin"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B332C43394;
	Tue, 27 Feb 2024 13:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042132;
	bh=LBqCPe7ZzmOdvYqRzpabzK1lBAWn0SkGQuUh40cg+Cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nQxxcyinXqSBiSjTntApyWkNp/IDgyeq9ou7L+IbTwfEVjnXyoiX12UUD823bd02M
	 SbcsPCSUawLJdz7FQevJBonM2p1SBEVlyPGoOVPQDxaywXTeMSwF6NP7EW0lZlcZoj
	 Bu4fx3jweWVUzPMcpfPra8x5OT2tOc95cijLZEn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.6 183/299] usb: dwc3: gadget: Dont disconnect if not started
Date: Tue, 27 Feb 2024 14:24:54 +0100
Message-ID: <20240227131631.730265278@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


