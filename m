Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDDA778F52;
	Mon, 12 May 2025 17:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071093; cv=none; b=cEXuPd8uCnU/0113ygWWpb9DSe+k9zkRS2D7CTB9OghHXWCFdtO9lxylekW+15OOm2JxBmYzfqxHBLU9WIYZXKXuQiqTDJhh9wMXPVq/QXoB9/SCzMcTBD/ebHhlEyNm6RXVVZ3R7ocFTDnXhDlOelHvG3TABOxdrI+pmt5Gedw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071093; c=relaxed/simple;
	bh=b79XI3kymRo5fG18q/V9L7Yp+LbfK/OjMlpMBmZOvVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=blA7xghqpdrrPtMgk/I1AgzqoNQGqMb1vZhJ8ZMQ6rtbjIxY3WXxtiI8W28/XTMpAATNxYnWB/P8z/OhnziOmIia7lB6P81QIOtcXYcveEVfK9c4ERZhT9n5/jqHIzbij0SQNU8zTDN0K7Jh7c+0VwjKR+wjvLHEzTtvqp/an2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j1wBmJcj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j1wBmJcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48210C4CEE7;
	Mon, 12 May 2025 17:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071092;
	bh=b79XI3kymRo5fG18q/V9L7Yp+LbfK/OjMlpMBmZOvVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j1wBmJcjrzyLamaKRiDOqpKGUVJi5msXGl4UTMeaUu2OhZVcshYJk6DRDG70SsKCA
	 Lcx8jrErxkUEc06WLUw+5nGLFY4+4mymTcK11bsGzn9E/gD95RXrE0rsLDbl2drQi5
	 8AgDLF03E4Q6wgf6YNn/ya8IsYa54Ym4qT0sYDc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Wayne Chang <waynec@nvidia.com>
Subject: [PATCH 5.15 37/54] usb: gadget: tegra-xudc: ACK ST_RC after clearing CTRL_RUN
Date: Mon, 12 May 2025 19:29:49 +0200
Message-ID: <20250512172017.134621902@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
References: <20250512172015.643809034@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayne Chang <waynec@nvidia.com>

commit 59820fde001500c167342257650541280c622b73 upstream.

We identified a bug where the ST_RC bit in the status register was not
being acknowledged after clearing the CTRL_RUN bit in the control
register. This could lead to unexpected behavior in the USB gadget
drivers.

This patch resolves the issue by adding the necessary code to explicitly
acknowledge ST_RC after clearing CTRL_RUN based on the programming
sequence, ensuring proper state transition.

Fixes: 49db427232fe ("usb: gadget: Add UDC driver for tegra XUSB device mode controller")
Cc: stable <stable@kernel.org>
Signed-off-by: Wayne Chang <waynec@nvidia.com>
Link: https://lore.kernel.org/r/20250418081228.1194779-1-waynec@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/tegra-xudc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/gadget/udc/tegra-xudc.c
+++ b/drivers/usb/gadget/udc/tegra-xudc.c
@@ -1737,6 +1737,10 @@ static int __tegra_xudc_ep_disable(struc
 		val = xudc_readl(xudc, CTRL);
 		val &= ~CTRL_RUN;
 		xudc_writel(xudc, val, CTRL);
+
+		val = xudc_readl(xudc, ST);
+		if (val & ST_RC)
+			xudc_writel(xudc, ST_RC, ST);
 	}
 
 	dev_info(xudc->dev, "ep %u disabled\n", ep->index);


