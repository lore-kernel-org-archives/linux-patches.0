Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B4A1C173C;
	Mon, 12 May 2025 17:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072093; cv=none; b=m9EIvAjFEHMO9qf+jK9rQQ1BQGYdyXHTrzcxXW+UiYb1GR80RstxQZkvhPxt0l/EY5zxC8d1c7RQcJaW7z9n6zFxxv/LZ9I1hiCddDtEtSPxkwvfp2ZsmdVV9vpzrjHSLvzaUGFl+mRlzsV2NODtRvHQ2t9LTjqTTQTjI+bujTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072093; c=relaxed/simple;
	bh=U8RXmeCYhiveqdAY4VeI8Ckd26paMIk2frn3BZFbFmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TPbjKTpIWfNT4lKrxZtGFptVDTLZ30XNCFPwIk+h/zUUiw8n/+QUx/NrOvr4DjLZcwgF1+sgpt6VXPc8Lebw2FORrmic1lyZjvZvQ2KlsPkokQQafKHO7KZhwPHSqYBih0H3QTGsXcG0jr630s0BVxvxT9xLG8afYT/XBt4TRqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gNMc913e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gNMc913e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E958C4CEE7;
	Mon, 12 May 2025 17:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072093;
	bh=U8RXmeCYhiveqdAY4VeI8Ckd26paMIk2frn3BZFbFmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gNMc913eaVGqWhDed+J1xDk+O28FLyH1oWEf/UIzo85j4WLXEFl9UpJQO7bCXFnwl
	 csQGRihIJn1ac4Vei2E4zxoNAnI+co67WSZaaLO4m6lcnuSC33ZuxCU4WwzsFlpYCu
	 UTIYI651r03HycimhGReQiI3pF7LuJejcJRCeaFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Wayne Chang <waynec@nvidia.com>
Subject: [PATCH 6.14 138/197] usb: gadget: tegra-xudc: ACK ST_RC after clearing CTRL_RUN
Date: Mon, 12 May 2025 19:39:48 +0200
Message-ID: <20250512172050.014147666@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1749,6 +1749,10 @@ static int __tegra_xudc_ep_disable(struc
 		val = xudc_readl(xudc, CTRL);
 		val &= ~CTRL_RUN;
 		xudc_writel(xudc, val, CTRL);
+
+		val = xudc_readl(xudc, ST);
+		if (val & ST_RC)
+			xudc_writel(xudc, ST_RC, ST);
 	}
 
 	dev_info(xudc->dev, "ep %u disabled\n", ep->index);


