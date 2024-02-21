Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA3078B5E;
	Wed, 21 Feb 2024 13:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523449; cv=none; b=k7Z9b5RPViSdLvWeXAK9u6jV/0KmC/boEvwt7XdIjNR7PprW50G6dv6aECol7dgPCtw3oIJeaHeKoCMay1WZS6GrPLIMdRU3sOJSdre3dPoMOuA+DoY3Gir18REeSS3eDZKLZXlkTqfVfN5EgdVExD0TevJL5++UKzHzBzjwz20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523449; c=relaxed/simple;
	bh=+RO6b0dufx9FIi7axtzZS56SuOhGFwMiKUs2dMaSgEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1VI97LQW7Pv0bgDUYy9kwwUNqnrCen17kaPaRhmxYGPS8IVV0ZcGOxZSh/g3RpT7HcZZe4VBCg3i8+TACyChoz+MF4EO4xzJHUbWUGiZQpYr13/uQBGBG5qMyrLCoM42u0U5vDSLnGtEDTjmjS8FKxHQjTDfn7fP2CYeZ9qQlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TG5hQBt1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TG5hQBt1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57EB9C433F1;
	Wed, 21 Feb 2024 13:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523448;
	bh=+RO6b0dufx9FIi7axtzZS56SuOhGFwMiKUs2dMaSgEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TG5hQBt1G2UsStXBzPoBWi2LCXquoAgcmpo+j+MAu9MpVJi+k7vlI2q/uLk8Ujuec
	 nqdS1TRk6L4B335F7rpDF8APGTS/1Q5YJRmjKxRX0elLM8aKCOjSizu573nVOF/neY
	 ykhpsJ/meDU3GZYqy4cZSD+VMz+tJFtIIEn2mktk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Wesley Cheng <quic_wcheng@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 438/476] usb: dwc3: gadget: Force sending delayed status during soft disconnect
Date: Wed, 21 Feb 2024 14:08:09 +0100
Message-ID: <20240221130024.221416978@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wesley Cheng <quic_wcheng@quicinc.com>

[ Upstream commit e1ee843488d58099a89979627ef85d5bd6c5cacd ]

If any function drivers request for a delayed status phase, this leads to a
SETUP transfer timeout error, since the function may take longer to process
the DATA stage.  This eventually results in end transfer timeouts, as there
is a pending SETUP transaction.

In addition, allow the DWC3_EP_DELAY_STOP to be set for if there is a
delayed status requested.  Ocasionally, a host may abort the current SETUP
transaction, by issuing a subsequent SETUP token.  In those situations, it
would result in an endxfer timeout as well.

Reviewed-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Wesley Cheng <quic_wcheng@quicinc.com>
Link: https://lore.kernel.org/r/20220817182359.13550-3-quic_wcheng@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 730e12fbec53 ("usb: dwc3: gadget: Handle EP0 request dequeuing properly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index b978e42ace75..ba1b2e70b351 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2470,6 +2470,9 @@ static int dwc3_gadget_soft_disconnect(struct dwc3 *dwc)
 	if (dwc->ep0state != EP0_SETUP_PHASE) {
 		int ret;
 
+		if (dwc->delayed_status)
+			dwc3_ep0_send_delayed_status(dwc);
+
 		reinit_completion(&dwc->ep0_in_setup);
 
 		spin_unlock_irqrestore(&dwc->lock, flags);
@@ -3662,7 +3665,7 @@ void dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force,
 	 * timeout. Delay issuing the End Transfer command until the Setup TRB is
 	 * prepared.
 	 */
-	if (dwc->ep0state != EP0_SETUP_PHASE && !dwc->delayed_status) {
+	if (dwc->ep0state != EP0_SETUP_PHASE) {
 		dep->flags |= DWC3_EP_DELAY_STOP;
 		return;
 	}
-- 
2.43.0



