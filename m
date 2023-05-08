Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6161F168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:53:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5928C433D2;
	Mon,  8 May 2023 10:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543188;
	bh=bTownw0lLmAEW9KKrhaRE6LyTWM03ryZNH3lvWjfgeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dj/IYPmAd2MazQXNTjCNphKpaSBerr326vyHWiHzne6HGIlYP2L40H3OVZF3vC9sp
	 hBhbICSt7aoWx6U03tmrLBMYLB5U3lSqSu4gXONU702dNuvzcbgRrhUzQ7vzLUMaUW
	 YHxp1ro9v/ydslWiRRXyAsFx6TUn3Xo51veFUHdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Badhri Jagan Sridharan <badhri@google.com>
Subject: [PATCH 6.3 012/694] usb: gadget: udc: core: Prevent redundant calls to pullup
Date: Mon,  8 May 2023 11:37:27 +0200
Message-Id: <20230508094433.032047962@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Badhri Jagan Sridharan <badhri@google.com>

commit a3afbf5cc887fc3401f012fe629810998ed61859 upstream.

usb_gadget_connect calls gadget->ops->pullup without checking whether
gadget->connected was previously set. Make this symmetric to
usb_gadget_disconnect by returning early if gadget->connected is
already set.

Fixes: 5a1da544e572 ("usb: gadget: core: do not try to disconnect gadget if it is not connected")
Cc: stable@vger.kernel.org
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Link: https://lore.kernel.org/r/20230407030741.3163220-2-badhri@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -676,6 +676,9 @@ static int usb_gadget_connect_locked(str
 		goto out;
 	}
 
+	if (gadget->connected)
+		goto out;
+
 	if (gadget->deactivated || !gadget->udc->started) {
 		/*
 		 * If gadget is deactivated we only save new state.


