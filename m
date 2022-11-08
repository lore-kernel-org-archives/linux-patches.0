Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37E915CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229B2C433D7;
	Tue,  8 Nov 2022 14:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916401;
	bh=fydzp8JUkrwHOpUdNHq4/6kqQc/8hfs1dQYdDyDur+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FoXGrel2Q8S6bOEYnBRJ0LFIr9+6H70XU1041vjLhcTIYsXeeD8Q7zHPHo1g8kXt6
	 wei2rMmareFHitANTaHBElvPBQ8RNRtU6zgxBTkFpJ1K2+1dZRQxzAKLqq1uvSH1Ki
	 jb1Fp3PKjeH7MyLjOaN2JqVNg96AQGLKCg3wBQi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Wesley Cheng <quic_wcheng@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 001/197] usb: dwc3: gadget: Force sending delayed status during soft disconnect
Date: Tue,  8 Nov 2022 14:37:19 +0100
Message-Id: <20221108133354.849215990@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wesley Cheng <quic_wcheng@quicinc.com>

commit e1ee843488d58099a89979627ef85d5bd6c5cacd upstream.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 0ed9826a4c47..530ef3232418 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3712,7 +3712,7 @@ void dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force,
 	 * timeout. Delay issuing the End Transfer command until the Setup TRB is
 	 * prepared.
 	 */
-	if (dwc->ep0state != EP0_SETUP_PHASE && !dwc->delayed_status) {
+	if (dwc->ep0state != EP0_SETUP_PHASE) {
 		dep->flags |= DWC3_EP_DELAY_STOP;
 		return;
 	}
-- 
2.35.1



