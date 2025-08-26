Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6A02192F2;
	Tue, 26 Aug 2025 14:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217203; cv=none; b=gfWhc0YUXWgbXiqdsqBQKgueOSUBq6DUhg5QU9NKaKW2LNBB/WR63WQrLiUkErX9eUR+Nmy5HbaEYG0cLra8qnIG0yvCOZAR3u5Qqrxfx8/+T4ky4goYaaty/lpMYVMaWoOd2RhX3SviTSrSuB+ZDrgJrDy/+kmOnH55ypyGwyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217203; c=relaxed/simple;
	bh=rBGhkHQxER1aoksRykyr1tLPa86nGemMV9vEwewxWH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kmDbi5l7exl7o5Gy2B/n6kYxeQT72DEe6y6njX0BCc7O05jm7/ZvyHFLV5LF3TUwjB+/0Ugnv+t/pud7CSARygwK200IQW6dGD9K4mbo0NrwGummTyHgGCDawTJlHKw2bxR6sW2V7+gn8t1NIEb5vaKOeaaIyTySVyz1twQV7fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vAnSRQzF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vAnSRQzF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0E1C4CEF1;
	Tue, 26 Aug 2025 14:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217202;
	bh=rBGhkHQxER1aoksRykyr1tLPa86nGemMV9vEwewxWH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vAnSRQzFbGlnRCWqo+nvdCGLburpiHTcSy/+Mt+1VhvjHkAQlq4KgXd5x7GocOW3B
	 nAr9PzRxkFxA7iu6aOAGVkfGdLa9pSviv8QUcdqW6Ysm7QrobmkrCFgn1Sr12DISH4
	 0q0vygZtQzeONIVPWFmo1RKUKQNZhZNYCLVNFzUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hongyu Xie <xiehongyu1@kylinos.cn>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/523] xhci: Disable stream for xHC controller with XHCI_BROKEN_STREAMS
Date: Tue, 26 Aug 2025 13:04:24 +0200
Message-ID: <20250826110925.927190020@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongyu Xie <xiehongyu1@kylinos.cn>

commit cd65ee81240e8bc3c3119b46db7f60c80864b90b upstream.

Disable stream for platform xHC controller with broken stream.

Fixes: 14aec589327a6 ("storage: accept some UAS devices if streams are unavailable")
Cc: stable <stable@kernel.org>
Signed-off-by: Hongyu Xie <xiehongyu1@kylinos.cn>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250627144127.3889714-3-mathias.nyman@linux.intel.com
[ removed xhci_get_usb3_hcd() call ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-plat.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -361,7 +361,8 @@ static int xhci_plat_probe(struct platfo
 	if (ret)
 		goto disable_usb_phy;
 
-	if (HCC_MAX_PSA(xhci->hcc_params) >= 4)
+	if (HCC_MAX_PSA(xhci->hcc_params) >= 4 &&
+	    !(xhci->quirks & XHCI_BROKEN_STREAMS))
 		xhci->shared_hcd->can_do_streams = 1;
 
 	ret = usb_add_hcd(xhci->shared_hcd, irq, IRQF_SHARED);


