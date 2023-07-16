Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73168F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:53:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47215C433C9;
	Sun, 16 Jul 2023 19:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537232;
	bh=5txr+HnpSYSKXT53FQXrd1YPQMKUGaEdwACSV5xJkes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q4HbrjwsxC4+tPD96rQIOnJyhNjp/OcmNHExqgMfcaPizxgd2l0yd7w1WxWwUcpJ1
	 qrVsNHdraLbsnpf5k+rLPnREfyx9PRXBees6yRtkTRG0mFqTgCGj//f0lQ5erZBldW
	 7kntJmneBL2etrEuUhS1r0WV5J3hdhNC7xoCT4wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.4 003/800] usb: dwc3: gadget: Propagate core init errors to UDC during pullup
Date: Sun, 16 Jul 2023 21:37:36 +0200
Message-ID: <20230716194949.188885229@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krishna Kurapati <quic_kriskura@quicinc.com>

commit c0aabed9cabe057309779a9e26fe86a113d24dad upstream.

In scenarios where pullup relies on resume (get sync) to initialize
the controller and set the run stop bit, then core_init is followed by
gadget_resume which will eventually set run stop bit.

But in cases where the core_init fails, the return value is not sent
back to udc appropriately. So according to UDC the controller has
started but in reality we never set the run stop bit.

On systems like Android, there are uevents sent to HAL depending on
whether the configfs_bind / configfs_disconnect were invoked. In the
above mentioned scnenario, if the core init fails, the run stop won't
be set and the cable plug-out won't result in generation of any
disconnect event and userspace would never get any uevent regarding
cable plug out and we never call pullup(0) again. Furthermore none of
the next Plug-In/Plug-Out's would be known to configfs.

Return back the appropriate result to UDC to let the userspace/
configfs know that the pullup failed so they can take appropriate
action.

Fixes: 77adb8bdf422 ("usb: dwc3: gadget: Allow runtime suspend if UDC unbinded")
Cc: stable <stable@kernel.org>
Signed-off-by: Krishna Kurapati <quic_kriskura@quicinc.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Message-ID: <20230618120949.14868-1-quic_kriskura@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2744,7 +2744,9 @@ static int dwc3_gadget_pullup(struct usb
 	ret = pm_runtime_get_sync(dwc->dev);
 	if (!ret || ret < 0) {
 		pm_runtime_put(dwc->dev);
-		return 0;
+		if (ret < 0)
+			pm_runtime_set_suspended(dwc->dev);
+		return ret;
 	}
 
 	if (dwc->pullups_connected == is_on) {


