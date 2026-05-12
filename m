Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40D93DC86D;
	Tue, 12 May 2026 17:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608494; cv=none; b=oB0W/6MVvZzjoTu0YkB8FOw9lHsVkQq9J4QhP9GR9FWRoV7BLtuGmDDfYiCC4YlJGpkQQjy+CQYmEpYczYpREKaMHmX8gDetwXnIv8YjaKmp88q8xLcDia8NZsXLA4V/WW4GOni6aI6DVbPqzmSbaRNiSM3D3ltSTqft+gAhlVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608494; c=relaxed/simple;
	bh=0hVj12dwTpCRZBm9c8QNGv/r3a3Au1V3oieUSJv3Ybs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rE+wDiwrsfGTg33Lf0yTB4Gj8kLsIFTezKmgiajvR7ni1hxP1Hd3KwfSbgNfyTN78BEqrDE2Ar7kEDzDJLGfaOSvqrsg59upe2yi3O3OR6gIkGzCR6/1z+e89rGX0F++FIs+TgvDHUZom74jjHApicwrj5KHHLVR4k7gIUCbzJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RS0g6LOl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RS0g6LOl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439A2C2BCFB;
	Tue, 12 May 2026 17:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608494;
	bh=0hVj12dwTpCRZBm9c8QNGv/r3a3Au1V3oieUSJv3Ybs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RS0g6LOlVaTIEX/+YimJr+2Xwhuvc4801U0JTGQ5Q7NlghJBXb5hdayHA1frw2qz9
	 2K/NAJcoORRpJhS8M7m/Kx7Es3QiF/gKbBOsKhZ4RxWOGtWX/cS2hy+SFBNd/3lsn+
	 g6nHi6u4hsM9MkDpJD7iUV5MVHccmjqHh21VCtko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 101/270] net: libwx: use request_irq for VF misc interrupt
Date: Tue, 12 May 2026 19:38:22 +0200
Message-ID: <20260512173940.585622280@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Jiawen Wu <jiawenwu@trustnetic.com>

commit 7a33345153eeeda195c55f15be27074e4c3b5109 upstream.

Currently, request_threaded_irq() is used with a primary handler but a
NULL threaded handler, while also setting the IRQF_ONESHOT flag. This
specific combination triggers a WARNING since the commit aef30c8d569c
("genirq: Warn about using IRQF_ONESHOT without a threaded handler").

WARNING: kernel/irq/manage.c:1502 at __setup_irq+0x4fa/0x760

Fix the issue by switching to request_irq(), which is the appropriate
interface or a non-threaded interrupt handler, and removing the
unnecessary IRQF_ONESHOT flag.

Fixes: eb4898fde1de ("net: libwx: add wangxun vf common api")
Cc: stable@vger.kernel.org
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Link: https://patch.msgid.link/786DDC7D5CCA6D0A+20260429083743.88961-2-jiawenwu@trustnetic.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_vf_common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/wangxun/libwx/wx_vf_common.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_vf_common.c
@@ -98,8 +98,8 @@ int wx_request_msix_irqs_vf(struct wx *w
 		}
 	}
 
-	err = request_threaded_irq(wx->msix_entry->vector, wx_msix_misc_vf,
-				   NULL, IRQF_ONESHOT, netdev->name, wx);
+	err = request_irq(wx->msix_entry->vector, wx_msix_misc_vf,
+			  0, netdev->name, wx);
 	if (err) {
 		wx_err(wx, "request_irq for msix_other failed: %d\n", err);
 		goto free_queue_irqs;


