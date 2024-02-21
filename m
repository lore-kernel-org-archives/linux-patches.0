Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F4038398;
	Wed, 21 Feb 2024 13:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523692; cv=none; b=QOaFRBy9leEAGugMibAqRsgxuOiwUWx4WI08iA6VfazIWumkh505H5jQvCCVaY680Fgdgpg4AEaJTj+V7Njx5zu3aw6iboKoOWmmZ5XeDnKa4CsKwdZX+Y4P/auJsj07fhxIkIh18bLo2mzc8HZqj3u/7uBtkjTTWuegEMf5DhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523692; c=relaxed/simple;
	bh=dqqbjycNx694mxCfz/Md1YHQLTM7LO52ktv82Tepb9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/oPpo3f/mS9iDKjVTOuMNjuKMhB7UxNSDLShIOCl/J0htHEpmBMh33yj2gSwk9mZ+r+/bJU+k7Zc0PFhBz9DHyw7hAPKDsyReHZ+Oahm/iJa04uAxK7+7U9/A1kOBRPqN3n4BwrR1ejtRbi61P7pCAP2ftJ1YxeSkbd3CLlvrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=naBxYy0C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="naBxYy0C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3BC8C433C7;
	Wed, 21 Feb 2024 13:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523692;
	bh=dqqbjycNx694mxCfz/Md1YHQLTM7LO52ktv82Tepb9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=naBxYy0CEK3r1m5OvoK8bXx4RNvkhnkfmsJQDNllx+thhEuP0yHB6ssr/zhsZJMeD
	 wiFRNNkU+25VwNIs/n/msS1d0JfQUeuHy1hE4tsp1XCMMyuJZwSGI/Y2MZTPPAQYpl
	 Od0LeCDRxvcOzNPL5py7yBkTkaczCyicZT3mZdj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ravi Gunasekaran <r-gunasekaran@ti.com>,
	Frank Li <Frank.Li@nxp.com>,
	Peter Chen <peter.chen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 003/379] usb: cdns3: fix incorrect calculation of ep_buf_size when more than one config
Date: Wed, 21 Feb 2024 14:03:02 +0100
Message-ID: <20240221125955.023428385@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 2627335a1329a0d39d8d277994678571c4f21800 ]

Previously, the cdns3_gadget_check_config() function in the cdns3 driver
mistakenly calculated the ep_buf_size by considering only one
configuration's endpoint information because "claimed" will be clear after
call usb_gadget_check_config().

The fix involves checking the private flags EP_CLAIMED instead of relying
on the "claimed" flag.

Fixes: dce49449e04f ("usb: cdns3: allocate TX FIFO size according to composite EP number")
Cc: stable <stable@kernel.org>
Reported-by: Ravi Gunasekaran <r-gunasekaran@ti.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Tested-by: Ravi Gunasekaran <r-gunasekaran@ti.com>
Link: https://lore.kernel.org/r/20230707230015.494999-2-Frank.Li@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 92f02efa1d86 ("usb: cdns3: fix iso transfer error when mult is not zero")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/gadget.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/cdns3/gadget.c b/drivers/usb/cdns3/gadget.c
index 575180a59ad4..ee64c4ab8dd2 100644
--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -3030,12 +3030,14 @@ static int cdns3_gadget_udc_stop(struct usb_gadget *gadget)
 static int cdns3_gadget_check_config(struct usb_gadget *gadget)
 {
 	struct cdns3_device *priv_dev = gadget_to_cdns3_device(gadget);
+	struct cdns3_endpoint *priv_ep;
 	struct usb_ep *ep;
 	int n_in = 0;
 	int total;
 
 	list_for_each_entry(ep, &gadget->ep_list, ep_list) {
-		if (ep->claimed && (ep->address & USB_DIR_IN))
+		priv_ep = ep_to_cdns3_ep(ep);
+		if ((priv_ep->flags & EP_CLAIMED) && (ep->address & USB_DIR_IN))
 			n_in++;
 	}
 
-- 
2.43.0



