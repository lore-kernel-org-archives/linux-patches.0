Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FBD18C32F;
	Tue, 10 Sep 2024 10:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962866; cv=none; b=MJCJ/GWYv4fZ4UxmoUOhwXa5cBAvrL/Ld/vexMJNHf2prL/p0+Rcfd757KmnKxKkmav5k3hE50+I1GKvMW5R70l9wkC//KcUv7dS913WsrNBdSZtMZVXZtKlrZDHybU21lfHt6cbvl/Eos9u4xBdpHZrsBHxi8jtmUMsNoJIajM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962866; c=relaxed/simple;
	bh=tdwrJYQ1d6KQQRZtozEtHVuICLmNcZ6j31gQXeFz7Yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NDeVU8JnbtuUNPir4fSn/T12SZ/aoAAyfNvCSI/V//WKTuXWT00v8TEdWRKV8LgaltJG/vSsvH2mJLQ3hQxSxZ+GB/fABJcpkEenPedUWflFB+vCAu4zmB//It0+X3wQrK9LbjcRWwZ9fEJ9iwtL4BieW8QMMqcw6kQoANA/GCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=od+sg+7x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="od+sg+7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABD9C4CEC3;
	Tue, 10 Sep 2024 10:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962866;
	bh=tdwrJYQ1d6KQQRZtozEtHVuICLmNcZ6j31gQXeFz7Yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=od+sg+7xSqdcIB70/AvMY19/jOdQ5QFJQMAGiNzD834n3QrCqyItM3I9qg48gp1qw
	 fx4QnSs9b83917Xq4HOWSKiG8amRryS4T1gCT/Cg690SVMUuNCs+dPsS6Q7Ne8uqAs
	 aaUUK7YCYyvxqNEeeXG2z+TowYbaQQGuSP0qNcW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 057/192] usb: gadget: aspeed_udc: validate endpoint index for ast udc
Date: Tue, 10 Sep 2024 11:31:21 +0200
Message-ID: <20240910092600.319701680@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

[ Upstream commit ee0d382feb44ec0f445e2ad63786cd7f3f6a8199 ]

We should verify the bound of the array to assure that host
may not manipulate the index to point past endpoint array.

Found by static analysis.

Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Reviewed-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Acked-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Link: https://lore.kernel.org/r/20240625022306.2568122-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/aspeed_udc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/udc/aspeed_udc.c b/drivers/usb/gadget/udc/aspeed_udc.c
index cedf17e38245..1a5a1115c1d9 100644
--- a/drivers/usb/gadget/udc/aspeed_udc.c
+++ b/drivers/usb/gadget/udc/aspeed_udc.c
@@ -1009,6 +1009,8 @@ static void ast_udc_getstatus(struct ast_udc_dev *udc)
 		break;
 	case USB_RECIP_ENDPOINT:
 		epnum = crq.wIndex & USB_ENDPOINT_NUMBER_MASK;
+		if (epnum >= AST_UDC_NUM_ENDPOINTS)
+			goto stall;
 		status = udc->ep[epnum].stopped;
 		break;
 	default:
-- 
2.43.0



